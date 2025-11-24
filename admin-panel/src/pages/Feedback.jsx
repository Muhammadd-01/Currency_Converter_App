import React, { useEffect, useState } from 'react';
import { MessageSquare, Star, User } from 'lucide-react';

const FeedbackPage = () => {
    const [feedback, setFeedback] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchFeedback = async () => {
            try {
                const response = await fetch('http://localhost:5000/api/data/feedback');
                const data = await response.json();
                setFeedback(data);
            } catch (error) {
                console.error('Error fetching feedback:', error);
            } finally {
                setLoading(false);
            }
        };

        fetchFeedback();
    }, []);

    return (
        <div className="space-y-6">
            <div>
                <h1 className="text-3xl font-bold text-white mb-2">User Feedback</h1>
                <p className="text-gray-400">Reviews and ratings from users</p>
            </div>

            <div className="grid gap-4">
                {loading ? (
                    <p className="text-gray-400">Loading feedback...</p>
                ) : feedback.length === 0 ? (
                    <p className="text-gray-400">No feedback yet.</p>
                ) : (
                    feedback.map((item) => (
                        <div key={item.id} className="bg-dark-surface p-6 rounded-2xl border border-white/5 hover:border-primary-end/30 transition-colors">
                            <div className="flex justify-between items-start mb-4">
                                <div className="flex items-center gap-3">
                                    <div className="w-10 h-10 rounded-full bg-white/10 flex items-center justify-center text-white">
                                        <User size={20} />
                                    </div>
                                    <div>
                                        <h3 className="text-white font-medium">{item.email}</h3>
                                        <p className="text-xs text-gray-400">
                                            {item.timestamp ? new Date(item.timestamp._seconds * 1000).toLocaleDateString() : 'Unknown Date'}
                                        </p>
                                    </div>
                                </div>
                                <div className="flex items-center gap-1 bg-yellow-500/10 px-3 py-1 rounded-full">
                                    <Star size={16} className="text-yellow-500 fill-yellow-500" />
                                    <span className="text-yellow-500 font-bold">{item.rating || 0}</span>
                                </div>
                            </div>
                            <p className="text-gray-300 leading-relaxed">{item.message}</p>
                        </div>
                    ))
                )}
            </div>
        </div>
    );
};

export default FeedbackPage;
