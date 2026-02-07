🌐 [English](README.md) | [한국어](README.ko.md)

# claude-config

Claude Code 글로벌 설정을 관리하는 저장소.

`~/.claude/`에 직접 연결하지 않고, 스크립트를 통해 **파일 복사 방식**으로 동기화한다.

## 관리 대상

| 파일 | 용도 |
|---|---|
| `CLAUDE.md` | 글로벌 행동 지침 (모든 프로젝트에 적용) |
| `settings.json` | 모델, 권한, hooks 등 런타임 설정 |

## 사용법

```bash
# 동기화 상태 확인
~/claude-config/sync.sh status

# 차이점 확인
~/claude-config/sync.sh diff

# remote -> ~/.claude/ 반영
~/claude-config/sync.sh pull

# ~/.claude/ -> remote 반영
~/claude-config/sync.sh push
```

## 새 머신 초기 세팅

```bash
git clone git@github.com:WoojinAhn/claude-config.git ~/claude-config
~/claude-config/sync.sh pull
```

## 파일 추가

`sync.sh` 내 `FILES` 배열에 파일명을 추가하면 동기화 대상에 포함된다.

```bash
FILES=("CLAUDE.md" "settings.json" "keybindings.json")
```
