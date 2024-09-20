<?php

namespace App\Http\Controllers\EdificioPiso;

use App\Classes\Ambiente\AmbienteManager;
use App\Classes\Edificio\EdificioManager;
use App\Classes\Piso\Piso;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class EdificioPisoController extends Controller
{
    public $edificioManager;
    public function __construct() {
        $this->edificioManager = new EdificioManager();
    }
    public function getEdificioPiso($id_edificio){
        return response()->json($this->edificioManager->getEdificioAmbiente($id_edificio));
    }
}
