export const GEOLOCATION_ERRORS = {
  'errors.location.unsupportedBrowser': 'Browser does not support location services',
  'errors.location.permissionDenied': 'You have rejected access to your location',
  'errors.location.positionUnavailable': 'Unable to determine your location',
  'errors.location.timeout': 'The geolocation service timed out'
};

var getCoords = (geoLocationOptions) => {
  geoLocationOptions = geoLocationOptions || {maximumAge:60000, timeout:5000, enableHighAccuracy:true};
  return new Promise((resolve, reject) => {
    if (window.navigator && window.navigator.geolocation) {
      window.navigator.geolocation.getCurrentPosition(
        position => {
          resolve(position.coords);
        },
        error => {
          switch (error.code) {
            case 1:
              reject(GEOLOCATION_ERRORS['errors.location.permissionDenied']);
              break;
            case 2:
              reject(GEOLOCATION_ERRORS['errors.location.positionUnavailable']);
              break;
            case 3:
              reject(GEOLOCATION_ERRORS['errors.location.timeout']);
              break;
          }
        },
        geoLocationOptions);
    } else {
      reject(GEOLOCATION_ERRORS['errors.location.unsupportedBrowser']);
    }
  })
};

// https://stackoverflow.com/questions/27928/calculate-distance-between-two-latitude-longitude-points-haversine-formula
var distance = (lat1, lon1, lat2, lon2) => {
  var p = 0.017453292519943295;    // Math.PI / 180
  var c = Math.cos;
  var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p))/2;

  return 12742 * Math.asin(Math.sqrt(a)); // 2 * R; R = 6371 km
}

export { getCoords, distance };