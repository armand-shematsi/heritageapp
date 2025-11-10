<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Event;
use App\Models\EventRegistration;
use Illuminate\Http\Request;

class EventController extends Controller
{
    public function index()
    {
        $events = Event::orderBy('date', 'asc')->get();
        return response()->json($events);
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'required|string',
            'date' => 'required|date',
            'time' => 'required|string',
            'location' => 'required|string|max:255',
            'type' => 'required|in:Virtual,In-Person',
            'price' => 'nullable|string',
            'host' => 'required|string|max:255',
            'duration' => 'nullable|string',
            'image_url' => 'nullable|url',
        ]);

        $event = Event::create($request->all());
        return response()->json($event, 201);
    }

    public function show($id)
    {
        $event = Event::with('registrations')->findOrFail($id);
        $event->attendees_count = $event->registrations()->count();
        return response()->json($event);
    }

    public function update(Request $request, $id)
    {
        $event = Event::findOrFail($id);

        $request->validate([
            'title' => 'sometimes|string|max:255',
            'description' => 'sometimes|string',
            'date' => 'sometimes|date',
            'time' => 'sometimes|string',
            'location' => 'sometimes|string|max:255',
            'type' => 'sometimes|in:Virtual,In-Person',
            'price' => 'nullable|string',
            'host' => 'sometimes|string|max:255',
            'duration' => 'nullable|string',
            'image_url' => 'nullable|url',
        ]);

        $event->update($request->all());
        return response()->json($event);
    }

    public function destroy($id)
    {
        $event = Event::findOrFail($id);
        $event->delete();
        return response()->json(['message' => 'Event deleted successfully']);
    }

    public function register(Request $request, $id)
    {
        $event = Event::findOrFail($id);

        // Check if already registered
        $existing = EventRegistration::where('event_id', $id)
            ->where('user_id', $request->user()->id)
            ->first();

        if ($existing) {
            return response()->json(['message' => 'Already registered for this event'], 400);
        }

        $registration = EventRegistration::create([
            'event_id' => $id,
            'user_id' => $request->user()->id,
        ]);

        return response()->json(['message' => 'Successfully registered for event', 'registration' => $registration], 201);
    }
}

