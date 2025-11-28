import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";

const firebaseConfig = {
    apiKey: "AIzaSyBjuwXg9imkt7rhJiKnw7a_9NDIgN6vTz0",
    authDomain: "currensee-ad1f4.firebaseapp.com",
    projectId: "currensee-ad1f4",
    storageBucket: "currensee-ad1f4.firebasestorage.app",
    messagingSenderId: "874006130232",
    appId: "1:874006130232:web:dfcdc244fd9cb780afc0cd"
};

const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export default app;
