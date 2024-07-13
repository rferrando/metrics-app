import './App.css';
import PostMetric from './components/PostMetric';
import ViewMetric from './components/ViewMetric';
import 'bootstrap/dist/css/bootstrap.min.css';

function App() {
  return (
  <div className="App">
    <div className="App-body">
      <PostMetric />
      <ViewMetric />
    </div>
  </div>
  );
}

export default App;

