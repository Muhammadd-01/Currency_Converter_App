import React, { useEffect, useState } from 'react';
import { Trash2, Search, Mail, Calendar, User } from 'lucide-react';

const UsersPage = () => {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async () => {
    try {
      const response = await fetch('http://localhost:5000/api/users');
      const data = await response.json();
      setUsers(data);
    } catch (error) {
      console.error('Error fetching users:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (uid) => {
    if (!window.confirm('Are you sure you want to delete this user? This action cannot be undone.')) return;

    try {
      const response = await fetch(`http://localhost:5000/api/users/${uid}`, {
        method: 'DELETE',
      });

      if (response.ok) {
        setUsers(users.filter(user => user.uid !== uid));
        alert('User deleted successfully');
      } else {
        alert('Failed to delete user');
      }
    } catch (error) {
      console.error('Error deleting user:', error);
      alert('Error deleting user');
    }
  };

  const filteredUsers = users.filter(user =>
    user.email?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    user.displayName?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold text-white mb-2">User Management</h1>
          <p className="text-gray-400">Manage your application users</p>
        </div>
        <div className="relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" size={20} />
          <input
            type="text"
            placeholder="Search users..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className="bg-dark-card border border-white/10 rounded-xl pl-10 pr-4 py-2 text-white focus:outline-none focus:border-primary-end w-64 transition-colors"
          />
        </div>
      </div>

      <div className="bg-dark-surface rounded-2xl border border-white/5 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left">
            <thead>
              <tr className="bg-white/5 border-b border-white/5">
                <th className="p-4 text-gray-400 font-medium">User</th>
                <th className="p-4 text-gray-400 font-medium">Email</th>
                <th className="p-4 text-gray-400 font-medium">Joined</th>
                <th className="p-4 text-gray-400 font-medium">Last Login</th>
                <th className="p-4 text-gray-400 font-medium text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-white/5">
              {loading ? (
                <tr>
                  <td colSpan="5" className="p-8 text-center text-gray-400">Loading users...</td>
                </tr>
              ) : filteredUsers.length === 0 ? (
                <tr>
                  <td colSpan="5" className="p-8 text-center text-gray-400">No users found</td>
                </tr>
              ) : (
                filteredUsers.map((user) => (
                  <tr key={user.uid} className="hover:bg-white/5 transition-colors">
                    <td className="p-4">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-full bg-gradient-to-br from-primary-start to-primary-end flex items-center justify-center text-white font-bold">
                          {user.photoURL ? (
                            <img src={user.photoURL} alt={user.displayName} className="w-full h-full rounded-full object-cover" />
                          ) : (
                            <User size={20} />
                          )}
                        </div>
                        <span className="text-white font-medium">{user.displayName || 'No Name'}</span>
                      </div>
                    </td>
                    <td className="p-4">
                      <div className="flex items-center gap-2 text-gray-300">
                        <Mail size={16} />
                        {user.email}
                      </div>
                    </td>
                    <td className="p-4 text-gray-400">
                      <div className="flex items-center gap-2">
                        <Calendar size={16} />
                        {new Date(user.creationTime).toLocaleDateString()}
                      </div>
                    </td>
                    <td className="p-4 text-gray-400">
                      {user.lastSignInTime ? new Date(user.lastSignInTime).toLocaleDateString() : 'Never'}
                    </td>
                    <td className="p-4 text-right">
                      <button
                        onClick={() => handleDelete(user.uid)}
                        className="p-2 text-red-400 hover:bg-red-500/10 rounded-lg transition-colors"
                        title="Delete User"
                      >
                        <Trash2 size={20} />
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default UsersPage;
