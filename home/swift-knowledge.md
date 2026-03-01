# Swift / SwiftUI Knowledge

## MenuBarExtra

- `MenuBarExtra` label 내에서 SwiftUI `.font()`, `VStack`, `Divider` 등 modifier/레이아웃이 무시됨
- 커스텀 렌더링이 필요하면 NSImage로 직접 그린 뒤 `Image(nsImage:)`로 전달해야 함
- `Text`는 표시되지만 폰트 크기 제어 불가 — NSAttributedString으로 NSImage에 직접 draw 필요

## MenuBarExtra — Keyboard Focus for Child Windows

- `MenuBarExtra` 앱은 `NSApplication.activationPolicy`가 `.accessory`라서, 별도 NSWindow(예: WKWebView 로그인 창)를 열어도 키보드 포커스를 받지 못함
- 해결: 창 열기 전 `NSApp.setActivationPolicy(.regular)`, 창 닫을 때 `.accessory`로 복원
- `kSecUseDataProtectionKeychain: true`로 저장된 Keychain 항목은 해당 앱의 코드 서명 컨텍스트에서만 접근 가능 — `security` CLI로는 읽을 수 없음

## Swift 6 Strict Concurrency

- `@MainActor` 클래스의 static 순수 함수는 `nonisolated` 명시해야 테스트에서 동기 호출 가능

## SPM Naming Conventions

- **디렉토리/타겟명**: PascalCase가 표준 (SE-0129). 예: `Sources/MyModule/`, `Tests/MyModuleTests/`
- **테스트 디렉토리**: 반드시 `Tests` 접미사 (SE-0129 공식 요구)
- **레포명**: Apple은 kebab-case + `swift-` prefix (`swift-log`), 커뮤니티는 PascalCase (`Alamofire`) — 둘 다 유효
- **Package name과 레포명**: 일치시키면 편리하지만 필수 아님. Apple은 `swift-log`(레포) = `"swift-log"`(Package name) ≠ `Logging`(product name)
- **product name (import 대상)**: PascalCase가 사실상 강제 (`import Logging`, `import NIO`)
