# Heritage App

A Flutter mobile application for cultural heritage preservation and mental wellness, with a Laravel backend API.

## Features

- **User Authentication** - Register, login, and manage user profiles
- **Heritage Sites** - Explore and discover cultural heritage sites
- **Mood Tracking** - Track mental wellness and mood entries
- **Community Forums** - Connect with others through language learning, cultural festivals, cuisine, and more
- **Events** - Discover and register for cultural events
- **Family Tree** - Build and manage your family tree

## Architecture

- **Frontend**: Flutter (Dart)
- **Backend**: Laravel (PHP) with RESTful API
- **Authentication**: Laravel Sanctum
- **Database**: MySQL/PostgreSQL

## Quick Start

See [SETUP.md](SETUP.md) for detailed setup instructions.

### Backend Setup
```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan serve
```

### Frontend Setup
```bash
flutter pub get
# Update lib/config/api_config.dart with your backend URL
flutter run
```

## Project Structure

```
heritageapp/
├── lib/
│   ├── config/          # Configuration files
│   ├── models/          # Data models
│   ├── screens/         # UI screens
│   └── services/        # API services
├── backend/             # Laravel API
│   ├── app/
│   │   ├── Http/Controllers/Api/
│   │   └── Models/
│   ├── database/migrations/
│   └── routes/api.php
└── SETUP.md             # Detailed setup guide
```

## API Documentation

The Laravel backend provides a RESTful API. See [SETUP.md](SETUP.md) for endpoint documentation.

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT License
