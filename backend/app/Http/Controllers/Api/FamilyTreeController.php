<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\FamilyTreeNode;
use Illuminate\Http\Request;

class FamilyTreeController extends Controller
{
    public function index(Request $request)
    {
        $nodes = FamilyTreeNode::where('user_id', $request->user()->id)
            ->with('parent', 'children')
            ->get();
        
        return response()->json($nodes);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'relationship' => 'required|string|max:255',
            'birth_date' => 'nullable|date',
            'death_date' => 'nullable|date',
            'notes' => 'nullable|string',
            'parent_id' => 'nullable|exists:family_tree_nodes,id',
        ]);

        $node = FamilyTreeNode::create([
            'user_id' => $request->user()->id,
            'name' => $request->name,
            'relationship' => $request->relationship,
            'birth_date' => $request->birth_date,
            'death_date' => $request->death_date,
            'notes' => $request->notes,
            'parent_id' => $request->parent_id,
        ]);

        return response()->json($node->load('parent', 'children'), 201);
    }

    public function show(Request $request, $id)
    {
        $node = FamilyTreeNode::where('user_id', $request->user()->id)
            ->with('parent', 'children')
            ->findOrFail($id);
        
        return response()->json($node);
    }

    public function update(Request $request, $id)
    {
        $node = FamilyTreeNode::where('user_id', $request->user()->id)
            ->findOrFail($id);

        $request->validate([
            'name' => 'sometimes|string|max:255',
            'relationship' => 'sometimes|string|max:255',
            'birth_date' => 'nullable|date',
            'death_date' => 'nullable|date',
            'notes' => 'nullable|string',
            'parent_id' => 'nullable|exists:family_tree_nodes,id',
        ]);

        $node->update($request->all());
        return response()->json($node->load('parent', 'children'));
    }

    public function destroy(Request $request, $id)
    {
        $node = FamilyTreeNode::where('user_id', $request->user()->id)
            ->findOrFail($id);
        
        $node->delete();
        return response()->json(['message' => 'Family member deleted successfully']);
    }
}

