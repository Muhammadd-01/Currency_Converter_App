
import React, { useState, useEffect } from 'react';
import { Search, Trash2, MoreVertical, History, X, Plus, Shield } from 'lucide-react';
import { useAuth } from '../context/AuthContext';

const Users = () => {
    const [users, setUsers] = useState([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [selectedUser, setSelectedUser] = useState(null);
    const [userHistory, setUserHistory] = useState([]);
    const [historyLoading, setHistoryLoading] = useState(false);
    const [showCreateAdminModal, setShowCreateAdminModal] = useState(false);
    const [newAdmin, setNewAdmin] = useState({ email: '', password: '', displayName: '' });
    const { isAdmin, isSuperAdmin, currentUser } = useAuth();

    useEffect(() => {
        fetchUsers();
    }, []);

    const fetchUsers = async () => {
        try {
            const response = await fetch('http://localhost:5000/api/users');
            const data = await response.json();
            setUsers(data);
            setLoading(false);
        } catch (error) {
            console.error('Error fetching users:', error);
            setLoading(false);
        }
    };

    const handleDeleteUser = async (user) => {
        if (user.customClaims?.superAdmin === true || user.email === 'superadmin@currensee.com') {
            alert("You cannot delete the Super Admin!");
            return;
        }

        if (!window.confirm('Are you sure you want to delete this user?')) return;

        try {
            const token = await currentUser.getIdToken();
            const response = await fetch(`http://localhost:5000/api/users/${user.uid}`, {
method: 'DELETE',
  headers: {
  'Authorization': `Bearer ${token}`
}
            });

if (response.ok) {
  setUsers(users.filter(u => u.uid !== user.uid));
} else {
  alert('Failed to delete user');
}
        } catch (error) {
  console.error('Error deleting user:', error);
}
    };

const handleCreateAdmin = async (e) => {
  e.preventDefault();
  try {
    const token = await currentUser.getIdToken();
    const response = await fetch('http://localhost:5000/api/admins', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      body: JSON.stringify(newAdmin),
    });

    if (response.ok) {
      setShowCreateAdminModal(false);
      setNewAdmin({ email: '', password: '', displayName: '' });
      alert('Admin created successfully');
      // Optionally refresh users list if the new admin appears there
      fetchUsers();
    } else {
      alert('Failed to create admin');
    }
  } catch (error) {
    console.error('Error creating admin:', error);
  }
};

const handleViewHistory = async (user) => {
  setSelectedUser(user);
  setHistoryLoading(true);
  try {
    const response = await fetch(`http://localhost:5000/api/history/${user.uid}`);
    if (response.ok) {
      const data = await response.json();
      setUserHistory(data);
    } else {
      console.error('Failed to fetch history');
    }
  } catch (error) {
    console.error('Error fetching history:', error);
  } finally {
    setHistoryLoading(false);
  }
};

const closeHistoryModal = () => {
  setSelectedUser(null);
  setUserHistory([]);
};

const filteredUsers = users.filter(user =>
  user.email?.toLowerCase().includes(searchTerm.toLowerCase()) ||
  user.displayName?.toLowerCase().includes(searchTerm.toLowerCase())
);

return (
  <div className="space-y-6 animate-fade-in relative">
    <div className="flex justify-between items-center">
      <div>
        <h1 className="text-3xl font-bold text-white mb-2">Users Management</h1>
        <p className="text-gray-400">Manage your application users</p>
      </div>
      <div className="flex items-center gap-4">
        {isSuperAdmin && (
          <button
            onClick={() => setShowCreateAdminModal(true)}
            className="bg-gradient-to-r from-primary-start to-primary-end px-4 py-2 rounded-xl font-bold text-white shadow-lg shadow-primary-end/20 hover:scale-105 transition-transform flex items-center gap-2"
          >
            <Plus size={20} />
            Add Admin
          </button>
        )}
        <div className="relative">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" size={20} />
          <input
            type="text"
            placeholder="Search users..."
            className="bg-dark-surface border border-white/10 rounded-xl py-2 pl-10 pr-4 text-white focus:outline-none focus:border-primary-end w-64"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
      </div>
    </div>

    <div className="bg-dark-surface rounded-3xl border border-white/10 overflow-hidden shadow-xl">
      <div className="overflow-x-auto">
        <table className="w-full">
          <thead>
            <tr className="bg-white/5 border-b border-white/10">
              <th className="px-6 py-4 text-left text-sm font-semibold text-gray-300">User</th>
              <th className="px-6 py-4 text-left text-sm font-semibold text-gray-300">Status</th>
              <th className="px-6 py-4 text-left text-sm font-semibold text-gray-300">Joined</th>
              <th className="px-6 py-4 text-left text-sm font-semibold text-gray-300">Last Active</th>
              <th className="px-6 py-4 text-right text-sm font-semibold text-gray-300">Actions</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {loading ? (
              <tr>
                <td colSpan="5" className="px-6 py-8 text-center text-gray-400">
                  Loading users...
                </td>
              </tr>
            ) : filteredUsers.length === 0 ? (
              <tr>
                <td colSpan="5" className="px-6 py-8 text-center text-gray-400">
                  No users found
                </td>
              </tr>
            ) : (
              filteredUsers.map((user) => (
                <tr key={user.uid} className="hover:bg-white/5 transition-colors group">
                  <td className="px-6 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-full bg-gradient-to-br from-primary-start to-primary-end flex items-center justify-center text-white font-bold">
                        {user.photoURL ? (
                          <img src={user.photoURL} alt={user.displayName} className="w-full h-full rounded-full object-cover" />
                        ) : (
                          (user.displayName || user.email || 'U')[0].toUpperCase()
                        )}
                      </div>
                      <div>
                        <div className="font-medium text-white flex items-center gap-2">
                          {user.displayName || 'Unnamed User'}
                          {user.customClaims?.superAdmin && <Shield size={14} className="text-yellow-500" />}
                        </div>
                        <div className="text-sm text-gray-400">{user.email}</div>
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <span className="px-3 py-1 rounded-full text-xs font-medium bg-green-500/20 text-green-400 border border-green-500/20">
                      Active
                    </span>
                  </td>
                  <td className="px-6 py-4 text-gray-400 text-sm">
                    {new Date(user.creationTime).toLocaleDateString()}
                  </td>
                  <td className="px-6 py-4 text-gray-400 text-sm">
                    {user.lastSignInTime ? new Date(user.lastSignInTime).toLocaleDateString() : 'Never'}
                  </td>
                  <td className="px-6 py-4 text-right">
                    <div className="flex items-center justify-end gap-2">
                      <button
                        onClick={() => handleViewHistory(user)}
                        className="p-2 hover:bg-white/10 rounded-lg text-gray-400 hover:text-accent transition-colors"
                        title="View History"
                      >
                        <History size={18} />
                      </button>
                      {(isAdmin || isSuperAdmin) && (
                        <button
                          onClick={() => handleDeleteUser(user)}
                          className="p-2 hover:bg-red-500/10 rounded-lg text-gray-400 hover:text-red-400 transition-colors"
                          title="Delete User"
                        >
                          <Trash2 size={18} />
                        </button>
                      )}
                    </div>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>

    {/* History Modal */}
    {selectedUser && (
      <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50 backdrop-blur-sm animate-fade-in">
        <div className="bg-dark-surface w-full max-w-2xl rounded-3xl border border-white/10 shadow-2xl overflow-hidden animate-slide-up">
          <div className="p-6 border-b border-white/10 flex justify-between items-center bg-white/5">
            <h2 className="text-xl font-bold text-white flex items-center gap-3">
              <History className="text-accent" />
              History: {selectedUser.displayName || selectedUser.email}
            </h2>
            <button onClick={closeHistoryModal} className="text-gray-400 hover:text-white transition-colors">
              <X size={24} />
            </button>
          </div>

          <div className="p-6 max-h-[60vh] overflow-y-auto custom-scrollbar">
            {historyLoading ? (
              <div className="text-center py-8 text-gray-400">Loading history...</div>
            ) : userHistory.length === 0 ? (
              <div className="text-center py-8 text-gray-400">No conversion history found.</div>
            ) : (
              <div className="space-y-4">
                {userHistory.map((item) => (
                  <div key={item.id} className="bg-white/5 p-4 rounded-xl border border-white/5 flex justify-between items-center">
                    <div>
                      <div className="flex items-center gap-2 mb-1">
                        <span className="text-lg font-bold text-white">{item.amount} {item.baseCurrency}</span>
                        <span className="text-gray-500">→</span>
                        <span className="text-lg font-bold text-accent">{item.convertedAmount.toFixed(2)} {item.targetCurrency}</span>
                      </div>
                      <div className="text-xs text-gray-400">
                        Rate: {item.rate} • {new Date(item.timestamp).toLocaleString()}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>
    )}

    {/* Create Admin Modal */}
    {showCreateAdminModal && (
      <div className="fixed inset-0 bg-black/80 backdrop-blur-sm flex items-center justify-center z-50 animate-fade-in">
        <div className="bg-dark-surface p-8 rounded-2xl border border-white/10 w-full max-w-md shadow-2xl animate-slide-up">
          <h2 className="text-2xl font-bold text-white mb-6">Add New Admin</h2>
          <form onSubmit={handleCreateAdmin} className="space-y-4">
            <div>
              <label className="block text-gray-400 text-sm mb-2">Display Name</label>
              <input
                type="text"
                className="w-full bg-dark-bg border border-white/10 rounded-xl px-4 py-3 text-white focus:border-primary-end outline-none transition-colors"
                value={newAdmin.displayName}
                onChange={e => setNewAdmin({ ...newAdmin, displayName: e.target.value })}
                required
              />
            </div>
            <div>
              <label className="block text-gray-400 text-sm mb-2">Email</label>
              <input
                type="email"
                className="w-full bg-dark-bg border border-white/10 rounded-xl px-4 py-3 text-white focus:border-primary-end outline-none transition-colors"
                value={newAdmin.email}
                onChange={e => setNewAdmin({ ...newAdmin, email: e.target.value })}
                required
              />
            </div>
            <div>
              <label className="block text-gray-400 text-sm mb-2">Password</label>
              <input
                type="password"
                className="w-full bg-dark-bg border border-white/10 rounded-xl px-4 py-3 text-white focus:border-primary-end outline-none transition-colors"
                value={newAdmin.password}
                onChange={e => setNewAdmin({ ...newAdmin, password: e.target.value })}
                required
              />
            </div>
            <div className="flex gap-3 mt-8">
              <button
                type="button"
                onClick={() => setShowCreateAdminModal(false)}
                className="flex-1 px-4 py-3 rounded-xl font-medium text-gray-400 hover:bg-white/5 transition-colors"
              >
                Cancel
              </button>
              <button
                type="submit"
                className="flex-1 bg-gradient-to-r from-primary-start to-primary-end px-4 py-3 rounded-xl font-bold text-white shadow-lg shadow-primary-end/20 hover:scale-105 transition-transform"
              >
                Create Admin
              </button>
            </div>
          </form>
        </div>
      </div>
    )}
  </div>
);
};

export default Users;

