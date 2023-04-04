import Axios, { AxiosError, type AxiosInstance, type AxiosRequestConfig } from "axios";
import { PUBLIC_API_URL } from "$env/static/public";
import type { ServerResponseError } from "$lib/server/server-response-error";

const BASE_URL = PUBLIC_API_URL ? PUBLIC_API_URL : "http://127.0.0.1:3333";

export const serverHttp: AxiosInstance = Axios.create({
	timeout: 1000 * 60, // Milliseconds * Seconds
	timeoutErrorMessage: "Request timed out",
	withCredentials: true
});

export async function getReqServer<T = unknown>(
	url: string,
	config?: AxiosRequestConfig
): Promise<T | ServerResponseError> {
	return serverHttp
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

export async function delReqServer<T = unknown>(
	url: string,
	config?: AxiosRequestConfig
): Promise<T | ServerResponseError> {
	return serverHttp
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

export async function postReqServer<T = unknown>(
	url: string,
	data: unknown,
	config?: AxiosRequestConfig
): Promise<T | ServerResponseError> {
	return serverHttp
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

export async function putReqServer<T = unknown>(
	url: string,
	data: unknown,
	config?: AxiosRequestConfig
): Promise<T | ServerResponseError> {
	return serverHttp
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

export async function patchReqServer<T = unknown>(
	url: string,
	data: unknown,
	config?: AxiosRequestConfig
): Promise<T | ServerResponseError> {
	return serverHttp
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

export async function headReqServer<T = unknown>(
	url: string,
	config?: AxiosRequestConfig
): Promise<T | ServerResponseError> {
	return serverHttp
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

function getError(err: AxiosError): ServerResponseError {
	if (err.response) {
		const response = err.response;
		const data = response.data as { reason: string };
		return {
			statusCode: response.status ?? 500,
			message: data.reason ?? response.statusText,
			error: response.statusText === "" ? "Internal Server Error" : response.statusText
		};
	}

	return {
		statusCode: 500,
		message: `An unknown error has occurred. Please try again in a little bit.`,
		error: "Internal Server Error"
	};
}
