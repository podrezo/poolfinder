// Public browser key for google maps
const API_KEY = 'AIzaSyDJMLTmpU6Z-Pu8eXG6iK2c8APkoH_NIlA';

export class GoogleMaps {

  static lookUpPlaceViaCoordinates(coords) {
    return new Promise((resolve, reject) => {
      var myRequest = new Request(`https://maps.googleapis.com/maps/api/geocode/json?latlng=${coords.latitude},${coords.longitude}&key=${API_KEY}`);

      fetch(myRequest).then(function (response) {
        // TODO: Check status
        response.json().then(data => resolve(data.results));
      });
    });
  }
}