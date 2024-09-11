<button type="button" class="ambiente btn btn-primary btn-sm editRecord" data-id="{{ $id }}"

    data-icono="{{ $icono }}" 
    data-nombre="{{ $nombre }}" 
    
    data-bs-toggle="modal"
    data-bs-target="#modal-center">
    <i class="fa fa-edit"></i>
    <img src="/images/{{ $icono }}" alt="{{ $nombre }}" width="300px">
    <h2>{{ $nombre }}</h2>
</button>
