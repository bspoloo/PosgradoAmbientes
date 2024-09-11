/*
    Custom CRUD
*/

(function () {

    'use strict';

    /*------------------------------------------
            --------------------------------------------
            Pass Header Token
            --------------------------------------------
       --------------------------------------------*/
    $.ajaxSetup({
        headers: {
            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
        }
    });

    /*------------------------------------------
        --------------------------------------------
        Render DataTable
        --------------------------------------------
        --------------------------------------------*/
    var table = $('.data-table').DataTable({
        processing: true,
        serverSide: true,
        ajax: URLindex,
        columns: columnas
    });

    var titulo = 'edit';
    URLindex = 'edificios';

    /*------------------------------------------
        --------------------------------------------
        Create or Update Record Table Code
        --------------------------------------------
        --------------------------------------------*/
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

                $('#form').trigger("reset");
                $('#ajaxModel').modal('hide');
                $('body, html').removeClass('modal-open');
                $('.modal-backdrop').remove(); //Elimina el backroll al momento de guardar
                $('html').css('overflow', 'auto');
                table.draw();
            },
            error: function (data) {
                console.log('Error:', data);
                alert('Hay un campo incompleto');

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


    /*------------------------------------------
        --------------------------------------------
        Click to Button
        --------------------------------------------
    --------------------------------------------*/

    $('#createNewRecord').on("click", function () {

        // console.log('furula el create');
        $('#table_id').val('');
        $('#form').trigger("reset");
        $('#form')[0].reset()
        $('#modelHeading').html("Crear nueva " + titulo);
        $('#ajaxModel').modal('show');
    });

    /*------------------------------------------
        --------------------------------------------
        Click to Edit Button
        --------------------------------------------
    --------------------------------------------*/
    $('body').on('click', '.editRecord', function () {// seleccionamos el boton con AJAX, donde el $ es una abreviacion del ajax

        var table_id = $(this).data('id'); //id de del boton edit en data-id = $row->id_universidad

        $.get(URLindex + '/' + table_id + '/edit', function (data) {
            $('#modelHeading').html("Editar " + titulo);
            $('#ajaxModel').modal('show');
            $('#table_id').val(data.id);

            $.each(data, function (index, itemData) {
                // console.log(index +' => ' +itemData);

                var element = $('[name="' + index + '"]');
                if (element.is('select')) {
                    element.val(itemData).change();
                } else if (element.is('input[type="file"]')) {
                    // No hacemos nada con los campos de archivo
                } else {
                    element.val(itemData);
                }
            });
        });

        console.log('furula edit');
        
    });

    /*------------------------------------------
        --------------------------------------------
        Delete Record Table Code
        --------------------------------------------
        --------------------------------------------*/
    $('body').on('click', '.deleteRecord', function () {

        var table_id = $(this).data("id");
        let sino = confirm("Confirma borrar el registro?");

        if (sino) {
            $.ajax({
                type: "DELETE",
                url: URLindex + '/' + table_id,
                success: function (data) {
                    table.draw();
                },
                error: function (data) {
                    confirm('Error al eliminar el elemento con id: ' + table_id + ' Esto debido a que es usada en otra tabla');
                    console.log('Error:', data);
                }
            });
        }
    });

})();