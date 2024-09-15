<div class="piso">
    {{ $nombre }}
    {{ $numero_piso }}

    <div class="actions">
        <button type="button" class="btn btn-primary btn-sm createNewRecord" data-bs-toggle="modal"
            data-bs-target="#modal-center" data-value='{{ $id_edificio }}_{{ $id_piso }}'><i
                class="fa fa-create"></i>+</button>
                
        <button id="toggleButton" class="toggleButton" data-value='{{ $id_edificio }}_{{ $id_piso }}'>
            <img src="/images/ojo.png" alt="open-piso" width="20px">
        </button>
        <button id="deletePiso" data-value='{{ $id_piso }}'>
            <img src="/images/borrar.png" alt="open-piso" width="20px">
        </button>
    </div>
    <div id="ambientesContainer{{ $id_edificio }}_{{ $id_piso }}" style="display: none;" class="ambientes">
        <!-- Los ambientes se cargarán aquí -->
    </div>
</div>
