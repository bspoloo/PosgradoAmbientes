$('body').on('click', '.editRecord', function () {
    URLindex = 'ambientes';
    titulo = 'Ambientes'

    var table_id = $(this).data('id');
    $.get('/' + URLindex + '/' + table_id + '/edit', function (data) {
        $('#modelHeading').html("Editar " + titulo);
        $('#ajaxModel').modal('show');
        $('#table_id').val(data.id);

        $.each(data, function (index, itemData) {

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
});