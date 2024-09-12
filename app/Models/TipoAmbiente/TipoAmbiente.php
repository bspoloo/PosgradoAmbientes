<?php

namespace App\Models\TipoAmbiente;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TipoAmbiente extends Model
{
    use HasFactory;
    protected $table = 'tipos_ambientes';
    protected $primaryKey = 'id_tipo_ambiente';
    public $timestamps = false;
    protected $fillable = [
        'nombre', 'icono','direccion', 'estado'
    ];
}
