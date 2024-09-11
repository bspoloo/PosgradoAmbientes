<?php

namespace App\Http\Controllers\Ambiente;

use App\Http\Controllers\Controller;
use App\Models\Ambiente\Ambiente;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Yajra\DataTables\Facades\DataTables;

class AmbienteController extends Controller
{
    public $model;
    public $data;
    public $validator;
    public function __construct()
    {
        $this->model = new Ambiente();
        $this->data = [
            'id_piso_bloque' => 'required | int',
            'id_tipo_ambiente' => 'required | int',
            'nombre' => 'required | string',
            'codigo' => 'required | string',
            'capacidad' => 'required | int',
            'metro_cuadrado' => 'required | int',
            'imagen_exterior' => 'required | string',
            'imagen_interior' => 'required | string',
            'estado' => 'required | string',
        ];
    }
    public function edit($id_ambiente)
    {
        $where = array('id_ambiente' => $id_ambiente);
        $table  = $this->model::where($where)->first();
        $table['id'] = $table->id_ambiente;
        return response()->json($table);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), $this->data);
    
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 422);
        }

        $this->model::updateOrCreate(
            [
                'id_universidad' => $request->table_id
            ],
            [
                'nombre' => $request->nombre,
                'nombre_abreviado' => $request->nombre_abreviado,
                'inicial' => $request->inicial,
                'estado' => $request->estado
            ]
        );

        return response()->json(['success' => 'Registro guardado exitosamente.' . $request]);
    }
}
