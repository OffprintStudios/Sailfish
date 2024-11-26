import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';

export default defineConfig({
	plugins: [sveltekit()],
	server: {
		port: 3000,
	},
	// test: {
	// 	include: ['src/**/*.{test,spec}.{js,ts}']
	// }
});
