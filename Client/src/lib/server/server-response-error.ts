export interface ServerResponseError {
	readonly statusCode: number;
	readonly message: string;
	readonly error: string;
}
