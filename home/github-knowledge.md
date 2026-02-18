# GitHub Knowledge

## GitHub Actions

- GitHub 레포에 `.github/workflows/*.yml` 파일이 있으면 GitHub가 자동으로 감지하고 실행한다
- 별도 서버나 배포 과정 없이, GitHub가 무료로 서버를 제공하고 코드를 실행해준다
- 무료 계정 기준 월 2,000분 실행 시간 제공
- Fork한 레포는 Actions가 기본 비활성 — Actions 탭에서 수동으로 켜야 함
- 트리거 종류: `schedule` (cron), `push`, `pull_request`, `workflow_dispatch` (수동 실행) 등
- `actions/github-script@v7`: 워크플로우 안에서 JavaScript를 인라인으로 실행할 수 있는 공식 액션
  - `github`, `context`, `core` 등의 전역 변수를 주입해줌
  - `github-token` 입력으로 커스텀 토큰을 넘기면 `github` 객체가 해당 토큰으로 인증됨

## GitHub Secrets

- 비밀번호, 토큰 등 민감한 값을 GitHub가 암호화해서 보관하는 기능
- 레포별로 관리됨 (레포 A의 시크릿은 레포 B에서 접근 불가)
- 한번 등록하면 값을 다시 조회할 수 없음 (수정만 가능)
- 워크플로우 로그에서 시크릿 값이 출력되면 자동으로 `***`로 마스킹
- Fork된 레포에는 시크릿이 복사되지 않음 — 각자 등록해야 함
- `${{ secrets.XXX }}` 형태로 워크플로우 YAML 안에서만 참조 가능
- `GITHUB_TOKEN`은 모든 워크플로우에 자동 제공되는 유일한 시크릿 (현재 레포 권한만 가짐)

## GitHub Token 종류

| 토큰 | 특징 |
|------|------|
| `GITHUB_TOKEN` | 워크플로우 자동 제공, 현재 레포만 접근, 행위자가 `github-actions[bot]` |
| Classic PAT | 사용자가 발급, 스코프 단위 권한 (`repo`, `workflow` 등), 모든 레포 접근 가능 |
| Fine-grained PAT | 사용자가 발급, 레포/권한을 세밀하게 지정 가능, `workflow` 스코프 미지원 |

- 본인 PAT으로 이슈를 생성하면 GitHub가 본인 행동으로 간주하여 알림을 보내지 않음
- `GITHUB_TOKEN`으로 생성하면 `github-actions[bot]` 행위자로 처리되어 알림이 감

## Fork

- 다른 사람의 레포를 본인 계정으로 복사하는 기능
- 워크플로우 파일도 함께 복사되지만, Actions는 기본 비활성
- 시크릿은 복사되지 않음

## Issue 작성 언어 패턴 (비영어권)

- **영어 본문 + 모국어 보충** — 가장 흔한 패턴. 제목과 주요 내용은 영어로 쓰되, 내부 논의 맥락이나 뉘앙스가 필요한 부분만 모국어로 작성
- 완전 영어 통일 — 포트폴리오/글로벌 공유 목적일 때
- 모국어 본문 + 영어 TL;DR — 팀 내부용이되 외부 방문자 고려 시
- 프로젝트 성격(개인/오픈소스/팀)에 따라 선택하되, 커뮤니티 공유를 고려하면 영어 중심이 유리
