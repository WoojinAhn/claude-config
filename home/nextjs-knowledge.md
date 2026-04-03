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

## `next build`의 검증 범위

`next build`는 빌드 외에 TypeScript 타입 체크 + ESLint를 함께 수행한다. 개발 중 `npx tsc --noEmit`으로 타입만 체크하면 lint 에러를 놓칠 수 있다.

| 명령 | 타입 체크 | ESLint | 빌드 |
|------|----------|--------|------|
| `npx tsc --noEmit` | O | X | X |
| `npm run lint` / `next lint` | X | O | X |
| `npm run build` / `next build` | O | O | O |

- push/배포 전 검증은 `npm run build`가 가장 확실
- CI/CD(Vercel 등)에서 `next build` 실패 = 배포 실패이므로, 로컬에서 미리 잡는 게 중요
