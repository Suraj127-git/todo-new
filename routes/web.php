<?php

use Illuminate\Support\Facades\Route;

use App\Http\Controllers\TodoController;

Route::get('/', [TodoController::class, 'index'])->name('todo.index');
Route::post('/todo', [TodoController::class, 'store'])->name('todo.store');
Route::post('/todo/{todo}', [TodoController::class, 'update'])->name('todo.update');
Route::post('/todo/{todo}', [TodoController::class, 'destroy'])->name('todo.destroy');
    