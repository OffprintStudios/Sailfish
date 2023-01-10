//
// Created by Alyx Mote on 10/1/22.
//

import Vapor
import Fluent
import SwiftSoup

final class AccountNote: Model, Content {
    static let schema = "account_notes"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "added_by")
    var addedBy: Profile

    @Parent(key: "account_id")
    var account: Account

    @Field(key: "message")
    var message: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    init() { }

    init(id: UUID? = nil, addedBy: Profile.IDValue, formInfo: NoteForm) throws {
        self.id = id
        self.$addedBy.id = addedBy
        self.$account.id = formInfo.accountId
        message = try SwiftSoup.clean(formInfo.message, Whitelist.none())!
    }
}

extension AccountNote {
    struct NoteForm: Codable {
        var accountId: UUID
        var message: String
    }
}

extension AccountNote.NoteForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("accountId", as: String.self, is: !.empty)
        validations.add("message", as: String.self, is: .count(3...))
    }
}
