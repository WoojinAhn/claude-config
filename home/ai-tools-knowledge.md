# AI Tools Knowledge

## opencode

- **opencode**: 터미널 기반 AI 코딩 에이전트 (TUI). Bubble Tea로 만든 인터랙티브 UI
- 설치: `brew install opencode-ai/tap/opencode`
- 공식 레포: https://github.com/opencode-ai/opencode
- 75+ AI 프로바이더 지원 (Anthropic, OpenAI, Google, GitHub Copilot 등)
- `/connect` 명령으로 프로바이더 인증 (OAuth 또는 API 키)

### Claude 구독 지원 범위
| 구독 | Claude Code CLI | opencode |
|------|----------------|----------|
| Claude Pro | O | **X** |
| Claude Max | O | O |
| Anthropic API Key | - | O |

- Claude Pro는 claude.ai OAuth 기반이라 opencode에서 직접 API 호출 불가
- opencode에서 Claude 쓰려면 Max 구독 또는 Anthropic API 키 필요

---

## oh-my-opencode

- opencode용 플러그인. 다중 전문 에이전트 시스템을 추가함
- 공식 레포: https://github.com/code-yeongyu/oh-my-opencode
- 설치: `npx oh-my-opencode install --no-tui --claude=<no|yes|max20> --gemini=<no|yes> --copilot=<no|yes>`
  - `yes` = Claude Max ($100), `max20` = Claude Max ($20)
- 설정 파일: `~/.config/opencode/oh-my-opencode.json`
- opencode 플러그인 등록: `~/.config/opencode/opencode.json`에 `"plugin": ["oh-my-opencode@latest"]`

### 주요 에이전트
| 에이전트 | 모델 | 역할 |
|---------|------|------|
| Sisyphus | Opus (main) | 오케스트레이터, 작업 전체 조율 |
| Prometheus | Opus | 실행 전 계획 수립 |
| Oracle | Opus | 아키텍처 분석, 디버깅 |
| Metis | Opus | 전략·의사결정 |
| Momus | Opus | 리뷰, 품질 검사 |
| Librarian | Sonnet | 문서화, 코드 검색 |
| Atlas | Sonnet | 구조 매핑 |
| Explore | Haiku | 빠른 코드 탐색 |

### 핵심 사용법
- `ultrawork` 또는 `ulw`: 프롬프트에 포함하면 모든 에이전트 자동 조율, 완료까지 지속 실행
- `/init-deep`: 프로젝트에 계층형 `AGENTS.md` 자동 생성 (에이전트 컨텍스트 사전 주입)
- `tab`: Prometheus 플래너 모드 (복잡한 작업 구조화)
