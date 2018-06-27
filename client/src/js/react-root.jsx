import 'script-loader!react/umd/react.development.js'; // TODO: change to production
import 'script-loader!react-dom/umd/react-dom.development.js'; // TODO: change to production
import 'script-loader!moment/moment';
import { LocationPicker } from './location-picker';
import { PoolList } from './pools-list';


ReactDOM.render(
  <div className="content">
    <LocationPicker/>
    <PoolList />
  </div>,
  document.getElementById('root')
);
