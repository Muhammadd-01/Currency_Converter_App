import React, { useEffect, useState } from 'react';
import { Shield, Trash2, Plus, Mail, User } from 'lucide-react';

const AdminsPage = () => {
    const [admins, setAdmins] = useState([]);
    const [loading, setLoading] = useState(true);
    const [showModal, setShowModal] = useState(false);
    const [newAdmin, setNewAdmin] = useState({ email: '', password: '', displayName: '' });

    useEffect(() => {
        fetchAdmins();
    }, []);

    const fetchAdmins = async () => {
        try {
            const response = await fetch('http://localhost:5000/api/admins');
            const data = await response.json();
            setAdmins(data);
        } catch (error) {
            console.error('Error fetching admins:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleCreateAdmin = async (e) => {
        e.preventDefault();
        try {
            const response = await fetch('http://localhost:5000/api/admins', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(newAdmin),
            });

            if (response.ok) {
                setShowModal(false);
                setNewAdmin({ email: '', password: '', displayName: '' });
                fetchAdmins();
                alert('Admin created successfully');
            } else {
                alert('Failed to create admin');
            }
        } catch (error) {
            console.error('Error creating admin:', error);
        }
    };

    const handleDelete = async (uid) => {
        if (!window.confirm('Are you sure you want to delete this admin?')) return;

        try {
            const response = await fetch(`http://localhost:5000/api/admins/${uid}`, {
                method: 'DELETE',
            });

            if (response.ok) {
                setAdmins(admins.filter(a => a.uid !== uid));
                alert('Admin deleted successfully');
            } else {
                alert('Failed to delete admin');
            }
        } catch (error) {
            console.error('Error deleting admin:', error);
        }
    };

    return (
        <div className="space-y-6">
            <div className="flex justify-between items-center">
                <div>
                    <h1 className="text-3xl font-bold text-white mb-2">Admin Management</h1>
                    <p className="text-gray-400">Manage system administrators</p>
                </div>
                <button
                    onClick={() => setShowModal(true)}
                    className="bg-gradient-to-r from-primary-start to-primary-end px-6 py-3 rounded-xl font-bold text-white shadow-lg shadow-primary-end/20 hover:scale-105 transition-transform flex items-center gap-2"
                >
                    <Plus size={20} />
                    Add Admin
                </button>
            </div>

            <div className="grid gap-4">
                {loading ? (
                    <p className="text-gray-400">Loading admins...</p>
                ) : (
                    admins.map((admin) => (
                        <div key={admin.uid} className="bg-dark-surface p-6 rounded-2xl border border-white/5 flex justify-between items-center group hover:border-primary-end/30 transition-colors">
                            <div className="flex items-center gap-4">
                                <div className={`w-12 h-12 rounded-full flex items-center justify-center text-white font-bold ${admin.isSuperAdmin ? 'bg-gradient-to-br from-yellow-400 to-orange-500' : 'bg-white/10'
                                    }`}>
                                    {admin.isSuperAdmin ? <Shield size={24} /> : <User size={24} />}
                                </div>
                                <div>
                                    <div className="flex items-center gap-2">
                                        <h3 className="text-white font-bold text-lg">{admin.displayName || 'Admin'}</h3>
                                        {admin.isSuperAdmin && (
                                            <span className="bg-yellow-500/20 text-yellow-500 text-xs px-2 py-0.5 rounded-full font-bold">SUPER ADMIN</span>
                                        )}
                                    </div>
                                    <div className="flex items-center gap-2 text-gray-400 text-sm mt-1">
                                        <Mail size={14} />
                                        {admin.email}
                                    </div>
                                </div>
                            </div>

                            {!admin.isSuperAdmin && (
                                <button
                                    onClick={() => handleDelete(admin.uid)}
                                    className="p-3 text-red-400 hover:bg-red-500/10 rounded-xl transition-colors opacity-0 group-hover:opacity-100"
                                    title="Delete Admin"
                                >
                                    <Trash2 size={20} />
                                </button>
                            )}
                        </div>
                    ))
                )}
            </div>

            {showModal && (
                <div className="fixed inset-0 bg-black/80 backdrop-blur-sm flex items-center justify-center z-50">
                    <div className="bg-dark-surface p-8 rounded-2xl border border-white/10 w-full max-w-md shadow-2xl">
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
                                    onClick={() => setShowModal(false)}
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

export default AdminsPage;
