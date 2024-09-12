<?php

namespace App\Models\Piso;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Piso extends Model
{
    use HasFactory;
    protected $table = 'pisos';
    protected $primaryKey = 'id_piso';
    public $timestamps = false;
    protected $fillable = [
        'numero','nombre', 'estado'
    ];
}
