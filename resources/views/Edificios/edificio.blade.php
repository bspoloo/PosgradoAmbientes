@extends('layouts.layout')
@section('title', 'Edificios')

@section('content')
    <body>
        <div>
            <h1>The map of all building:</h1>
            <p>welcome to the dashboard user</p>
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


        <script type="text/javascript">
            var titulo = 'Universidad';
            var URLindex = "{{ route('ambientes.index') }}";
            var columnas = [{
                    data: 'id_universidad',
                    name: 'id_universidad'
                },
                {
                    data: 'nombre',
                    name: 'nombre'
                },
                {
                    data: 'nombre_abreviado',
                    name: 'nombre_abreviado'
                },
                {
                    data: 'inicial',
                    name: 'inicial',
                    orderable: false,
                    searchable: false
                },
                {
                    data: 'estado',
                    name: 'estado',
                    orderable: false,
                    searchable: false
                },
                {
                    data: 'action',
                    name: 'action',
                    orderable: false,
                    searchable: false
                },
            ]
        </script>

        <div class="modal fade" id="ajaxModel" tabindex="-1" aria-labelledby="exampleModalgridLabel">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modelHeading">Titulo</h5>

                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="form" name="form" class="needs-validation" autocomplete="off" novalidate>
                            <input type="hidden" name="table_id" id="table_id">
                            @csrf

                            <div class="mb-3">
                                <label for="nombre" class="form-label">Nombre<span
                                        class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="nombre" value="" id="nombre"
                                    placeholder="Introduzca el nombre de la universidad" required>
                                <div class="invalid-feedback"></div>
                            </div>

                            <div class="mb-3">
                                <label for="numero_piso" class="form-label">Numero de piso <span
                                        class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="numero_piso" value=""
                                    id="numero_piso" placeholder="Introduzca el numero de piso"
                                    required>
                                <div class="invalid-feedback"></div>
                            </div>

                            <div class="mb-3">
                                <label for="piso_bloque" class="form-label">Piso Bloque <span
                                        class="text-danger">*</span></label>
                                <input type="text" class="form-control" name="piso_bloque" value="" id="piso_bloque"
                                    placeholder="Introduzca el piso_bloque" required>
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

        <script src="{{ URL::asset('js/crud.js') }}"></script>
    </body>
@endsection
