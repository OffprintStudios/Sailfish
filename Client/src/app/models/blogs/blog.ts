import { ContentRating } from "$models/util";

export interface Blog {
    readonly id: string;
    readonly author: {
        readonly id: string;
        readonly username: string;
        readonly avatar: string;
    };
    title: string;
    body: string;
    rating: ContentRating;
    words: number;
    views: number;
    likes: number;
    dislikes: number;
    favorites: number;
    readonly editedOn?: Date;
    readonly listed?: boolean;
    readonly publishedOn?: boolean;
    readonly createdAt: Date;
    readonly updatedAt: Date;
}
