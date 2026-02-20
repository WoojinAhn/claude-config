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
