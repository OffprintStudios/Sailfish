export enum EventType {
	// User events
	follow = "follow",
	newReply = "new-reply",

	// Blog events
	addFavorite = "add-favorite",
	newBlogComment = "new-blog-comment",

	// Work events
	addToLibrary = "add-to-library",
	newWorkComment = "new-work-comment",
	workApproved = "work-approved",
	workRejected = "work-rejected",

	// Admin events
	userWarned = "user-warned",
	userMuted = "user-muted",
	userBanned = "user-banned"
}
