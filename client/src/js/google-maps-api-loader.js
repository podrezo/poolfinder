// https://gist.github.com/mavame/b833b50085dc856acbccbb34ab1dbe92
/**
 * Use this class to ensure Google Maps API javascript is loaded before running any google map specific code.
 */
export class GoogleMapsApi {
  /**
   * Constructor set up config.
   */
  constructor() {
    // api key for google maps
    this.apiKey = 'AIzaSyDJMLTmpU6Z-Pu8eXG6iK2c8APkoH_NIlA'; // poolfinder

    // set a globally scoped callback if it doesn't already exist
    if (!window._GoogleMapsApi) {
      this.callbackName = '_GoogleMapsApi.mapLoaded';
      window._GoogleMapsApi = this;
      window._GoogleMapsApi.mapLoaded = this.mapLoaded.bind(this);
    }
  }

  /**
   * Load the Google Maps API javascript
   */
  load() {
    if (!this.promise) {
      this.promise = new Promise(resolve => {
        this.resolve = resolve;
        if (typeof window.google === 'undefined') {
          const script = document.createElement('script');
          script.src = `//maps.googleapis.com/maps/api/js?key=${this.apiKey}&callback=${this.callbackName}&libraries=places`;
          script.async = true;
          document.body.append(script);
        } else {
          this.resolve();
        }
      });
    }

    return this.promise;
  }

  /**
   * Globally scoped callback for the map loaded
   */
  mapLoaded() {
    if (this.resolve) {
      this.resolve();
    }
  }
}