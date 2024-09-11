<?php

namespace App\Classes\Piso;

class Piso
{
    public $id_piso;
    public $numero;
    public $nombre;
	public $estado;
    public $ambientes;

    public function __construct($id_piso,$numero,$nombre,$estado, $ambientes)
    {
        $this->id_piso= $id_piso;
        $this->numero = $numero;
        $this->nombre = $nombre;
        $this->estado = $estado;
        $this->ambientes = $ambientes;
    }
}
