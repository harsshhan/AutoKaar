# AutoKaar - Flutter Ride-Sharing Application

AutoKaar is a modern ride-sharing application built with Flutter, offering separate interfaces for users and drivers. The application integrates with Google Maps for location services and Supabase for backend functionality. It provides a seamless experience for both passengers and drivers with real-time tracking, notifications, and efficient ride management.

## Table of Contents
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Dependencies](#dependencies)
- [Configuration](#configuration)
- [Platform Support](#platform-support)
- [Development](#development)
- [Testing](#testing)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)
- [Support](#support)
- [Acknowledgments](#acknowledgments)

## Features

### User Interface
- **Ride Booking**
  - Real-time ride request system
  - Fare estimation
  - Multiple payment options
  - Ride history tracking
- **Location Services**
  - Live location tracking
  - Route visualization
  - Estimated time of arrival
  - Favorite locations saving
- **Safety Features**
  - Driver verification
  - Emergency contacts
  - Ride sharing with trusted contacts
  - In-app SOS button

### Driver Interface
- **Ride Management**
  - Real-time ride requests
  - Route optimization
  - Earnings dashboard
  - Performance analytics
- **Navigation**
  - Turn-by-turn navigation
  - Traffic updates
  - Alternative route suggestions
- **Business Tools**
  - Daily/weekly earnings reports
  - Customer ratings
  - Performance metrics
  - Work schedule management

### General Features
- **Push Notifications**
  - Ride status updates
  - Payment confirmations
  - Promotional offers
  - System alerts
- **Backend Integration**
  - Supabase for data management
  - Real-time updates
  - Secure authentication
  - Data synchronization
- **Payment System**
  - Multiple payment methods
  - Secure transactions
  - Automatic fare calculation
  - Payment history

## Prerequisites

### Development Environment
- Flutter SDK (^3.7.0)
- Dart SDK
- Android Studio / VS Code
- Git
- Postman (for API testing)

### API Keys and Accounts
- Google Maps API Key
- Supabase Account
- Payment Gateway Integration (if applicable)

### System Requirements
- Minimum 8GB RAM
- 20GB free disk space
- Operating System: Windows 10/11, macOS, or Linux

## Installation

1. Clone the repository:
```bash
git clone [repository-url]
cd autokaar
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure environment:
   - Add your Google Maps API key to the Android and iOS configurations
   - Update Supabase credentials in `lib/main.dart`
   - Configure payment gateway credentials
   - Set up environment variables

4. Run the application:
```bash
flutter run
```

## Project Structure

```
AutoKaar/
├── lib/
│   ├── screens/
│   │   ├── heatmap.dart                 # Heatmap visualization for demand areas
│   │   ├── driver_screen.dart           # Main driver interface
│   │   ├── driver_tracking_screen.dart  # Real-time driver tracking
│   │   ├── home_screen.dart             # Application home screen
│   │   ├── loading_screen.dart          # Loading and splash screen
│   │   ├── navigation_screen.dart       # Navigation interface
│   │   ├── real_time_map.dart          # Real-time map view
│   │   ├── tempCodeRunnerFile.dart     # Temporary code testing file
│   │   └── user_screen.dart             # Main user interface
│   ├── services/
│   │   ├── google_maps_service.dart     # Google Maps integration service
│   │   └── supabase_service.dart        # Supabase backend service
│   ├── utils/
│   │   └── notification_utils.dart      # Push notification utilities
│   ├── widgets/
│   │   ├── menu_item.dart              # Reusable menu item widget
│   │   └── profile_header.dart         # User profile header widget
│   └── main.dart                       # Application entry point
├── assets/
│   ├── images/
│   │   ├── auto.png
│   │   └── images/vijay.png
│   ├── fonts/
│   └── icons/
├── test/
│   ├── unit/
│   └── integration/
├── android/
├── ios/
├── web/
├── windows/
├── linux/
├── macos/
└── pubspec.yaml
```

### File Descriptions

#### Screens
- `heatmap.dart`: Displays a heatmap visualization of demand areas to help drivers identify high-demand locations
- `driver_screen.dart`: Main interface for drivers to manage rides and view earnings
- `driver_tracking_screen.dart`: Real-time tracking interface for monitoring driver location
- `home_screen.dart`: Initial screen with options to choose between user and driver modes
- `loading_screen.dart`: Loading and splash screen with app initialization
- `navigation_screen.dart`: Turn-by-turn navigation interface for drivers
- `real_time_map.dart`: Real-time map view showing current location and nearby rides
- `user_screen.dart`: Main interface for users to book and manage rides
- `tempCodeRunnerFile.dart`: Temporary file for testing and development purposes

#### Services
- `google_maps_service.dart`: Handles all Google Maps related functionality including geocoding and routing
- `supabase_service.dart`: Manages all backend interactions with Supabase including authentication and data storage

#### Utils
- `notification_utils.dart`: Handles push notification setup and management

#### Widgets
- `menu_item.dart`: Reusable widget for menu items in various screens
- `profile_header.dart`: Custom widget for displaying user profile information

## Dependencies

### Core Dependencies
- `google_maps_flutter: ^2.10.1` - Google Maps integration
- `supabase_flutter: ^2.8.4` - Backend services
- `geolocator: ^13.0.2` - Location services
- `flutter_local_notifications: ^18.0.1` - Push notifications
- `http: ^1.3.0` - API communication
- `intl: ^0.20.2` - Internationalization
- `image: ^4.5.3` - Image handling

### UI Dependencies
- `flutter_svg: ^2.0.9` - SVG support
- `cached_network_image: ^3.3.1` - Image caching
- `shimmer: ^3.0.0` - Loading effects

### State Management
- `provider: ^6.1.1` - State management
- `get_it: ^7.6.7` - Dependency injection

### Storage
- `shared_preferences: ^2.2.2` - Local storage
- `sqflite: ^2.3.2` - SQLite database

## Configuration

### Android Configuration
1. Update `android/app/src/main/AndroidManifest.xml` with required permissions
2. Add Google Maps API key in `android/app/src/main/AndroidManifest.xml`
3. Configure ProGuard rules in `android/app/proguard-rules.pro`

### iOS Configuration
1. Update `ios/Runner/Info.plist` with required permissions
2. Add Google Maps API key in `ios/Runner/AppDelegate.swift`
3. Configure capabilities in Xcode

### Environment Variables
Create a `.env` file in the root directory:
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
```

## Platform Support

### Mobile
- Android (API level 21 and above)
- iOS (12.0 and above)

### Desktop
- Windows 10/11
- macOS 10.15+
- Linux (Ubuntu 20.04+)

### Web
- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## Development

### Code Style
- Follow Flutter's official style guide
- Use the provided `analysis_options.yaml` for linting
- Follow the project's coding conventions
- Use meaningful variable and function names
- Add comments for complex logic

### Git Workflow
1. Create feature branch from development
2. Make changes and commit with meaningful messages
3. Push changes and create pull request
4. Get code review and address feedback
5. Merge to development branch

### Performance Guidelines
- Optimize image assets
- Implement lazy loading
- Use const constructors
- Minimize rebuilds
- Implement proper error handling

## Testing

### Unit Tests
```bash
flutter test test/unit/
```

### Integration Tests
```bash
flutter test test/integration/
```

### Widget Tests
```bash
flutter test test/widget/
```

### Test Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Deployment

### Android
1. Generate keystore:
```bash
keytool -genkey -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Build release APK:
```bash
flutter build apk --release
```

3. Build App Bundle:
```bash
flutter build appbundle
```

### iOS
1. Update version in Xcode
2. Archive the app
3. Upload to App Store Connect

### Web
```bash
flutter build web --release
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Contribution Guidelines
- Follow the existing code style
- Add tests for new features
- Update documentation
- Keep commits atomic and focused
- Write clear commit messages

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

### Getting Help
- Check the [documentation](docs/)
- Open an issue in the repository
- Contact the development team
- Join our community chat

### Bug Reports
When reporting bugs, please include:
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots/videos
- Device information

## Acknowledgments

### Core Technologies
- Flutter team for the amazing framework
- Google Maps Platform
- Supabase team
- All contributors to the project

### Design Resources
- Material Design
- Flutter Icons
- Custom UI components

### Community
- Flutter community
- Stack Overflow contributors
- GitHub contributors

### Special Thanks
- All beta testers
- Early adopters
- Community feedback providers
