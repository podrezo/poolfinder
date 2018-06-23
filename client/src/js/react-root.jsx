import 'script-loader!react/umd/react.development.js'; // TODO: change to production
import 'script-loader!react-dom/umd/react-dom.development.js'; // TODO: change to production

class Task extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      value: props.name,
      crossedOut: false
    };
    this.handleChange = this.handleChange.bind(this);
  }
  handleChange(event) {
    this.setState({crossedOut: !!event.target.checked});
  }
  render(id) {
    return (
      <li>
        <input type="checkbox" id={'chk_'+this.props.id} value={this.state.crossedOut} onChange={this.handleChange}/>
        <label htmlFor={'chk_'+this.props.id} className={ this.state.crossedOut ? 'crossout' : '' }>{this.state.value}</label>
      </li>
    );
  }
}

class TaskList extends React.Component {
  render() {
    return (
      <div>
        <h1>Task List for {this.props.name}</h1>
        <ul>
          <Task name="Go outside" id="1"/>
          <Task name="Do work" id="2"/>
          <Task name="Sleep" id="3"/>
        </ul>
      </div>
    );
  }
}

ReactDOM.render(
  <TaskList name="Joe" />,
  document.getElementById('root')
);
