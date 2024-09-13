<?php

use App\Http\Controllers\Ambiente\AmbienteController;
use App\Http\Controllers\Edificio\EdificioController;
use App\Http\Controllers\Piso\PisoController;
use App\Http\Controllers\PisoBloque\PisoBloqueController;
use Illuminate\Support\Facades\Route;

// Route::get('/', function () {
//     return view('welcome');
// });

Route::post('pisos', [PisoController::class, 'store']);

Route::get('ambientes/{id_ambiente}/edit', [AmbienteController::class, 'edit']);
Route::post('ambientes', [AmbienteController::class, 'store']);
Route::delete('ambientes/{id_ambiente}', [AmbienteController::class, 'destroy']);

Route::get('edificios', [EdificioController::class, 'getEdificios']);
Route::get('edificios/{id_edificio}', [EdificioController::class, 'getEdificioById']);

Route::get('pisos_bloques/{id_edificio_piso}', [PisoBloqueController::class, 'getPisosBloques']);

