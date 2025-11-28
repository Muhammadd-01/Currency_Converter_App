import React, { createContext, useContext, useEffect, useState } from 'react';
import { auth } from '../firebase';
import {
    signInWithEmailAndPassword,
    signOut,
    onAuthStateChanged
} from 'firebase/auth';

const AuthContext = createContext();

export const useAuth = () => useContext(AuthContext);

export const AuthProvider = ({ children }) => {
    const [currentUser, setCurrentUser] = useState(null);
    const [userRole, setUserRole] = useState(null);
    const [loading, setLoading] = useState(true);

    const login = (email, password) => {
        return signInWithEmailAndPassword(auth, email, password);
    };

    const logout = () => {
        return signOut(auth);
    };

    useEffect(() => {
        const unsubscribe = onAuthStateChanged(auth, async (user) => {
            setCurrentUser(user);
            if (user) {
                try {
                    const tokenResult = await user.getIdTokenResult();
                    // Check for custom claims
                    if (tokenResult.claims.superAdmin) {
                        setUserRole('superAdmin');
                    } else if (tokenResult.claims.admin) {
                        setUserRole('admin');
                    } else {
                        setUserRole('user');
                    }
                } catch (error) {
                    console.error("Error getting token result:", error);
                    setUserRole('user');
                }
            } else {
                setUserRole(null);
            }
            setLoading(false);
        });

        return unsubscribe;
    }, []);

    const value = {
        currentUser,
        userRole,
        isSuperAdmin: userRole === 'superAdmin',
        isAdmin: userRole === 'admin' || userRole === 'superAdmin',
        login,
        logout
    };

    return (
        <AuthContext.Provider value={value}>
            {!loading && children}
        </AuthContext.Provider>
    );
};
