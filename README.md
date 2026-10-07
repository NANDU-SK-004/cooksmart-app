# 🍳 CookSmart — AI-Powered Mobile Pantry Assistant

[![Flutter](https://img.shields.io/badge/Flutter-3.38-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Google Gemini](https://img.shields.io/badge/Google%20Gemini-Generative%20AI-8E75B2?logo=google&logoColor=white)](https://aistudio.google.com/)
[![Android](https://img.shields.io/badge/Platform-Android%20%7C%20Web-3DDC84?logo=android&logoColor=white)](https://android.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> **Transform leftover ingredients in your pantry into gourmet, chef-quality recipes in seconds using Google Gemini AI.**

---

## 📖 Overview

Ever opened your fridge, stared at random ingredients like spinach, eggs, and mushrooms, and wondered what to make? **CookSmart** is an intelligent, cross-platform mobile assistant that eliminates food waste and mealtime indecision by generating realistic, delicious recipes tailored specifically to what you already have at home.

Built with **Flutter** and connected directly to **Google's Gemini API**, CookSmart delivers instant recipe generation, interactive cooking timers, portion scaling, and personalized bookmarking in a warm, dark-themed mobile interface.

---

## ✨ Key Features

- 🥬 **Smart Pantry Chef**: Easily add pantry ingredients with a tagger interface and one-tap quick-add suggestions.
- ⚡ **Real-Time Generative AI**: Direct integration with Google Gemini with automated multi-model fallback (`gemini-flash-lite-latest` → `gemini-3.1-flash-lite` → `gemini-3.8-flash`) for instant responses and 99.9% uptime.
- 📐 **Dynamic Servings Scaler**: Interactive portion stepper (`+` / `-`) that automatically recalculates ingredient measurements and quantities on the fly.
- ⏱️ **Step-by-Step Cooking Mode**: Detailed, numbered cooking instructions featuring integrated timer badges for each cooking stage.
- 🔖 **Bookmark & Collection Manager**: Save AI-generated and trending recipes into categorized collections (*Quick <30m*, *High Protein*, *Vegetarian*, *Favorites*).
- 🎨 **Modern Dark Aesthetic**: Styled with warm amber and orange accents, ergonomic bottom navigation, and a native dark splash screen.

---

## 📱 App Screens

| 1. Home Screen | 2. Pantry Chef | 3. Recipe Results | 4. Saved Recipes |
| :---: | :---: | :---: | :---: |
| Hero search, trending carousel, daily stats | Real-time ingredient tagger & quick chips | Scalable ingredients, timer chips, save action | Categorized grid of bookmarked dishes |

---

## 🛠️ Tech Stack & Architecture

- **Framework**: [Flutter](https://flutter.dev) (v3.38+)
- **Language**: [Dart](https://dart.dev)
- **AI Engine**: [Google Gemini API](https://ai.google.dev/) (Structured JSON responseSchema & fallback parsing)
- **Networking**: `http: ^1.2.2` (RESTful communication with Google Generative Language endpoints)
- **Design & Typography**: Google Fonts (`Plus Jakarta Sans`), custom design tokens
- **Platform Support**: Android (Native APK compiled with Gradle Kotlin DSL), Web (HTML5/CanvasKit), Windows

---

## 📂 Project Structure

```text
cooksmart-app/
├── cooksmart_app/                     # Flutter mobile application
│   ├── android/                       # Native Android project files & Gradle configuration
│   ├── lib/
│   │   ├── config/                    # API and environment configuration
│   │   │   ├── api_config.dart        # Local API key (git-ignored for security)
│   │   │   └── api_config.example.dart# Public template for cloning
│   │   ├── models/                    # Data models (Recipe, Ingredient, Step)
│   │   ├── screens/                   # 4 Core application screens
│   │   │   ├── home_screen.dart
│   │   │   ├── ingredients_screen.dart
│   │   │   ├── recipe_screen.dart
│   │   │   └── saved_screen.dart
│   │   ├── services/                  # Gemini AI API service & fallback logic
│   │   ├── state/                     # Reactive app state management
│   │   ├── theme/                     # AppTheme colors, typography, styles
│   │   └── main.dart                  # Application entry point
│   ├── test/                          # Unit and widget test suite
│   └── pubspec.yaml                   # Flutter dependencies & metadata
├── .stitch/                           # Google Stitch UI design specifications
└── README.md                          # Repository documentation
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.24 or newer)
- [Dart SDK](https://dart.dev/get-dart)
- An active [Google Gemini API Key](https://aistudio.google.com/app/apikey) (free tier supported)

### 1. Clone the Repository

```bash
git clone https://github.com/NANDU-SK-004/cooksmart-app.git
cd cooksmart-app/cooksmart_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Your Gemini API Key

1. Copy the example configuration file:
   ```bash
   cp lib/config/api_config.example.dart lib/config/api_config.dart
   ```
2. Open `lib/config/api_config.dart` and insert your Gemini API key:
   ```dart
   class ApiConfig {
     static const String geminiApiKey = 'YOUR_ACTUAL_GEMINI_API_KEY';
   }
   ```
   *(Note: `api_config.dart` is in `.gitignore` and will never be committed to Git).*

Alternatively, you can pass your API key at runtime without touching the code:
```bash
flutter run --dart-define=GEMINI_API_KEY="YOUR_ACTUAL_GEMINI_API_KEY"
```

---

## 🏃 Running the Application

### Run on Chrome (Web):
```bash
flutter run -d chrome
```

### Run on a Connected Android Device:
```bash
flutter run -d android
```

### Build a Standalone Android APK:
```bash
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk
```

---

## 🧪 Testing

Run the automated test suite:
```bash
flutter test
```

Run static code analysis:
```bash
flutter analyze
```

---

## 🔒 Security Best Practices

- API credentials are decoupled using dedicated config templates and excluded via `.gitignore`.
- Android app permissions are restricted strictly to `android.permission.INTERNET` and `android.permission.ACCESS_NETWORK_STATE`.
- Zero sensitive user data or credentials exist in the Git commit history.

---

## 👨‍💻 Author

Created by **Nandu**  
- GitHub: [@NANDU-SK-004](https://github.com/NANDU-SK-004)

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
