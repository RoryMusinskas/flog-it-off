document.addEventListener("turbolinks:load", function () {
  let map_el = document.getElementById("map");
  if (map_el) {
    initializeMap(map_el, document.getElementsByClassName("collection"));
  } else {
    // alert("Error can't initialize map");
  }
});

function initializeMap() {
  const mapboxgl = require("mapbox-gl");

  // Mapbox token
  mapboxgl.accessToken =
    "pk.eyJ1IjoibXV6ejAwa2EiLCJhIjoiY2thajJ2bmhuMDg4eDJybzVicWNidWh2dSJ9.z95l72KviRI3hRPOGcOAXw";

  // Initialize the map with center
  const map = new mapboxgl.Map({
    container: "map",
    center: gon.coordinates,
    style: "mapbox://styles/mapbox/streets-v11",
  });

  // get the current location of the user and set their coords
  // navigator.geolocation.getCurrentPosition((position) => {});

  addControlsToMap(mapboxgl, map);
  generateMarker(mapboxgl, map);
  map.flyTo({
    center: gon.coordinates,
    zoom: 8,
  });
}
// add map controls onto map
function addControlsToMap(mapboxgl, map) {
  // zoom in and out controls
  map.addControl(new mapboxgl.NavigationControl());

  // set the params for the button to get users location
  const geolocate = new mapboxgl.GeolocateControl({
    positionOptions: {
      enableHighAccuracy: true,
    },
    trackUserLocation: true,
  });
  // add the button onto the map
  map.addControl(geolocate);
}

// generate the marker with the coordinates the user entered on create
function generateMarker(mapboxgl, map) {
  marker = new mapboxgl.Marker({ draggable: true })
    .setLngLat(gon.coordinates)
    .addTo(map)
    .on("dragend", function (e) {
      let lngLat = marker.getLngLat();
      let lat = lngLat.lat;
      let lng = lngLat.lng;
      addElementsToForm(lng, lat);
    });
}

// Get the lat and long from the drag end event and add them to thier respective form elements
function addElementsToForm(lng, lat) {
  document.getElementById("collection_longitude").value = lng;
  document.getElementById("collection_latitude").value = lat;
}
