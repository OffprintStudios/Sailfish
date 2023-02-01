//
// Created by Alyx Mote on 11/12/22.
//

import Vapor
import Fluent
import SwiftSoup

final class Section: Model, Content {
    static let schema = "sections"

    @ID(custom: "id", generatedBy: .user)
    var id: String?

    @Parent(key: "work_id")
    var work: Work
    
    @OptionalParent(key: "volume_id")
    var volume: Volume?

    @Field(key: "title")
    var title: String

    @Field(key: "body")
    var body: String

    @Field(key: "words")
    var words: Int64

    @OptionalField(key: "note_top")
    var noteTop: String?

    @OptionalField(key: "note_bottom")
    var noteBottom: String?

    @Children(for: \.$section)
    var comments: [Comment]
    
    @Field(key: "lang")
    var lang: Language

    @Field(key: "rank")
    var rank: Int64

    @OptionalField(key: "published_on")
    var publishedOn: Date?
    
    @OptionalField(key: "first_published")
    var firstPublished: Date?

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: "deleted_at", on: .delete)
    var deletedAt: Date?

    init() { }

    init(id: String? = nil, with formInfo: SectionForm, in volumeId: String? = nil, rank: Int64) throws {
        self.id = generateId(with: id)
        self.$volume.id = volumeId
        title = try SwiftSoup.clean(formInfo.title, .none())!
        body = try SwiftSoup.clean(formInfo.body, defaultWhitelist())!
        if let hasNoteTop = formInfo.noteTop {
            noteTop = try SwiftSoup.clean(hasNoteTop, defaultWhitelist())!
        }
        if let hasNoteBottom = formInfo.noteBottom {
            noteBottom = try SwiftSoup.clean(hasNoteBottom, defaultWhitelist())!
        }
        self.rank = rank
        words = Int64(try SwiftSoup.clean(formInfo.body, Whitelist.none())!.split { !$0.isLetter }.count)
        lang = .en
    }
}

extension Section {
    struct SectionForm: Content {
        var title: String
        var body: String
        var noteTop: String?
        var noteBottom: String?
    }
}

extension Section.SectionForm: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: .count(1...120), required: true)
        validations.add("body", as: String.self, is: .count(3...), required: true)
        validations.add("noteTop", as: String.self, is: .count(3...), required: false)
        validations.add("noteBottom", as: String.self, is: .count(3...), required: false)
    }
}
