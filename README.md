# RideAuto - Flutter Ride-Sharing Application

RideAuto is a modern ride-sharing application built with Flutter, offering separate interfaces for users and drivers. The application integrates with Google Maps for location services and Supabase for backend functionality.

## Features

- **Dual Interface System**
  - User Interface for passengers
  - Driver Interface for ride providers
- **Location Services**
  - Real-time location tracking
  - Google Maps integration
  - Geolocation support
- **Push Notifications**
  - Local notifications for ride updates
- **Backend Integration**
  - Supabase for data management
  - HTTP client for API communication

## Prerequisites

- Flutter SDK (^3.7.0)
- Dart SDK
- Android Studio / VS Code
- Google Maps API Key
- Supabase Account

## Installation

1. Clone the repository:
```bash
git clone [repository-url]
cd rideauto
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure environment:
   - Add your Google Maps API key to the Android and iOS configurations
   - Update Supabase credentials in `lib/main.dart`

4. Run the application:
```bash
flutter run
```

## Project Structure

```
rideauto/
├── lib/
│   ├── screens/
│   │   ├── user_screen.dart
│   │   └── driver_screen.dart
│   └── main.dart
├── assets/
│   └── images/
├── android/
├── ios/
└── pubspec.yaml
```

## Dependencies

- `google_maps_flutter: ^2.10.1` - Google Maps integration
- `supabase_flutter: ^2.8.4` - Backend services
- `geolocator: ^13.0.2` - Location services
- `flutter_local_notifications: ^18.0.1` - Push notifications
- `http: ^1.3.0` - API communication
- `intl: ^0.20.2` - Internationalization
- `image: ^4.5.3` - Image handling

## Platform Support

- Android
- iOS
- Web
- Windows
- Linux
- macOS

## Development

1. **Code Style**
   - Follow Flutter's official style guide
   - Use the provided `analysis_options.yaml` for linting

2. **Testing**
   - Run tests using:
   ```bash
   flutter test
   ```

3. **Building**
   - Android: `flutter build apk` or `flutter build appbundle`
   - iOS: `flutter build ios`
   - Web: `flutter build web`

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please open an issue in the repository or contact the development team.

## Acknowledgments

- Flutter team for the amazing framework
- Google Maps Platform
- Supabase team
- All contributors to the project
