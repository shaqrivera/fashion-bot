# FashionBot

Your personal AI stylist. Upload pictures of your wardrobe and receive outfit recommendations based on what you own, the current season, and your style preferences.

## Tech Stack

| Technology | Purpose |
|---|---|
| SwiftUI | Declarative UI framework |
| Swift 6 | Strict concurrency enabled |
| SwiftData | On-device persistence |
| PhotosUI / AVFoundation | Camera & photo library |
| Claude API | AI-powered styling recommendations |
| XcodeGen | Declarative project generation |

## Architecture

MVVM with a service layer:

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
├── App/                  # App entry point
├── Views/                # SwiftUI views, organized by feature
│   ├── Wardrobe/         # Clothing gallery and management
│   ├── Outfits/          # AI-generated outfit recommendations
│   └── Profile/          # Style preferences and settings
├── ViewModels/           # ObservableObject view models
├── Models/               # SwiftData @Model classes
├── Services/             # Business logic and API clients
├── Utilities/            # Shared helpers and extensions
└── Resources/            # Assets, colors, app icon
FashionBotTests/          # Unit tests (Swift Testing)
FashionBotUITests/        # UI tests (XCTest)
project.yml               # XcodeGen project spec
```

## Requirements

- Xcode 16+
- iOS 17.0+ deployment target
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (for project generation)

## Getting Started

```bash
# Clone the repo
git clone git@github.com:shaqrivera/fashion-bot.git
cd fashion-bot

# Generate the Xcode project
xcodegen generate

# Open in Xcode
open FashionBot.xcodeproj
```

## Build & Test

```bash
# Build
xcodebuild build -scheme FashionBot \
  -destination 'platform=iOS Simulator,name=iPhone 16'

# Run unit tests
xcodebuild test -scheme FashionBot \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -only-testing:FashionBotTests

# Run UI tests
xcodebuild test -scheme FashionBot \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  -only-testing:FashionBotUITests
```

## Roadmap

Development is tracked via [GitHub Issues](https://github.com/shaqrivera/fashion-bot/issues). See the [project roadmap](https://github.com/shaqrivera/fashion-bot/issues/1) for the full plan.

| Milestone | Status | Description |
|---|---|---|
| M1: Foundation | In Progress | Project setup, data models, navigation, persistence |
| M2: Wardrobe Management | Planned | Photo capture, categorization, gallery, CRUD |
| M3: Style Profile | Planned | Onboarding, preferences, season/weather awareness |
| M4: AI Recommendations | Planned | Claude API integration, outfit generation, feedback |
| M5: Polish & Wish List | Planned | History, wish list, UI refinements |
