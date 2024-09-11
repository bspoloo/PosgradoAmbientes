@extends('layouts.layout')
@section('title', 'Edificios')

@section('content')

    <body>
        <div>
            <h1>The map of all building:</h1>
            <p>welcome to the dashboard user</p>
        </div>
        <div class="cnotainer">
            <div class="row">
                <div class="col-12">
                    <div class="page-title-box d-sm-flex align-items-center justify-content-between">
                        <h4 class="mb-sm-0 font-size-18">Edificio</h4>
                        <div class="page-title-right">
                            <ol class="breadcrumb m-0">
                                <li class="breadcrumb-item"><a href="javascript: void(0);">Gestión</a></li>
                                <li class="breadcrumb-item active">Ambientes</li>
                            </ol>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="container">
            <div>
                <img class="rounded-img" src="/images/{{ $edificio->imagen }}" alt="{{ $edificio->imagen }}" width="300px">
            </div>
            <div>
                <h2>Nombre: {{ $edificio->nombre }}</h2>
            </div>
        </div>

        <div class="edificio">
            @foreach ($pisos_ambientes as $piso)
                <x-piso type="info">
                    <x-slot name="nombre">
                        {{ $piso->nombre }}
                    </x-slot>
                    <x-slot name="numero_piso">
                        {{ $piso->numero }}
                    </x-slot>
                </x-piso>
                <div class="ambientes piso">
                    @foreach ($piso->ambientes as $ambiente)
                        <x-ambiente type="info">
                            <x-slot name="id">
                                {{ $ambiente->id_ambiente }}
                            </x-slot>
                            <x-slot name="icono">
                                {{ $ambiente->icono }}
                            </x-slot>
                            <x-slot name="nombre">
                                {{ $ambiente->nombre }}
                            </x-slot>
                        </x-ambiente>
                    @endforeach
                </div>
            @endforeach
        </div>
        <!-- Modal Structure -->
        <div class="modal fade" id="modal-center" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modelHeading">Detalles del Ambiente</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="form" name="form" class="needs-validation" autocomplete="off" novalidate>
                            <input type="hidden" name="id_ambiente" id="id_ambiente">
                            @csrf
        
                            <!-- Nombre -->
                            <div class="mb-3">
                                <label for="nombre" class="form-label">Nombre <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="nombre" id="nombre" placeholder="Nombre del ambiente" required>
                                <div class="invalid-feedback"></div>
                            </div>
        
                            <!-- Código -->
                            <div class="mb-3">
                                <label for="codigo" class="form-label">Código <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="codigo" id="codigo" placeholder="Código del ambiente" required>
                                <div class="invalid-feedback"></div>
                            </div>
        
                            <!-- Capacidad -->
                            <div class="mb-3">
                                <label for="capacidad" class="form-label">Capacidad <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" name="capacidad" id="capacidad" placeholder="Capacidad del ambiente" required>
                                <div class="invalid-feedback"></div>
                            </div>
        
                            <!-- Metro Cuadrado -->
                            <div class="mb-3">
                                <label for="metro_cuadrado" class="form-label">Metro Cuadrado <span class="text-danger">*</span></label>
                                <input type="number" step="0.01" class="form-control" name="metro_cuadrado" id="metro_cuadrado" placeholder="Metros cuadrados del ambiente" required>
                                <div class="invalid-feedback"></div>
                            </div>
        
                            <!-- Imagen Exterior -->
                            <div class="mb-3">
                                <label for="imagen_exterior" class="form-label">Imagen Exterior <span class="text-danger">*</span></label>
                                <input type="file" class="form-control" name="imagen_exterior" id="imagen_exterior" required>
                                <div class="invalid-feedback"></div>
                            </div>
        
                            <!-- Imagen Interior -->
                            <div class="mb-3">
                                <label for="imagen_interior" class="form-label">Imagen Interior <span class="text-danger">*</span></label>
                                <input type="file" class="form-control" name="imagen_interior" id="imagen_interior" required>
                                <div class="invalid-feedback"></div>
                            </div>
        
                            <!-- Estado -->
                            <div class="mb-3">
                                <label for="estado" class="form-label">Estado <span class="text-danger">*</span></label>
                                <select class="form-control" name="estado" id="estado">
                                    <option value="S">Activado</option>
                                    <option value="N">Desactivado</option>
                                </select>
                                <div class="invalid-feedback"></div>
                            </div>
        
                            <div class="mt-4">
                                <button class="btn btn-success w-100" type="submit">Guardar</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <script src="{{ URL::asset('js/edit.js') }}"></script>
    </body>
@endsection
