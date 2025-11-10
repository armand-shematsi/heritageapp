<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MoodEntry extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'mood_rating',
        'notes',
        'date',
        'tags',
    ];

    protected $casts = [
        'date' => 'datetime',
        'tags' => 'array',
        'mood_rating' => 'integer',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}

