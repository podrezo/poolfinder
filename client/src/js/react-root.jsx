import 'script-loader!react/umd/react.development.js'; // TODO: change to production
import 'script-loader!react-dom/umd/react-dom.development.js'; // TODO: change to production
import 'script-loader!moment/moment';
import { LocationPicker } from './location-picker';
import { PoolList } from './pools-list';

class PoolFinderRoot extends React.Component {
  constructor() {
    super();
    this.state = {
      latitude: 0,
      longitude: 0
    }
    this.locationChangedHandler = this.locationChangedHandler.bind(this);
  }
  locationChangedHandler(newLocation) {
    this.setState({
      latitude: newLocation.latitude,
      longitude: newLocation.longitude,
    });
  }
  render() {
    return(
      <div className="content">
        <LocationPicker locationChangedHandler={this.locationChangedHandler}/>
        <PoolList latitude={this.state.latitude} longitude={this.state.longitude} />
      </div>
    )
  }
}

ReactDOM.render(
  <PoolFinderRoot/>,
  document.getElementById('root')
);
