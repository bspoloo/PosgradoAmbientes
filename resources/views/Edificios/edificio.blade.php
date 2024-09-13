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
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modal-add-piso">
                    Añadir Piso
                </button>
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

                    <x-slot name="id_edificio">
                        {{ $edificio->id_edificio }}
                    </x-slot>
                    <x-slot name="id_piso">
                        {{ $piso->id_piso }}
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
                            <x-slot name="piso_bloque">
                                {{ $ambiente->piso_bloque }}
                            </x-slot>
                            <x-slot name="id_edificio">
                                {{ $edificio->id_edificio }}
                            </x-slot>
                            <x-slot name="id_piso">
                                {{ $piso->id_piso }}
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

                            <div class="mb-3">
                                <label for="id_piso_bloque" class="form-label">Piso Bloque<span class="text-danger">*</span></label>
                                <select class="form-select mb-4" name="id_piso_bloque" id="id_piso_bloque">
                                    <!-- Las opciones se llenarán dinámicamente con AJAX -->
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="id_tipo_ambiente" class="form-label">Tipo de Ambiente<span
                                        class="text-danger">*</span></label>
                                <select class="form-select mb-4" name="id_tipo_ambiente" id="id_tipo_ambiente">
                                    @foreach ($TipoAmbientes as $TipoAmbiente)
                                        <option value="{{ $TipoAmbiente->id_tipo_ambiente }}">{{ $TipoAmbiente->nombre }}
                                        </option>
                                    @endforeach
                                </select>
                            </div>

                            <!-- Nombre -->
                            <div class="mb-3">
                                <label for="nombre" class="form-label">Nombre <span class="text-danger">*</span></label>
                                <input type="text" class="form-control @error('nombre') is-invalid @enderror"
                                    name="nombre" id="nombre" placeholder="Nombre del ambiente" required>
                                <div class="invalid-feedback"></div>
                            </div>

                            <!-- Código -->
                            <div class="mb-3">
                                <label for="codigo" class="form-label">Código <span class="text-danger">*</span></label>
                                <input type="text" class="form-control @error('codigo') is-invalid @enderror"
                                    name="codigo" id="codigo" placeholder="Código del ambiente" required>
                                <div class="invalid-feedback"></div>
                            </div>

                            <!-- Capacidad -->
                            <div class="mb-3">
                                <label for="capacidad" class="form-label">Capacidad <span
                                        class="text-danger">*</span></label>
                                <input type="number" class="form-control @error('capacidad') is-invalid @enderror"
                                    name="capacidad" id="capacidad" placeholder="Capacidad del ambiente" required>
                                <div class="invalid-feedback"></div>
                            </div>

                            <!-- Metro Cuadrado -->
                            <div class="mb-3">
                                <label for="metro_cuadrado" class="form-label">Metro Cuadrado <span
                                        class="text-danger">*</span></label>
                                <input type="number" step="0.01"
                                    class="form-control @error('metro_cuadrado') is-invalid @enderror"
                                    name="metro_cuadrado" id="metro_cuadrado" placeholder="Metros cuadrados del ambiente"
                                    required>
                                <div class="invalid-feedback"></div>
                            </div>

                            <!-- Imagen Exterior -->
                            <div class="mb-3">

                                <img id="preview-imagen_exterior" src="" alt="Imagen actual"
                                    style="width: 150px; margin-top: 10px;">

                                <label for="imagen_exterior" class="form-label">Imagen Exterior <span
                                        class="text-danger">*</span></label>
                                <input type="file" class="form-control @error('imagen_exterior') is-invalid @enderror"
                                    name="imagen_exterior" id="imagen_exterior" required>
                                <div class="invalid-feedback"></div>
                            </div>

                            <!-- Imagen Interior -->
                            <div class="mb-3">
                                <img id="preview-imagen_interior" src="" alt="Imagen actual"
                                    style="width: 150px; margin-top: 10px;">
                                <label for="imagen_interior" class="form-label">Imagen Interior <span
                                        class="text-danger">*</span></label>
                                <input type="file" class="form-control @error('imagen_interior') is-invalid @enderror"
                                    name="imagen_interior" id="imagen_interior" required>
                                <div class="invalid-feedback"></div>
                            </div>

                            <!-- Estado -->
                            <div class="mb-3">
                                <label for="estado" class="form-label">Estado <span
                                        class="text-danger">*</span></label>
                                <select class="form-control" name="estado" id="estado">
                                    <option value="S">Activado</option>
                                    <option value="N">Desactivado</option>
                                </select>
                                <div class="invalid-feedback"></div>
                            </div>

                            <div class="mt-4">
                                <button class="btn btn-success w-100 submit" type="submit">Guardar</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="modal-add-piso" tabindex="-1" aria-labelledby="addPisoLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addPisoLabel">Agregar Nuevo Piso</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body">

                        <form id="form2" name="form2" class="needs-validation" autocomplete="off"
                            class="needs-validation" novalidate>
                            <input type="hidden" name="id_piso" id="id_piso">
                            @csrf

                            <select class="form-select mb-4" name="id_bloque" id="id_bloque">
                                @foreach ($bloques as $bloque)
                                    <option value="{{ $bloque->id_bloque }}">{{ $bloque->nombre }}
                                    </option>
                                @endforeach
                            </select>

                            <div class="">
                                <select class="form-select mb-4" name="id_piso" id="id_piso">

                                    @foreach ($pisos_ambientes as $piso)
                                        <option value="{{ $piso->id_piso }}">{{ $piso->numero }}.- {{ $piso->nombre }}
                                        </option>
                                    @endforeach

                                </select>
                                @php
                                    $cantidad = 0;
                                    for (
                                        $i = $pisos_ambientes[0]->numero;
                                        $i < $pisos[count($pisos) - 1]->numero;
                                        $i++
                                    ) {
                                        $cantidad++;
                                    }
                                @endphp

                                <div class="mb-3">
                                    <label for="cantidad" class="cantidad">Cantidad <span
                                            class="text-danger">*</span></label>
                                    <input type="number" class="form-control @error('cantidad') is-invalid @enderror"
                                        name="cantidad" id="cantidad" min="0"
                                        placeholder="Usted solo puede insertar cantidad de {{ $cantidad }} pisos"
                                        max="{{ $cantidad }}" required>
                                    <div class="invalid-feedback"></div>
                                </div>
                                <div class="mb-3">
                                    <label for="nombre_piso_bloque" class="form-label">Nombre del Piso Bloque <span
                                            class="text-danger">*</span></label>
                                    <input type="text" class="form-control @error('nombre_piso_bloque') is-invalid @enderror"
                                        name="nombre_piso_bloque" id="nombre_piso_bloque" placeholder="Intriduzca el nombre Piso Bloque"
                                        required>
                                    <div class="invalid-feedback"></div>
                                </div>

                                <div class="mb-3">
                                    <label for="cantidad_ambientes" class="form-label">Cantidad de ambientes<span
                                            class="text-danger">*</span></label>
                                    <input type="number" min="0"
                                        class="form-control @error('cantidad_ambientes') is-invalid @enderror"
                                        name="cantidad_ambientes" id="cantidad_ambientes"
                                        placeholder="Intriduzca la cantidad de ambientes" required>
                                    <div class="invalid-feedback"></div>
                                </div>

                                <div class="mb-3">
                                    <label for="imagen" class="form-label">Imagen<span
                                            class="text-danger">*</span></label>
                                    <input type="file" class="form-control @error('imagen') is-invalid @enderror"
                                        name="imagen" value="" id="imagen" placeholder="Introduzca la imagen"
                                        required>
                                </div>

                                <div class="mb-3">
                                    <label for="estado" class="form-label">Estado <span
                                            class="text-danger">*</span></label>
                                    <select class="form-control" name="estado" id="estado">
                                        <option value="S">Activado</option>
                                        <option value="N">Desactivado</option>
                                    </select>
                                </div>
                            </div>
                            @if ($cantidad == 0)
                                <div class="mt-4">
                                    <button type="button" class=" btn btn-success w-100" data-bs-dismiss="modal"
                                        aria-label="Close">Usted ya no puede crear mas
                                        pisos</button>
                                </div>
                            @else
                                <div class="mt-4">
                                    <button class="btn btn-success w-100 submit" type="submit">Guardar</button>
                                </div>
                            @endif

                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="{{ URL::asset('js/edit.js') }}"></script>
        <script src="{{ URL::asset('js/edit2.js') }}"></script>
    </body>
@endsection

