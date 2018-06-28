import 'script-loader!react/umd/react.development.js'; // TODO: change to production
import 'script-loader!react-dom/umd/react-dom.development.js'; // TODO: change to production
import 'script-loader!moment/moment';
import {getLocation} from './firebase';
import {getCoords, distance, DEFAULT_LOCATION} from './geo';
import LOCATIONS_LIST from './locations';

class Pool extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      swimTimes: []
    };
  }

  componentDidMount() {
    getLocation(this.props.pool.id.toString())
      .then(data => {
        var minTime = new Date(Date.now() - 1000*60*60*12);
        var maxTime = new Date(Date.now() + 1000*60*60*24); // TODO: Make this configurable
        var now = new Date();
        var swimTimes = data.schedule
          .map(s => {
            return {
              from: new Date(s.from.seconds * 1000),
              to: new Date(s.to.seconds * 1000),
              activity: s.activity
            };
          })
          .filter(s => {
            // because it is possible for a swim time to have started before NOW
            // that is still going on and relevant (especially long hours like
            // 11am-6pm), we want to check for times that are already underway
            // in addition to hours that haven't started yet.
            return s.to > now && minTime < s.from && s.from < maxTime;
          });
        this.setState({swimTimes: swimTimes});
        console.log(swimTimes);
      });
  }

  //getLocation

  render(id) {
    var swimTimesList = this.state.swimTimes.map(t => {
      var from_s = moment(t.from).calendar(); 
      var to_s = moment(t.to).format('LT');
      return <li key={t.from+':'+t.to}>{from_s} to {to_s} ({t.activity})</li>
    });

    var noSwimTimes = <p><em>N/A</em></p>

    // TODO: Add geo uri link like [<a href={'geo:' + this.props.pool.latitude + ',' + this.props.pool.longitude}>Map It</a>]
    // TODO: Display distance using this.props.pool.distance
    return (
      <div className="pool pure-u-1">
        <div className="pure-g">
          <div className="pure-u-1">
            <h3 title={this.props.pool.name} className="pool-name">{this.props.pool.name}</h3>
            <h4 className="pool-category">{this.props.pool.category}</h4>
          </div>
          <div className="pure-u-1 pure-u-md-1-3">
            <p>
              {this.props.pool.address}<br/>
              <a href={'tel:' + this.props.pool.phone}>{this.props.pool.phone}</a>
            </p>
          </div>
          <div className="pure-u-1 pure-u-md-2-3">
            <ul>
              {swimTimesList.length > 0 ? swimTimesList : noSwimTimes}
            </ul>
          </div>
        </div>
      </div>
    );
  }
}

export class PoolList extends React.Component {
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
      pool.latitude,
      pool.longitude
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
    getCoords()
      .then(coords => {
        this._userCoords = coords;
      })
      .catch(() => {
        this._userCoords = DEFAULT_LOCATION;
      })
      .then(() => {
        // process the pool list
        this._pools = LOCATIONS_LIST
          .map(this._mapPoolToDistance.bind(this))
          .filter(pool => {
            // TODO: Make this configurable
            return pool.distance < 2.5 && ['Indoor Pool', 'Outdoor Pool'].indexOf(pool.category) > -1;
          }) 
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
      <div className="pure-g">
        {rows}
      </div>
    );
  }
}