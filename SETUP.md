# Heritage App - Setup Guide

This guide will help you set up both the Laravel backend and Flutter frontend.

## Prerequisites

- PHP 8.1 or higher
- Composer
- MySQL or PostgreSQL
- Flutter SDK
- Node.js (for Laravel Mix/Vite if needed)

## Backend Setup (Laravel)

1. **Navigate to the backend directory:**
   ```bash
   cd backend
   ```

2. **Install dependencies:**
   ```bash
   composer install
   ```

3. **Set up environment file:**
   ```bash
   cp .env.example .env
   ```

4. **Configure your database in `.env`:**
   ```env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=heritage_app
   DB_USERNAME=root
   DB_PASSWORD=your_password
   ```

5. **Generate application key:**
   ```bash
   php artisan key:generate
   ```

6. **Run migrations:**
   ```bash
   php artisan migrate
   ```

7. **Install Laravel Sanctum (if not already installed):**
   ```bash
   php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
   php artisan migrate
   ```

8. **Start the development server:**
   ```bash
   php artisan serve
   ```

   The API will be available at `http://localhost:8000`

## Frontend Setup (Flutter)

1. **Navigate to the project root:**
   ```bash
   cd heritageapp
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoint:**
   
   Edit `lib/config/api_config.dart` and update the `baseUrl`:
   
   - For Android Emulator: `http://10.0.2.2:8000/api`
   - For iOS Simulator: `http://localhost:8000/api`
   - For Physical Device: `http://YOUR_COMPUTER_IP:8000/api` (e.g., `http://192.168.1.100:8000/api`)
   - For Web: `http://localhost:8000/api`

4. **Run the app:**
   ```bash
   flutter run
   ```

## API Endpoints

### Authentication
- `POST /api/register` - Register a new user
- `POST /api/login` - Login user
- `POST /api/logout` - Logout user (requires authentication)
- `GET /api/user` - Get authenticated user (requires authentication)

### Heritage Sites
- `GET /api/heritage-sites` - Get all heritage sites
- `GET /api/heritage-sites/{id}` - Get a specific heritage site
- `POST /api/heritage-sites` - Create a heritage site (requires authentication)
- `PUT /api/heritage-sites/{id}` - Update a heritage site (requires authentication)
- `DELETE /api/heritage-sites/{id}` - Delete a heritage site (requires authentication)

### Mood Entries
- `GET /api/mood-entries` - Get user's mood entries (requires authentication)
- `POST /api/mood-entries` - Create a mood entry (requires authentication)
- `GET /api/mood-entries/{id}` - Get a specific mood entry (requires authentication)
- `PUT /api/mood-entries/{id}` - Update a mood entry (requires authentication)
- `DELETE /api/mood-entries/{id}` - Delete a mood entry (requires authentication)

### Events
- `GET /api/events` - Get all events
- `POST /api/events` - Create an event (requires authentication)
- `GET /api/events/{id}` - Get a specific event
- `PUT /api/events/{id}` - Update an event (requires authentication)
- `DELETE /api/events/{id}` - Delete an event (requires authentication)
- `POST /api/events/{id}/register` - Register for an event (requires authentication)

### Community
- `GET /api/community/posts` - Get community posts (requires authentication)
- `POST /api/community/posts` - Create a post (requires authentication)
- `GET /api/community/forums` - Get forums (requires authentication)
- `POST /api/community/forums/{id}/messages` - Send a message to a forum (requires authentication)

### Family Tree
- `GET /api/family-tree` - Get user's family tree (requires authentication)
- `POST /api/family-tree` - Add a family member (requires authentication)
- `PUT /api/family-tree/{id}` - Update a family member (requires authentication)
- `DELETE /api/family-tree/{id}` - Delete a family member (requires authentication)

## Testing the Setup

1. **Start the Laravel backend:**
   ```bash
   cd backend
   php artisan serve
   ```

2. **Test the API:**
   ```bash
   curl http://localhost:8000/api/heritage-sites
   ```

3. **Run the Flutter app:**
   ```bash
   cd heritageapp
   flutter run
   ```

## Troubleshooting

### CORS Issues
If you encounter CORS errors, make sure:
- The `config/cors.php` file is properly configured
- The `SANCTUM_STATEFUL_DOMAINS` in `.env` includes your frontend domain

### Connection Issues
- Make sure the Laravel server is running
- Check that the API URL in `lib/config/api_config.dart` matches your backend URL
- For physical devices, ensure both devices are on the same network
- Check firewall settings

### Database Issues
- Ensure your database server is running
- Verify database credentials in `.env`
- Run `php artisan migrate:fresh` to reset the database (WARNING: This will delete all data)

## Next Steps

- Seed the database with sample data
- Configure file storage for images
- Set up email notifications
- Deploy to production

