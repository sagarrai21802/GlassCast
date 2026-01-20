# CLAUDE.md - Glasscast Project Context

This file provides context for AI assistants working on this codebase.

## Project Overview

**Glasscast** is a premium iOS weather app built with SwiftUI, featuring:
- Glassmorphism UI design
- OTP-based email authentication (Supabase)
- Real-time weather data (OpenWeatherMap)
- Secure Keychain storage for API keys
- Dark/Light mode support
- Haptic feedback

## Development History

### Phase 1: Setup & Design
- Created Xcode project targeting iOS 26
- Set up Supabase project with auth and PostgreSQL database
- Designed glassmorphism UI for auth and home screens

### Phase 2: Core Infrastructure
- Implemented MVVM architecture
- Created `SupabaseService` for authentication
- Created `WeatherService` for OpenWeatherMap API
- Created `LocationService` for CoreLocation

### Phase 3: Authentication
- Built login/signup UI with premium design
- Implemented email/password authentication via Supabase
- **Later replaced magic links with OTP verification**
- Added `OTPVerificationView` for 6-digit code entry

### Phase 4: Home & Navigation
- Built custom glass tab bar with animations
- Implemented Home screen with weather display
- Added city search with debouncing
- Built Favourites and Settings screens

### Phase 5: Weather & Favorites
- Integrated OpenWeatherMap API
- Added 5-day forecast display
- Implemented add/remove favorites
- Synced favorites with Supabase database

### Phase 6: Settings
- Temperature unit toggle (°C/°F)
- Theme picker (System/Light/Dark)
- Sign out functionality
- User preferences persistence

### Phase 7: Polish
- Added staggered card entrance animations
- Floating weather icon animation
- Created `AnimationStyles.swift` with reusable modifiers
- Replaced inline loading/error views with `SharedComponents.swift`

### Phase 8: Security
- **Moved API keys to Keychain** via `SecureKeyStorage.swift`
- Implemented `KeychainLocalStorage` for Supabase session persistence
- Auto-login on app launch via `restoreSession()`
- Removed deep link handling (not needed for OTP flow)

### Phase 9: Testing & Quality
- Created `GlasscastTests` target
- Added unit tests for:
  - `SecureKeyStorageTests` - Keychain CRUD operations
  - `PreferencesServiceTests` - UserDefaults persistence
  - `WeatherServiceTests` - JSON decoding and models

### Bonus: Haptic Feedback
- Created `HapticService.swift` for centralized haptics
- Added haptics to: tab bar, toggles, buttons, favorites

## Key Files

### Services
| File | Purpose |
|------|---------|
| `SupabaseService.swift` | Auth and database operations |
| `WeatherService.swift` | Weather API calls and models |
| `LocationService.swift` | CoreLocation wrapper |
| `PreferencesService.swift` | User preferences (Observable) |
| `SecureKeyStorage.swift` | Keychain API key storage |
| `KeychainLocalStorage.swift` | Supabase session storage |
| `HapticService.swift` | Haptic feedback utilities |

### Views
| File | Purpose |
|------|---------|
| `AuthView.swift` | Login/signup form |
| `OTPVerificationView.swift` | 6-digit OTP entry |
| `HomeView.swift` | Weather display and search |
| `FavouritesView.swift` | Saved cities list |
| `SettingsView.swift` | App preferences |
| `CustomTabBar.swift` | Glass-style navigation |

### Theme
| File | Purpose |
|------|---------|
| `GlasscastTheme.swift` | Colors, typography, spacing |
| `PremiumBackground.swift` | Animated gradient background |
| `AnimationStyles.swift` | Reusable animation modifiers |
| `SharedComponents.swift` | Loading, error, empty states |

## API Configuration

### Current Setup
API keys are stored in iOS Keychain on first launch:
```swift
// SecureKeyStorage.swift
private func initializeDefaultKeysIfNeeded() {
    if retrieve(key: .supabaseURL) == nil {
        _ = save(key: .supabaseURL, value: "https://...")
    }
    // ... same for other keys
}
```

### Key Identifiers
```swift
enum SecureStorageKey: String {
    case supabaseURL = "com.glasscast.supabase.url"
    case supabaseAnonKey = "com.glasscast.supabase.anonkey"
    case openWeatherAPIKey = "com.glasscast.openweather.apikey"
}
```

## Supabase Schema

### Tables
```sql
-- favorites table
CREATE TABLE favorites (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    city_name TEXT NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    country TEXT,
    state TEXT,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- RLS enabled
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;

-- Users can only access their own favorites
CREATE POLICY "Users can manage own favorites" ON favorites
    FOR ALL USING (auth.uid() = user_id);
```

## Common Tasks

### Adding a new service
1. Create file in `Glasscast/Services/`
2. Follow singleton pattern with `static let shared`
3. Add unit tests in `GlasscastTests/`

### Adding a new feature
1. Create folder under `Glasscast/Features/[FeatureName]/`
2. Add `Views/` and `ViewModels/` subfolders
3. Follow existing MVVM pattern

### Updating API keys
Modify `SecureKeyStorage.swift` → `initializeDefaultKeysIfNeeded()`
Then delete app and reinstall to reset Keychain.

## Testing

```bash
# Run all tests
Cmd + U in Xcode

# Run specific test file
xcodebuild test -scheme Glasscast -only-testing:GlasscastTests/WeatherServiceTests
```

## Known Issues

1. **Haptics only work on device** - Simulator doesn't support haptic feedback
2. **Keychain persists after delete** - Uninstall doesn't clear Keychain on simulator
3. **Pull-to-refresh animation** - Slight delay before haptic fires

## Future Improvements

- [ ] Supabase Realtime for live favorites sync
- [ ] iOS Home Screen widgets
- [ ] Apple Watch companion app
- [ ] Weather alerts/notifications
- [ ] Multiple weather providers
