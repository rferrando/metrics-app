import './App.css';
import PostMetric from './components/PostMetric';
import ViewMetric from './components/ViewMetric';

function App() {
  return (
    <div className="App">
      <header className="App-header">
          <h1>Metrics App</h1>
      </header>
      <PostMetric />
      <ViewMetric />
    </div>
  );
}

export default App;

