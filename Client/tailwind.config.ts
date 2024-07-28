import type { Config } from 'tailwindcss';

export default {
	content: ['./src/**/*.{html,js,svelte,svx,ts}'],

	darkMode: 'class',

	theme: {
		extend: {
			colors: {
                "accent": "rgb(var(--accent))",
                "accent-light": "rgb(var(--accent-light))",
                "accent-dark": "rgb(var(--accent-dark))",
            },
            fontFamily: {
                "default": "var(--body-text)",
                "header": "var(--header-text)",
                "default-serif": "var(--body-text-serif)",
            },
            textColor: {
                "default": "var(--text-color)",
            },
            boxShadow: {
                "small-shadow": "0 0 5px rgba(0, 0, 0, 0.5)"
            },
            animation: {
                modalf: "modalf 150ms ease-in-out",
            },
            keyframes: {
                modalf: {
                    "0%": { transform: "scale(0)", opacity: "0" },
                    "100%": { transform: "scale(1)", opacity: "1" }
                }
            }
		}
	},

	plugins: [
		require("@tailwindcss/aspect-ratio"),
        require("@tailwindcss/forms"),
        require("@tailwindcss/typography"),
        require("tailwindcss-opentype"),
        require("tailwind-scrollbar"),
        function({ addVariant }) {
            addVariant('firefox', ':-moz-any(&)')
        },
	]
} as Config;
