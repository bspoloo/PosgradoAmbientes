<div class="piso">
    {{ $nombre }}
    {{ $numero_piso }}

    <div class="actions">
        <button type="button" class="btn btn-primary btn-sm createNewRecord" data-value='{{ $id_edificio }}_{{ $id_piso }}'><i
                class="fa fa-create"></i>+</button>
                
        <button id="toggleButton" class="toggleButton" data-value='{{ $id_edificio }}_{{ $id_piso }}'>
            <img src="/images/ojo.png" alt="open-piso" width="20px">
        </button>
        <button id="deletePiso" data-value='{{ $id_piso }}' class="deletePiso"  data-id="{{ $id_piso }}">
            <img src="/images/borrar.png" alt="open-piso" width="20px">
        </button>
    </div>
</div>
