# Swift / SwiftUI Knowledge

## MenuBarExtra

- `MenuBarExtra` label 내에서 SwiftUI `.font()`, `VStack`, `Divider` 등 modifier/레이아웃이 무시됨
- 커스텀 렌더링이 필요하면 NSImage로 직접 그린 뒤 `Image(nsImage:)`로 전달해야 함
- `Text`는 표시되지만 폰트 크기 제어 불가 — NSAttributedString으로 NSImage에 직접 draw 필요

## Swift 6 Strict Concurrency

- `@MainActor` 클래스의 static 순수 함수는 `nonisolated` 명시해야 테스트에서 동기 호출 가능

## SPM Naming Conventions

- **디렉토리/타겟명**: PascalCase가 표준 (SE-0129). 예: `Sources/MyModule/`, `Tests/MyModuleTests/`
- **테스트 디렉토리**: 반드시 `Tests` 접미사 (SE-0129 공식 요구)
- **레포명**: Apple은 kebab-case + `swift-` prefix (`swift-log`), 커뮤니티는 PascalCase (`Alamofire`) — 둘 다 유효
- **Package name과 레포명**: 일치시키면 편리하지만 필수 아님. Apple은 `swift-log`(레포) = `"swift-log"`(Package name) ≠ `Logging`(product name)
- **product name (import 대상)**: PascalCase가 사실상 강제 (`import Logging`, `import NIO`)
