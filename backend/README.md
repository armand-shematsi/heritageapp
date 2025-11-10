# Heritage App - Laravel Backend API

This is the Laravel backend API for the Heritage App Flutter application.

## Setup Instructions

1. Install Composer (if not already installed)
2. Navigate to the backend directory
3. Run `composer install`
4. Copy `.env.example` to `.env` and configure your database
5. Run `php artisan key:generate`
6. Run `php artisan migrate`
7. Run `php artisan serve` to start the development server

## API Endpoints

### Authentication
- POST `/api/register` - Register a new user
- POST `/api/login` - Login user
- POST `/api/logout` - Logout user
- GET `/api/user` - Get authenticated user

### Heritage Sites
- GET `/api/heritage-sites` - Get all heritage sites
- GET `/api/heritage-sites/{id}` - Get a specific heritage site
- POST `/api/heritage-sites` - Create a heritage site (authenticated)
- PUT `/api/heritage-sites/{id}` - Update a heritage site (authenticated)
- DELETE `/api/heritage-sites/{id}` - Delete a heritage site (authenticated)

### Mood Entries
- GET `/api/mood-entries` - Get user's mood entries
- POST `/api/mood-entries` - Create a mood entry
- GET `/api/mood-entries/{id}` - Get a specific mood entry
- PUT `/api/mood-entries/{id}` - Update a mood entry
- DELETE `/api/mood-entries/{id}` - Delete a mood entry

### Events
- GET `/api/events` - Get all events
- POST `/api/events` - Create an event (authenticated)
- GET `/api/events/{id}` - Get a specific event
- PUT `/api/events/{id}` - Update an event (authenticated)
- DELETE `/api/events/{id}` - Delete an event (authenticated)
- POST `/api/events/{id}/register` - Register for an event

### Community
- GET `/api/community/posts` - Get community posts
- POST `/api/community/posts` - Create a post
- GET `/api/community/forums` - Get forums
- POST `/api/community/forums/{id}/messages` - Send a message to a forum

### Family Tree
- GET `/api/family-tree` - Get user's family tree
- POST `/api/family-tree` - Add a family member
- PUT `/api/family-tree/{id}` - Update a family member
- DELETE `/api/family-tree/{id}` - Delete a family member

