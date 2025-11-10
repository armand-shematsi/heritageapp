<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class HeritageSite extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'description',
        'location',
        'image_url',
        'cultural_significance',
        'latitude',
        'longitude',
    ];

    protected $casts = [
        'latitude' => 'float',
        'longitude' => 'float',
    ];
}

