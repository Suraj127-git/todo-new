<?php

namespace App\Http\Controllers;

use App\Models\Todo;
use Inertia\Inertia;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class TodoController extends Controller
{
    public function index()
    {
        Log::info('Todos:', ['data' => Todo::all()]);
        return Inertia::render('Todo/Index', [
            'todos' => Todo::all(),
        ]);
    }

public function store(Request $request)
{
    $request->validate(['title' => 'required|string|max:255']);
    Todo::create(['title' => $request->title]);
    return redirect()->back();
}

public function update(Request $request, Todo $todo)
{
    $request->validate(['completed' => 'required|boolean']);
    $todo->update(['completed' => $request->completed]);
    return redirect()->back();
}

public function destroy(Todo $todo)
{
    $todo->delete();
    return redirect()->back();
}

}
