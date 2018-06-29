// Public browser key for google maps
const API_KEY = 'AIzaSyDJMLTmpU6Z-Pu8eXG6iK2c8APkoH_NIlA';

export class GoogleMaps {

  static lookUpPlaceViaCoordinates(coords) {
    return new Promise((resolve, reject) => {
      var geocodingRequest = new Request(`https://maps.googleapis.com/maps/api/geocode/json?latlng=${coords.latitude},${coords.longitude}&key=${API_KEY}`);

      fetch(geocodingRequest).then(function (response) {
        // TODO: Check status
        response.json().then(data => resolve(data.results));
      });
    });
  }

  static lookUpPlaceViaAddress(address) {
    return new Promise((resolve, reject) => {
      // TODO: Google allows us to set bounds for suggested area to search; we should do that
      // https://developers.google.com/maps/documentation/javascript/geocoding#GeocodingRequests
      var geocodingRequest = new Request(`https://maps.googleapis.com/maps/api/geocode/json?address=${address}&key=${API_KEY}`);

      fetch(geocodingRequest).then(function (response) {
        // TODO: Check status
        response.json().then(data => {
          if(data.results.length == 0) {
            reject();
            return;
          }
          resolve({
            address: data.results[0]['formatted_address'],
            latitude: data.results[0].geometry.location.lat,
            longitude: data.results[0].geometry.location.lng,
          });
        });
      });
    });
  }
}