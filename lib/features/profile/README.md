# Profile Feature

This feature handles user profile management including viewing, updating, and managing user information stored in Firestore.

## Architecture

This feature follows **Clean Architecture** principles with clear separation of concerns:

```
profile/
├── home_di.dart                           # Dependency Injection setup
│
├── data/                                  # Data Layer
│   ├── datasources/
│   │   ├── profile_remote_datasource.dart     # Abstract data source
│   │   └── profile_remote_datasource_impl.dart # Firestore implementation
│   ├── models/
│   │   └── user_profile_model.dart       # Data transfer object
│   └── repositories/
│       └── profile_repository_impl.dart  # Repository implementation
│
├── domain/                                # Domain Layer (Business Logic)
│   ├── entities/
│   │   └── user_profile_entity.dart      # Core business entity
│   ├── repositories/
│   │   └── profile_repository.dart       # Repository contract
│   └── usecases/
│       ├── get_user_profile_usecase.dart # Fetch profile
│       ├── update_profile_usecase.dart   # Update profile
│       └── delete_profile_usecase.dart   # Delete account
│
└── presentation/                          # Presentation Layer (UI)
    ├── provider/
    │   └── profile_provider.dart         # State management (ChangeNotifier)
    └── screens/
        ├── profile_screen.dart           # Main profile screen (responsive)
        ├── profile_mobile.dart           # Mobile UI with glassmorphism
        └── profile_tablet.dart           # Tablet UI
```

## Layer Responsibilities

### Domain Layer

- **Entities**: Pure Dart classes (UserProfileEntity)
- **Repository Contracts**: Abstract interfaces
- **Use Cases**: Profile operations (get, update, delete)
- ✅ **No Flutter dependencies**
- ✅ **Easily unit testable**

### Data Layer

- **Models**: Extend entities with JSON serialization
- **Data Sources**: Firestore operations
- **Repository Implementations**: Concrete data operations
- Handles Firestore queries and updates
- Data transformation between model and entity

### Presentation Layer

- **Provider**: Manages profile state (loading, error, data)
- **Screens**: Responsive UI layouts
- **Widgets**: Profile-specific components
- Glassmorphism UI effects

## Features

### View Profile

- Display user information
- Name, email, phone, age
- Glassmorphism card design
- Loading states
- Error handling
- Auto-refresh on navigation

### Update Profile

- Edit user information
- Real-time validation
- Optimistic updates
- Success/error feedback

### Delete Account

- Account deletion with confirmation
- Removes user data from Firestore
- Clears authentication

### Profile Data

- Fetched from Firestore `users` collection
- Document ID matches Firebase Auth UID
- Complete user profile data

## Data Flow

### Fetch Profile Flow

```
UI (profile_mobile.dart)
  ↓
Provider (profile_provider.dart)
  ↓ (initState - loads data)
Use Case (get_user_profile_usecase.dart)
  ↓
Repository (profile_repository_impl.dart)
  ↓
Data Source (profile_remote_datasource_impl.dart)
  ↓
Firestore users/{uid}
  ↓
Return UserProfileEntity
```

### Update Profile Flow

```
UI → Provider → Update UseCase → Repository → DataSource → Firestore
  ↓
Update local state (optimistic update)
  ↓
Notify listeners
```

## State Management

Uses **Provider** (ChangeNotifier):

```dart
class ProfileProvider extends ChangeNotifier {
  UserProfileEntity? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserProfileEntity? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Methods
  Future<void> loadUserProfile(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _userProfile = await getUserProfileUseCase(userId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({...}) async { }
}
```

Provider should be registered globally in `app/app_name.dart`:

```dart
ChangeNotifierProvider(create: (_) => di<ProfileProvider>()),
```

## UI Design

### Glassmorphism Effect

Profile cards use glassmorphism design:

- Semi-transparent background (`AppColors.white.withOpacity(0.1)`)
- Backdrop blur filter (`BackdropFilter`)
- Border with transparency
- Modern frosted glass appearance

### CustomCard Component

```dart
CustomCard(
  color: AppColors.white.withOpacity(0.1),  // Triggers glassmorphism
  enableGlassmorphism: true,                 // Default
  child: ProfileContent(...),
)
```

### Responsive Layout

- Mobile: Single column, compact spacing
- Tablet: Wider layout, better spacing
- Uses responsive extensions (`.w`, `.h`, `.ht`)

## Profile Information Display

### Info Row Structure

```dart
_buildInfoRow(
  context,
  icon: Icons.person_outline,
  label: 'Name',
  value: profile.name,
)
```

