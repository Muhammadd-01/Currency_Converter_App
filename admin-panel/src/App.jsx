import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Layout from './components/Layout';
import Dashboard from './pages/Dashboard';
import FeedbackPage from './pages/Feedback';
import IssuesPage from './pages/Issues';
import Users from './pages/Users';

function App() {
  return (
    <Router>
      <Layout>
        <Routes>
          <Route path="/" element={<Dashboard />} />
          <Route path="/users" element={<Users />} />
          <Route path="/feedback" element={<FeedbackPage />} />
          <Route path="/issues" element={<IssuesPage />} />
        </Routes>
      </Layout>
    </Router>
  );
}

export default App;
