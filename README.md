<div align="center">

  # 🧘 MeditateNow — Premium Flutter Web Mindfulness App

  <p align="center">
    <strong>"Find your calm."</strong><br>
    A production-grade, responsive Flutter Web application built with Dart, Material 3 Scandinavian design, real-time audio engine, guided breathing visualizer, and persistent streak tracking.
  </p>

  <p align="center">
    <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter Badge">
    <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart Badge">
    <img src="https://img.shields.io/badge/Material_3-Scandinavian_Theme-2E7D32?style=for-the-badge" alt="Material 3 Badge">
    <img src="https://img.shields.io/badge/Platform-Flutter_Web-42A5F5?style=for-the-badge&logo=googlechrome&logoColor=white" alt="Web Badge">
    <img src="https://img.shields.io/badge/License-MIT-green.style=for-the-badge" alt="License Badge">
  </p>

</div>

---

## 📸 Visual Showcase & Screenshots

### 🏠 1. Dashboard & Personalized Recommendations
The home screen features daily quote cards, quick-start session chips, streak counters, and curated recommendations tailored to your daily rhythm.

<div align="center">
  <img src="docs/screenshots/home_dashboard.png" width="900" alt="Home Dashboard" style="border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.15);">
</div>

---

### 🎧 2. Guided Session Audio Player (10:00 Timer)
Full-screen audio player with pulsing radial gradient visualizer, real-time minute scrubber (`00:00` $\to$ `10:00`), play/pause, +/-10s seek, and volume control.

<div align="center">
  <img src="docs/screenshots/audio_player.png" width="800" alt="Audio Player" style="border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.15);">
</div>

---

### 🎨 3. Responsive Light & Dark Mode Settings
Designed with Scandinavian minimalism — support for high-contrast light mode and rich AMOLED dark mode across desktop, tablet, and mobile displays.

| ☀️ Light Mode Theme | 🌙 Dark Mode Theme |
| :---: | :---: |
| <img src="docs/screenshots/settings_light_mode.png" width="440" alt="Light Mode"> | <img src="docs/screenshots/settings_dark_mode.png" width="440" alt="Dark Mode"> |

---

### 🎵 4. Global Mini-Player Persistence
Allows users to minimize the active audio session into a floating bottom bar with real-time stream progress while browsing the library or changing settings.

<div align="center">
  <img src="docs/screenshots/mini_player.png" width="850" alt="Mini Player" style="border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.15);">
</div>

---

## ✨ Key Features & Capabilities

- 🎧 **Continuous Audio Engine (`just_audio`)**: Seamless looping ambient audio matching target session durations (5, 8, 10, 15, 20 mins) with scrubber seeking and global mini-player persistence.
- 🧘 **Guided Meditation Library**: Filterable sessions across Morning, Focus, Stress Relief, Sleep, Anxiety, and Self Love with instructor details, ratings, and health benefits.
- 🫁 **Interactive Breathing Visualizer**: Custom animated expanding/contracting circle with guided inhale/hold/exhale phase indicators for Box Breathing, Calm Breathing, and 4-7-8 Relaxation.
- 🌙 **Sleep Soundscapes & Fade Timer**: High-quality ambient soundscapes (Rain, Ocean Waves, Forest Night, Soft Wind, Night Ambience, White Noise) with customizable sleep fade timer (10, 20, 30, 45, 60 mins).
- 🔥 **Streak & Progress Engine**: Real-time streak counter, weekly activity rhythm grid, total mindful minutes, and unlocked achievement badges backed by `SharedPreferences`.
- 📐 **Adaptive Responsive Layout**: Clean NavigationRail for Desktop/Tablet displays and NavigationBar for Mobile.

---

## 🏛️ Project Architecture & Tech Stack

```text
flutter_meditatenow/
├── docs/
│   └── screenshots/              # High-resolution application screenshots
├── assets/
│   ├── audio/                    # Ambient audio tracks (.wav & .mp3 dual-format)
│   └── images/                   # High-res nature artwork (.png)
├── lib/
│   ├── main.dart                 # Application entry point & MaterialApp theme configuration
│   ├── core/
│   │   └── theme.dart            # Scandinavian color tokens (Deep Forest Green, Sage, Warm Cream, Dark Slate)
│   ├── models/
│   │   ├── meditation_session.dart  # Guided meditation session model
│   │   ├── sleep_sound.dart         # Ambient sleep soundscape model
│   │   ├── breathing_exercise.dart  # Guided breathing rhythm model
│   │   ├── user_progress.dart       # Persistent user stats & streak model
│   │   └── achievement.dart         # Achievement milestone model
│   ├── data/
│   │   └── mock_data.dart           # Production-ready curated mock sessions & exercises
│   ├── services/
│   │   ├── audio_service.dart       # Singleton just_audio wrapper with virtual session timer & stream
│   │   └── progress_service.dart    # SharedPreferences persistence layer
│   ├── screens/
│   │   ├── home_screen.dart                # Personalized dashboard & quick starts
│   │   ├── meditation_library_screen.dart  # Filterable library by category & search
│   │   ├── meditation_detail_screen.dart   # Session overview & benefit breakdown
│   │   ├── meditation_player_screen.dart   # Full-screen player with pulsing visualizer
│   │   ├── breathing_screen.dart           # Guided box breathing exercise
│   │   ├── sleep_screen.dart               # Sleep soundscapes & fade timer
│   │   ├── progress_screen.dart            # Analytics, streaks, weekly grid & badges
│   │   └── settings_screen.dart            # Responsive web settings dashboard
│   └── widgets/
│       ├── mini_player.dart         # Global floating audio mini-player
│       ├── breathing_circle.dart    # Animated breathing visualizer
│       └── responsive_shell.dart    # Adaptive NavigationRail / NavigationBar shell
```

---

## 🔧 Audio Engine Specifications

- **Format Resilience**: Includes dual `.wav` and `.mp3` format support with automatic fallback to prevent browser MIME-type decoding errors on Chrome HTML5 Web Audio.
- **Virtual Position Stream**: Streams real-time session progress counting up from `00:00` to target duration (`10:00`) while looping ambient audio seamlessly in the background.

---

## 🚀 How to Run Locally

### Prerequisites
- [Flutter SDK (>= 3.2.0)](https://docs.flutter.dev/get-started/install)
- Google Chrome Browser

### Step-by-Step Instructions

1. **Clone Repository**:
   ```bash
   git clone https://github.com/Antrikshh-Coder/MeditateNow.git
   cd MeditateNow
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run on Chrome (Development)**:
   ```bash
   flutter run -d chrome
   ```

4. **Build Release Bundle for Web**:
   ```bash
   flutter build web --release
   ```

---

## 📄 License

Distributed under the **MIT License**. See `LICENSE` for more information.

---

<p align="center">
  Crafted with ❤️ using <strong>Flutter & Dart</strong>
</p>
