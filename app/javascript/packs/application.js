// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// ***** START: ADDED BY KisoThemes *****
window.$ = window.jQuery = require("jquery");
// ***** END: ADDED BY KisoThemes *****

require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");
// ***** START: ADDED BY KisoThemes *****
require("bootstrap");
require("jquery-slimscroll");
require("bootstrap-switch");
require("jquery-countdown");
require("jquery-countto");
require("fastclick");
require("object-fit-images");
require("jasny-bootstrap");
require("jquery-parallax.js");
require("code-prettify");
require("prismjs");
// ***** END: ADDED BY KisoThemes *****

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

require("kiso_themes");
