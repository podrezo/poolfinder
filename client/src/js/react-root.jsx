import 'script-loader!react/umd/react.development.js'; // TODO: change to production
import 'script-loader!react-dom/umd/react-dom.development.js'; // TODO: change to production
import firebase from './firebase';
import {getCoords, distance} from './geo';

class Pool extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: props.name,
      address: props.address,
      distance: props.distance,
      category: props.category,
      phone: props.phone,
    };
    // this.handleChange = this.handleChange.bind(this);
  }
  // handleChange(event) {
  //   this.setState({ crossedOut: !!event.target.checked });
  // }

  render(id) {
    return (
      <tr>
        <td><strong>{this.props.name}</strong><br/>{this.props.address}<br/>{this.props.phone}</td>
        <td>{this.props.type}</td>
        <td>{this.props.distance} km</td>
      </tr>
    );
  }
}

class PoolList extends React.Component {
  constructor() {
    super();
    this.state = {
      pools: []
    };
  }

  _mapPoolToDistance(pool) {
    var d = distance(
      this._userCoords.latitude,
      this._userCoords.longitude,
      pool.coordinates.latitude,
      pool.coordinates.longitude
    );
    // There's no round to nearest N digits and toFixed converts to string sadly
    d = Math.round( d * 10 ) / 10;
    pool.distance = d;
    return pool;
  }

  componentDidMount() {
    this._pools = [];
    firebase.getLocations()
      .then(pools => {
        this._pools = pools;
      })
      .then(getCoords)
      .then(coords => {
        this._userCoords = coords;
        console.log(`Detected user location to be at ${coords.latitude}, ${coords.longitude}`)
        var pools = this._pools
          .map(this._mapPoolToDistance.bind(this))
          .filter(pool => pool.distance < 5) // TODO: Make this configurable
          // sort by closest pool first
          .sort((a,b) => {
            return a.distance - b.distance;
          })
        this.setState({
          pools: pools
        });
      });
  }

  render() {

    var rows = this.state.pools.map(pool => 
      <Pool key={pool.name} name={pool.name} address={pool.address}
            phone={pool.phone} distance={pool.distance} type={pool.category}/>
    );

    return (
      <table className="pure-table pure-table-bordered">
        <thead>
          <tr>
            <th>Location &amp; Address</th>
            <th>Type</th>
            <th>Distance</th>
          </tr>
        </thead>

        <tbody>
          {rows}
        </tbody>
      </table>
    );
  }
}

ReactDOM.render(
  <PoolList />,
  document.getElementById('root')
);
