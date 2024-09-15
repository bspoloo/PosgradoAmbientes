URLindex2 = '/pisos';

$('#form2').on('submit', function (e) {
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
            $('#form').trigger("reset");
            $('#ajaxModel').modal('hide');

            // table.draw();
            location.reload();
        },
        error: function (data) {
            console.log('Error:', data);

            if (data.responseJSON) {
                // Limpiar los errores anteriores
                $('#form input, #form select').removeClass('is-invalid');
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
    $('#form')[0].reset();

    $('#form-container-piso .form-title-piso').html("Crear nuevo Piso");
    $('#form-container-piso').addClass('visible');
});

$('body').on('click', '.deletePiso', function () {

    console.log('fural');
    var table_id = $(this).data("id");
    let sino = confirm("Confirma borrar el Piso?");

    if (sino) {
        $.ajax({
            type: "DELETE",
            url: '/pisos/' + table_id,
            success: function (data) {
                location.reload();
            },
            error: function (data) {
                alert('Error al eliminar: ' + data.responseText);
                console.log('Error:', data);
            }
        });
    }
});

$('#close-form2').click(function() {
    $('#form-container-piso').addClass('hidden');
    $('#form-container-piso').removeClass('visible');
});