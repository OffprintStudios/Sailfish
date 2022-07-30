import adapter from '@sveltejs/adapter-auto';
import preprocess from 'svelte-preprocess';

/** @type {import('@sveltejs/kit').Config} */
const config = {
	// Consult https://github.com/sveltejs/svelte-preprocess
	// for more information about preprocessors
	preprocess: [
		preprocess({
			scss: {
				prependData: '@use "src/variables.scss" as *;'
			},

			postcss: true
		})
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
