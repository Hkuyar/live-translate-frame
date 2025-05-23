# Live Translate Frame AI

## Purpose  
Translate spoken languages in real time on Frame AI glasses via OpenAI GPT.

## Prerequisites  
- Flutter SDK  
- Android Studio + emulator  
- Xcode (for iOS)  
- Git  
- OpenAI API key  
- Frame SDK codebase  

Usage
Pair with Frame AI via BLE

Press glasses button to start listening

Spoken non-English is auto-translated and shown as subtitles

(Future) reverse translation mode via settings

## Setup  
```bash
git clone https://github.com/<you>/live-translate-frame.git
cd live-translate-frame
flutter pub get
echo "OPENAI_API_KEY=sk-…" > .env
flutter run
