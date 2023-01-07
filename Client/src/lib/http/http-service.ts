// NOTE: USE ONLY FOR CLIENT-SIDE COMPONENTS

import type { AxiosInstance, AxiosRequestConfig } from "axios";
import Axios from "axios";
import { BASE_URL } from "./base-url";
import type { ResponseError } from "./response-error";
import { account } from "../state/account.state";
import { get } from "svelte/store";
import type { RefreshPackage } from "../models/accounts";

export const http: AxiosInstance = Axios.create({
	timeout: 1000 * 60, // Milliseconds * Seconds
	timeoutErrorMessage: "Request timed out",
	withCredentials: true
});

http.interceptors.request.use((request) => {
	const token = get(account).token;
	if (token) {
		request.headers = {
			Authorization: `Bearer ${token}`
		};
	}
	return request;
});

http.interceptors.response.use(
	(response) => response,
	async (error) => {
		const status = error.response ? error.response.status : null;
		if (status === 401) {
			const user = get(account).account;
			if (user) {
				const refresh = await fetch(`/api/auth/refresh-token?accountId=${user.id}`, {
					method: "POST"
				});
				if (refresh.status === 200) {
					const data: RefreshPackage = await refresh.json();
					account.update((state) => ({
						...state,
						token: data.accessToken
					}));
					return http.request(error.config);
				} else {
					account.update(() => ({
						account: null,
						profiles: [],
						currProfile: null,
						token: null
					}));
				}
			}
		}
		return Promise.reject(error);
	}
);

export async function getReq<T = unknown>(
	url: string,
	config?: AxiosRequestConfig
): Promise<T | ResponseError> {
	return http
		.get<T>(`${BASE_URL}${url}`, config)
		.then((res) => res.data)
		.catch((error) => {
			if (error.isAxiosError) {
				return getError(error);
			} else {
				return {
					statusCode: 500,
					message: `An unknown error has occurred. Please try again in a little bit.`,
					error: "Internal Server Error"
				};
			}
		});
}

export async function delReq<T = unknown>(
	url: string,
	config?: AxiosRequestConfig
): Promise<T | ResponseError> {
	return http
		.delete<T>(`${BASE_URL}${url}`, config)
		.then((res) => res.data)
		.catch((error) => {
			if (error.isAxiosError) {
				return getError(error);
			} else {
				return {
					statusCode: 500,
					message: `An unknown error has occurred. Please try again in a little bit.`,
					error: "Internal Server Error"
				};
			}
		});
}

export async function postReq<T = unknown>(
	url: string,
	data: unknown,
	config?: AxiosRequestConfig
): Promise<T | ResponseError> {
	return http
		.post<T>(`${BASE_URL}${url}`, data, config)
		.then((res) => res.data)
		.catch((error) => {
			if (error.isAxiosError) {
				return getError(error);
			} else {
				return {
					statusCode: 500,
					message: `An unknown error has occurred. Please try again in a little bit.`,
					error: "Internal Server Error"
				};
			}
		});
}

export async function putReq<T = unknown>(
	url: string,
	data: unknown,
	config?: AxiosRequestConfig
): Promise<T | ResponseError> {
	return http
		.put<T>(`${BASE_URL}${url}`, data, config)
		.then((res) => res.data)
		.catch((error) => {
			if (error.isAxiosError) {
				return getError(error);
			} else {
				return {
					statusCode: 500,
					message: `An unknown error has occurred. Please try again in a little bit.`,
					error: "Internal Server Error"
				};
			}
		});
}

export async function patchReq<T = unknown>(
	url: string,
	data: unknown,
	config?: AxiosRequestConfig
): Promise<T | ResponseError> {
	return http
		.patch<T>(`${BASE_URL}${url}`, data, config)
		.then((res) => res.data)
		.catch((error) => {
			if (error.isAxiosError) {
				return getError(error);
			} else {
				return {
					statusCode: 500,
					message: `An unknown error has occurred. Please try again in a little bit.`,
					error: "Internal Server Error"
				};
			}
		});
}

export async function headReq<T = unknown>(
	url: string,
	config?: AxiosRequestConfig
): Promise<T | ResponseError> {
	return http
		.head<T>(`${BASE_URL}${url}`, config)
		.then((res) => res.data)
		.catch((error) => {
			if (error.isAxiosError) {
				return getError(error);
			} else {
				return {
					statusCode: 500,
					message: `An unknown error has occurred. Please try again in a little bit.`,
					error: "Internal Server Error"
				};
			}
		});
}

function getError(err: any): ResponseError {
	return {
		statusCode: err.response.status ?? 500,
		message: err.response.data.reason ?? err.response.statusText,
		error: err.response.statusText
	};
}
