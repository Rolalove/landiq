# LandIQ: Smart Agricultural Intelligence for Nigeria 🇳🇬

LandIQ is a premium Flutter mobile application designed to empower Nigerian farmers and landowners with hyper-local agricultural intelligence. By leveraging advanced data analysis and AI, LandIQ provides instant insights into soil health, degradation risks, and crop suitability based on precise geographic coordinates.

---

## 🌟 Key Features

### 🚜 Smart Assessments
- **Instant Soil Analysis**: Get deep insights into soil texture, drainage, and pH levels based on Nigerian mapping units.
- **AI-Powered Insights**: Receive customized agricultural advice powered by LandIQ's specialized AI intelligence.
- **Degradation Risk Tracking**: Proactively identify and monitor land degradation risks to ensure long-term sustainability.
- **Badge Achievement**: Earn Gold, Silver, or Bronze badges based on your land's fertility and health scores.

### 📊 Dashboard & Stats
- **Interactive Overview**: Track your total assessed lands, saved reports, and average soil scores at a glance.
- **Recent Activity**: Quick access to your most recent assessments with high-fidelity skeleton loading states.
- **Rich Visualizations**: Premium UI featuring vibrant cards, progress indicators, and modern typography.

### 💾 Data Management
- **Permanent Saving**: Save assessment reports permanently to your personal dashboard.
- **Search & Filter**: Effortlessly find specific assessments by state or badge name.
- **Deep Linking**: Seamlessly navigate between recent assessments and detailed reports.

---

## 🏗️ Technical Architecture

### Core Stack
- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **State Management**: [Riverpod](https://riverpod.dev) (High-fidelity, reactive state)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router) (Declarative routing)
- **Networking**: [Dio](https://pub.dev/packages/dio) (Clean, interceptor-based API client)

### Directory Structure
```
lib/
├── core/              // Global themes, widgets, routers, and network clients
├── features/          // Feature-based organization
│   ├── auth/          // Identity and session management
│   ├── home/          // Dashboard and main navigation
│   ├── assessment/    // Creation, polling, and report generation
│   ├── saved/         // Permanent assessment repository
│   ├── profile/       // User settings and app information
│   └── notifications/ // User alerts and system updates
└── main.dart          // Application entry point
```

### Design System
LandIQ uses a custom-built design system defined in `lib/core/theme/`:
- **AppColors**: A sophisticated palette featuring `Primary Teal` (#0A4D5C) and `Secondary Charcoal` (#062B35).
- **AppTypography**: Premium font hierarchies using local styles for maximum readability.
- **Skeletons**: High-fidelity pulsing loaders for a premium "perceived speed" experience.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Latest Stable)
- Android Studio / VS Code with Dart & Flutter extensions
- A valid LandIQ API Base URL

### Installation
1.  **Clone the repository**:
    ```bash
    git clone [repository-url]
    cd rola_mobile/landiq
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the application**:
    ```bash
    flutter run
    ```

---

## 🛠️ Development Guidelines
- **State Management**: Always use Riverpod providers for asynchronous data and global state.
- **UI Components**: Use semantic widgets from `lib/core/widgets` to maintain brand consistency.

---

## 📄 License
© 2026 LandIQ Intelligence. All rights reserved. Proprietary and Confidential.
