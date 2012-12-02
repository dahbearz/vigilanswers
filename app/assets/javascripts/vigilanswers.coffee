$(document).ready ->
  $('button').button()
  mapOptions = {
    center: new google.maps.LatLng(-34.397, 150.644),
    zoom: 8,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  self.map = new google.maps.Map(document.getElementById("map-holder"), mapOptions);
  mapReady();
  $('#index-search-holder #search-submit').click(searchReports);

mapReady = () ->
  console.log('mapready');
  $('#report-list .report').each ->
    report = $(this)
    marker = new google.maps.Marker({
      position: new google.maps.LatLng(report.data('latitude'), report.data('longitude')),
      map: self.map,
      title:"Hello World!"
    });

searchReports = () ->
  center = self.map.getCenter()
  $.getJSON('/', data: { 
    title: $('#search').val(), 
    latitude: center.lat(),
    longitude: center.lng()
  })
