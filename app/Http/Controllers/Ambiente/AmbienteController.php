<?php

namespace App\Http\Controllers\Ambiente;

use App\Http\Controllers\Controller;
use App\Models\Ambiente\Ambiente;
use Illuminate\Http\Request;

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
    public function index(Request $request)
    {
        if ($request->ajax()) {

            $data = Ambiente::all();

            return DataTables::of($data)
                ->addIndexColumn()
                ->addColumn('action', function ($row) {
                    $btn = '<button type="button" class="btn btn-primary btn-sm editRecord" data-id="' . $row->id_universidad . '" data-bs-toggle="modal" data-bs-target="#modal-center"><i class="fa fa-edit"></i>Edit</button>';
                    $btn = $btn . ' <a href="javascript:void(0)" class="btn btn-danger btn-sm deleteRecord" data-id="' . $row->id_universidad . '"><i class="fa fa-trash"></i>Delete</a';
                    return $btn;
                })
                ->rawColumns(['action'])
                ->make(true);
        }

        return view('CRUD.Universidades.uni_list');
    }
    
    public function edit($id_ambiente)
    {
        $where = array('id_edificio' => $id_ambiente);
        $table  = $this->model::where($where)->first();
        $table['id'] = $table->id_ambiente;
        return response()->json($table);
    }
}
