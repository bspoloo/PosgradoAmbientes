<div class="ambiente-container">
    <button type="button" class="ambiente editRecord" data-id="{{ $id }}" 
        data-value='{{$id_edificio}}_{{$id_piso}}' data-icono="{{ $icono }}" data-nombre="{{ $nombre }}">
        <i class="fa fa-edit"></i>
        <img src="/images/{{ $icono }}" alt="{{ $nombre }}" width="300px">
        <h2>{{ $nombre }}</h2>
    </button>
    <div class="data-form">
        {{$piso_bloque}}
    </div>

    <a href="javascript:void(0)" class="btn deleteRecord" data-id="{{ $id }}"><i class="fa fa-trash"></i>
        <img src="/images/borrar.png" width="30px" alt="delete {{ $nombre }}">
    </a>
</div>