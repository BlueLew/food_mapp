// var places = <%== @places.map { |place| {lat: place.latitude, lng: place.longitude }}.to_json %>;
  
//   var map;

//   function initMap() {
//     map = new google.maps.Map(document.getElementById('map'), {
//       center: {lat: 34.8526, lng: -82.3940},
//       zoom: 10
//     });

//     places.forEach(function(place) {
//       var position = new google.maps.LatLng(place.lat, place.lng);
//       var marker = new google.maps.Marker({
//         position: position,
//         map: map
//       });
//     });
//   }

// var place = <%== {lat: @place.latitude, lng: @place.longitude }.to_json %>;
  
//   var map;

//   function initMap() {
//     map = new google.maps.Map(document.getElementById('show_map'), {
//       center: {lat: place.lat, lng: place.lng},
//       zoom: 20
//     });

//     var position = new google.maps.LatLng(place.lat, place.lng);
//     var marker = new google.maps.Marker({
//       position: position,
//       map: map
//     });
//   }
