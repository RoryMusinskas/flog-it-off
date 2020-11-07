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
    style: "mapbox://styles/mapbox/streets-v11",
  });

  // get the current location of the user and set their coords
  navigator.geolocation.getCurrentPosition((position) => {});

  addControlsToMap(mapboxgl, map);
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

  // locate the user
  locateUser(map, geolocate);
}

// locate the user on map load
function locateUser(map, geolocate) {
  // set a count variable for how many times the user has pressed the geolocate button
  let count = 0;

  // on map load, run the geoloction and get users position
  map.on("load", function () {
    geolocate.trigger();
  });

  geolocate.on("geolocate", function () {
    // Get the location of the user
    let userlocation = geolocate._lastKnownPosition;

    // Set the lng and lat from the user location
    let lng = userlocation.coords.longitude;
    let lat = userlocation.coords.latitude;

    addElementsToForm(lng, lat);
    addMarkerToMap(map, lng, lat, count);
    count++;
  });
}

// add the marker onto the map
function addMarkerToMap(map, lng, lat, count) {
  const mapboxgl = require("mapbox-gl");
  // set a marker at the users location, if it's the first time they have located, then if they drag and move it, update the form field
  if (count == 0) {
    generateMarker(mapboxgl, map, lng, lat);
    // remove the marker and add a new one if user geolocates again. This is for if they start away from their actual location
  } else {
    marker.remove();
    generateMarker(mapboxgl, map, lng, lat);
  }
}

// generate a single marker
function generateMarker(mapboxgl, map, lng, lat) {
  marker = new mapboxgl.Marker({ draggable: true })
    .setLngLat([lng, lat])
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
