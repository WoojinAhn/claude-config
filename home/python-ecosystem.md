# Python 생태계 관습 학습 노트

작업 중 발견한 Python 문화/관습을 기록하는 living document.

---

## Naming: 하이픈 vs 언더스코어

**날짜:** 2026-02-15

| 대상 | 컨벤션 | 예시 |
|------|--------|------|
| **PyPI 패키지 이름** | 하이픈(`-`) 권장 | `my-package` |
| **import 모듈/패키지** | 언더스코어(`_`) 필수 | `import my_package` |
| **디렉토리(패키지)** | 언더스코어(`_`) | `my_package/` |
| **파일(모듈)** | 언더스코어(`_`) | `my_module.py` |

- PyPI는 하이픈과 언더스코어를 동일하게 취급 (PEP 503 정규화: `-`, `_`, `.` 모두 `-`로 변환)
- `pip install my-package` → `import my_package` 패턴이 일반적
- `setup.py`/`pyproject.toml`의 `name`은 하이픈, 실제 소스 디렉토리는 언더스코어

---

## PyPI 발행 vs 로컬 패키징

**날짜:** 2026-03-30

| 행위 | 하는 일 | 결과 |
|------|---------|------|
| `pyproject.toml` 작성 | 패키지 메타데이터 선언 | 로컬 파일일 뿐, 아무 일도 안 일어남 |
| `pip install -e .` | 로컬 개발용 설치 | 현재 머신에서만 import/CLI 사용 가능 |
| `pipx install .` | CLI 도구를 격리 venv에 설치 | 현재 머신 PATH에 명령어 등록 |
| `twine upload dist/*` | PyPI 서버에 업로드 | 전 세계 누구나 `pip install 패키지명`으로 설치 가능 |

- `pyproject.toml`에 URL/classifiers를 적는 것 = 사전 메타데이터 준비. PyPI 발행과는 별개
- PyPI는 품질 심사 없음. 계정만 있으면 누구나 발행 가능
- GitHub Actions로 git tag push 시 자동 발행도 가능

---

## PEP 668: 시스템 Python pip 제한

**날짜:** 2026-03-30

- Python 3.12+부터 homebrew 등 시스템 Python에 `pip install`이 기본 차단됨
- `--break-system-packages` 플래그로 우회 가능하나 비권장
- 해결 방법: `venv`, `pipx`, 또는 프로젝트별 가상환경 사용

---

## pipx: CLI 도구 배포/설치

**날짜:** 2026-03-30

- Python CLI 도구를 격리된 venv에 설치하되 명령어만 시스템 PATH에 노출
- 소비자가 Python 환경을 신경 쓸 필요 없이 CLI 사용 가능
- `pipx install .` (로컬), `pipx install git+https://...` (GitHub), `pipx install 패키지명` (PyPI)
- `pyproject.toml`의 `[project.scripts]` entry point 필요
- 모듈 import는 불가 — CLI 전용. import가 필요하면 `pip install -e .`

---

## Linter / Formatter 생태계

**날짜:** 2026-05-05

### 도구별 역할

| 도구 | 역할 | 수정 | 비고 |
|------|------|------|------|
| **flake8** | 린터 (PEP 8 + 논리 오류 + 복잡도 검사) | ✗ 보고만 | pycodestyle + pyflakes + mccabe wrapper |
| **autopep8** | flake8 룰 기반 자동 수정 | ✓ in-place | 공백/들여쓰기 류 강함 |
| **black** | 무논쟁 자동 포매터 | ✓ | 라인 기본 88, 스타일 토론 차단 |
| **isort** | import 정렬 | ✓ | black과 함께 자주 씀 |
| **ruff** | Rust 기반 초고속 린터+포매터 | ✓ | flake8 + isort + pyupgrade 등 통합. 신규 프로젝트는 ruff 권장 |
| **pylint** | 더 엄격한 린터 | ✗ | flake8보다 무겁고 oversensitive |

### flake8 룰 코드 prefix
- `E***` pycodestyle 에러 (E501 라인 길이, E302 빈 줄, E402 import 위치 등)
- `W***` pycodestyle 경고 (W291 trailing space, W293 blank line whitespace 등)
- `F***` pyflakes (F401 unused import, F541 f-string without placeholder 등)
- `C***` mccabe (C901 too complex)

### 설정 파일 우선순위
- `setup.cfg [flake8]` 또는 **`.flake8`** 사용 (flake8는 `pyproject.toml` **native 미지원** — 별도 plugin `Flake8-pyproject` 필요)
- ruff는 `pyproject.toml [tool.ruff]` native 지원 → 하나의 파일에 통합 가능

### black 호환 ignore
- black과 flake8 동시 사용 시 충돌 룰 두 개를 ignore 필수:
  ```ini
  [flake8]
  extend-ignore = E203, W503
  max-line-length = 120  # black 기본은 88, 취향 따라
  ```
- `E203 whitespace before ':'` — black은 슬라이스 `a [1 : 2]` 같은 공백을 의도적으로 넣음
- `W503 line break before binary operator` — black은 PEP 8 최신 권장(연산자 앞 줄바꿈)을 따름

### per-file-ignores
- 테스트 파일에서 `sys.path.insert(0, ...)` 후 import하는 패턴은 `E402 module level import not at top` 위반:
  ```ini
  per-file-ignores =
      tests/*:E402
  ```

### 누적 위반 정리 전략
1. **config 완화 먼저** — `max-line-length`를 실제 분포에 맞춰 올리면 E501 대부분 해결
2. **autopep8로 자동 수정** — `autopep8 --in-place --recursive --select=W291,W292,W293,E302,E303,E305 src/ tests/`
3. **autopep8 미커버** — docstring 안 빈 줄(W293)은 안 잡힘. `sed -i '' 's/^[[:space:]]*$//' file.py`로 보완 (BSD/macOS는 `-i ''`)
4. **F401/F541/E712 등 논리 오류는 수동** — 자동 수정 시 의도 파악 못 함
5. **CI 강제** — 정리 후 GitHub Actions에 `flake8 src/ tests/` step 추가하여 신규 위반 차단

### 검사만 vs 강제
- 프로젝트가 flake8를 `requirements.txt`에 넣고 README에 명령만 적어두는 건 **강제 없음**. 위반은 무한 누적됨
- CI에 step으로 추가 + PR 머지 차단해야 실질적 강제
