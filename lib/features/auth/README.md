# Authentication Feature

This feature handles user authentication including sign up, login, logout, and auth state management using Firebase Authentication and Firestore.

## Architecture

This feature follows **Clean Architecture** principles with clear separation of concerns:

```
auth/
├── auth_di.dart                           # Dependency Injection setup
│
├── data/                                  # Data Layer
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart   # Abstract data source contract
│   │   └── auth_remote_datasource_impl.dart  # Firebase implementation
│   ├── models/
│   │   └── user_model.dart               # Data transfer object
│   └── repositories/
│       └── auth_repository_impl.dart     # Repository implementation
│
├── domain/                                # Domain Layer (Business Logic)
│   ├── entities/
│   │   └── user_entity.dart              # Core business entity
│   ├── repositories/
│   │   └── auth_repository.dart          # Repository contract
│   └── usecases/
│       ├── login_usecase.dart            # Login business logic
│       ├── logout_usecase.dart           # Logout business logic
│       ├── register_usecase.dart         # Registration business logic
│       └── sign_up_usecase.dart          # Sign up with profile data
│
└── presentation/                          # Presentation Layer (UI)
    ├── providers/
    │   └── auth_provider.dart            # State management (ChangeNotifier)
    └── screens/
        ├── auth_screen.dart              # Main auth screen (responsive wrapper)
        ├── signup_mobile.dart            # Mobile UI implementation
        └── signup_tablet.dart            # Tablet UI implementation
```

## Layer Responsibilities

### Domain Layer

- **Entities**: Pure Dart classes representing business objects (UserEntity)
- **Repository Contracts**: Abstract interfaces defining data operations
- **Use Cases**: Single-responsibility business logic operations
- ✅ **No Flutter dependencies**
- ✅ **Easily unit testable**

### Data Layer

- **Models**: Data transfer objects that extend entities
- **Data Sources**: External data providers (Firebase Auth, Firestore)
- **Repository Implementations**: Concrete implementations of domain contracts
- Handles data serialization/deserialization
- Manages API/Firebase communication

### Presentation Layer

- **Providers**: State management using ChangeNotifier
- **Screens**: UI components (mobile/tablet responsive)
- **Widgets**: Feature-specific UI components
- Consumes use cases through providers
- Displays data and handles user interactions

## Features

### Sign Up

- Full name input with validation
- Phone number with validation
- Age input
- Email with format validation
- Password with security requirements
- Creates Firebase Auth account
- Stores user profile data in Firestore
- Real-time validation feedback
- Loading states
- Error handling

### Login

- Email authentication
- Password verification
- Fetches complete user profile from Firestore
- Error messages for invalid credentials

### Logout

- Signs out from Firebase Auth
- Clears user state

### Auth State Management

- Stream-based auth state monitoring
- Automatic session persistence
- Real-time user status updates

## Data Flow

### Sign Up Flow

```
UI (auth_mobile.dart)
  ↓
Provider (auth_provider.dart)
  ↓
Use Case (sign_up_usecase.dart)
  ↓
Repository (auth_repository_impl.dart)
  ↓
Data Source (auth_remote_datasource_impl.dart)
  ↓
Firebase Auth + Firestore
```

### Login Flow

```
UI → Provider → Login UseCase → Repository → DataSource → Firebase
  ↓
Fetch Profile from Firestore
  ↓
Return UserEntity with complete data
```

## Dependency Injection

All dependencies are registered in `auth_di.dart`:

```dart
// Firebase instances (singleton)
FirebaseAuth.instance
FirebaseFirestore.instance

// Data source (singleton)
AuthRemoteDataSource → AuthRemoteDataSourceImpl

// Repository (singleton)
AuthRepository → AuthRepositoryImpl

// Use cases (singleton)
SignUpUseCase

// Provider (factory - new instance per request)
AuthProvider
```

Registered in `app/injection_container.dart` via `initAuthDependencies()`.

## State Management

