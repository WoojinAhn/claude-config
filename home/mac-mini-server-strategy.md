# Mac Mini M1 Server Strategy

Mac Mini M1 (8GB) 상시 가동 서버 활용 전략.
M5 Max MBP는 개발 전용, Mini는 인프라 전용으로 분리.

- Idle ~5-7W, 월 전기료 1,000원 미만

---

## 1. GitHub Actions Self-Hosted Runner

무료 플랜 월 2,000분 제한 절약. private repo에서 특히 유용.

### Setup

```bash
# 1. GitHub Settings > Actions > Runners > New self-hosted runner
# 2. 다운로드 및 설치 (macOS ARM64)
mkdir ~/actions-runner && cd ~/actions-runner
curl -o actions-runner-osx-arm64-2.XXX.X.tar.gz -L https://github.com/actions/runner/releases/download/vX.X.X/actions-runner-osx-arm64-2.XXX.X.tar.gz
tar xzf ./actions-runner-osx-arm64-2.XXX.X.tar.gz

# 3. 등록 (GitHub에서 제공하는 토큰 사용)
./config.sh --url https://github.com/<owner>/<repo> --token <TOKEN>

# 4. 서비스로 등록 (재부팅 시 자동 시작)
./svc.sh install
./svc.sh start
```

### Workflow 설정

```yaml
# .github/workflows/ci.yml
jobs:
  build:
    runs-on: self-hosted  # GitHub-hosted 대신 Mini 사용
```

### Tips

- org 레벨로 등록하면 여러 repo에서 공유 가능
- label로 `mini-m1` 붙여두면 특정 job만 Mini로 라우팅 가능
- Docker 기반 action은 macOS runner에서 제한적 — native 빌드 위주로 활용

---

## 2. Tailscale Gateway

외부에서 홈 네트워크의 Mini, MBP, Docker 서비스에 안전하게 접근.

### Setup

```bash
# 1. Tailscale 설치
brew install tailscale

# 2. 로그인
sudo tailscale up

# 3. Mini를 exit node로 설정 (선택: 홈 네트워크 전체 접근)
sudo tailscale up --advertise-exit-node --advertise-routes=192.168.0.0/24
```

### Use Cases

- **카페/외부에서 MBP → Mini SSH 접속**: `ssh woojin@<tailscale-ip>`
- **Mini의 Docker 서비스 접근**: `http://<tailscale-ip>:5432` (PostgreSQL 등)
- **MBP Ollama 원격 접근**: Mini가 리버스 프록시 역할, MBP WoL로 깨우기
- **홈 네트워크 VPN**: exit node로 설정하면 외부에서 홈 IP로 인터넷 사용 가능

---

## 3. Always-On Infra Services (Docker)

MBP에서 개발 중 필요한 서비스를 Mini에서 상시 구동.

```yaml
# docker-compose.yml 예시
services:
  postgres:
    image: postgres:16
    ports: ["5432:5432"]
    volumes: ["pgdata:/var/lib/postgresql/data"]
  redis:
    image: redis:7-alpine
    ports: ["6379:6379"]
```

- MBP에서 Tailscale IP로 접속하면 로컬처럼 사용 가능
- MBP 재시작해도 DB 데이터 유지

---

## 4. Cron / Background Jobs

상시 돌아가야 하는 스크래핑, 모니터링, 알림.

- GoPeaceTrain (호텔 예약 모니터링)
- YouTube unsubscriber
- 기타 스케줄 작업

```bash
# launchd 또는 crontab으로 등록
crontab -e
# 0 */6 * * * cd ~/jobs/gopeacetrain && python3 main.py
```

---

## Network Topology

```
[External / Cafe]
    │
    │ Tailscale (WireGuard)
    ▼
[Mac Mini M1 - 192.168.x.x / tailscale-ip]
    ├── GitHub Actions Runner
    ├── Docker (PostgreSQL, Redis, ...)
    ├── Cron Jobs
    ├── Caddy (reverse proxy)
    └── WoL trigger for MBP
            │
            ▼
[M5 Max MBP - 192.168.x.x / tailscale-ip]
    ├── Ollama (LLM inference)
    ├── Development IDE
    └── MLX fine-tuning
```
