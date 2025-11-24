import { Link } from 'react-router-dom';

export default function Dashboard() {
  return (
    <div className="p-8">
      <h1 className="text-3xl font-bold mb-8 text-gray-800">Admin Dashboard</h1>
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <Link to="/users" className="block p-6 bg-white rounded-lg shadow hover:shadow-lg transition duration-300 border border-gray-200">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-xl font-semibold text-gray-800">Users</h2>
            <span className="bg-blue-100 text-blue-800 text-xs font-medium px-2.5 py-0.5 rounded">Manage</span>
          </div>
          <p className="text-gray-600">View and manage registered users from Firebase.</p>
        </Link>
        
        <div className="block p-6 bg-white rounded-lg shadow border border-gray-200 opacity-60 cursor-not-allowed">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-xl font-semibold text-gray-800">Analytics</h2>
            <span className="bg-gray-100 text-gray-800 text-xs font-medium px-2.5 py-0.5 rounded">Coming Soon</span>
          </div>
          <p className="text-gray-600">View app usage statistics and conversion metrics.</p>
        </div>
      </div>
    </div>
  );
}
