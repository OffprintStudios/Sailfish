export interface Session {
	readonly id: string;
	readonly account: { readonly id: string; };
	readonly deviceInfo: {
		readonly browser: string;
		readonly ipAddr: string;
		readonly os: string;
	};
	readonly expires: Date;
	readonly createdAt: Date;
}
