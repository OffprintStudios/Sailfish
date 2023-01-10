export type { Paginate } from './paginate';

export type Typify<T> = { [K in keyof T]: Typify<T[K]> };