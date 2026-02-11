# FashionBot

AI-powered personal stylist iOS app. Users photograph their wardrobe and receive outfit recommendations based on what they own, the current season, and their style preferences.

## Tech Stack

- **SwiftUI** — Declarative UI (iOS 17+ deployment target)
- **Swift 6** — Strict concurrency enabled
- **SwiftData** — Persistence layer
- **PhotosUI / AVFoundation** — Camera & photo library
- **Claude API** — AI backbone for styling recommendations
- **XcodeGen** — Project generation from `project.yml`
- **MVVM** — Architecture pattern

## Architecture

```
┌─────────────────────────────────┐
│           SwiftUI Views         │
├─────────────────────────────────┤
│           ViewModels            │
├──────────┬──────────┬───────────┤
│ Wardrobe │  Style   │    AI     │
│  Service │ Service  │  Service  │
├──────────┴──────────┴───────────┤
│     SwiftData / Persistence     │
└─────────────────────────────────┘
```

## Project Structure

```
FashionBot/
├── App/                  # App entry point (FashionBotApp.swift)
├── Views/                # SwiftUI views, organized by feature
│   ├── Wardrobe/
│   ├── Outfits/
│   └── Profile/
├── ViewModels/           # ObservableObject view models
├── Models/               # SwiftData @Model classes
├── Services/             # Business logic and API clients
├── Utilities/            # Shared helpers and extensions
└── Resources/            # Assets, colors, app icon
FashionBotTests/          # Unit tests (Swift Testing framework)
FashionBotUITests/        # UI tests (XCTest / XCUIApplication)
project.yml               # XcodeGen project spec (source of truth)
```

## Conventions

- **Views**: Each feature gets a subfolder under `Views/`. Use `NavigationStack` for drill-down navigation within each tab.
- **Empty states**: Use `ContentUnavailableView` for placeholder/empty states (iOS 17+).
- **Tab icons**: SF Symbols — `tshirt.fill` (Wardrobe), `sparkles` (Outfits), `person.fill` (Profile).
- **Tests**: Unit tests use Swift Testing (`import Testing`, `@Test`, `#expect`). UI tests use XCTest (`XCUIApplication`).
- **Previews**: Every view includes a `#Preview` block.
- **No force unwraps** in production code.
- **Imports** consolidated at the top of files.

## Build & Test

```bash
# Generate Xcode project from spec
xcodegen generate

# Build
xcodebuild build -scheme FashionBot -destination 'platform=iOS Simulator,name=iPhone 17 Pro'

# Run unit tests
xcodebuild test -scheme FashionBot -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:FashionBotTests

# Run UI tests
xcodebuild test -scheme FashionBot -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:FashionBotUITests
```

## Branching

- Branch naming: `issue-<number>/<short-description>` (e.g., `issue-3/core-data-models`)
- PRs target `main` and reference the issue with `Closes #<number>`
- Roadmap and all issues tracked in GitHub: Epic is issue #1

## Key Decisions

- iOS 17+ only — enables `ContentUnavailableView`, modern `NavigationStack`, and latest SwiftData APIs.
- XcodeGen over manual `.xcodeproj` — keeps project config declarative and merge-friendly via `project.yml`.
- Swift 6 strict concurrency — catches threading issues at compile time.
