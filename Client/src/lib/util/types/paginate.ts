export interface Paginate<T> {
	items: T[];
	readonly metadata: {
		readonly page: number;
		readonly per: number;
		readonly total: number;
	};
}
