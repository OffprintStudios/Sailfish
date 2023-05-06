        import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        "Sailfish Ready!"
    }
    
    app.get("version") { req in
        "1.0.0-beta.6"
    }

    try app.register(collection: AdminController())
    try app.register(collection: AuthController())
    try app.register(collection: AccountController())
    try app.register(collection: SessionController())
    try app.register(collection: ProfileController())
    try app.register(collection: BlogController())
    try app.register(collection: NewsController())
    try app.register(collection: NotificationController())
    try app.register(collection: FollowerController())
    try app.register(collection: WorkController())
    try app.register(collection: VolumeController())
    try app.register(collection: SectionController())
    try app.register(collection: TagController())
    try app.register(collection: LibraryController())
    try app.register(collection: ShelfController())
    try app.register(collection: HistoryController())
    try app.register(collection: ApprovalQueueController())
    try app.register(collection: ExploreController())
    try app.register(collection: SearchController())
}
