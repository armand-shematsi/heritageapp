<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\HeritageSiteController;
use App\Http\Controllers\Api\MoodEntryController;
use App\Http\Controllers\Api\EventController;
use App\Http\Controllers\Api\CommunityController;
use App\Http\Controllers\Api\FamilyTreeController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// Public routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    // Auth routes
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'user']);
    
    // Heritage Sites
    Route::apiResource('heritage-sites', HeritageSiteController::class);
    
    // Mood Entries
    Route::apiResource('mood-entries', MoodEntryController::class);
    
    // Events
    Route::apiResource('events', EventController::class);
    Route::post('/events/{id}/register', [EventController::class, 'register']);
    
    // Community
    Route::get('/community/posts', [CommunityController::class, 'getPosts']);
    Route::post('/community/posts', [CommunityController::class, 'createPost']);
    Route::get('/community/forums', [CommunityController::class, 'getForums']);
    Route::post('/community/forums/{id}/messages', [CommunityController::class, 'sendMessage']);
    
    // Family Tree
    Route::apiResource('family-tree', FamilyTreeController::class);
});

