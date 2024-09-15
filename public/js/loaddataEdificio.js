$(document).ready(function () {
    var isOpen = false;

    $('body').on('click', '.openEdificioButton', function () {
        var id_edificio = $(this).data('value');

        if (isOpen) {
            $('#edificioContainer' + id_edificio).hide();
            $(this).find('img').attr('src', '/images/ojo.png').attr('alt', 'Abrir');
        } else {
            cargaredificio(id_edificio);
            $('#edificioContainer' + id_edificio).show();
            $(this).find('img').attr('src', '/images/ojo2.png').attr('alt', 'Cerrar');
        }
        isOpen = !isOpen;
    });

    function cargaredificio(id_edificio) {
        console.log(id_edificio);
        $.ajax({
            url: `/edificios_ambientes/${id_edificio}`,
            type: 'GET',
            dataType: 'json',
            success: function (response) {
                console.log('el id: ' + response);
                $('#edificioContainer' + id_edificio).empty();

                $.each(response, function (index, piso) {
                    console.log(piso);
                    $('#edificioContainer' + id_edificio).append(getEdificio(piso, id_edificio));
                });
            },
            error: function (xhr) {
                console.log('Error al cargar los edificio:', xhr);
            }
        });
    }
    function getEdificio(piso, id_edificio) {
        return `
        
        <div class="piso">
            ${piso.nombre}
            ${piso.numero}
        </div>
        <div class="ambientes piso">
            ${piso.ambientes.map(function (ambiente) {
                return `
                <div class="ambiente-container">
                    <button type="button" class="ambiente btn btn-primary btn-sm editRecord" data-id="${ambiente.id_ambiente}" data-value='${id_edificio}_${piso.id_piso}'
                        data-icono="${ambiente.icono}" data-nombre="${ambiente.nombre}" data-bs-toggle="modal"
                        data-bs-target="#modal-center">
                        <i class="fa fa-edit"></i>
                        <img src="/images/${ambiente.icono}" alt="${ambiente.nombre}" width="300px">
                        <h2>${ambiente.nombre}</h2>
                    </button>
                    <div class="data-form">
                        ${ambiente.piso_bloque}
                    </div>
                    <a href="javascript:void(0)" class="btn deleteRecord" data-id="${ambiente.id_ambiente}" ><i class="fa fa-trash"></i><img
                            src="/images/borrar.png" width="30px" alt="delete ${ambiente.nombre}"></a>
                </div>`;
            })}
        </div>
        `;
    }
});