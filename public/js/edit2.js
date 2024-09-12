URLindex = '/pisos';
titulo = 'Piso'

$('#form2').on('submit', function (e) {
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