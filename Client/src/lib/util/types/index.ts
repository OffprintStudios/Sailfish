export type { PaginateResults } from './paginate-results';

export type Typify<T> = { [K in keyof T]: Typify<T[K]> };