<?php

namespace App\Http\Controllers\Piso;

use App\Http\Controllers\Controller;
use App\Models\Piso\Piso;
use App\Models\PisoBloque\PisoBloque;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
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


        $iName = null;

        if ($request->hasFile('imagen')) {
            $iName = time() . 'imagen.' . $request->imagen->extension();
            $request->imagen->move(public_path('images'), $iName);
        }
        $piso = Piso::where('numero', $request->numero_piso);
        // Actualizar los bloques existentes
        PisoBloque::where('id_bloque', $request->id_bloque)
            ->where('id_piso', '>=', $request->numero_piso + 1)
            ->update(['id_piso' => DB::raw('id_piso + ' . $request->cantidad)]);

        // Insertar los nuevos pisos
        for ($i = $request->numero_piso; $i < $request->cantidad; $i++) {
            PisoBloque::create([
                'id_bloque' => $request->id_bloque,
                'id_piso' =>  +$piso->numero + 1,
                'nombre' => $request->nombre . ' ' . ($request->numero_piso + $i),
                'cantidad_ambientes' => $request->cantidad_ambientes,
                'imagen' => $iName,
                'estado' => $request->estado,
            ]);
        }
        return response()->json(['success' => 'Registro guardado exitosamente.' . $request]);
    }
}
