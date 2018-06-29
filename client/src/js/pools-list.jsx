import 'script-loader!react/umd/react.development.js'; // TODO: change to production
import 'script-loader!react-dom/umd/react-dom.development.js'; // TODO: change to production
import 'script-loader!moment/moment';
import {getLocation} from './firebase';
import {distance} from './geo';
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
          })
          .sort((a,b) => {
            return a.from > b.from;
          });
        this.setState({swimTimes: swimTimes});
      });
  }

  //getLocation

  render(id) {
    var swimTimesList = this.state.swimTimes.map(t => {
      var from_s = moment(t.from).calendar(); 
      var to_s = moment(t.to).format('LT');
      return <p className="swimTime" key={t.from+':'+t.to+':'+id+':'+t.activity}>{from_s} to {to_s} <span className="swimTimeActivity">{t.activity}</span></p>
    });

    var noSwimTimes = <p><em>N/A</em></p>

    // TODO: Add geo uri link like [<a href={'geo:' + this.props.pool.latitude + ',' + this.props.pool.longitude}>Map It</a>]
    return (
      <div className="pool pure-u-1">
        <div className="pool-distance">{this.props.pool.distance}</div>
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
            {swimTimesList.length > 0 ? swimTimesList : noSwimTimes}
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
  }

  _mapPoolToDistance(pool) {
    var d = distance(
      this.props.latitude,
      this.props.longitude,
      pool.latitude,
      pool.longitude
    );
    // There's no round to nearest N digits and toFixed converts to string sadly
    d = Math.round( d * 10 ) / 10;
    pool.distance = d;
    return pool;
  }

  componentDidUpdate(prevProps) {
    console.log(`New location set: ${this.props.latitude}, ${this.props.longitude}`);
    // Don't update if we didn't set user's location
    if (!this.props.latitude || !this.props.longitude) {
      return;
    }
    // Don't update if the latitude/longitude haven't changed
    if (this.props.latitude === prevProps.latitude && this.props.longitude === prevProps.longitude) {
      return;
    }
    // process the pool list
    var pools = LOCATIONS_LIST
      .map(this._mapPoolToDistance.bind(this))
      .filter(pool => {
        // TODO: Do we want to include splash pads and wading pools too?
        return ['Indoor Pool', 'Outdoor Pool'].indexOf(pool.category) > -1;
      }) 
      // sort by closest pool first
      .sort((a,b) => {
        return a.distance - b.distance;
      })
      // Show only closest 5 pools
      .slice(0, 5);
    // set the state to refresh the component
    this.setState({
      pools: pools
    });
  }

  render() {

    var rows = this.state.pools.map(pool => 
      <Pool key={pool.name} pool={pool} />
    );
    return (
      <div className="pure-g">
        {rows}
      </div>
    );
  }
}