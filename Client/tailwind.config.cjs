/** @type {import('tailwindcss').Config}*/
const config = {
	content: ['./src/**/*.{html,js,svelte,ts,md}'],

	theme: {
		extend: {}
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
