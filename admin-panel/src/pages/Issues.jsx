import React, { useEffect, useState } from 'react';
import { AlertCircle, CheckCircle, Clock } from 'lucide-react';

const IssuesPage = () => {
    const [issues, setIssues] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchIssues = async () => {
            try {
                const response = await fetch('http://localhost:5000/api/data/issues');
                const data = await response.json();
                setIssues(data);
            } catch (error) {
                console.error('Error fetching issues:', error);
            } finally {
                setLoading(false);
            }
        };

        fetchIssues();
    }, []);

    return (
        <div className="space-y-6">
            <div>
                <h1 className="text-3xl font-bold text-white mb-2">Issue Reports</h1>
                <p className="text-gray-400">Track and manage reported bugs</p>
            </div>

            <div className="grid gap-4">
                {loading ? (
                    <p className="text-gray-400">Loading issues...</p>
                ) : issues.length === 0 ? (
                    <p className="text-gray-400">No issues reported.</p>
                ) : (
                    issues.map((issue) => (
                        <div key={issue.id} className="bg-dark-surface p-6 rounded-2xl border border-white/5">
                            <div className="flex justify-between items-start mb-2">
                                <h3 className="text-xl font-bold text-white">{issue.subject}</h3>
                                <div className={`px-3 py-1 rounded-full text-xs font-bold flex items-center gap-2 ${issue.status === 'open' ? 'bg-red-500/10 text-red-500' : 'bg-green-500/10 text-green-500'
                                    }`}>
                                    {issue.status === 'open' ? <AlertCircle size={14} /> : <CheckCircle size={14} />}
                                    {issue.status?.toUpperCase()}
                                </div>
                            </div>
                            <p className="text-sm text-gray-400 mb-4">Reported by {issue.email}</p>
                            <div className="bg-black/20 p-4 rounded-xl text-gray-300">
                                {issue.description}
                            </div>
                        </div>
                    ))
                )}
            </div>
        </div>
    );
};

export default IssuesPage;
