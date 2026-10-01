# 📄 MeditateNow — Final Project Documentation & Case Study Report

---

## 1. 🎯 Problem Understanding

### **Case Study & Core Objective**
Modern digital lifestyle creates continuous cognitive overwhelm, stress accumulation, fragmented focus, and sleep disruption. The **MeditateNow** project was assigned to build a centralized, production-grade Flutter Web/Mobile platform that provides users with easy access to guided meditation sessions, soothing sleep soundscapes, interactive breathing exercises, and gamified streak tracking.

### **Key Problem Statements Solved**
1. **Audio Cutoff Bug Fix**: Audio assets was terminating prematurely after 10 seconds despite the session length showing in minutes (e.g. `10:00`). This was resolved by implementing a virtual session duration timer paired with seamless sample audio looping (`LoopMode.one`).
2. **Cross-Platform Responsive UX**: Designed a responsive layout system adapting between Desktop/Tablet (`NavigationRail`) and Mobile (`NavigationBar`).
3. **Format & Browser Resilience**: Solved browser Web Audio MIME-type errors by synthesizing dual-format `.wav` and `.mp3` ambient audio assets with automatic fallback.
4. **Data Persistence without External Backend**: Implemented a lightweight local storage layer using `SharedPreferences` to log mindful minutes, streak rhythms, and achievement milestones.

---

## 2. 🎨 Application Design

### **Aesthetics & Theme System**
The application adheres to Scandinavian Minimalist design principles using custom Material 3 design tokens:
- **Deep Forest Green (`#163022`)**: Grounding primary shade for headings, cards, and active UI elements.
- **Soft Sage (`#8CA98E`)**: Relaxing secondary accent for progress bars, icons, and chips.
- **Warm Cream (`#FAF8F5`)**: Soft, non-glare canvas background for light mode.
- **Typography**: Pairing of `GoogleFonts.dmSerifDisplay` for serene editorial titles and `GoogleFonts.manrope` / `GoogleFonts.plusJakartaSans` for clean UI body text.

### **Navigation Flow & Screen Hierarchy**
```text
ResponsiveShell (Layout Container)
 ├── Tab 1: Home Dashboard (Greeting, Daily Quote, Quick Starts, Streak Summary)
 ├── Tab 2: Meditation Library (Search Bar, Category Chips, Session Cards)
 │     └── Sub-Screen: Meditation Detail Screen (Benefits, Instructor Bio, Rating)
 │           └── Modal: Meditation Player Screen (Pulsing Artwork, 10:00 Scrubber)
 ├── Tab 3: Breathing Visualizer (Box 4-4-4-4, Calm 4-2-6-2, Relaxation 4-4-8-2)
 ├── Tab 4: Sleep Soundscapes (6 Ambient Sounds, 10-60 min Sleep Fade Timer)
 ├── Tab 5: Progress & Analytics (Streak Counter, Weekly Grid, Mindful Minutes, Badges)
 ├── Sub-Screen: Settings Dashboard (Light/Dark Mode Toggle, Audio Preferences)
 └── Floating Overlay: Global Mini-Player (Persistent Bottom Audio Control Bar)
```

---

## 3. 🛠️ Implementation

### **Tech Stack & Dependencies**
- **Framework**: Pure Flutter 3.x & Dart 3.x
- **Target Platforms**: Flutter Web (Chrome, Safari, Firefox) & Desktop/Mobile
- **Packages Used**:
  - `just_audio` & `just_audio_web`: Audio streaming, loop mode control, and position tracking.
  - `shared_preferences`: Persistent local storage for user progress.
  - `google_fonts`: Dynamic high-quality typography.
  - `provider`: Lightweight state management.

### **Core Service Architectures**

#### A. Audio Engine (`FlutterAudioService`)
Located in [`lib/services/audio_service.dart`](file:///Users/antriksh.manwadkar/Downloads/meditatenow/flutter_meditatenow/lib/services/audio_service.dart):
- **Virtual Session Position Stream**: Manages a 1-second `Timer.periodic` streaming virtual position counting up second-by-second from `00:00` to the target session duration (e.g. `600` seconds for a 10 min session).
- **Loop Engine**: Sets `LoopMode.one` for guided tracks so sample ambient audio loops continuously without cutting off.
- **Format Fallback**: Automatically tries `.wav` if `.mp3` fails on web audio decoders.

#### B. Progress Engine (`ProgressService`)
Located in [`lib/services/progress_service.dart`](file:///Users/antriksh.manwadkar/Downloads/meditatenow/flutter_meditatenow/lib/services/progress_service.dart):
- Calculates consecutive day streaks, total mindful minutes, session completion counts, and unlocks achievement badges (First Session, 7 Day Calm, Early Bird, Mindful Explorer, Deep Relaxer).

---

## 4. 📸 Screenshots & Demonstration

### 🏠 Home Dashboard
Features daily quotes, streak indicators, and quick-start session chips.
![Home Dashboard](docs/screenshots/home_dashboard.png)

---

### 🎧 Guided Audio Player (Full Session Timer)
Pulsing visualizer, real-time minute scrubber (`00:00` $\to$ `10:00`), +/-10s seek buttons, and volume control.
![Audio Player](docs/screenshots/audio_player.png)

---

### 🎨 Responsive Light & Dark Mode Themes

| ☀️ Light Mode Settings | 🌙 Dark Mode Settings |
| :---: | :---: |
| ![Light Mode](docs/screenshots/settings_light_mode.png) | ![Dark Mode](docs/screenshots/settings_dark_mode.png) |

---

### 🎵 Global Mini-Player Persistence
Floating audio bar allowing uninterrupted listening while navigating library screens.
![Mini Player](docs/screenshots/mini_player.png)

---

## 5. 📑 Application Workflow & Feature Summary

### **End-to-End User Journey**
1. **Onboarding & Home**: User opens MeditateNow and sees a personalized greeting (Morning/Evening), daily quote, active streak counter, and recommended sessions.
2. **Session Selection**: User browses the Meditation Library or filters by category (Focus, Stress Relief, Sleep, Morning, Anxiety). Tapping a card opens the Meditation Detail screen displaying benefits and instructor profiles.
3. **Audio Playback**: Tapping "Begin Meditation" opens the full-screen player. Ambient audio loops seamlessly while the virtual timer counts up to the full session duration (`10:00`). Seeking or pausing syncs real-time position streams across the player modal and global mini-player.
4. **Session Completion & Analytics**: Upon reaching the session end, audio stops, completion is recorded, streak increments, and progress metrics update in `SharedPreferences`.
5. **Sleep Soundscapes & Timer**: On the Sleep tab, users select an ambient sound (Rain, Ocean, Forest, Wind, Night, White Noise) and set a 10–60 min sleep fade timer. Audio automatically stops when the timer expires.
6. **Breathing Exercises**: Users select Box Breathing (`4-4-4-4`), Calm (`4-2-6-2`), or Deep Relaxation (`4-4-8-2`). An animated circle smoothly expands/contracts in sync with inhale, hold, and exhale prompts.

---

<p align="center">
  <strong>MeditateNow — Production-Grade Pure Flutter & Dart Application</strong>
</p>
