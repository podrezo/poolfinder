

export class GoogleMaps {
  constructor() {
    // Public browser key for google maps
    this.apiKey = 'AIzaSyDJMLTmpU6Z-Pu8eXG6iK2c8APkoH_NIlA';
  }

  lookUpPlaceViaCoordinates(coords) {
    return new Promise((resolve, reject) => {
      var myRequest = new Request(`https://maps.googleapis.com/maps/api/geocode/json?latlng=${coords.latitude},${coords.longitude}&key=${this.apiKey}`);

      fetch(myRequest).then(function (response) {
        // TODO: Check status
        response.json().then(data => resolve(data.results));
      });
    });
  }
}