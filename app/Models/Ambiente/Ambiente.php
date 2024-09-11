<?php

namespace App\Models\Ambiente;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Ambiente extends Model
{
    use HasFactory;
    protected $table = 'ambientes';
    protected $primaryKey = 'id_ambiente';
    public $timestamps = false;
    protected $fillable = [
        'id_piso_bloque', 'id_tipo_ambiente','nombre', 'codigo', 'capacidad', 'metro_cuadrado', 'imagen_exterior', 'imagen_interior', 'estado'
    ];
}
