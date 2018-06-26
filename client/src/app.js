import './assets/scss/app.scss';
// import './js/react-root';
import './js/sidemenu';

import { GoogleMaps } from './js/google-maps';
import { getCoords } from './js/geo';

var gmap = new GoogleMaps();
getCoords()
  .catch(err => {
    // TODO: Handle the error
    return {
      // Yonge-Dundas Square
      latitude: 43.6562247,
      longitude: -79.3828281
    };
  })
  .then(gmap.lookUpPlaceViaCoordinates.bind(gmap))
  .then(results => {
    console.log(results);
  });