Uses **Provider** (ChangeNotifier) for state management:

```dart
class AuthProvider extends ChangeNotifier {
  UserEntity? _user;           // Current user
  bool _isLoading = false;     // Loading state
  String? _errorMessage;       // Error messages

  // Getters
  UserEntity? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Methods
  Future<void> signUp({...}) async { }
}
```

Provider is registered globally in `app/app_name.dart` MultiProvider:

```dart
ChangeNotifierProvider(create: (_) => di<AuthProvider>()),
```

## Firebase Integration

### Authentication

- **Firebase Auth**: User authentication (email/password)
- **Secure**: Password hashing handled by Firebase
- **Session Management**: Automatic token refresh

### Data Storage

- **Firestore**: User profile data storage
- Collection: `users`
- Document ID: Firebase Auth UID
- Fields:
  - `uid`: User ID (string)
  - `name`: Full name (string)
  - `email`: Email address (string)
  - `phone`: Phone number (string)
  - `age`: Age (integer)
  - `createdAt`: Timestamp (server timestamp)

## UI Components

### Custom Widgets Used

- `CustomTextField`: Input fields with validation
- `CustomOutlinedButton`: Primary action button
- `GradientScaffold`: Gradient background
- `AppLogoWidget`: Branding
- `CustomSnackbar`: Error/success messages

### Responsive Design

- Separate mobile and tablet layouts
- Uses responsive extensions (`.w`, `.h`, `.ht`, `.r`)
- Configured via `ResponsiveConfig`

## Validation

Field validation types from `TextFieldType` enum:

- **Name**: Non-empty, alphabets only
- **Phone**: Valid phone format
- **Email**: Valid email format
- **Password**: Minimum length, complexity requirements
- **Number**: Age field validation

## Error Handling

Errors are caught and displayed user-friendly:

- Firebase exceptions → Parsed error messages
- Network errors → Connection error messages
- Validation errors → Inline field errors
- General exceptions → Generic error message

## Usage Example

### In Screen

```dart
// Access provider
final authProvider = context.read<AuthProvider>();

// Sign up
await authProvider.signUp(
  email: email,
  password: password,
  name: name,
  phone: phone,
  ageString: age,
);

// Check state
if (authProvider.user != null) {
  // Success - navigate to home
  context.go(RouteNames.home);
}

if (authProvider.errorMessage != null) {
  // Show error
  CustomSnackbar.show(
    context: context,
    message: authProvider.errorMessage!,
    type: SnackbarType.error,
  );
}
```

### In Widget Build

```dart
Consumer<AuthProvider>(
  builder: (context, authProvider, _) {
    if (authProvider.isLoading) {
      return CircularProgressIndicator();
    }

    return SignUpButton(
      onPressed: () => authProvider.signUp(...),
    );
  },
)
```

## Testing

### Unit Tests (Domain Layer)

- Use Cases: Test business logic in isolation
- Entities: Test data validation
- No mocking needed for pure logic

### Integration Tests (Data Layer)

- Mock Firebase Auth/Firestore
- Test repository implementations
- Verify data transformations

### Widget Tests (Presentation)

- Mock providers
- Test UI renders correctly
- Test user interactions
- Verify navigation

## Future Enhancements

Planned features:

- [ ] Social authentication (Google, Apple)
- [ ] Phone number authentication
- [ ] Password reset flow
- [ ] Email verification
- [ ] Profile photo upload
- [ ] Biometric authentication
- [ ] Multi-factor authentication

## Dependencies

- `firebase_auth`: Authentication
- `cloud_firestore`: User data storage
- `provider`: State management
- `get_it`: Dependency injection
- `go_router`: Navigation

## Notes

- Never store sensitive data in plain text
- User passwords are handled securely by Firebase
- Auth tokens are stored using Flutter Secure Storage
- Provider is injected globally for app-wide access
- Use cases ensure business logic is testable
- Clean Architecture allows easy switching of data sources
