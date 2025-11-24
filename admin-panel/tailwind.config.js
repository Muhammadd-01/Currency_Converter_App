/** @type {import('tailwindcss').Config} */
export default {
    content: [
        "./index.html",
        "./src/**/*.{js,ts,jsx,tsx}",
    ],
    theme: {
        extend: {
            colors: {
                primary: {
                    start: '#4A00E0',
                    end: '#8E2DE2',
                },
                secondary: {
                    start: '#0F2027',
                    mid: '#203A43',
                    end: '#2C5364',
                },
                accent: '#00D4FF',
                success: '#00E676',
                warning: '#FFFFAB00',
                error: '#FF5252',
                dark: {
                    bg: '#0A0E21',
                    surface: '#1A1A2E',
                    card: '#16213E',
                }
            },
            fontFamily: {
                sans: ['Inter', 'sans-serif'],
            }
        },
    },
    plugins: [],
}
