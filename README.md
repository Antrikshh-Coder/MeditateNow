# 🧘 MeditateNow — Production-Grade Pure Flutter & Dart Mindfulness Web App

> **"Find your calm."**  
> A client-ready, responsive, cross-platform Flutter Web application built with pure Dart, Material 3 Scandinavian design aesthetics, real-time audio playback engine, interactive breathing visualizer, and persistent streak tracking.

---

## ✨ Features & Highlights

- 🎧 **Continuous Audio Engine (`just_audio`)**: Seamless looping audio playback matching the full session duration (5 min, 8 min, 10 min, 15 min, 20 min) with full scrubber control, play/pause, +/-10s relative seek, volume controls, and global mini-player persistence.
- 🧘 **Guided Meditation Library**: Filterable sessions across Morning, Focus, Stress Relief, Sleep, Anxiety, and Self Love with detailed instructor info, ratings, and benefits.
- 🫁 **Interactive Breathing Visualizer**: Custom animated expanding/contracting circle with guided inhale/hold/exhale phase indicators for Box Breathing, Calm Breathing, and 4-7-8 Relaxation.
- 🌙 **Sleep Soundscapes & Fade Timer**: High-quality ambient soundscapes with configurable sleep fade timer (10, 20, 30, 45, 60 mins).
- 🔥 **Streak & Progress Engine**: Real-time streak counter, weekly activity tracker, total mindful minutes, and unlocked achievement badges backed by `SharedPreferences`.
- 🌓 **Adaptive Light & Dark Mode**: Pristine Scandinavian aesthetic in light mode and rich AMOLED dark mode across desktop, tablet, and mobile breakpoints.

---

## 🏛️ Clean Architecture Overview

```text
flutter_meditatenow/
├── pubspec.yaml                 # Dependencies: just_audio, shared_preferences, google_fonts
├── assets/                      # High-resolution artwork (.png) and audio tracks (.mp3)
├── lib/
│   ├── main.dart                # Main app entry point with light/dark theme provider & responsive layout shell
│   ├── core/
│   │   └── theme.dart           # Scandinavian color palette tokens (Deep Forest Green, Sage, Warm Cream, Dark Slate)
│   ├── models/
│   │   ├── meditation_session.dart # Guided meditation model with benefits & duration
│   │   ├── sleep_sound.dart        # Ambient sleep soundscape model
│   │   ├── breathing_exercise.dart # Inhale / hold / exhale rhythm model
│   │   ├── user_progress.dart      # Persistent streak, mindful minutes, completed sessions model
│   │   └── achievement.dart        # Milestone badges model
│   ├── data/
│   │   └── mock_data.dart          # Production-ready curated mock sessions, audio, and exercises
│   ├── services/
│   │   ├── audio_service.dart      # Singleton just_audio service with virtual session position timer & stream
│   │   └── progress_service.dart   # SharedPreferences persistence layer
│   ├── screens/
│   │   ├── home_screen.dart               # Personalized dashboard & recommendations
│   │   ├── meditation_library_screen.dart # Filterable library by category & search
│   │   ├── meditation_detail_screen.dart  # Session overview & benefit breakdown
│   │   ├── meditation_player_screen.dart  # Full-screen player with pulsing visualizer
│   │   ├── breathing_screen.dart          # Guided box breathing exercise
│   │   ├── sleep_screen.dart              # Sleep soundscapes & fade timer
│   │   ├── progress_screen.dart           # Analytics, streaks, weekly grid & badges
│   │   └── settings_screen.dart           # Responsive web settings dashboard & theme toggle
│   └── widgets/
│       ├── mini_player.dart        # Global floating audio mini-player with progress indicator
│       └── responsive_shell.dart   # Adaptive NavigationRail (Desktop/Tablet) and NavigationBar (Mobile)
```

---

## 🔧 Technical Fixes Applied

### 🔊 Audio Duration & Continuous Looping Fix
- **Issue**: Short ~10-second sample audio files were causing the player to complete prematurely even when session duration was set to minutes (e.g. 10 mins).
- **Solution**: Implemented a virtual target session duration timer (`targetDurationSeconds`) in `FlutterAudioService` paired with continuous sample audio looping (`LoopMode.one`). The player now seamlessly loops audio while accurately incrementing timer progress from `00:00` up to `10:00` (or target duration), ensuring uninterrupted play for the full duration.

---

## 🚀 How to Run Locally

1. **Install Flutter Dependencies**:
   ```bash
   cd flutter_meditatenow
   flutter pub get
   ```

2. **Run in Chrome (Development)**:
   ```bash
   flutter run -d chrome
   ```

3. **Build Production Bundle for Web**:
   ```bash
   flutter build web --release
   ```

---

## 📦 How to Upload to GitHub

Follow these steps to upload this project to your GitHub account:

1. **Open Terminal in Project Directory**:
   ```bash
   cd /Users/antriksh.manwadkar/Downloads/meditatenow/flutter_meditatenow
   ```

2. **Initialize Git Repository (if not already done)**:
   ```bash
   git init
   git add .
   git commit -m "feat: complete MeditateNow Flutter web app with audio session fix & responsive Material 3 UI"
   ```

3. **Link Your GitHub Repository & Push**:
   ```bash
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/meditatenow.git
   git push -u origin main
   ```

---

## 📄 License
This project is open-source under the MIT License.
