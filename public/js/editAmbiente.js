$(document).ready(function () {
    $.ajaxSetup({
        headers: {
            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
        }
    });

    let URLindex = '/ambientes';
    let titulo = 'Ambiente';

    $('#form-ambiente').on('submit', function (e) {
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
                location.reload();
            },
            error: function (data) {
                console.log('Error:', data);

                if (data.responseJSON) {
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

    $('body').on("click", ".createNewRecord", function () {

        var button_value = $(this).data('value');
        var $select = $('#id_piso_bloque');
        $select.empty();

        $('#id_ambiente').val('');
        $('#form')[0].reset();

        $('#form-container .form-title').html("Crear nuevo " + titulo);
        $('#form-container').addClass('visible');

        // Obtener los datos de los pisos y bloques de manera dinámica
        $.get(`/pisos_bloques/${button_value}`, function (data) {
            $.each(data, function (index, item) {
                $select.append('<option value="' + item.id_piso_bloque + '">' + item.piso_bloque + '</option>');
            });
        });
    });

    $('body').on('click', '.editRecord', function () {
        var table_id = $(this).data('id');
        var button_value = $(this).data('value');
        var $select = $('#id_piso_bloque');
        $select.empty();

        $.get(URLindex + '/' + table_id + '/edit', function (data) {
            $('#form-title').html("Editar " + titulo);
            $('#form-container').removeClass('hidden').addClass('visible');
            $('#table_id').val(data.id);

            $.each(data, function (index, itemData) {
                var element = $('[name="' + index + '"]');
                if (element.is('select')) {
                    element.val(itemData).change();
                } else if (element.is('input[type="file"]')) {
                    var id_preview = '#preview-' + index;
                    if (itemData) {
                        $(id_preview).attr('src', '/images/' + itemData).show();
                    } else {
                        $(id_preview).hide();
                    }
                } else {
                    element.val(itemData);
                }
            });
        });

        $.get(`/pisos_bloques/${button_value}`, function (data) {
            $.each(data, function (index, item) {
                $select.append($('<option>', {
                    value: item.id_piso_bloque,
                    text: item.piso_bloque
                }));
            });
        });
    });

    $('input[type="file"]').on('change', function () {
        var input = this;
        var id_preview = '#preview-' + $(input).attr('name');

        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                $(id_preview).attr('src', e.target.result).show();
            }

            reader.readAsDataURL(input.files[0]);
        } else {
            $(id_preview).hide();
        }
    });

    $('#close-form-ambiente').click(function () {

        $('#form-container').addClass('hidden');
        $('#form-container').removeClass('visible');

        $('#form-container-piso').addClass('hidden');
        $('#form-container-piso').removeClass('visible');
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