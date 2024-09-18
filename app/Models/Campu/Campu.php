<?php

namespace App\Models\Campu;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Campu extends Model
{
    use HasFactory;
    protected $table = 'campus';
    protected $primaryKey = 'id_campu';
    public $timestamps = false;
    protected $fillable = [
        'nombre', 'direccion','poligono', 'latitud', 'longitud', 'imagen', 'estado'
    ];
}
