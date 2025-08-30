# Project Context for `aadab-app`

## Project Overview

This is a Flutter project named "aadab". It's a mobile application that appears to be an e-commerce platform, featuring user authentication, product browsing, shopping cart functionality, order management, and more. The app integrates with Firebase for core services like authentication, messaging, and potentially backend functionalities. It uses a variety of third-party packages for features like payments (Razorpay), UI components, state management, HTTP requests, and device interactions.

Key technologies and architecture:
- **Language/Framework**: Dart/Flutter
- **State Management**: Provider (with some GetIt for service location)
- **Backend/Services**: Firebase (Core, Auth, Messaging), Custom API (staging URL: `https://api.staging.aadab.online`)
- **Key Dependencies**:
  - `razorpay_flutter` for payments
  - `provider` for state management
  - `http` for API calls
  - `shared_preferences` for local storage
  - `firebase_core`, `firebase_auth`, `firebase_messaging`
  - UI libraries like `google_fonts`, `carousel_slider`, `flutter_rating_bar`
  - Device interaction: `permission_handler`, `device_info_plus`, `connectivity_plus`
  - Deep linking: `app_links`
  - Notifications: `flutter_local_notifications`

## Project Structure

- `lib/`: Main source code directory.
  - `main.dart`: Entry point, sets up providers, Firebase, connectivity, and notification handling.
  - `locator.dart`: Uses `get_it` for service location pattern.
  - `core/`: Contains business logic, models, providers, services, and utilities.
    - `providers/`: State management using `ChangeNotifierProvider`.
    - `services/`: Business logic interacting with APIs and local storage.
    - `models/`: Data models.
    - `config/`: (Currently empty) Likely intended for configuration files.
    - `utils/`: Utility functions.
  - `ui/`: All UI-related code.
    - `views/`: Individual pages/screens.
    - `widgets/`: Reusable UI components.
    - `shared/`: Shared UI elements like styles.
    - `routing/`: Routing logic.
    - `root_p.dart`: Initial page that handles app loading, authentication check, and initial navigation based on user state and permissions.

## Building and Running

1.  Ensure you have Flutter installed and set up.
2.  Run `flutter pub get` to install dependencies.
3.  Connect a device or start an emulator.
4.  Run `flutter run` to build and deploy the app.

The app's entry point (`main.dart`) initializes Firebase and a connectivity service before launching the main `MyApp` widget. The `RootPage` (`root_p.dart`) handles the initial logic of checking login status, fetching configuration (from `https://api.staging.aadab.online`), checking app version, verifying permissions, and navigating to the appropriate screen (e.g., home, splash, permissions, update).

## Development Conventions

- Uses `provider` for state management with `ChangeNotifier` models.
- Employs `get_it` for dependency injection of services.
- Follows a structure separating UI (`ui/`) from business logic (`core/`).
- Utilizes `Future.delayed(Duration.zero, ...)` for navigation actions in `initState` or similar lifecycle methods to ensure the widget tree is built before attempting navigation.
- Handles deep links and push notifications with specific routing logic in `main.dart`.
- Includes network awareness with `connectivity_plus` integration.