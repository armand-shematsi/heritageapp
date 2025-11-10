<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\HeritageSite;
use App\Models\Forum;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Seed Heritage Sites
        HeritageSite::create([
            'name' => 'Kasubi Tombs',
            'description' => 'Royal burial grounds of Buganda kings',
            'location' => 'Kampala, Uganda',
            'image_url' => '',
            'cultural_significance' => 'UNESCO World Heritage Site',
            'latitude' => 0.3476,
            'longitude' => 32.5825,
        ]);

        HeritageSite::create([
            'name' => 'Great Mosque of Djenné',
            'description' => 'Largest mud-brick building in the world',
            'location' => 'Djenné, Mali',
            'image_url' => '',
            'cultural_significance' => 'Center of Islamic learning',
            'latitude' => 13.9060,
            'longitude' => -4.5553,
        ]);

        HeritageSite::create([
            'name' => 'Lalibela Rock Churches',
            'description' => 'Monolithic churches carved from rock',
            'location' => 'Lalibela, Ethiopia',
            'image_url' => '',
            'cultural_significance' => 'UNESCO World Heritage Site',
            'latitude' => 12.0317,
            'longitude' => 39.0419,
        ]);

        // Seed Forums
        Forum::create([
            'name' => 'Language Learning',
            'description' => 'Practice and learn native languages',
            'icon' => 'language',
            'color' => '#2196F3',
        ]);

        Forum::create([
            'name' => 'Cultural Festivals',
            'description' => 'Share and discuss traditional celebrations',
            'icon' => 'celebration',
            'color' => '#4CAF50',
        ]);

        Forum::create([
            'name' => 'Traditional Cuisine',
            'description' => 'Recipes and cooking techniques',
            'icon' => 'restaurant',
            'color' => '#FF9800',
        ]);

        Forum::create([
            'name' => 'Oral History',
            'description' => 'Share family stories and traditions',
            'icon' => 'history',
            'color' => '#9C27B0',
        ]);

        Forum::create([
            'name' => 'Traditional Music',
            'description' => 'Cultural music and instruments',
            'icon' => 'music_note',
            'color' => '#F44336',
        ]);
    }
}

