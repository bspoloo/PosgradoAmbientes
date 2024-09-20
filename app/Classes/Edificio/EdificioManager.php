<?php

namespace App\Classes\Edificio;

use App\Classes\Ambiente\AmbienteManager;
use App\Classes\Edificio\Edificio as EdificioEdificio;
use App\Classes\Piso\Piso;
use App\Models\Edificio\Edificio;
use App\Models\Piso\Piso as PisoPiso;
use App\Models\PisoBloque\PisoBloque;
use App\Models\TipoAmbiente\TipoAmbiente;
use Illuminate\Support\Facades\DB;

class EdificioManager
{
    /**
     * Create a new class instance.
     */
    public $ambienteManager;
    public function __construct()
    {
        $this->ambienteManager = new AmbienteManager();
    }
    public function getEdificio($id_edificio)
    {
        $edificio = DB::table('edicio_campus')->where('id_edificio', $id_edificio)->first();
        $pisos_ambientes = [];
        $nombre = '';

        $pisos = DB::table('edificio_piso')
            ->where('id_edificio', $edificio->id_edificio)
            ->orderBy('numero_piso', 'desc')
            ->get();

        foreach ($pisos as $piso) {
            if ($nombre != $piso->piso) {

                $pisos_ambientes[] = new Piso(
                    $piso->id_piso,
                    $piso->numero_piso,
                    $piso->piso,
                    $piso->piso_estado,
                    $this->ambienteManager->getAmbientes($edificio, $piso->numero_piso)
                );

                $nombre = $piso->piso;
            }
        }

        $edificio_ambiente = new EdificioEdificio(
            $edificio,
            $pisos_ambientes,
            PisoBloque::all(),
            TipoAmbiente::all(),
            DB::table('bloques')->where('id_edificio', $edificio->id_edificio)->get(),
            PisoPiso::orderBy('numero', 'asc')->get()
        );
        return $edificio_ambiente;
    }
    public function getEdificioAmbiente($id_edificio)
    {
        $edificio = Edificio::findOrFail($id_edificio);
        $pisos_ambientes = [];
        $nombre = '';

        $pisos = DB::table('edificio_piso')
            ->where('id_edificio', $edificio->id_edificio)
            ->orderBy('numero_piso', 'desc')
            ->get();

        foreach ($pisos as $piso) {
            if ($nombre != $piso->piso) {

                $pisos_ambientes[] = new Piso(
                    $piso->id_piso,
                    $piso->numero_piso,
                    $piso->piso,
                    $piso->piso_estado,
                    $this->ambienteManager->getAmbientes($edificio, $piso->numero_piso)
                );
                $nombre = $piso->piso;
            }
        }
        return $pisos_ambientes;
    }
}
