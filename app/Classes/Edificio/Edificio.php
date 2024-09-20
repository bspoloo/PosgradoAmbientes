<?php

namespace App\Classes\Edificio;

class Edificio
{
    public $edificio;
    public $pisos_ambientes;
    public $PisosBloques;
    public $TipoAmbientes;
    public $bloques;
    public $pisos;
    
    public function __construct($edificio, $pisos_ambientes, $PisosBloques, $TipoAmbientes, $bloques, $pisos)
    {
        $this->edificio= $edificio;
        $this->pisos_ambientes = $pisos_ambientes;
        $this->PisosBloques = $PisosBloques;
        $this->TipoAmbientes = $TipoAmbientes;
        $this->bloques = $bloques;
        $this->pisos = $pisos;
    }
}
