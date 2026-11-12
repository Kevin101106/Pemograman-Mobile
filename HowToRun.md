# FreshTrack - How to Run

## 1. Project Overview

FreshTrack is a mobile application for tracking stored food items and their expiration dates.

The application helps users manage food inventory, monitor expiration status, and reduce food waste.

### Technology Stack

- Frontend: Flutter and Dart
- Backend: Laravel 12 and PHP
- Database: MySQL
- Authentication: Laravel Sanctum
- Platform: Android

## 2. Requirements

Install the following software before running the application:

- Flutter SDK
- Dart SDK
- PHP 8.2 or compatible version
- Composer
- XAMPP
- Android Studio
- Android Emulator
- Git

## 3. Project Structure

```text
Pemograman-Mobile/
├── backend/
├── frontend/
├── architecture.md
├── README.md
└── HowToRun.md
```

## 4. Database Setup

1. Open XAMPP Control Panel.
2. Start Apache and MySQL.
3. Open phpMyAdmin at `http://localhost/phpmyadmin`.
4. Create a database named `freshtrack_db`.
5. Configure the database connection in `backend/.env`:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=freshtrack_db
DB_USERNAME=root
DB_PASSWORD=
```

Adjust the database username and password if your MySQL configuration is different.

## 5. Backend Setup

Open a terminal in the project root directory and execute:

```powershell
cd backend
composer install
```

Configure the `.env` file using the database settings above.

Generate the application key:

```powershell
php artisan key:generate
```

Run database migrations:

```powershell
php artisan migrate
```

Start the Laravel development server:

```powershell
php artisan serve --host=0.0.0.0 --port=8000
```

The backend API will be available at:

`http://localhost:8000/api`

Keep the backend terminal running while using the application.

## 6. Frontend Setup

Open another terminal from the project root directory:

```powershell
cd frontend
flutter pub get
```

Start an Android Emulator through Android Studio.

Run the application:

```powershell
flutter run
```

For Android Emulator, the frontend API configuration must point to:

`http://10.0.2.2:8000/api`

This address allows the Android Emulator to access the Laravel server running on the host computer.

## 7. Login and Registration

1. Open FreshTrack on the Android Emulator.
2. Register a new account or use an existing test account.
3. Log in to access the application.
4. Use the application features to manage food items.

## 8. Main Application Features

- User registration and login.
- Add new food items.
- View food inventory.
- Edit existing food items.
- Delete food items.
- Search food items by name.
- Filter food items by category and storage location.
- Sort food items by expiration date.
- Monitor food expiration status:
  - Fresh
  - Use Soon
  - Past Due

## 9. Running Tests

Open a terminal inside the `frontend` directory.

Run static code analysis:

```powershell
flutter analyze
```

Run all Flutter tests:

```powershell
flutter test
```

All tests should pass before the application is considered ready for demonstration.

## 10. Troubleshooting

### Backend Connection Refused

- Make sure Apache and MySQL are running in XAMPP.
- Make sure the Laravel development server is running.
- Check that the frontend API address uses `10.0.2.2` when running on Android Emulator.
- Make sure the Laravel server uses port `8000`.

### Database Connection Error

- Make sure MySQL is running.
- Verify the database name and credentials in `backend/.env`.
- Make sure the `freshtrack_db` database exists.

### Flutter Dependency Error

Run:

```powershell
flutter pub get
```

### Test Failure

Run:

```powershell
flutter test
```

Review the test output and fix any failing tests before demonstration.
