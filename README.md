# Glasscast 🌤️

**Built live on stream!** 🎥

Glasscast isn't just another weather app. It's an exploration into premium iOS design, connecting real data with a beautiful, tactile interface. We built this from scratch, focusing on "glassmorphism" aesthetics, smooth animations, and top-tier security.

[**Watch the Making Of / Demo Video**](https://drive.google.com/file/d/1HdSpUpRuEt4PGOGlJel7-obg_2bMeuQY/view?usp=sharing)
[**Watch the Live Build on YouTube**](https://youtube.com/live/WqX9LzF3sKU?feature=share)

---

## What's Inside?

*   **Glass UI**: Translucent layers that adapt to Light/Dark mode.
*   **Real-time Weather**: Powered by OpenWeatherMap.
*   **Secure Auth**: Sign up with email via Supabase (OTP only, no passwords saved).
*   **Keychain Security**: We don't hardcode keys. They live in the iOS Keychain.
*   **Feel the Weather**: Haptic feedback on every meaningful interaction.

## Tech Stack

*   **SwiftUI** (iOS 26+)
*   **Supabase** (Auth & Database)
*   **Keychain Services**
*   **MVVM Architecture**

---

## How to Run This

1.  **Clone it**:
    ```bash
    git clone https://github.com/sagarrai21802/GlassCast.git
    open Glasscast.xcodeproj
    ```

2.  **Wait a sec**: Xcode will fetch the Supabase SDK.

3.  **API Keys (The Secure Way)**:
    This app uses **Keychain** to store API keys, so they aren't exposed in the code.
    
    On the very first launch, the app sets up default keys (for demo purposes). If you want to use *your* keys, check `Services/SecureKeyStorage.swift` and look for `initializeDefaultKeysIfNeeded()`.

    You'll need keys for:
    *   **Supabase** (URL & Anon Key)
    *   **OpenWeatherMap** (API Key)

4.  **Run**: Hit `Cmd + R` and enjoy.

---

## Testing

We added unit tests for the critical stuff (Security, Preferences, JSON parsing).
Run them with `Cmd + U`.

---

**Made by Sagar Rai**
*Built with passion, code, and coffee.*
