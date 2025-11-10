<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('family_tree_nodes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('name');
            $table->string('relationship'); // e.g., 'father', 'mother', 'grandfather'
            $table->date('birth_date')->nullable();
            $table->date('death_date')->nullable();
            $table->text('notes')->nullable();
            $table->foreignId('parent_id')->nullable()->constrained('family_tree_nodes')->onDelete('set null');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('family_tree_nodes');
    }
};