Displays:

- **Name**: Full name with person icon
- **Phone**: Phone number with phone icon
- **Age**: Age with cake icon
- **Email**: Email address with email icon

### Loading State

- Centered circular progress indicator
- White color matching gradient background

### Error State

- Error icon (64px)
- Error title
- Error message
- Centered layout
- Retry option

### Empty State

- "No profile data" message
- Handles missing user scenario

## Firestore Integration

### Collection Structure

```
users (collection)
  └── {userId} (document)
      ├── uid: string
      ├── name: string
      ├── email: string
      ├── phone: string
      ├── age: number
      └── createdAt: timestamp
```

### Data Operations

- **Read**: `doc(userId).get()`
- **Update**: `doc(userId).update({...})`
- **Delete**: `doc(userId).delete()`
- **Listen**: `doc(userId).snapshots()` (for real-time updates)

## Dependency Injection

Register in `home_di.dart` (should be renamed to `profile_di.dart`):

```dart
Future<void> initProfileDependencies() async {
  // Data source
  di.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(firestore: di()),
  );

  // Repository
  di.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: di()),
  );

  // Use cases
  di.registerLazySingleton<GetUserProfileUseCase>(
    () => GetUserProfileUseCase(di()),
  );

  // Provider
  di.registerFactory<ProfileProvider>(
    () => ProfileProvider(
      getUserProfileUseCase: di(),
    ),
  );
}
```

## Navigation

Profile screen receives userId as parameter:

### Route Definition

```dart
GoRoute(
  path: '/profile/:userId',
  name: RouteNames.profile,
  builder: (context, state) {
    final userId = state.pathParameters['userId']!;
    return ProfileScreen(userId: userId);
  },
)
```

### Navigation Example

```dart
context.go('/profile/${userId}');
// or
context.push(RouteNames.profile, extra: userId);
```

## Usage Example

### In Screen

```dart
class _ProfileMobileState extends State<ProfileMobile> {
  @override
  void initState() {
    super.initState();
    // Load profile on screen init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = context.read<ProfileProvider>();
      profileProvider.loadUserProfile(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.errorMessage != null) {
            return ErrorDisplay(message: provider.errorMessage!);
          }

          final profile = provider.userProfile;
          if (profile == null) {
            return const EmptyState();
          }

          return ProfileContent(profile: profile);
        },
      ),
    );
  }
}
```

## Error Handling

Comprehensive error management:

- **Firestore errors**: Network, permission errors
- **Not found**: User doesn't exist
- **Parse errors**: Invalid data format
- **Network errors**: Connection issues

Error display:

- User-friendly error messages
- Visual error state with icon
- Retry options where appropriate

## Testing

### Unit Tests

- Test use cases independently
- Mock repositories
- Verify business logic

### Widget Tests

- Mock ProfileProvider
- Test UI renders correctly
- Test loading/error/success states
- Verify navigation

### Integration Tests

- Test with real Firestore emulator
- Verify data operations
- Test error scenarios

## Glassmorphism Implementation

The glassmorphism effect is automatically applied when:

1. `CustomCard` receives a color with opacity < 1.0
2. `enableGlassmorphism` is true (default)

```dart
// Automatically applies glassmorphism
CustomCard(
  color: AppColors.white.withOpacity(0.1),
  child: YourContent(),
)

// No glassmorphism (solid card)
CustomCard(
  color: AppColors.white,
  child: YourContent(),
)

// Disable glassmorphism explicitly
CustomCard(
  color: AppColors.white.withOpacity(0.1),
  enableGlassmorphism: false,
  child: YourContent(),
)
```

Effect uses:

- `BackdropFilter` with `ImageFilter.blur(sigmaX: 10, sigmaY: 10)`
- Semi-transparent border: `Colors.white.withOpacity(0.2)`
- `ClipRRect` for rounded corners

## Future Enhancements

Planned features:

- [ ] Edit profile inline
- [ ] Profile photo upload
- [ ] Change password
- [ ] Email verification status
- [ ] Account settings
- [ ] Privacy settings
- [ ] Dark mode profile theme
- [ ] Export user data
- [ ] Activity log

## Dependencies

- `cloud_firestore`: Data storage
- `provider`: State management
- `get_it`: Dependency injection
- `go_router`: Navigation

## Notes

- Profile data is fetched fresh on each screen load
- Consider implementing caching for better performance
- Glassmorphism requires a background with contrast
- User ID comes from authenticated user
- Profile provider should be global for app-wide access
- Consider real-time updates with Firestore streams
- Add offline support for better UX
