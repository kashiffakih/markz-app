# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Aadab is a Flutter e-commerce mobile application featuring user authentication, product browsing, shopping cart functionality, order management, and integrated payment systems. The app uses Firebase for backend services and various payment gateways including PhonePe and Razorpay.

## Development Commands

### Core Flutter Commands
- `flutter pub get` - Install dependencies
- `flutter run` - Run the app in development mode
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app
- `flutter test` - Run tests
- `flutter clean` - Clean build artifacts

### Build Commands
- `flutter build apk --release` - Build release APK for Android
- `flutter build appbundle` - Build Android App Bundle for Play Store
- `flutter build ios --release` - Build release version for iOS

## Architecture Overview

### Core Architecture Pattern
- **State Management**: Provider pattern with `ChangeNotifier` models
- **Dependency Injection**: GetIt service locator pattern
- **API Layer**: HTTP-based services with custom API endpoints
- **Navigation**: Named routes with custom route generator

### Directory Structure
```
lib/
├── main.dart                 # App entry point with providers setup
├── locator.dart             # GetIt service registration
├── core/                    # Business logic layer
│   ├── models/              # Data models
│   ├── providers/           # State management (Provider pattern)
│   ├── services/            # API services and business logic
│   └── utils/               # Utility functions
└── ui/                      # Presentation layer
    ├── views/               # Screen pages organized by feature
    ├── widgets/             # Reusable UI components
    ├── routing/             # Route definitions and generator
    └── shared/              # Shared UI constants and styles
```

### Key Services & Providers
- `AuthService` & `AuthModel` - User authentication and session management
- `ProductService` & `ProductModel` - Product catalog and search
- `AddToCartService` & `AddToCartModel` - Shopping cart functionality
- `OrderService` & `OrderModel` - Order management
- `ConfigService` & `ConfigModel` - App configuration from API
- `ConnectivityService` - Network status monitoring

### API Integration
- Base API URL: `https://api.staging.aadab.online`
- All services follow REST API patterns with HTTP requests
- Authentication tokens managed through shared preferences
- Network connectivity awareness with automatic retry logic

### Firebase Integration
- Firebase Core, Auth, and Messaging configured
- Push notifications with deep linking support
- Firebase initialization in main.dart before app launch

### Payment Integration
- PhonePe SDK integration (`phonepe_payment_sdk`)
- Payment flows handled in checkout process
- Payment response models for transaction tracking

### Navigation & Deep Linking
- Custom route generator in `ui/routing/router.dart`
- Deep linking support via `app_links` package
- Push notification routing to specific screens
- Route-based navigation with arguments support

## Development Guidelines

### State Management
- Use Provider pattern for state management
- Register services in locator.dart using GetIt
- Keep UI widgets stateless when possible
- Use `Consumer` widgets for reactive UI updates

### API Service Pattern
- All API calls go through service classes in `core/services/`
- Services are registered as singletons in locator.dart
- Use HTTP package for API communications
- Handle network errors gracefully with connectivity awareness

### UI Development
- Organize views by feature in `ui/views/`
- Create reusable widgets in `ui/widgets/`
- Use shared styling from `ui/shared/`
- Implement responsive design patterns

### Network Handling
- App includes comprehensive network connectivity monitoring
- `NetworkAwareWidget` and `NetworkStatusOverlay` provide UI feedback
- Automatic handling of network state changes
- Retry mechanisms for failed API calls

## Testing

- Test files located in `test/` directory
- Run tests using `flutter test`
- Widget tests and unit tests supported
- Null safety compliance testing included

## Key Dependencies

### State & Navigation
- `provider: ^6.0.5` - State management
- `get_it: ^7.2.0` - Service location

### Firebase & Auth
- `firebase_core`, `firebase_auth`, `firebase_messaging`
- `google_sign_in: ^5.0.0`
- `flutter_facebook_auth`

### Payment & Commerce
- `phonepe_payment_sdk: ^3.0.1`
- Various e-commerce related packages

### UI & UX
- `google_fonts: ^6.2.1`
- `carousel_slider: ^5.0.0`
- `flutter_rating_bar: ^4.0.1`
- `smooth_page_indicator: ^1.2.0+3`

### Utilities
- `http: ^1.2.2` - API requests
- `shared_preferences: ^2.0.20` - Local storage
- `connectivity_plus: ^6.0.5` - Network monitoring
- `permission_handler: ^11.3.1` - Device permissions