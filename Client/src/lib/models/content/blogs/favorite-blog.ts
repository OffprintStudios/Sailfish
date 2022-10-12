import type { Blog } from "./blog";
import type { Profile } from "../../accounts";

export interface FavoriteBlog {
	readonly id: string;
	readonly blog: Blog;
	readonly profile: Profile;
	readonly createdAt: Date;
}