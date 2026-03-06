# Next.js Knowledge

## Default npm Scripts (Convention)

Next.js 프로젝트는 `create-next-app`이 생성하는 표준 스크립트가 있다:

| Script | Command | Purpose |
|--------|---------|---------|
| `dev` | `next dev` | Development server (HMR, source maps, error overlay) |
| `build` | `next build` | Production build |
| `start` | `next start` | Production server (requires `build` first) |
| `lint` | `eslint` or `next lint` | Linting |

- `dev`는 개발 전용 서버이므로 이름을 `web` 등으로 바꾸면 Next.js 관례에서 벗어남
- 별도 alias가 필요하면 `"web": "next dev"` 처럼 추가하되 `dev`는 유지하는 것이 관례
- `start`는 `build` 이후에만 동작 (빌드 결과물 서빙)
