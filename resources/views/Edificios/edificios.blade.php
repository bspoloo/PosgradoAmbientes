@extends('layouts.layout')
@section('title', 'Edificios')

@section('content')

    <body>

        <div>
            <h1>The map of all building:</h1>
            <p>welcome to the dashboard user</p>
        </div>

        <div id="map" style="height: 500px;"></div>

        <script>
            var locations = @json($edificios);
            console.log(locations);

            var map = L.map('map').setView([locations[0].latitud, locations[0].longitud], 20);

            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 18,
                attribution: '© OpenStreetMap contributors'
            }).addTo(map);

            var locations = @json($edificios);


            locations.forEach(function(location) {
                console.log(location.poligono);
                var customIcon = L.icon({
                    iconUrl: `/images/${location.imagen}`,
                    iconSize: [100, 100],
                    iconAnchor: [50, 50],
                    popupAnchor: [-3, -38],
                });

                var marker = L.marker([location.latitud, location.longitud], {
                        icon: customIcon
                    }).addTo(map)
                    .bindPopup(location.nombre)
                marker.on('click', function() {
                    window.location.href = `/edificios/${location.id_edificio}`;
                });

                if (location.poligono) {
                    var coordsString = location.poligono;
                    var coordPairs = coordsString.split(',');
                    var polygonCoords = [];
                    for (var i = 0; i < coordPairs.length; i += 2) {
                        polygonCoords.push([parseFloat(coordPairs[i]), parseFloat(coordPairs[i + 1])]);
                    }
                    var polygon = L.polygon(polygonCoords, {
                        color: 'red',
                        fillColor: '#f03',
                        fillOpacity: 0.3
                    }).addTo(map);
                }
            });
        </script>
    </body>
@endsection
