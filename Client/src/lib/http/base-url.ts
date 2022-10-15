import { dev } from "$app/environment";

export const BASE_URL = dev ? `http://127.0.0.1:3333` : `https://api.offprint.net`;