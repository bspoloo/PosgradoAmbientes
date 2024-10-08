<?php

use App\Http\Controllers\Ambiente\AmbienteController;
use App\Http\Controllers\Edificio\EdificioController;
use App\Http\Controllers\EdificioPiso\EdificioPisoController;
use App\Http\Controllers\Piso\PisoController;
use App\Http\Controllers\PisoBloque\PisoBloqueController;
use Illuminate\Support\Facades\Route;

Route::post('pisos', [PisoController::class, 'store']);
Route::delete('pisos/{id_piso}', [PisoController::class, 'destroy']);

Route::get('ambientes/{id_edificio_piso}', [AmbienteController::class, 'getAmbientes']);
Route::get('ambientes/{id_ambiente}/edit', [AmbienteController::class, 'edit']);
Route::post('ambientes', [AmbienteController::class, 'store']);
Route::delete('ambientes/{id_ambiente}', [AmbienteController::class, 'destroy']);

Route::get('edificios', [EdificioController::class, 'getEdificios']);

Route::get('edificios/{id_edificio}', [EdificioController::class, 'index']);
Route::get('edificios/{id_edificio}/get', [EdificioController::class, 'getEdificioById']);
Route::post('edificios', [EdificioController::class, 'updateLocationPoligon']);
Route::get('edificios_ambientes/{id_edificio}', [EdificioController::class, 'getEdificioAmbiente']);

Route::get('pisos_bloques/{id_edificio_piso}', [PisoBloqueController::class, 'getPisosBloques']);

Route::get('EdificiosPisos/{id_edificio}', [EdificioPisoController::class, 'getEdificioPiso']);