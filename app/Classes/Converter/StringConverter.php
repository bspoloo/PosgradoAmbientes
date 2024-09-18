<?php

namespace App\Classes\Converter;

class StringConverter
{
    public function __construct()
    {
        //
    }
    public function arrayToString($arrayPoligono)
    {
        $poligono = [];

        if (!is_string($arrayPoligono)) {
            
            foreach ($arrayPoligono as $item) {
                if (isset($item['lat']) && isset($item['lng'])) {
                    $poligono[] = "{$item['lat']},{$item['lng']}";
                } else {
                    throw new \InvalidArgumentException("Element must have 'lat' and 'lng' properties.");
                }
            }

            return implode(',', $poligono);

        } else {
            return $arrayPoligono;
        }
    }
}
