import './assets/scss/app.scss';
// import './js/react-root';
import './js/sidemenu';

import { GoogleMaps } from './js/google-maps';
import { getCoords } from './js/geo';

var gmap = new GoogleMaps();
gmap
  .load()
  .then(getCoords)
  .then(gmap.lookUpPlaceViaCoordinates)
  .then(results => {
    console.log(results);
  });