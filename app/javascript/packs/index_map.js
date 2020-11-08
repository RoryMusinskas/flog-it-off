// Load the javascript map when page is loaded
document.addEventListener("turbolinks:load", function () {
  let map_el = document.getElementById("map");
  if (map_el) {
    initializeMap(map_el, document.getElementsByClassName("collection"));
  }
});

const mapboxgl = require("mapbox-gl");
// initialize the map and set controls and markers
function initializeMap() {
  // Mapbox token
  mapboxgl.accessToken =
    "pk.eyJ1IjoibXV6ejAwa2EiLCJhIjoiY2thajJ2bmhuMDg4eDJybzVicWNidWh2dSJ9.z95l72KviRI3hRPOGcOAXw";

  var geojson = gon.geocollection;

  // adding a unique id for each collection for the side bar
  geojson.features.forEach(function (collection, i) {
    collection.properties.id = i;
  });

  // Initialize the map with center
  const map = new mapboxgl.Map({
    container: "map",
    style: "mapbox://styles/mapbox/streets-v11",
  });
  map.on("load", function () {
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
  addFilterToMap(map);
}

function addFilterToMap(map) {
  // array for visible points on map
  var collectionPoints = [];

  // Create a popup, but don't add it to the map yet.
  var popup = new mapboxgl.Popup({
    closeButton: false,
  });

  var filterEl = document.getElementById("feature-filter");
  var listingEl = document.getElementById("feature-listing");

  // Renders the collection to the filter sidebar
  function renderCollections(features) {
    var empty = document.createElement("p");
    // Clear any existing listings
    listingEl.innerHTML = "";
    if (features.length) {
      features.forEach(function (feature) {
        var prop = feature.properties;
        var item = document.createElement("a");
        item.textContent = prop.name_id + " (" + prop.description + ")";
        item.addEventListener("mouseover", function () {
          // Highlight corresponding feature on the map
          popup
            .setLngLat(feature.geometry.coordinates)
            .setText(prop.name_id + " (" + prop.description + ")")
            .addTo(map);
        });
        // Go to the collection on click of the filter bar
        item.addEventListener("click", function () {
          window.location.replace(`collections/${prop.collection_id}`);
        });
        // add each visible item to the filter bar on the left side of screen
        listingEl.appendChild(item);
      });

      // Show the filter input
      filterEl.parentNode.style.display = "block";
    } else if (features.length === 0 && filterEl.value !== "") {
      empty.textContent = "No results found";
      listingEl.appendChild(empty);
    } else {
      empty.textContent = "Drag the map to populate results";
      listingEl.appendChild(empty);

      // Hide the filter input
      filterEl.parentNode.style.display = "none";

      // remove features filter
      // Only load this function after the map is loaded
      map.on("load", function () {
        map.setFilter("collections", ["has", "name_id"]);
      });
    }
  }

  // Helper function, trim whitespace and make all lowercase
  function normalize(string) {
    return string.trim().toLowerCase();
  }

  // Return the unqiue features of a passed in array
  function getUniqueFeatures(array, comparatorProperty) {
    var existingFeatureKeys = {};
    var uniqueFeatures = array.filter(function (el) {
      if (existingFeatureKeys[el.properties[comparatorProperty]]) {
        return false;
      } else {
        existingFeatureKeys[el.properties[comparatorProperty]] = true;
        return true;
      }
    });

    return uniqueFeatures;
  }

  // Each time the map renders, call the function, this is so the function doesnt call before the layer is loaded
  map.on("render", afterChangeComplete);

  function afterChangeComplete() {
    if (!map.loaded()) {
      return;
    } // still not loaded; bail out.
    map.on("moveend", function () {
      var features = map.queryRenderedFeatures({ layers: ["collections"] });

      if (features) {
        var uniqueFeatures = getUniqueFeatures(features, "description");
        // Populate features for the listing overlay.
        renderCollections(uniqueFeatures);

        // Clear the input container
        filterEl.value = "";

        // Store the current features in sn `airports` variable to
        // later use for filtering on `keyup`.
        collectionPoints = uniqueFeatures;
      }
    });
    map.off("render", afterChangeComplete); // remove this handler now that we're done.
  }

  map.on("mousemove", "collections", function (e) {
    // Change the cursor style as a UI indicator.
    map.getCanvas().style.cursor = "pointer";

    // Populate the popup and set its coordinates based on the feature.
    var feature = e.features[0];
    popup
      .setLngLat(feature.geometry.coordinates)
      .setText(
        feature.properties.name_id + " (" + feature.properties.description + ")"
      )
      .addTo(map);
  });

  map.on("mouseleave", "collections", function () {
    map.getCanvas().style.cursor = "";
    popup.remove();
  });

  // The function for the filtering of the features on the map
  filterEl.addEventListener("keyup", function (e) {
    var value = normalize(e.target.value);

    // Filter visible features that don't match the input value.
    var filtered = collectionPoints.filter(function (feature) {
      var name = normalize(feature.properties.name_id);
      var description = normalize(feature.properties.description);
      return name.indexOf(value) > -1 || description.indexOf(value) > -1;
    });

    // Populate the sidebar with filtered results
    renderCollections(filtered);

    // Set the filter to populate features into the layer.
    if (filtered.length) {
      map.setFilter("collections", [
        "match",
        ["get", "description"],
        filtered.map(function (feature) {
          return feature.properties.description;
        }),
        true,
        false,
      ]);
    }
  });

  // passing an empty array to render an empty state
  map.on("load", function () {
    renderCollections([]);
  });

  // When a click event occurs on a feature in the places layer, open a popup at the
  // location of the feature, with description HTML from its properties.
  //map.on("click", "collections", function (e) {
  //  var coordinates = e.features[0].geometry.coordinates.slice();
  //  var description = e.features[0].properties.description;
  //  // console.log(description);

  //  //find the collections id of the clicked marker
  //  var clicked_collection_id = e.features[0].properties.collection_id;
  //  var collections = gon.collections;

  //  var found_collection = collections.find(
  //    (x) => x.id === clicked_collection_id
  //  );

  //  // console.log(found_collection);

  //  // Ensure that if the map is zoomed out such that multiple
  //  // copies of the feature are visible, the popup appears
  //  // over the copy being pointed to.
  //  while (Math.abs(e.lngLat.lng - coordinates[0]) > 180) {
  //    coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360;
  //  }

  //  new mapboxgl.Popup()
  //    .setLngLat(coordinates)
  //    .setHTML(
  //      "<h3>" +
  //        "Seller name: " +
  //        "</h3><p>" +
  //        found_collection.seller_id +
  //        "</p>" +
  //        "<h3>" +
  //        "Description: " +
  //        "</h3><p>" +
  //        found_collection.description +
  //        "</p>" +
  //        "<h3>" +
  //        "<button class='show-button' id=" +
  //        found_collection.id +
  //        ">" +
  //        "Show</button>"
  //    )
  //    .addTo(map);
  //});

  //document.querySelector("#map").addEventListener("click", function (e) {
  //  console.log(e);
  //  if (e.target.classList[0] == "show-button") {
  //    window.location.replace(`collections/${e.target.id}`);
  //  }
  //});

  // add the map controls
  addControlsToMap(mapboxgl, map);

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
}
