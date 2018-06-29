import 'script-loader!react/umd/react.development.js'; // TODO: change to production
import 'script-loader!react-dom/umd/react-dom.development.js'; // TODO: change to production
import { GoogleMaps } from './google-maps';
import { getCoords, DEFAULT_LOCATION } from './geo';

class LocationError extends React.Component {
  render() {
    return(
      <p className="error">{this.props.message}</p>
    )
  }
}

export class LocationPicker extends React.Component {
  constructor() {
    super();
    this.state = {
      loading: true,
      address: ''
    };
    this.changeAddress = this.changeAddress.bind(this);
  }

  componentDidMount() {
    getCoords()
      .then(coords => {
        this.props.locationChangedHandler(coords);
        return coords;
      })
      .catch(errorMessage => {
        this.setState({
          error: errorMessage
        });
        this.props.locationChangedHandler(DEFAULT_LOCATION);
        return DEFAULT_LOCATION;
      })
      .then(GoogleMaps.lookUpPlaceViaCoordinates)
      .then(results => {
        const location = results
          .filter(r => r.types.includes('street_address'))
          .pop();
        if(location) {
          this.setState({
            loading: false,
            address: location['formatted_address']
          });
        } else {
          throw new Error('Reverse geocoding failed; no results from google');
        }
      })
      .catch(err => {
        this.setState({
          loading: false,
          error: err.message,
          address: 'Unknown Location'
        });
      });
  }
  changeAddress(event) {
    var addr = window.prompt('Enter an address (e.g. "11 Crown Hill Place")');
    if(!addr) return;
    GoogleMaps.lookUpPlaceViaAddress(addr)
      .then(result => {
        this.setState({
          address: result.address
        });
        // result has the address too, which we don't need, but we ignore it
        this.props.locationChangedHandler(result);
      });
  }
  render() {
    return (
      <div className="location-picker">
        {this.state.error ? <LocationError message={this.state.error}/> : ''}
        <p>{this.state.loading ? 
          <span>Trying to determine your location...</span> :
          <span>Showing pools near <strong>{this.state.address}</strong>. Not here? &laquo;<a onClick={this.changeAddress}>Change search address</a>&raquo;</span>
        }</p>
      </div>
    );
  }
}