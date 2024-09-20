URLindex2 = '/pisos';
updateEdificioPiso();

$('#form-piso').on('submit', function (e) {
    e.preventDefault();

    var formData = new FormData(this);

    $.ajax({
        data: formData,
        url: URLindex2,
        type: "POST",
        dataType: 'json',
        contentType: false,
        processData: false,
        success: function (data) {
            $('#form-piso').trigger("reset");
            $('#form-container-piso').addClass('hidden');
            $('#form-container-piso').removeClass('visible');
            $('#form-piso')[0].reset();
            updateEdificioPiso();

        },
        error: function (data) {
            console.log('Error:', data);
            if (data.responseJSON) {
                // Limpiar los errores anteriores
                $('#form-piso input, #form-piso select').removeClass('is-invalid');
                $('.invalid-feedback').remove();

                var errors = data.responseJSON.errors;
                console.log(errors);

                $.each(errors, function (field, messages) {
                    var input = $('[name="' + field + '"]');
                    input.addClass('is-invalid');
                    input.after('<div class="invalid-feedback">' + messages[0] + '</div>');
                });
            }
        }
    });
});

$('body').on("click", ".createNewPiso", function () {
    var $select = $('#id_piso_bloque');
    $select.empty();

    $('#id_ambiente').val('');
    $('#form-piso')[0].reset();

    $('#form-container-piso .form-title-piso').html("Crear nuevo Piso");
    $('#form-container-piso').addClass('visible');
});

$('#close-form-piso').click(function () {
    $('#form-container-piso').addClass('hidden');
    $('#form-container-piso').removeClass('visible');
});

function updateEdificioPiso() {
    let edificio_ambiente = document.getElementById('edificio-ambientes');

    $.ajax({
        url: `/EdificiosPisos/${edificio.id_edificio}`,
        type: 'GET',
        dataType: 'json',
        success: function (response) {
            var newEdificio = '';
            $.each(response, function (index, piso) {
                newEdificio += `<div class="piso">
                ${piso.nombre} ${piso.numero}
                    <div class="actions">
                        <button type="button" class="btn btn-primary btn-sm createNewRecord" data-value="${edificio.id_edificio}_${piso.id_piso}">
                            <i class="fa fa-create"></i> +
                        </button>
                        <button id="toggleButton" class="toggleButton" data-value="${edificio.id_edificio}_${piso.id_piso}">
                            <img src="/images/ojo.png" alt="open-piso" width="20px">
                        </button>
                        <button id="deletePiso" data-value="${piso.id_piso}" class="deletePiso" data-id="${piso.id_piso}" >
                            <img src="/images/borrar.png" alt="open-piso" width="20px">
                        </button>
                    </div>
                </div>`;
            });
            edificio_ambiente.innerHTML = newEdificio;
        },
        error: function (xhr) {
            console.log('Error al cargar los edificios:', xhr);
        }
    });
}
$('body').on('click', '.deletePiso', function () {

    var table_id = $(this).data("id");
    console.log(table_id);

    let sino = confirm("Confirma borrar el Piso?");

    if (sino) {
        $.ajax({
            type: "DELETE",
            url: '/pisos/' + table_id,
            success: function (data) {
                updateEdificioPiso();
            },
            error: function (data) {
                alert('Error al eliminar: Primero debe borrar todos los ambientes para borrar el Piso');
                console.log('Error:', data);
            }
        });
    }
});

