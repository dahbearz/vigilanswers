jQuery.noConflict
jQuery(document).ready ->
  jQuery('button').button()
  jQuery('#index-search-holder #search-submit').click(searchReports);
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
  jQuery('#report-list .report').each ->
    report = jQuery(this)
    marker = new google.maps.Marker({
      position: new google.maps.LatLng(report.data('latitude'), report.data('longitude')),
      map: self.map,
      title:"Hello World!"
    });

searchReports = () ->
  center = self.map.getCenter()
  $.getJSON('/', { 
    title: jQuery('#search').val(), 
    latitude: center.lat(),
    longitude: center.lng()
  })
