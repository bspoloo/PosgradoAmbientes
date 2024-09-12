

/*------------------------------------------
   Pass Header Token
--------------------------------------------*/

$(document).ready(function () {
    $.ajaxSetup({
        headers: {
            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
        }
    });

    let URLindex = '/ambientes';
    let titulo = 'Ambientes';

    $('#form').on('submit', function (e) {
        e.preventDefault();

        var formData = new FormData(this);

        $.ajax({
            data: formData,
            url: URLindex,
            type: "POST",
            dataType: 'json',
            contentType: false,
            processData: false,
            success: function (data) {
                $('#form')[0].reset();
                $('#ajaxModel').modal('hide');
                location.reload();  // Recargar la página para reflejar cambios
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

    $('#createNewRecord').on("click", function () {
        $('#table_id').val('');
        $('#form')[0].reset();
        $('#modelHeading').html("Crear nueva " + titulo);
        $('#ajaxModel').modal('show');
    });

    $('body').on('click', '.editRecord', function () {
        var table_id = $(this).data('id');

        $.get(URLindex + '/' + table_id + '/edit', function (data) {
            $('#modelHeading').html("Editar " + titulo);
            $('#ajaxModel').modal('show');
            $('#table_id').val(data.id);

            $.each(data, function (index, itemData) {
                var element = $('[name="' + index + '"]');

                if (element.is('select')) {
                    element.val(itemData).change();
                } else if (element.is('input[type="file"]')) {
                    var id_preview = '#preview-' + index;
                    $(id_preview).attr('src', '/images/' + itemData);
                } else {
                    element.val(itemData);
                }
            });
        });
    });

    $('body').on('click', '.deleteRecord', function () {
        var table_id = $(this).data("id");
        let sino = confirm("Confirma borrar el ambiente?");

        if (sino) {
            $.ajax({
                type: "DELETE",
                url: URLindex + '/' + table_id,
                success: function (data) {
                    location.reload();  // Recargar la página después de eliminar
                },
                error: function (data) {
                    alert('Error al eliminar: ' + data.responseText);
                    console.log('Error:', data);
                }
            });
        }
    });
})