🌐 [English](README.md) | [한국어](README.ko.md)

# claude-config

Claude Code 글로벌 설정을 관리하는 저장소.

`~/.claude/`에 직접 연결하지 않고, 스크립트를 통해 **파일 복사 방식**으로 동기화한다.

## 관리 대상

| 파일 | 용도 |
|---|---|
| `CLAUDE.md` | 글로벌 행동 지침 (모든 프로젝트에 적용) |
| `settings.json` | 모델, 권한, hooks 등 런타임 설정 |

## 새 머신 초기 세팅

```bash
git clone git@github.com:WoojinAhn/claude-config.git ~/path/to/claude-config
cd ~/path/to/claude-config
./sync.sh setup
```

`setup` 실행 시:
1. 관리 대상 파일별로 repo와 `~/.claude/`의 diff 표시
2. 파일별 덮어쓰기 여부 확인
3. `push-config.sh`를 `~/.claude/`에 설치 (auto-push hook용)

## 사용법

```bash
# 차이점 확인
./sync.sh diff

# remote -> ~/.claude/ 반영 (push-config.sh도 재설치)
./sync.sh pull

# ~/.claude/ -> remote 반영 (수동)
./sync.sh push

# 동기화 상태 확인
./sync.sh status
```

## Auto-Push

`settings.json`의 hook이 Claude Code 세션에서 `Write|Edit` 시마다 `~/.claude/push-config.sh`를 실행한다. 이 스크립트는 `setup` 시 repo 경로가 주입되어 생성되므로, 커밋된 파일에 하드코딩된 경로가 없다.

## 파일 추가

`sync.sh` 내 `FILES` 배열에 파일명을 추가하면 동기화 대상에 포함된다.

```bash
FILES=("CLAUDE.md" "settings.json" "keybindings.json")
```
