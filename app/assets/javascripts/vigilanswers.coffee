$(document).ready ->
  mapOptions = {
    center: new google.maps.LatLng(-34.397, 150.644),
    zoom: 8,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  self.map = new google.maps.Map(document.getElementById("map-holder"), mapOptions);
  mapReady();

mapReady = () ->
  console.log('mapready');
  marker = new google.maps.Marker({
    position: new google.maps.LatLng(-34.397, 150.644),
    map: self.map,
    title:"Hello World!"
  });
