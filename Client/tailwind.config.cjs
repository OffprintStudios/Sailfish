/** @type {import('tailwindcss').Config}*/
const config = {
	content: ['./src/**/*.{html,js,svelte,ts,md}'],

	theme: {
		extend: {
            animation: {
                modalf: "modalf 0.15s ease-in-out",
            },
            keyframes: {
                modalf: {
                    "0%": { transform: "scale(0)", opacity: "0" },
                    "100%": { transform: "scale(1)", opacity: "1" },
                },
            },
        }
	},

    darkMode: 'class',

	plugins: [
        require('@tailwindcss/aspect-ratio'),
        require('@tailwindcss/forms'),
        require('@tailwindcss/typography'),
        require('tailwindcss-opentype'),
        function({ addVariant }) {
            addVariant('firefox', ':-moz-any(&)')
        }
    ]
};

module.exports = config;
