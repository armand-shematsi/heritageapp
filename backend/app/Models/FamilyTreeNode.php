<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class FamilyTreeNode extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'name',
        'relationship',
        'birth_date',
        'death_date',
        'notes',
        'parent_id',
    ];

    protected $casts = [
        'birth_date' => 'date',
        'death_date' => 'date',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function parent()
    {
        return $this->belongsTo(FamilyTreeNode::class, 'parent_id');
    }

    public function children()
    {
        return $this->hasMany(FamilyTreeNode::class, 'parent_id');
    }
}

