<?php

namespace App\Http\Controllers\Ambiente;

use App\Classes\Ambiente\AmbienteManager;
use App\Http\Controllers\Controller;
use App\Models\Ambiente\Ambiente;
use App\Models\Edificio\Edificio;
use App\Models\Piso\Piso;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
class AmbienteController extends Controller
{
    public $model;
    public $data;
    public $validator;
    public $ambienteManganer;
    public function __construct()
    {
        $this->model = new Ambiente();
        $this->ambienteManganer = new AmbienteManager();
        $this->data = [
            'id_piso_bloque' => 'required | string',
            'id_tipo_ambiente' => 'required | string',
            'nombre' => 'required | string',
            'codigo' => 'required | string',
            'capacidad' => 'required | string',
            'metro_cuadrado' => 'required | string',
            'estado' => 'required | string',
        ];
    }
    public function getAmbientes($id_edificio_piso)
    {
        $data = explode('_', $id_edificio_piso);

        $edificio = Edificio::findOrfail($data[0]);
        $piso = Piso::findOrfail($data[1]);
        return response()->json($this->ambienteManganer->getAmbientes($edificio, $piso->numero));
    }
    public function edit($id_ambiente)
    {
        $table  = $this->model::findOrfail($id_ambiente);
        $table['id'] = $table->id_ambiente;
        return response()->json($table);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), $this->data);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $ieNmae = null;
        $iiName = null;

        if ($request->hasFile('imagen_exterior')) {
            $ieNmae = time() . 'imagen_exterior.' . $request->imagen_exterior->extension();
            $request->imagen_exterior->move(public_path('images'), $ieNmae);
        }

        if ($request->hasFile('imagen_interior')) {
            $iiName = time() . 'imagen_interior.' . $request->imagen_interior->extension();
            $request->imagen_interior->move(public_path('images'), $iiName);
        }

        $ambiente = $this->model::updateOrCreate(
            ['id_ambiente' => $request->id_ambiente],
            [
                'id_piso_bloque' => $request->id_piso_bloque,
                'id_tipo_ambiente' => $request->id_tipo_ambiente,
                'nombre' => $request->nombre,
                'codigo' => $request->codigo,
                'capacidad' => $request->capacidad,
                'metro_cuadrado' => $request->metro_cuadrado,
                'imagen_exterior' => $ieNmae,
                'imagen_interior' => $iiName,
                'estado' => $request->estado,
            ]
        );

        $ambiente->save();
        return response()->json(['success' => 'Registro guardado exitosamente.' . $request]);
    }

    public function destroy($id_ambiente)
    {
        $this->model::find($id_ambiente)->delete();
        return response()->json(['success' => 'Registro borrado exitosamente.']);
    }
    
}
