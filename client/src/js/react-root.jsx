import 'script-loader!react/umd/react.development.js'; // TODO: change to production
import 'script-loader!react-dom/umd/react-dom.development.js'; // TODO: change to production
import 'script-loader!moment/moment';
import {getLocations, getSchedule} from './firebase';
import {getCoords, distance} from './geo';




class Pool extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      name: props.pool.name,
      address: props.pool.address,
      distance: props.pool.distance,
      category: props.pool.category,
      phone: props.pool.phone,
      swimTimes: props.pool.swimTimes
    };
    // this.handleChange = this.handleChange.bind(this);
  }
  // handleChange(event) {
  //   this.setState({ crossedOut: !!event.target.checked });
  // }

  //<td>{this.props.type}</td>

  render(id) {
    var swimTimesList = this.state.swimTimes.map(t => {
      var from_s = moment(t.from).calendar(); 
      var to_s = moment(t.to).format('LT');
      return <li key={t.from+':'+t.to}>{from_s} to {to_s} ({t.activity})</li>
    });

    var noSwimTimes = <p><em>N/A</em></p>

    return (
      <tr>
        <td><strong>{this.state.name}</strong><br/>{this.state.address}<br/>{this.state.phone}</td>
        <td>{this.state.distance} km</td>
        <td>
          <ul>
            {swimTimesList.length > 0 ? swimTimesList : noSwimTimes}
          </ul>
        </td>
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
    this._pools = [];
    this._schedule = [];
    this._userCoords = null;
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

  _mapScheduleToLocation(pool) {
    const relevantSwimTimes = this._schedule
      .filter(s => s.location_name === pool.name)
      .map(s => {
        return {
          from: s.from.seconds*1000,
          to: s.to.seconds*1000,
          activity: s.activity_name
        };
      });
    pool.swimTimes = relevantSwimTimes;
    return pool;
  }

  componentDidMount() {
    var minTime = new Date(Date.now() - 1000*60*60*12);
    var maxTime = new Date(Date.now() + 1000*60*60*24); // TODO: Make this configurable
    getCoords()
      .then(coords => {
        // TODO: If this fails, use some fallback or give a notification
        console.log(`Detected user location to be at ${coords.latitude}, ${coords.longitude}`);
        this._userCoords = coords;
      })
      .then(getLocations)
      .then(pools => {
        this._pools = pools;
      })
      .then(() => getSchedule(minTime, maxTime))
      .then(schedule => {
        var now = Date.now() / 1000;
        window.schedule = schedule;
        this._schedule = schedule.filter(s => {
          // because it is possible for a swim time to have started before NOW
          // that is still going on and relevant (especially long hours like
          // 11am-6pm), we want to check for times that are already underway
          // in addition to hours that haven't started yet.
          return (s.from.seconds < now && now < s.to.seconds) || s.from.seconds > now;
        });
        console.log(`Matching schedule entries: ${this._schedule.length}`);
      })
      .then(() => {
        // process the pool list
        this._pools = this._pools
          .map(this._mapPoolToDistance.bind(this))
          .filter(pool => pool.distance < 5) // TODO: Make this configurable
          // sort by closest pool first
          .sort((a,b) => {
            return a.distance - b.distance;
          });
        // filter the schedule to contain only swim times for locations we're interested in
        var localPoolNames = this._pools.map(pool => pool.name);
        this._schedule = this._schedule.filter(s => localPoolNames.indexOf(s.location_name) > -1);
        // combine schedule with location data
        this._pools = this._pools.map(this._mapScheduleToLocation.bind(this));
        // set the state to refresh the component
        this.setState({
          pools: this._pools
        });
      });
  }

  render() {

    var rows = this.state.pools.map(pool => 
      <Pool key={pool.name} pool={pool} />
    );
    // TODO: If there are no pools nearby display some message
    return (
      <table className="pure-table pure-table-bordered">
        <thead>
          <tr>
            <th>Location &amp; Address</th>
            <th>Distance</th>
            <th>Swim Times</th>
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
