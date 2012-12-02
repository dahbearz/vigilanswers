jQuery.noConflict
markers = []
jQuery(document).ready ->
  jQuery('button').button()
  jQuery('#index-search-holder #search-submit').click(searchReports)
  jQuery('#index-search-holder #refresh-results').click(refreshReports)
  jQuery('#index-search-holder #recenter-map').click(recenterMap)
  map_holder = jQuery('#map-holder')
  navigator.geolocation.getCurrentPosition(repositionMap)
  console.log(jQuery('.upvote')[0])

  mapOptions = {
    center: new google.maps.LatLng(
      map_holder.data('latitude'),
      map_holder.data('longitude')
    ),
    zoom: 12,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  self.map = new google.maps.Map(document.getElementById("map-holder"), mapOptions)
  self.geocoder = new google.maps.Geocoder()
  navigator.geolocation.getCurrentPosition(repositionMap)
  mapReady()

repositionMap = (position) ->
  self.map.setCenter(
    new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
  )

mapReady = () ->
  jQuery.each initial_list_items, ->
    addReport this

addReport = (report) ->
  addMarker report
  jQuery('#report-list').append(ich.report_list_item(report))

addMarker = (report) ->
  marker = new google.maps.Marker({
    position: new google.maps.LatLng(report.latitude, report.longitude),
    map: self.map,
    title:"Hello World!"
  })
  markers.push marker

clearMarkers = () ->
  marker.setMap(null) for marker in markers

searchReports = () ->
  center = self.map.getCenter()
  jQuery.getJSON '/', { 
    title: jQuery('#search').val(), 
    latitude: center.lat(),
    zoom: self.map.getZoom(),
    longitude: center.lng()
  }, updateList

updateScore = () ->
  id = jQuery(this).closest('li').data('id')
  jQuery.post('/reports/'+id+'/increment_count')

refreshReports = () ->
  center = self.map.getCenter()
  jQuery.getJSON '/', { 
    latitude: center.lat(),
    zoom: self.map.getZoom(),
    longitude: center.lng()
  }, updateList

recenterMap = () ->
  address_val = jQuery('#recenter').val()
  self.geocoder.geocode {address: address_val}, (resp) ->
    console.log resp
    loc = resp[0].geometry.location
    repositionMap({coords: {latitude: loc.lat(), longitude: loc.lng()}})
    refreshReports()

updateList = (list_items) ->
  jQuery('#report-list').html('')
  clearMarkers()
  jQuery.each list_items, ->
    addReport this
