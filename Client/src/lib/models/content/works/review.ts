export interface Review {
    readonly id: string
    readonly work: { readonly id: string; };
    readonly profile: {
        readonly id: string;
        readonly username: string;
        readonly avatar: string;
        readonly banner?: string;
    };
    readonly section: {
        readonly id: string;
        readonly title: string;
    };
    readonly body: string;
    readonly likes: number;
    readonly dislikes: number;
    readonly recommended: boolean;
    readonly createdAt: Date;
    readonly updatedAt: Date;
}