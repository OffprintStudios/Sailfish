import Vapor
import Fluent
import SwiftSoup

final class Blog: Model, Content {
    static let schema = "blogs"

    @ID(key: .id)
    var id: UUID?
}

extension Blog {
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let authorId: FieldKey = "author_id"
        static let title: FieldKey = "title"
        static let body: FieldKey = "body"
        static let rating: FieldKey = "rating"
        static let words: FieldKey = "words"
        static let faves: FieldKey = "faves"
    }
}