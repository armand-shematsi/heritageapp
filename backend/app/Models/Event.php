<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Event extends Model
{
    use HasFactory;

    protected $fillable = [
        'title',
        'description',
        'date',
        'time',
        'location',
        'type',
        'price',
        'host',
        'duration',
        'image_url',
    ];

    protected $casts = [
        'date' => 'date',
    ];

    public function registrations()
    {
        return $this->hasMany(EventRegistration::class);
    }
}

