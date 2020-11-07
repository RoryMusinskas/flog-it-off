// Load the javascript map when page is loaded
document.addEventListener("turbolinks:load", function () {
  let map_el = document.getElementById("map");
  if (map_el) {
    initializeMap(map_el, document.getElementsByClassName("collection"));
  }
});

// initialize the map and set controls and markers
function initializeMap() {
  const mapboxgl = require("mapbox-gl");
  // Mapbox token
  mapboxgl.accessToken =
    "pk.eyJ1IjoibXV6ejAwa2EiLCJhIjoiY2thajJ2bmhuMDg4eDJybzVicWNidWh2dSJ9.z95l72KviRI3hRPOGcOAXw";

  var geojson = gon.geocollection;

  // Initialize the map with center
  const map = new mapboxgl.Map({
    container: "map",
    style: "mapbox://styles/mapbox/streets-v11",
  });

  map.on("load", function () {
    // console.log(gon.geocollection);
    // Add an image to use as a custom marker
    map.loadImage(
      "https://docs.mapbox.com/mapbox-gl-js/assets/custom_marker.png",
      function (error, image) {
        if (error) throw error;
        map.addImage("custom-marker", image);
        map.addSource("collections", {
          type: "geojson",
          data: geojson,
          cluster: true,
          clusterMaxZoom: 14,
          clusterRadius: 50,
        });
        map.addLayer({
          id: "collections",
          type: "symbol",
          source: "collections",
          layout: {
            "icon-image": "custom-marker",
            "text-field": ["get", "seller_id"],
            "text-font": ["Open Sans Semibold", "Arial Unicode MS Bold"],
            "text-offset": [0, 1.25],
            "text-anchor": "top",
          },
        });
      }
    );
  });
  // When a click event occurs on a feature in the places layer, open a popup at the
  // location of the feature, with description HTML from its properties.
  map.on("click", "collections", function (e) {
    var coordinates = e.features[0].geometry.coordinates.slice();
    var description = e.features[0].properties.description;
    // console.log(description);

    //find the collections id of the clicked marker
    var clicked_collection_id = e.features[0].properties.collection_id;
    var collections = gon.collections;

    var found_collection = collections.find(
      (x) => x.id === clicked_collection_id
    );

    // console.log(found_collection);

    // Ensure that if the map is zoomed out such that multiple
    // copies of the feature are visible, the popup appears
    // over the copy being pointed to.
    while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
      coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
    }

    new mapboxgl.Popup()
      .setLngLat(coordinates)
      .setHTML(
        "<h3>" +
          "Seller name: " +
          "</h3><p>" +
          found_collection.seller_id +
          "</p>" +
          "<h3>" +
          "Description: " +
          "</h3><p>" +
          found_collection.description +
          "</p>" +
          "<h3>" +
          "<button class='show-button' id=" +
          found_collection.id +
          ">" +
          "Show</button>"
      )
      .addTo(map);
  });
  // Change the cursor to a pointer when the mouse is over the places layer.
  map.on("mouseenter", "collections", function () {
    map.getCanvas().style.cursor = "pointer";
  });
  // Change it back to a pointer when it leaves.
  map.on("mouseleave", "collections", function () {
    map.getCanvas().style.cursor = "";
  });

  document.querySelector("#map").addEventListener("click", function (e) {
    console.log(e);
    if (e.target.classList[0] == "show-button") {
      window.location.replace(`collections/${e.target.id}`);
    }
  });
  // add the map controls
  addControlsToMap(mapboxgl, map);
}

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

  function locateUser(map, geolocate) {
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
    });
  }
}
