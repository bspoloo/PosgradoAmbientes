<?php

namespace App\Http\Controllers\Edificio;

use App\Classes\Ambiente\AmbienteManager;
use App\Classes\Converter\StringConverter;
use App\Classes\Edificio\EdificioManager;
use App\Classes\Piso\Piso;
use App\Http\Controllers\Controller;
use App\Models\Campu\Campu;
use App\Models\Edificio\Edificio;
use App\Models\Piso\Piso as PisoPiso;
use App\Models\PisoBloque\PisoBloque;
use App\Models\TipoAmbiente\TipoAmbiente;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Yajra\DataTables\Facades\DataTables;

class EdificioController extends Controller
{
    private $ambienteManager;
    private $edificioManager;
    private $converter;
    public function __construct()
    {
        $this->ambienteManager = new AmbienteManager();
        $this->edificioManager = new EdificioManager();
        $this->converter = new StringConverter();
    }

    public function getEdificios()
    {
        // $edificios = Edificio::all();
        $edificios = DB::table('edicio_campus')
            ->orderBy('id_edificio', 'asc')
            ->get();

        return view('Edificios.edificios', ['edificios' => $edificios]);
    }
    public function getEdificioById($id_edificio)
    {

        // $edificio = Edificio::findOrFail($id_edificio);
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

        return view('Edificios.edificio', [
            'edificio' => $edificio,
            'pisos_ambientes' => $pisos_ambientes,
            'PisosBloques' => PisoBloque::all(),
            'TipoAmbientes' => TipoAmbiente::all(),
            'bloques' => DB::table('bloques')->where('id_edificio', $edificio->id_edificio)->get(),
            'pisos' => PisoPiso::orderBy('numero', 'asc')->get()
        ]);
    }
    public function getEdificioAmbiente($id_edificio){
        return response()->json(
            $this->edificioManager->getEdificioAmbiente($id_edificio)
        );
    }
    public function updateLocationPoligon(Request $request){

        $edificio = Edificio::findOrFail($request->id_edificio);
        $edificio_campu = DB::table('edicio_campus')->where('id_edificio',$request->id_edificio)->first();
        $campu = Campu::findOrFail($edificio_campu->id_campu);

        $poligono = $this->converter->arrayToString($request->poligono);

        $edificio->latitud = $request->latitud;
        $edificio->longitud = $request->longitud;
        $edificio->update();

        $campu->poligono = $poligono;
        $campu->latitud = $request->latitud;
        $campu->longitud = $request->longitud;

        $campu->update();

        return response()->json([
            'success' => $poligono,
        ]);
    }
}
