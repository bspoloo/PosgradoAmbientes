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

        DB::beginTransaction();

        try {
            $this->reorganizarPisos($request->id_bloque, $request->id_piso, $request->cantidad);
            $this->addPisos($request);

            DB::commit();
            return response()->json(['success' => 'Registro guardado exitosamente.']);
        } catch (\Exception $e) {
            DB::rollback();
            return response()->json(['error' => 'Error al guardar el registro: ' . $e->getMessage()], 500);
        }
    }

    public function addPisos($request)
    {
        $iName = null;

        if ($request->hasFile('imagen')) {
            $iName = time() . '_imagen.' . $request->imagen->extension();
            $request->imagen->move(public_path('images'), $iName);
        }

        for ($i = 0; $i < $request->cantidad; $i++) {
            PisoBloque::create([
                'id_bloque' => $request->id_bloque,
                'id_piso' => $request->id_piso + $i, 
                'nombre' => $request->nombre_piso_bloque,
                'cantidad_ambientes' => $request->cantidad_ambientes,
                'imagen' => $iName,
                'estado' => $request->estado,
            ]);
        }
    }

    public function reorganizarPisos($id_bloque, $id_piso_inicio, $cantidad)
    {
        PisoBloque::where('id_bloque', $id_bloque)
            ->where('id_piso', '>=', $id_piso_inicio)
            ->orderBy('id_piso', 'desc')
            ->increment('id_piso', $cantidad);
    }
}