import { vitePreprocess } from '@sveltejs/kit/vite';
import preprocess from "svelte-preprocess";
import adapter from "@sveltejs/adapter-node";

/** @type {import('@sveltejs/kit').Config} */
const config = {
	// Consult https://github.com/sveltejs/svelte-preprocess
	// for more information about preprocessors
	preprocess: [
		preprocess({
			postcss: true,
		}),
		vitePreprocess(),
	],

	kit: {
		adapter: adapter(),
		version: {
			name: '1.0.0-alpha.010',
			pollInterval: 1000 * 60,
		}
	}
};

export default config;
