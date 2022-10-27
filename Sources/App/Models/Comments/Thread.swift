//
// Created by Alyx Mote on 10/26/22.
//

import Vapor
import Fluent
import NanoID

final class Thread: Model, Content {
    static let schema = "threads"

    @ID(custom: "id", generatedBy: .user)
    var id: String?

    @OptionalParent(key: "created_by")
    var createdBy: Profile?

    @Children(for: \.$thread)
    var comments: [Comment]

    @Children(for: \.$thread)
    var blacklist: [ThreadBlacklist]

    @Field(key: "open")
    var open: Bool

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() { }

    init(id: String? = nil, createdBy: String? = nil) {
        if let hasId = id {
            self.id = hasId
        } else {
            self.id = NanoID.with(size: NANO_ID_SIZE)
        }

        open = true

        if let hasBeenCreated = createdBy {
            self.$createdBy.id = hasBeenCreated
        }
    }
}
