import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import Layout from './components/Layout';
import Dashboard from './pages/Dashboard';
import Users from './pages/Users';
import AdminsPage from './pages/Admins';
import FeedbackPage from './pages/Feedback';
import IssuesPage from './pages/Issues';
import Login from './pages/Login';

const ProtectedRoute = ({ children, requireSuperAdmin }) => {
  const { currentUser, isAdmin, isSuperAdmin, loading } = useAuth();

  if (loading) return <div className="min-h-screen bg-dark-bg flex items-center justify-center text-white">Loading...</div>;

  if (!currentUser || !isAdmin) {
    return <Navigate to="/login" />;
  }

  if (requireSuperAdmin && !isSuperAdmin) {
    return <Navigate to="/" />;
  }

  return children;
};

function App() {
  return (
    <AuthProvider>
      <Router>
        <Routes>
          <Route path="/login" element={<Login />} />

          <Route path="/" element={
            <ProtectedRoute>
              <Layout>
                <Dashboard />
              </Layout>
            </ProtectedRoute>
          } />

          <Route path="/users" element={
            <ProtectedRoute>
              <Layout>
                <Users />
              </Layout>
            </ProtectedRoute>
          } />

          <Route path="/admins" element={
            <ProtectedRoute requireSuperAdmin={true}>
              <Layout>
                <AdminsPage />
              </Layout>
            </ProtectedRoute>
          } />

          <Route path="/feedback" element={
            <ProtectedRoute>
              <Layout>
                <FeedbackPage />
              </Layout>
            </ProtectedRoute>
          } />

          <Route path="/issues" element={
            <ProtectedRoute>
              <Layout>
                <IssuesPage />
              </Layout>
            </ProtectedRoute>
          } />
        </Routes>
      </Router>
    </AuthProvider>
  );
}

export default App;
