import 'script-loader!react/umd/react.development.js'; // TODO: change to production
import 'script-loader!react-dom/umd/react-dom.development.js'; // TODO: change to production
import { GoogleMaps } from './google-maps';
import { getCoords } from './geo';

class LocationError extends React.Component {
  render() {
    return(
      <p><em>{this.props.message}</em></p>
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
  }

  componentDidMount() {
    getCoords()
      .catch(errorMessage => {
        this.setState({
          error: errorMessage
        });
        return {
          // Yonge-Dundas Square
          latitude: 43.6562247,
          longitude: -79.3828281
        };
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

  render() {
    return (
      <div className={'pure-alert' + (this.state.error ? ' pure-alert-warning' :'')}>
        {this.state.error ? <LocationError message={this.state.error}/> : ''}
        {this.state.loading ? 
          <span>Trying to determine your location...</span> :
          <span>Showing pools near <strong>{this.state.address}</strong></span>
        }
      </div>
    );
  }
}