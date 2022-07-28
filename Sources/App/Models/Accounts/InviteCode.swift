//
// Created by Alyx Mote on 7/21/22.
//

import Vapor
import Fluent

final class InviteCode: Model, Content {
    static let schema = "invite_codes"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "used")
    var used: Bool

    @OptionalField(key: "by_who")
    var byWho: String?

    init() { }

    init(id: UUID? = nil) {
        self.id = id
        used = false
        byWho = nil
    }
}
