import { sveltekit } from '@sveltejs/kit/vite';

/** @type {import('vite').UserConfig} */
const config = {
	plugins: [sveltekit()],

	css: {
		preprocessorOptions: {
			scss: {
				additionalData: '@use "src/variables.scss" as *;'
			},
		}
	},

	server: {
		port: 3000,
		fs: {
			allow: ['.yarn']
		}
	},
};

export default config;
