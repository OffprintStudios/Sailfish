//
// Created by Alyx Mote on 11/12/22.
//

import Vapor
import Fluent
import SwiftSoup

final class Section: Model, Content {
    static let schema = "sections"

    @ID(custom: FieldKeys.id, generatedBy: .user)
    var id: String?

    @Parent(key: FieldKeys.workId)
    var work: Work
    
    @OptionalParent(key: FieldKeys.volumeId)
    var volume: Volume?

    @Field(key: FieldKeys.title)
    var title: String

    @Field(key: FieldKeys.body)
    var body: String

    @Field(key: FieldKeys.words)
    var words: Int64

    @OptionalField(key: FieldKeys.noteTop)
    var noteTop: String?

    @OptionalField(key: FieldKeys.noteBottom)
    var noteBottom: String?

    @Children(for: \.$section)
    var comments: [Comment]
    
    @Field(key: FieldKeys.lang)
    var lang: Language

    @Field(key: FieldKeys.rank)
    var rank: Int64

    @OptionalField(key: FieldKeys.publishedOn)
    var publishedOn: Date?
    
    @OptionalField(key: FieldKeys.firstPublished)
    var firstPublished: Date?

    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: FieldKeys.deletedAt, on: .delete)
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
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let workId: FieldKey = "work_id"
        static let volumeId: FieldKey = "volume_id"
        static let title: FieldKey = "title"
        static let body: FieldKey = "body"
        static let words: FieldKey = "words"
        static let noteTop: FieldKey = "note_top"
        static let noteBottom: FieldKey = "note_bottom"
        static let lang: FieldKey = "lang"
        static let rank: FieldKey = "rank"
        static let publishedOn: FieldKey = "published_on"
        static let firstPublished: FieldKey = "first_published"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
        static let deletedAt: FieldKey = "deleted_at"
    }
    
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
