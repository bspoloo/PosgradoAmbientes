let isEditingPoligon = false;
var marcador;
var newPoligon = [];
var editPoligonIcon = document.getElementById('editPoligonoIcon');
var poligonoDibujo = null;
var marcadors = [];

document.getElementById('editPoligono').addEventListener('click', function() {
    isEditingPoligon = !isEditingPoligon;

    if (isEditingPoligon) {
        editPoligonIcon.src = '/images/poligono-cerrado.png';
        this.classList.add('active');
        map.on('click', onMapClickPoligono);
    } else {
        editPoligonIcon.src = '/images/poligono-abierto.png';
        this.classList.remove('active');
        map.off('click', onMapClickPoligono);
        if (poligonoDibujo) {
            map.removeLayer(poligonoDibujo);
            poligonoDibujo = null;
        }
        for (let i = 0; i < marcadors.length; i++) {
            map.removeLayer(marcadors[i]);
        }
        marcadors = [];
        newPoligon = [];
    }
});

function onMapClickPoligono(e) {

    marcador = L.marker(e.latlng).addTo(map);
    marcadors.push(marcador);
    newPoligon.push(e.latlng);

    drawPoligon(newPoligon);
}

function drawPoligon(coordinates) {
    if (poligonoDibujo) {
        map.removeLayer(poligonoDibujo);
    }

    poligonoDibujo = L.polygon(coordinates, {
        color: 'green',
        fillOpacity: 0.4
    }).addTo(map);
}
