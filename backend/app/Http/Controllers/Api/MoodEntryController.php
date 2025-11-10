<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MoodEntry;
use Illuminate\Http\Request;

class MoodEntryController extends Controller
{
    public function index(Request $request)
    {
        $entries = MoodEntry::where('user_id', $request->user()->id)
            ->orderBy('date', 'desc')
            ->get();
        
        return response()->json($entries);
    }

    public function store(Request $request)
    {
        $request->validate([
            'mood_rating' => 'required|integer|min:1|max:10',
            'notes' => 'nullable|string',
            'date' => 'nullable|date',
            'tags' => 'nullable|array',
        ]);

        $entry = MoodEntry::create([
            'user_id' => $request->user()->id,
            'mood_rating' => $request->mood_rating,
            'notes' => $request->notes,
            'date' => $request->date ?? now(),
            'tags' => $request->tags ?? [],
        ]);

        return response()->json($entry, 201);
    }

    public function show(Request $request, $id)
    {
        $entry = MoodEntry::where('user_id', $request->user()->id)
            ->findOrFail($id);
        
        return response()->json($entry);
    }

    public function update(Request $request, $id)
    {
        $entry = MoodEntry::where('user_id', $request->user()->id)
            ->findOrFail($id);

        $request->validate([
            'mood_rating' => 'sometimes|integer|min:1|max:10',
            'notes' => 'nullable|string',
            'date' => 'nullable|date',
            'tags' => 'nullable|array',
        ]);

        $entry->update($request->all());
        return response()->json($entry);
    }

    public function destroy(Request $request, $id)
    {
        $entry = MoodEntry::where('user_id', $request->user()->id)
            ->findOrFail($id);
        
        $entry->delete();
        return response()->json(['message' => 'Mood entry deleted successfully']);
    }
}

