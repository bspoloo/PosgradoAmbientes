$(document).ready(function () {
    var isOpen = false;

    $('body').on('click', '.toggleButton', function () {
        var button_value = $(this).data('value');

        if (isOpen) {
            $('#ambientesContainer' + button_value).hide();
            $(this).find('img').attr('src', '/images/ojo.png').attr('alt', 'Abrir');
        } else {
            cargarAmbientes(button_value);
            $('#ambientesContainer' + button_value).show();
            $(this).find('img').attr('src', '/images/ojo2.png').attr('alt', 'Cerrar');
        }
        isOpen = !isOpen;
    });

    function cargarAmbientes(button_value) {
        $.ajax({
            url: `/ambientes/${button_value}`,
            type: 'GET',
            dataType: 'json',
            success: function (response) {
                $('#ambientesContainer' + button_value).empty();
                $.each(response, function (index, ambiente) {
                    $('#ambientesContainer' + button_value).append(getAmbiente(ambiente, button_value));
                });
            },
            error: function (xhr) {
                console.log('Error al cargar los ambientes:', xhr);
            }
        });
    }
    function getAmbiente(ambiente, button_value) {
        return `
        <div class="ambiente-container">
            <button type="button" class="ambiente editRecord btn btn-primary btn-sm" data-id="${ambiente.id_ambiente}" data-value='${button_value.split('_')[0]}_${button_value.split('_')[1]}'
                data-icono="${ambiente.icono}" data-nombre="${ambiente.nombre}">
                <i class="fa fa-edit"></i>
                <img src="/images/${ambiente.icono}" alt="${ambiente.nombre}" width="100px">
            <p>${ambiente.nombre}</p>
            </button>
            <div class="data-form">
                ${ambiente.piso_bloque}
            </div>
            <a href="javascript:void(0)" class="btn deleteRecord" data-id="${ambiente.id_ambiente}" ><i class="fa fa-trash"></i><img
            src="/images/borrar.png" width="30px" alt="delete {{ ${ambiente.nombre} }}"></a>
        </div>`;
    }
});