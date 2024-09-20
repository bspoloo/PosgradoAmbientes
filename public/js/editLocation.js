let isEditingLocation = false;
var editLocationIcon = document.getElementById('editLocationIcon');
var newLocation = {};

document.getElementById('editLocation').addEventListener('click', function () {

    isEditingLocation = !isEditingLocation;

    if (isEditingLocation) {
        editLocationIcon.src = '/images/lapiz-cerrado.png';
        this.classList.add('active');
        map.on('click', onMapClickLocation);
    } else {
        editLocationIcon.src = '/images/lapiz-abierto.png';
        this.classList.remove('active');
        map.off('click', onMapClickLocation);
    }
});

function onMapClickLocation(e) {
    if (isEditingLocation) {
        let lat = e.latlng.lat;
        let lng = e.latlng.lng;

        marker.setLatLng([lat, lng]);
        map.setView([lat, lng], map.getZoom());

        newLocation.id_edificio = edificio.id_edificio;
        newLocation.latitud = lat;
        newLocation.longitud = lng;
        newLocation.poligono = edificio.poligono;
    }
}

$('body').on('click', '.editDataEdificio', function (e) {

    if (!newLocation.latitud || !newLocation.longitud) {
        newLocation = {
            id_edificio: edificio.id_edificio,
            latitud: edificio.latitud,
            longitud: edificio.longitud,
        }
    }
    if (newPoligon == 0) {
        newLocation.poligono = edificio.poligono;
    } else {
        newLocation.poligono = newPoligon;
    }

    $.ajax({
        url: '/edificios',
        type: 'POST',
        dataType: 'json',
        contentType: 'application/json',
        data: JSON.stringify({
            id_edificio: newLocation.id_edificio,
            latitud: newLocation.latitud,
            longitud: newLocation.longitud,
            poligono: newLocation.poligono,
        }),
        success: function (data) {
            $.ajax({
                url: `/edificios/${edificio.id_edificio}/get`,
                type: 'GET',
                dataType: 'json',
                success: function (response) {
                    edificio = response.edificio;
                    loadMap(edificio);
                },
                error: function (xhr) {
                    console.log('Error al cargar los edificio:', xhr);
                }
            });
        },
        error: function (data) {
            console.log('Error:', data);
        }
    });
});