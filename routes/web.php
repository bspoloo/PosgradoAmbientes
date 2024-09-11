<?php

use App\Http\Controllers\Ambiente\AmbienteController;
use App\Http\Controllers\Edificio\EdificioController;
use Illuminate\Support\Facades\Route;

// Route::get('/', function () {
//     return view('welcome');
// });

Route::get('edificios', [EdificioController::class, 'getEdificios']);
Route::get('edificios/{id_edificio}', [EdificioController::class, 'getEdificioById']);

Route::get('ambientes', [AmbienteController::class, 'index'])->name('ambientes.index');
Route::get('ambientes/{id_ambiente}/edit', [AmbienteController::class, 'edit']);
Route::post('ambientes', [AmbienteController::class, 'store']);
