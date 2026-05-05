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

## Linter — flake8 운영 시 trap

**날짜:** 2026-05-05

신규 프로젝트라면 `ruff` 권장 (Rust 기반, flake8 + isort 등 통합, `pyproject.toml` native 지원). 이미 flake8를 쓰는 프로젝트에서 막혔던 지점들:

- **`pyproject.toml` native 미지원** — flake8는 `setup.cfg [flake8]` 또는 `.flake8` 파일에 설정. `pyproject.toml`에 적으려면 `Flake8-pyproject` plugin 별도 설치 필요
- **black 호환 시 `extend-ignore = E203, W503` 필수** — 안 넣으면 black이 만드는 코드를 flake8가 위반으로 잡음 (E203: 슬라이스 공백, W503: 연산자 앞 줄바꿈)
- **테스트의 `sys.path.insert(0, ...)` 후 import** — E402 위반. `per-file-ignores = tests/*:E402`로 처리
- **autopep8 `--select=W291,W292,W293,E302`로 공백류 일괄 수정 가능** 하나, **docstring 내부 공백-only 줄(W293)은 못 잡음**. macOS sed로 보완: `sed -i '' 's/^[[:space:]]*$//' file.py` (GNU sed는 `-i ''` 대신 `-i`)
- **CI step 없으면 강제 아님** — `requirements.txt`에 flake8 넣고 README에 명령만 적어두는 건 무의미, 위반 무한 누적. GitHub Actions에 `flake8 src/ tests/` step + PR 머지 차단까지 묶여야 실질적 강제
