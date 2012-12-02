$(document).ready ->
  $('button').button()
  $('#index-search-holder #search-submit').click(searchReports);
  navigator.geolocation.getCurrentPosition(browserGeolocationCallback)

browserGeolocationCallback = (position) ->
  console.log "position:"
  console.log position
  mapOptions = {
    center: new google.maps.LatLng(
      position.coords.latitude, position.coords.longitude
    ),
    zoom: 12,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  self.map = new google.maps.Map(document.getElementById("map-holder"), mapOptions);
  mapReady();


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
  $.getJSON('/', {
    title: $('#search').val(),
    latitude: center.lat(),
    longitude: center.lng()
  })

updateScore = () ->
  $.ajax '/'
    type: 'PUT'
    data: {report: {score: 1} }
    dataType: 'text/json'
    success: (data, textStatus, jqXHR) ->
      $('body').append "Successful AJAX call: #{data}"
