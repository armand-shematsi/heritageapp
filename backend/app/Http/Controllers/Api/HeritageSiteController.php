<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\HeritageSite;
use Illuminate\Http\Request;

class HeritageSiteController extends Controller
{
    public function index()
    {
        $sites = HeritageSite::all();
        return response()->json($sites);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'location' => 'required|string|max:255',
            'image_url' => 'nullable|url',
            'cultural_significance' => 'nullable|string',
            'latitude' => 'required|numeric',
            'longitude' => 'required|numeric',
        ]);

        $site = HeritageSite::create($request->all());
        return response()->json($site, 201);
    }

    public function show($id)
    {
        $site = HeritageSite::findOrFail($id);
        return response()->json($site);
    }

    public function update(Request $request, $id)
    {
        $site = HeritageSite::findOrFail($id);
        
        $request->validate([
            'name' => 'sometimes|string|max:255',
            'description' => 'sometimes|string',
            'location' => 'sometimes|string|max:255',
            'image_url' => 'nullable|url',
            'cultural_significance' => 'nullable|string',
            'latitude' => 'sometimes|numeric',
            'longitude' => 'sometimes|numeric',
        ]);

        $site->update($request->all());
        return response()->json($site);
    }

    public function destroy($id)
    {
        $site = HeritageSite::findOrFail($id);
        $site->delete();
        return response()->json(['message' => 'Heritage site deleted successfully']);
    }
}

