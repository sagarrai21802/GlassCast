# 🌤️ Glasscast - Premium Weather App

A beautifully designed iOS weather application built with SwiftUI, featuring a glassmorphism UI, OTP authentication, and real-time weather data.

![iOS 26+](https://img.shields.io/badge/iOS-26%2B-blue)
![Swift 5.9](https://img.shields.io/badge/Swift-5.9-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0-green)

## 📱 Demo

> 🎬 **Video Demo**: [Watch the demo video](./demo.mp4)

## ✨ Features

### Core Features
- 🌡️ **Real-time Weather** - Current conditions, temperature, humidity, wind
- 📅 **5-Day Forecast** - Daily weather predictions with high/low temps
- 🔍 **City Search** - Find and add any city worldwide
- ❤️ **Favorites** - Save cities and sync across sessions
- 🌙 **Dark/Light Mode** - System, light, or dark theme options
- 📲 **Haptic Feedback** - Tactile responses for premium feel

### Security
- 🔐 **OTP Authentication** - Email-based verification (no magic links)
- 🔑 **Keychain Storage** - All API keys stored securely
- 🔄 **Auto-Login** - Session persistence via Keychain

### Polish
- ✨ **Glassmorphism UI** - Modern translucent design
- 🎭 **Smooth Animations** - Staggered card entrances, floating icons
- 📱 **Premium Loading States** - Shimmer effects and styled errors

## 🛠️ Tech Stack

| Component | Technology |
|-----------|------------|
| UI Framework | SwiftUI |
| Architecture | MVVM |
| Backend | Supabase (Auth + PostgreSQL) |
| Weather API | OpenWeatherMap |
| Secure Storage | iOS Keychain |
| Testing | XCTest |

## 📦 Installation

### Prerequisites
- Xcode 26.0+
- iOS 26.0+ device or simulator
- Swift 5.9+

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/sagarrai21802/GlassCast.git
   cd GlassCast
   ```

2. **Open in Xcode**
   ```bash
   open Glasscast.xcodeproj
   ```

3. **Install Dependencies**
   - Xcode will automatically resolve Swift Package Manager dependencies
   - Wait for Supabase SDK to download

4. **Build & Run**
   - Select a simulator or device
   - Press `Cmd + R`

## 🔐 API Key Configuration

The app uses **Keychain** for secure API key storage. On first launch, default development keys are automatically stored.

### How It Works

1. **First Launch**: `SecureKeyStorage.swift` initializes default keys:
   - Supabase URL
   - Supabase Anon Key
   - OpenWeatherMap API Key

2. **Subsequent Launches**: Keys are read from Keychain (not source code)

### Updating API Keys

To use your own API keys, modify `SecureKeyStorage.swift`:

```swift
private func initializeDefaultKeysIfNeeded() {
    if retrieve(key: .supabaseURL) == nil {
        _ = save(key: .supabaseURL, value: "YOUR_SUPABASE_URL")
    }
    
    if retrieve(key: .supabaseAnonKey) == nil {
        _ = save(key: .supabaseAnonKey, value: "YOUR_SUPABASE_ANON_KEY")
    }
    
    if retrieve(key: .openWeatherAPIKey) == nil {
        _ = save(key: .openWeatherAPIKey, value: "YOUR_OPENWEATHER_API_KEY")
    }
}
```

### Getting Your Own Keys

| Service | How to Get |
|---------|-----------|
| **Supabase** | Create project at [supabase.com](https://supabase.com) |
| **OpenWeatherMap** | Sign up at [openweathermap.org](https://openweathermap.org/api) |

## 🧪 Running Tests

```bash
# Run all tests
xcodebuild test -scheme Glasscast -destination 'platform=iOS Simulator,name=iPhone 16'

# Or in Xcode
Cmd + U
```

### Test Coverage
- `SecureKeyStorageTests` - Keychain operations
- `PreferencesServiceTests` - User preferences persistence
- `WeatherServiceTests` - JSON decoding, model validation

## 📁 Project Structure

```
Glasscast/
├── Core/
│   └── Theme/
│       ├── GlasscastTheme.swift
│       ├── PremiumBackground.swift
│       └── AnimationStyles.swift
├── Features/
│   ├── Auth/
│   │   ├── Views/
│   │   │   ├── AuthView.swift
│   │   │   └── OTPVerificationView.swift
│   │   └── ViewModels/
│   │       └── AuthViewModel.swift
│   ├── Home/
│   │   ├── Views/
│   │   │   └── HomeView.swift
│   │   └── ViewModels/
│   │       └── HomeViewModel.swift
│   ├── Favourites/
│   ├── Settings/
│   └── Navigation/
├── Services/
│   ├── SupabaseService.swift
│   ├── WeatherService.swift
│   ├── LocationService.swift
│   ├── PreferencesService.swift
│   ├── SecureKeyStorage.swift
│   ├── KeychainLocalStorage.swift
│   └── HapticService.swift
└── Shared/
    └── Components/
        └── SharedComponents.swift
```

## 🎨 Design Highlights

- **Glassmorphism**: Translucent backgrounds with blur effects
- **Adaptive Colors**: Uses `.primary` for automatic light/dark adaptation
- **Spring Animations**: Natural-feeling card transitions
- **Floating Elements**: Weather icon gently floats for visual interest

## 📝 License

This project is for educational purposes. Feel free to use as reference.

## 👤 Author

**Sagar Rai**
- GitHub: [@sagarrai21802](https://github.com/sagarrai21802)

---

Made with ❤️ using SwiftUI
