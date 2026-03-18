# Claude Code Skills & Commands Knowledge

Claude Code 스킬/커맨드 저작 시 참고할 경험적 지식.

## 공식 문서 참조

- Skills: https://code.claude.com/docs/en/skills
- Tools reference: https://code.claude.com/docs/en/tools-reference
- Permissions: https://code.claude.com/docs/en/permissions

---

## 사용 가능한 내장 도구 (allowed-tools)

Skills/commands의 `allowed-tools` frontmatter에 아래 도구를 지정 가능. 제한 없이 모든 내장 도구를 사용할 수 있음.

| 도구 | 용도 | Permission |
|---|---|---|
| Agent | 서브에이전트 생성 | No |
| AskUserQuestion | 인터랙티브 선택 UI | No |
| Bash | 셸 명령 실행 | Yes |
| CronCreate/Delete/List | 예약 실행 | No |
| Edit | 파일 수정 | Yes |
| EnterPlanMode/ExitPlanMode | 플랜 모드 | No/Yes |
| EnterWorktree/ExitWorktree | Git worktree 격리 | No |
| Glob | 파일 패턴 검색 | No |
| Grep | 내용 검색 | No |
| LSP | 언어서버 코드 인텔리전스 | No |
| NotebookEdit | Jupyter 노트북 편집 | Yes |
| Read | 파일 읽기 | No |
| Skill | 다른 스킬 호출 | Yes |
| Task* | 태스크 관리 (Create/Get/List/Update/Output/Stop) | No |
| ToolSearch | 지연 로드 도구 검색 | No |
| WebFetch | URL 콘텐츠 가져오기 | Yes |
| WebSearch | 웹 검색 | Yes |
| Write | 파일 생성/덮어쓰기 | Yes |

---

## 인터랙티브 UI 도구

### AskUserQuestion — 유일한 내장 선택형 UI

Claude Code에서 사용자에게 인터랙티브 선택지를 보여주는 유일한 내장 도구.

**기본 사용:**
- 2~4개 옵션 (자동으로 "Other" 추가됨)
- `multiSelect: true`로 복수 선택 가능
- `header`: 칩/태그로 표시 (최대 12자)

**preview 기능:**
- 옵션에 `preview` 필드 추가 시 좌우 분할 레이아웃으로 전환
- 왼쪽: 옵션 목록, 오른쪽: 포커스된 옵션의 마크다운 프리뷰
- 마크다운 렌더링 지원, 여러 줄 가능
- single-select에서만 지원 (multiSelect 불가)
- 용도: ASCII 목업, 코드 스니펫 비교, 다이어그램, 설정 예시

**제약:**
- 옵션 최대 4개 (페이지네이션으로 우회 가능하나, 실질 페이지당 3개)
- 질문 최대 4개를 한 번에 표시 가능

**슬래시 커맨드에서 사용:**
```yaml
---
allowed-tools: Bash, AskUserQuestion
---
```

### 비주얼 출력 패턴 (공식 권장)

AskUserQuestion의 4개 제한을 넘는 풍부한 UI가 필요할 때, **HTML 파일 생성 → 브라우저 열기** 패턴을 공식 문서에서 권장.

```python
# 스킬에 번들된 스크립트로 HTML 생성
import webbrowser
# ... HTML 생성 로직 ...
webbrowser.open(f'file://{output_path}')
```

- 인터랙티브 트리뷰, 차트, 대시보드 등 무제한 UI 가능
- Python stdlib만으로 구현 가능 (외부 의존성 불필요)
- cmux 환경이면 `cmux browser open <url>`로도 열기 가능

---

## cmux CLI — 터미널 멀티플렉서 UI

cmux(Claude Multiplexer) 환경에서 사용 가능한 UI 관련 명령어.
cmux 안에서 실행 중일 때만 동작 (`CMUX_WORKSPACE_ID` 환경변수 존재 여부로 판별).

### 워크스페이스/세션 관리
```bash
cmux new-workspace --cwd <path> --command "<cmd>"  # 새 워크스페이스 + 명령 실행
cmux list-workspaces                                 # 워크스페이스 목록
cmux close-workspace --workspace <id>                # 워크스페이스 닫기
cmux select-workspace --workspace <id>               # 워크스페이스 전환
```

### 사이드바 UI
```bash
cmux set-status <key> <value> [--icon <name>] [--color <#hex>]  # 상태 표시
cmux set-progress <0.0-1.0> [--label <text>]                     # 진행률 바
cmux log [--level <level>] [--source <name>] <message>           # 로그
cmux notify --title <text> [--subtitle <text>] [--body <text>]   # 알림
```

### 화면 읽기/입력
```bash
cmux read-screen [--workspace <id>] [--lines <n>]   # 화면 내용 읽기
cmux send [--workspace <id>] <text>                  # 텍스트 입력
cmux send-key [--workspace <id>] <key>               # 키 입력
```

### 브라우저 (내장)
```bash
cmux browser open [url]           # 브라우저 패널 열기
cmux browser navigate <url>       # URL 이동
cmux browser snapshot             # 페이지 스냅샷
cmux browser eval <script>        # JS 실행
```

### 활용 사례: `/lanes`에서 레포 resume
```bash
# 세션 UUID 추출 후 새 워크스페이스에서 바로 resume
cmux new-workspace --cwd ~/home/<repo> --command "claude --resume <uuid>"
```

---

## Frontmatter 주요 필드

```yaml
---
name: my-skill                    # 슬래시 커맨드 이름
description: What this does        # Claude 자동 호출 판단 기준
argument-hint: [--flag] [arg]      # 자동완성 힌트
disable-model-invocation: true     # Claude 자동 호출 차단 (수동만)
user-invocable: false              # 사용자 메뉴 숨김 (Claude만 호출)
allowed-tools: Read, Grep, Bash    # 허용 도구
model: opus                       # 사용 모델
context: fork                     # 서브에이전트에서 실행
agent: Explore                    # fork 시 에이전트 타입
---
```

## 동적 컨텍스트 주입

```markdown
# !`command` 구문으로 실행 시점에 셸 명령 결과를 주입
PR diff: !`gh pr diff`
Git status: !`git status --short`
```

## 변수 치환

| 변수 | 설명 |
|---|---|
| `$ARGUMENTS` | 전체 인자 |
| `$ARGUMENTS[N]` 또는 `$N` | N번째 인자 (0-based) |
| `${CLAUDE_SESSION_ID}` | 현재 세션 ID |
| `${CLAUDE_SKILL_DIR}` | 스킬 디렉토리 경로 |
