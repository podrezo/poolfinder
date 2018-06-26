import { GoogleMapsApi } from './google-maps-api-loader';

export class GoogleMaps {
  constructor() {
    this.gmapApi = null;
  }

  load() {
    return new Promise((resolve, reject) => {
      this.gmapApi = new GoogleMapsApi();
      this.gmapApi.load().then(() => {
        resolve();
      });
    });
  }

  // var map = new google.maps.Map(document.querySelector('.map-container'));
  // var service = new google.maps.places.PlacesService(map);
  // service.getDetails({
  //   placeId: 'ChIJN1t_tDeuEmsRUsoyG83frY4'
  // }, function(place,status) {
  //   console.log(place);
  // });

  lookUpPlaceViaCoordinates(coords) {
    return new Promise((resolve, reject) => {
      const geocoder = new google.maps.Geocoder();
      geocoder.geocode({
        location: {
          lat: coords.latitude,
          lng: coords.longitude,
        }
      }, (results, status) => {
        // TODO: Reject if status is bad
        resolve(results);
      });
    });

  }
}