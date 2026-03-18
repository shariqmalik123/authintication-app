# Auth Screen

Flutter authentication screen with Firebase integration and custom UI components.

## What's Inside

This project has a clean authentication interface with support for multiple input types (name, phone, email, password, etc.). Built with responsive design in mind and includes:

- Custom text fields with validation
- Gradient scaffolds
- Reusable button components
- Firebase authentication setup
- Device preview for testing different screen sizes
- Dependency injection pattern

## Setup

1. Make sure you have Flutter installed
2. Clone the repo
3. Run `flutter pub get`
4. Configure Firebase (already set up via firebase_options.dart)
5. Run the app: `flutter run`

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── firebase_options.dart              # Firebase configuration
│
├── app/                               # Application Layer
│   ├── app_name.dart                 # MaterialApp with MultiProvider
│   └── injection_container.dart      # Dependency Injection (GetIt)
│
├── core/                              # Shared Infrastructure
│   ├── config/
│   │   └── responsive_config.dart    # Responsive design configuration
│   │
│   ├── constants/
│   │   ├── app_assets.dart           # Asset paths (fonts, SVGs)
│   │   └── app_constants.dart        # App-wide constants
│   │
│   ├── entities/
│   │   └── image_info_entity.dart    # Shared entities
│   │
│   ├── enums/
│   │   └── app_enums.dart            # App-wide enums
│   │
│   ├── extensions/
│   │   ├── context_extensions.dart   # BuildContext extensions
│   │   ├── helper_extensions.dart    # General helper extensions
│   │   ├── responsive_extension.dart # Responsive sizing (.w, .h, .r)
│   │   ├── string_extensions.dart    # String utilities
│   │   └── widget_extensions.dart    # Widget helpers
│   │
│   ├── providers/
│   │   └── theme_provider.dart       # Theme state management
│   │
│   ├── router/
│   │   ├── app_router.dart           # GoRouter configuration
│   │   ├── route_names.dart          # Route name constants
│   │   └── route_transitions.dart    # Custom transitions
│   │
│   ├── services/
│   │   ├── dio/                      # HTTP client
│   │   ├── image picker/             # Image selection
│   │   ├── local storage/            # Secure local storage
│   │   ├── logger/                   # Logging service
│   │   ├── network/                  # Network utilities
│   │   └── notifications/            # Push notifications
│   │
│   ├── theme/
│   │   ├── app_border_radius.dart    # Border radius tokens
│   │   ├── app_colors.dart           # Color palette
│   │   ├── app_shadows.dart          # Shadow definitions
│   │   ├── app_text_style.dart       # Typography styles
│   │   ├── app_theme.dart            # Theme constants
│   │   └── app_theme_data.dart       # ThemeData config
│   │
│   ├── utils/
│   │   ├── system_utils.dart         # System-level utilities
│   │   └── validators.dart           # Input validators
│   │
│   └── widgets/                       # Reusable UI Components
│       ├── animated/                  # Animated widgets
│       ├── bottom sheets/             # Bottom sheet components
│       ├── buttons/
│       │   └── custom_outlined_button.dart
│       ├── cards/
│       │   └── custom_card.dart      # Glassmorphism card
│       ├── dialogs/                   # Dialog components
│       ├── inputs/
│       │   └── custom_text_field.dart
│       ├── loaders/                   # Loading indicators
│       ├── more/
│       │   └── app_logo_widget.dart
│       ├── scaffolds/
│       │   └── gradient_scaffold.dart
│       └── snackbars/
│           └── custom_snackbars.dart
│
└── features/                          # Feature Modules (Clean Architecture)
    │
    ├── auth/                          # Authentication Feature
    │   ├── auth_di.dart              # Feature DI registration
    │   │
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── auth_remote_datasource.dart
    │   │   │   └── auth_remote_datasource_impl.dart
    │   │   ├── models/
    │   │   │   └── user_model.dart
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart
    │   │
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── user_entity.dart
    │   │   ├── repositories/
    │   │   │   └── auth_repository.dart
    │   │   └── usecases/
    │   │       ├── login_usecase.dart
    │   │       ├── logout_usecase.dart
    │   │       ├── register_usecase.dart
    │   │       └── sign_up_usecase.dart
    │   │
    │   └── presentation/
    │       ├── providers/
    │       │   └── auth_provider.dart  # State management
    │       └── screens/
    │           ├── auth_mobile.dart
    │           └── auth_tablet.dart
    │
    ├── home/                          # Home Feature
    │   ├── home_di.dart
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │
    └── profile/                       # Profile Feature
        ├── data/
        ├── domain/
        └── presentation/
            ├── provider/
            │   └── profile_provider.dart
            └── screens/
                └── profile_mobile.dart

assets/
├── fonts/                             # Custom fonts (Inter, Georgia)
│   ├── Inter/
│   └── Georgia/
└── svgs/                              # SVG assets
```

### Architecture Pattern

This project follows **Clean Architecture** with feature-based organization:

- **Domain Layer**: Business logic, entities, repository contracts, use cases
- **Data Layer**: Repository implementations, models, data sources (Firebase, API)
- **Presentation Layer**: UI screens, state management (Provider), widgets

### Key Technologies

- **State Management**: Provider
- **Dependency Injection**: GetIt
- **Navigation**: GoRouter
- **HTTP Client**: Dio
- **Authentication**: Firebase Auth + Firestore
- **Local Storage**: Flutter Secure Storage
- **Push Notifications**: Firebase Messaging

### Design Tokens

All UI constants are centralized:

- Colors: `core/theme/app_colors.dart`
- Typography: `core/theme/app_text_style.dart` (Inter for body, Georgia for headings)
- Spacing: Responsive extensions (`.w`, `.h`, `.ht`, `.r`)
- Border radius: `core/theme/app_border_radius.dart`
- Shadows: `core/theme/app_shadows.dart`

## Notes

- Uses device_preview in debug mode to test responsive layouts
- Theme system is centralized in core/theme
- Custom validators for different field types
- Ready for both mobile and tablet views
