<?php

use App\Http\Controllers\Ambiente\AmbienteController;
use App\Http\Controllers\Edificio\EdificioController;
use Illuminate\Support\Facades\Route;

// Route::get('/', function () {
//     return view('welcome');
// });
Route::get('ambientes/{id_ambiente}/edit', [AmbienteController::class, 'edit']);
Route::post('ambientes', [AmbienteController::class, 'store']);

Route::get('edificios', [EdificioController::class, 'getEdificios']);
Route::get('edificios/{id_edificio}', [EdificioController::class, 'getEdificioById']);


