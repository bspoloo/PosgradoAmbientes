<?php

namespace App\Http\Controllers\PisoBloque;

use App\Http\Controllers\Controller;
use App\Models\PisoBloque\PisoBloque;
use Illuminate\Http\Request;

class PisoBloqueController extends Controller
{
    public function getPisosBloques($numero_piso){
        $pisos_bloques = PisoBloque::findOrFail($numero_piso);
        
        return response()->json(['success' => 'El piso BLoque para el edificio es:.' . $pisos_bloques]);
    }
}
