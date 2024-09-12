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
            'id_bloque' => 'required | string',
            'numero_piso' => 'required | string',
            'cantidad' => 'required | string',
            'nombre' => 'required | string',
            'cantidad_ambientes' => 'required | string',
            'imagen' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
            'estado' => 'required | string',
        ];
    }
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), $this->data);
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }
        $piso = Piso::where('numero', $request->numero_piso)->first();

        $iName = null;

        if ($request->hasFile('imagen')) {
            $iName = time() . 'imagen.' . $request->imagen->extension();
            $request->imagen->move(public_path('images'), $iName);
        }

        for ($i = $request->numero_piso; $i < $request->cantidad; $i++) {

            $piso_bloque = PisoBloque::where('id_piso', $i)->first();

            $piso_bloque->update([
                'id_piso' => $request->numero_piso + $i,
            ]);

            $piso_bloque = PisoBloque::create(
                [
                    'id_bloque' => $request->id_bloque,
                    'id_piso' => $piso->id_piso + ($i + 1),
                    'nombre' => $request->nombre,
                    'cantidad_ambientes' => $request->cantidad_ambientes,
                    'imagen' => $iName,
                    'estado' => $request->estado,
                ]
            );

            $piso_bloque->save();
        }
        return response()->json(['success' => 'Registro guardado exitosamente.' . $request]);
    }
}
