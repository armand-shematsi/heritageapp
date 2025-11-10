<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\CommunityPost;
use App\Models\Forum;
use Illuminate\Http\Request;

class CommunityController extends Controller
{
    public function getPosts(Request $request)
    {
        $forumId = $request->query('forum_id');
        
        $query = CommunityPost::with('user', 'forum');
        
        if ($forumId) {
            $query->where('forum_id', $forumId);
        }
        
        $posts = $query->orderBy('created_at', 'desc')->get();
        
        return response()->json($posts);
    }

    public function createPost(Request $request)
    {
        $request->validate([
            'forum_id' => 'required|exists:forums,id',
            'title' => 'required|string|max:255',
            'content' => 'required|string',
        ]);

        $post = CommunityPost::create([
            'user_id' => $request->user()->id,
            'forum_id' => $request->forum_id,
            'title' => $request->title,
            'content' => $request->content,
        ]);

        return response()->json($post->load('user', 'forum'), 201);
    }

    public function getForums()
    {
        $forums = Forum::withCount('posts')->get();
        return response()->json($forums);
    }

    public function sendMessage(Request $request, $id)
    {
        $forum = Forum::findOrFail($id);

        $request->validate([
            'content' => 'required|string',
        ]);

        $post = CommunityPost::create([
            'user_id' => $request->user()->id,
            'forum_id' => $id,
            'title' => 'Message',
            'content' => $request->content,
        ]);

        return response()->json($post->load('user'), 201);
    }
}

