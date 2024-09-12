<?php

namespace App\Models\PisoBloque;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PisoBloque extends Model
{
    use HasFactory;
    protected $table = 'pisos_bloques';
    protected $primaryKey = 'id_piso_bloque';
    public $timestamps = false;
    protected $fillable = [
        'id_bloque', 'id_piso','nombre', 'cantidad_ambientes', 'imagen', 'imagen', 'estado'
    ];
}
