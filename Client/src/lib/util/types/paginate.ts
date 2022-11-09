export interface Paginate<T> {
	readonly items: T[];
	readonly metadata: {
		readonly page: number;
		readonly per: number;
		readonly total: number;
	}
}