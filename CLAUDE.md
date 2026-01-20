# Glasscast Project Context

**Overview**: Premium iOS Weather App (SwiftUI) with Supabase Auth & Keychain Security.

## Tech Stack
- **Language**: Swift 5.9
- **UI**: SwiftUI (MVVM)
- **Backend / Auth**: Supabase (PostgreSQL, OTP Auth)
- **API**: OpenWeatherMap
- **Security**: iOS Keychain (API Keys & Session Tokens)

## Core Features
1.  **Glass UI**: Custom components in `Core/Theme`.
2.  **Auth**: OTP Email flow (`AuthView`, `SupabaseService`).
3.  **Weather**: Real-time & 5-day forecast (`HomeView`, `WeatherService`).
4.  **Security**: API keys stored in Keychain (`SecureKeyStorage`).
5.  **Haptics**: Custom feedback wrapper (`HapticService`).

## Key Commands
- **Run Tests**: `Cmd + U` (Covers Key Storage, Preferences, JSON Models).
- **Build**: `Cmd + B`.

## Project Structure
- `Features/`: Auth, Home, Favourites, Settings.
- `Services/`: Supabase, Weather, Location, SecureKeyStorage.
- `Core/Theme/`: Colors, Animations, Backgrounds.

## Setup Notes
- **API Keys**: Stored in Keychain. On first run, `SecureKeyStorage` populates default dev keys.
- **Supabase**: Requires `favorites` table with RLS enabled.

## Code Style
- Use `Task { }` for concurrency.
- **No hardcoded keys** in view models. Use `SecureKeyStorage`.
- Keep views small; extract components to `Shared/`.
