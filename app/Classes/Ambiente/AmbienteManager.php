<?php

namespace App\Classes\Ambiente;

use Illuminate\Support\Facades\DB;

class AmbienteManager
{
    /**
     * Create a new class instance.
     */
    public function __construct() {}
    public function getAmbientes($edificio, $piso)
    {
        $ambientes = DB::table('ambiente_piso_bloque')
            ->where('id_edificio', $edificio->id_edificio)
            ->where('numero_piso', $piso)
            ->orderBy('id_edificio', 'asc')
            ->get();

        return $ambientes;
    }
}
