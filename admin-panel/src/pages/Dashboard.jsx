import React, { useEffect, useState } from 'react';
import { Users, Activity, DollarSign, TrendingUp } from 'lucide-react';

const StatCard = ({ title, value, icon: Icon, gradient }) => (
  <div className={`p-6 rounded-2xl bg-gradient-to-br ${gradient} shadow-lg relative overflow-hidden group hover:scale-105 transition-transform duration-300`}>
    <div className="absolute top-0 right-0 -mt-4 -mr-4 w-24 h-24 bg-white/10 rounded-full blur-xl group-hover:scale-150 transition-transform duration-500"></div>
    <div className="relative z-10">
      <div className="flex justify-between items-start">
        <div>
          <p className="text-white/80 font-medium mb-1">{title}</p>
          <h3 className="text-3xl font-bold text-white">{value}</h3>
        </div>
        <div className="p-3 bg-white/20 rounded-xl backdrop-blur-sm">
          <Icon className="text-white" size={24} />
        </div>
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
    // Fetch stats from backend
    const fetchStats = async () => {
      try {
        const response = await fetch('http://localhost:5000/api/users');
        const data = await response.json();
        setStats({
          totalUsers: data.length,
          activeUsers: data.filter(u => u.lastSignInTime).length, // Simple logic for now
          totalConversions: 1234, // Mock data
        });
      } catch (error) {
        console.error('Error fetching stats:', error);
      }
    };

    fetchStats();
  }, []);

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold text-white mb-2">Dashboard Overview</h1>
        <p className="text-gray-400">Welcome back, Admin</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <StatCard
          title="Total Users"
          value={stats.totalUsers}
          icon={Users}
          gradient="from-primary-start to-primary-end"
        />
        <StatCard
          title="Active Users"
          value={stats.activeUsers}
          icon={Activity}
          gradient="from-secondary-start to-secondary-end"
        />
        <StatCard
          title="Total Conversions"
          value={stats.totalConversions}
          icon={TrendingUp}
          gradient="from-accent to-blue-600"
        />
      </div>

      {/* Recent Activity Section could go here */}
      <div className="bg-dark-surface p-6 rounded-2xl border border-white/5">
        <h2 className="text-xl font-bold text-white mb-4">System Status</h2>
        <div className="flex items-center gap-2 text-success">
          <div className="w-3 h-3 rounded-full bg-success animate-pulse"></div>
          <span>All systems operational</span>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
