<?php

namespace App\Http\Controllers\PisoBloque;

use App\Http\Controllers\Controller;
use App\Models\PisoBloque\PisoBloque;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class PisoBloqueController extends Controller
{
    public function getPisosBloques($id_edificio_piso){
        $data = explode('_', $id_edificio_piso);

        $pisos_bloques = DB::table('edifcio_piso_bloque')
        ->where('id_edificio', $data[0])
        ->where('id_piso', $data[1])
        ->get();

        return response()->json($pisos_bloques);
    }
}
