$(document).ready(function () {
    var isOpen = false;

    $('body').on('click', '.toggleButton', function () {
        var button_value = $(this).data('value');

        if (isOpen) {
            $('#ambienteContainer').hide();
            $(this).find('img').attr('src', '/images/ojo.png').attr('alt', 'Abrir');
        } else {
            cargarAmbientes(button_value);
            $('#ambienteContainer').show();
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
                $('#ambienteContainer').empty();
                
                $.each(response, function (index, ambiente) {
                    $('#ambienteContainer').append(getAmbiente(ambiente, button_value));
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
            <button type="button" class="ambiente editRecord" data-id="${ambiente.id_ambiente}" data-value='${button_value.split('')[0]}_${button_value.split('_')[1]}'
                data-icono="${ambiente.icono}" data-nombre="${ambiente.nombre}">
                <i class="fa fa-edit"></i>
                <img src="/images/${ambiente.icono}" alt="${ambiente.nombre}" width="100px">
            <p>${ambiente.nombre}</p>
            </button>
            <div class="data-form">
                ${ambiente.piso_bloque}
            </div>
            <a href="javascript:void(0)" class="btn deleteRecord" data-id="${ambiente.id_ambiente}" data-value='${button_value.split('')[0]}_${button_value.split('_')[1]}'><i class="fa fa-trash"></i><img
            src="/images/borrar.png" width="30px" alt="delete {{ ${ambiente.nombre} }}"></a>
        </div>`;
    }
});