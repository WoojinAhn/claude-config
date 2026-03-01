# Swift / SwiftUI Knowledge

## MenuBarExtra

- `MenuBarExtra` label 내에서 SwiftUI `.font()`, `VStack`, `Divider` 등 modifier/레이아웃이 무시됨
- 커스텀 렌더링이 필요하면 NSImage로 직접 그린 뒤 `Image(nsImage:)`로 전달해야 함
- `Text`는 표시되지만 폰트 크기 제어 불가 — NSAttributedString으로 NSImage에 직접 draw 필요

## Swift 6 Strict Concurrency

- `@MainActor` 클래스의 static 순수 함수는 `nonisolated` 명시해야 테스트에서 동기 호출 가능
