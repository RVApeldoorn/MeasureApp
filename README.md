# MeasureApp

## Overview
MeasureApp is a Flutter mobile and web application designed for patients to interact with the Measurement API. It allows users to fetch their assigned measurement sessions, submit measurement values (e.g., weight, height, blood pressure), and secure their app with a PIN code. The app uses a setup code to authenticate with the API, receiving a JWT token for subsequent requests. Built with Flutter, it uses packages like `dio` for HTTP requests, `flutter_secure_storage` for token storage, and `flutter_reactive_ble` for the connection with our height measuring device.

## Setup Instructions

### Prerequisites
- **Flutter SDK**: Install Flutter (version 3.7.0 or higher) from [flutter.dev](https://flutter.dev/docs/get-started/install).
- **Dart**: Included with Flutter, ensure the SDK is configured.
- **Emulator/Device**: Set up an Android/iOS emulator or physical device for mobile testing.
- **Chrome**: Install Google Chrome for web testing.
- **Flutter Web Support**: Ensure web support is enabled. Run `flutter config --enable-web` to enable it, and verify with:
  ```bash
  flutter devices
  ```
  Look for "Chrome (web)" in the output.

### Installation
1. **Clone the Repository**:
   ```bash
   git clone git@github.com:RVApeldoorn/MeasureApp.git
   cd MeasureApp
   ```

2. **Install Dependencies**:
   Restore Flutter packages, including `dio`, `flutter_secure_storage`, `shared_preferences`, and `flutter_reactive_ble`:
   ```bash
   flutter pub get
   ```

4. **Platform Permissions**:
   - For Android, update `android/app/src/main/AndroidManifest.xml` to include permissions for Bluetooth (used by `flutter_reactive_ble`):
     ```xml
     <uses-permission android:name="android.permission.BLUETOOTH" />
     <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
     <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
     ```
   - For iOS, update `ios/Runner/Info.plist`:
     ```xml
     <key>NSBluetoothAlwaysUsageDescription</key>
     <string>App requires Bluetooth to connect to measurement devices.</string>
     <key>NSLocationWhenInUseUsageDescription</key>
     <string>App requires location for Bluetooth functionality.</string>
     ```

### Configure API URL
To connect to the Health Measurement API running locally, configure the API’s local IP address (e.g., `192.168.x.x:5005`) in the app’s code:
1. **Find Your Local IP Address**:
   - **Windows**: Run in Command Prompt:
     ```bash
     ipconfig
     ```
     Look for `IPv4 Address` under your active network (e.g., `192.168.1.100`).
   - **macOS/Linux**: Run in Terminal:
     ```bash
     ifconfig | grep inet
     ```
     Find the `inet` address for your network interface (e.g., `192.168.1.100`).
2. **Update API URL**:
   - Replace the placeholder IP in the API URL with your local IP address. Example:
     ```dart
     final response = await _dio.get('http://192.168.1.100:5005/api/patient/sessions');
     ```
   - **Note**: The API uses `http` (not `https`) on port `5005`. Ensure the app and API are on the same Wi-Fi network.
3. **Network Requirements**:
   - Ensure the API is running on the specified IP and port (see API README).

### Run the App
1. **Mobile Testing**:
   Start the app on an Android/iOS emulator or physical device:
   ```bash
   flutter run
   ```
   Select the target device when prompted (use `flutter devices` to list available devices).

2. **Web Testing**:
   Run the app in Chrome for web testing:
   ```bash
   flutter run -d chrome
   ```
   - The app will open in Chrome at `http://localhost:5000` (or a random port). To specify a port:
     ```bash
     flutter run -d chrome --web-port=8080
     ```

### Setup Process for App
- **Initial Setup**:
  - Upon first launch, the user is prompted to enter a setup code (test codes are seeded in database).
  - The app sends the setup code to the API using `dio` for validation.
  - If valid, the API returns a JWT token, which is stored using `flutter_secure_storage`.
- **PIN Code**:
  - After setup, the user sets a PIN code to secure the app locally. The PIN is stored using `flutter_secure_storage` and required on app launch.
- **Subsequent Requests**:
  - All API requests include the JWT token in the Authorization header for user identification.
  - The app fetches sessions and submits measurement values (e.g., weight, blood pressure) to the API.

### Basic Features
- **Session Management**: Users can view their assigned measurement sessions and open measurement requests.
- **Measurement Submission**: Submit individual measurements (e.g., weight, height, blood pressure) to the API.
- **Bluetooth Integration**: Supports Bluetooth devices for automated measurement collection (via `flutter_reactive_ble`).
- **Security**: JWT tokens are securely stored, and the app is protected with a user-defined PIN code.
- **Localization**: Supports multiple languages using `flutter_localizations` and `intl`.

## Technology Stack
The MeasureApp uses the following technologies:

### Frontend
- **Flutter (SDK 3.7.0+)**: Cross-platform framework for building mobile (Android/iOS) and web apps.
- **Dart**: Programming language for Flutter, handling app logic and UI.

### Key Packages
- **dio (5.4.0)**: HTTP client for API requests to the Measurement API (e.g., fetching sessions, submitting measurements).
- **flutter_secure_storage (9.0.0)**: Securely stores JWT tokens and PIN codes locally.
- **flutter_reactive_ble (5.4.0)**: Connects to Bluetooth devices (e.g., height measurement device), with permissions in `AndroidManifest.xml` and `Info.plist`.
- **shared_preferences (2.5.3)**: Stores non-sensitive user settings.
- **flutter_localizations & intl (0.19.0)**: Enables multi-language support.
- **permission_handler (11.4.0)**: Manages Bluetooth and location permissions.
- **flutter_svg (2.0.10+1)**: Renders SVG assets for icons/images.