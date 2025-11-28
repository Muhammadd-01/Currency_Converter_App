import React, { useEffect, useState } from 'react';
import { Users, Activity, DollarSign, TrendingUp, ArrowUpRight, ArrowDownRight } from 'lucide-react';

const StatCard = ({ title, value, icon: Icon, gradient, trend }) => (
  <div className={`p-6 rounded-3xl bg-gradient-to-br ${gradient} shadow-xl relative overflow-hidden group hover:scale-[1.02] transition-all duration-300 border border-white/10`}>
    <div className="absolute top-0 right-0 -mt-8 -mr-8 w-32 h-32 bg-white/10 rounded-full blur-2xl group-hover:scale-150 transition-transform duration-700"></div>
    <div className="relative z-10">
      <div className="flex justify-between items-start mb-4">
        <div className="p-3 bg-white/20 rounded-2xl backdrop-blur-md shadow-inner">
          <Icon className="text-white" size={24} />
        </div>
        {trend && (
          <div className={`flex items-center gap-1 px-2 py-1 rounded-lg text-xs font-bold ${trend > 0 ? 'bg-green-500/20 text-green-300' : 'bg-red-500/20 text-red-300'}`}>
            {trend > 0 ? <ArrowUpRight size={12} /> : <ArrowDownRight size={12} />}
            {Math.abs(trend)}%
          </div>
        )}
      </div>
      <div>
        <h3 className="text-4xl font-bold text-white mb-1 tracking-tight">{value}</h3>
        <p className="text-white/70 font-medium text-sm">{title}</p>
      </div>
    </div>
  </div>
);

const Dashboard = () => {
  const [stats, setStats] = useState({
    totalUsers: 0,
    activeUsers: 0,
    totalConversions: 0,
  });

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const response = await fetch('http://localhost:5000/api/users');
        const data = await response.json();
        setStats({
          totalUsers: data.length,
          activeUsers: data.filter(u => u.lastSignInTime).length,
          totalConversions: 1234,
        });
      } catch (error) {
        console.error('Error fetching stats:', error);
      }
    };

    fetchStats();
  }, []);

  return (
    <div className="space-y-8 animate-fade-in">
      <div className="flex justify-between items-end">
        <div>
          <h1 className="text-4xl font-bold text-white mb-2 tracking-tight">Dashboard</h1>
          <p className="text-gray-400">Overview of your application performance</p>
        </div>
        <div className="flex gap-2">
          <div className="px-4 py-2 bg-dark-surface rounded-xl border border-white/10 text-sm text-gray-400">
            Last updated: Just now
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <StatCard
          title="Total Users"
          value={stats.totalUsers}
          icon={Users}
          gradient="from-primary-start to-primary-end"
          trend={12}
        />
        <StatCard
          title="Active Users"
          value={stats.activeUsers}
          icon={Activity}
          gradient="from-secondary-start to-secondary-end"
          trend={-5}
        />
        <StatCard
          title="Total Conversions"
          value={stats.totalConversions}
          icon={TrendingUp}
          gradient="from-accent to-blue-600"
          trend={8}
        />
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-dark-surface p-8 rounded-3xl border border-white/5 shadow-xl">
          <h2 className="text-xl font-bold text-white mb-6">System Status</h2>
          <div className="space-y-4">
            <div className="flex items-center justify-between p-4 bg-white/5 rounded-2xl border border-white/5">
              <div className="flex items-center gap-3">
                <div className="w-2 h-2 rounded-full bg-success animate-pulse"></div>
                <span className="text-gray-300 font-medium">API Server</span>
              </div>
              <span className="text-success text-sm font-bold">Operational</span>
            </div>
            <div className="flex items-center justify-between p-4 bg-white/5 rounded-2xl border border-white/5">
              <div className="flex items-center gap-3">
                <div className="w-2 h-2 rounded-full bg-success animate-pulse"></div>
                <span className="text-gray-300 font-medium">Database</span>
              </div>
              <span className="text-success text-sm font-bold">Operational</span>
            </div>
            <div className="flex items-center justify-between p-4 bg-white/5 rounded-2xl border border-white/5">
              <div className="flex items-center gap-3">
                <div className="w-2 h-2 rounded-full bg-success animate-pulse"></div>
                <span className="text-gray-300 font-medium">Firebase Auth</span>
              </div>
              <span className="text-success text-sm font-bold">Operational</span>
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-dark-surface to-dark-card p-8 rounded-3xl border border-white/5 shadow-xl relative overflow-hidden">
          <div className="absolute top-0 right-0 w-64 h-64 bg-primary-end/10 rounded-full blur-3xl -mr-16 -mt-16"></div>
          <h2 className="text-xl font-bold text-white mb-6 relative z-10">Quick Actions</h2>
          <div className="grid grid-cols-2 gap-4 relative z-10">
            <button className="p-4 bg-white/5 hover:bg-white/10 rounded-2xl border border-white/5 transition-colors text-left group">
              <Users className="text-primary-end mb-3 group-hover:scale-110 transition-transform" size={24} />
              <span className="block text-white font-bold">Manage Users</span>
              <span className="text-xs text-gray-500">View and edit users</span>
            </button>
            <button className="p-4 bg-white/5 hover:bg-white/10 rounded-2xl border border-white/5 transition-colors text-left group">
              <Activity className="text-accent mb-3 group-hover:scale-110 transition-transform" size={24} />
              <span className="block text-white font-bold">View Reports</span>
              <span className="text-xs text-gray-500">Check system logs</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
