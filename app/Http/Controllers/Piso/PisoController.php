<?php

namespace App\Http\Controllers\Piso;

use App\Http\Controllers\Controller;
use App\Models\Piso\Piso;
use App\Models\PisoBloque\PisoBloque;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PisoController extends Controller
{
    public $data;

    public function __construct()
    {
        $this->data = [
            'id_bloque' => 'required|string',
            'id_piso' => 'required|integer',
            'cantidad' => 'required|integer',
            'nombre_piso_bloque' => 'required|string',
            'cantidad_ambientes' => 'required|integer',
            'imagen' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
            'estado' => 'required|string',
        ];
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), $this->data);
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }
        $this->addPisos($request);
        return response()->json(['success' => 'Registro guardado exitosamente.']);
    }

    public function destroy($id_piso)
    {
        pisobloque::where('id_piso', $id_piso)->delete();
        return response()->json(['success' => 'Registro borrado exitosamente.']);
    }

    public function addPisos($request)
    {
        $iName = null;

        if ($request->hasFile('imagen')) {
            $iName = time() . '_imagen.' . $request->imagen->extension();
            $request->imagen->move(public_path('images'), $iName);
        }

        for($i = 0 ; $i< $request->cantidad; $i++){
            PisoBloque::create([
                'id_bloque' => $request->id_bloque,
                'id_piso' => $request->id_piso + ($i+1), 
                'nombre' => $request->nombre_piso_bloque,
                'cantidad_ambientes' => $request->cantidad_ambientes,
                'imagen' => $iName,
                'estado' => $request->estado,
            ]);
        }
    }
}