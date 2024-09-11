<?php

namespace App\Models\Edificio;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Edificio extends Model
{
    use HasFactory;
    protected $table = 'edificios';
    protected $primaryKey = 'id_edificio';
    public $timestamps = false;
    protected $fillable = [
        'id_campu', 'nombre','direccion', 'latitud', 'longitud', 'imagen', 'estado'
    ];
}
