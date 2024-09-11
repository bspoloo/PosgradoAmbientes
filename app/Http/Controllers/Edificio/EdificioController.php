<?php

namespace App\Http\Controllers\Edificio;

use App\Classes\Ambiente\AmbienteManager;
use App\Classes\Piso\Piso;
use App\Http\Controllers\Controller;
use App\Models\Edificio\Edificio;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class EdificioController extends Controller
{
    private $ambienteManager;
    public function __construct()
    {
        $this->ambienteManager = new AmbienteManager();
    }

    public function getEdificios()
    {
        $edificios = Edificio::all();
        return view('Edificios.edificios', ['edificios' => $edificios]);
    }
    public function getEdificioById($id_edificio)
    {

        $edificio = Edificio::findOrFail($id_edificio);
        $pisos_ambientes = [];
        $nombre = '';

        $this->ambienteManager->getAmbientes($edificio, 1);

        $pisos = DB::table('edificio_piso')
            ->where('id_edificio', $edificio->id_edificio)
            ->orderBy('numero_piso', 'desc')
            ->get();

        foreach ($pisos as $piso) {
            if ($nombre != $piso->piso) {
                
                $pisos_ambientes[] = new Piso(
                    $piso->id_piso,
                    $piso->piso,
                    $piso->numero_piso,
                    $piso->piso_estado,
                    $this->ambienteManager->getAmbientes($edificio, $piso->numero_piso)
                );

                $nombre = $piso->piso;
            }
        }


        return view('Edificios.edificio', ['edificio' => $edificio, 'pisos_ambientes' => $pisos_ambientes]);
    }
}
