import Vapor
import Fluent
import struct Foundation.Date

struct WorkObject: Content {
    var id: String?
    var authorID: String
    var authorName: String
    var title: String
    var blurb: String
    var desc: String
    var category: Work.Category
    var rating: ContentRating
    var status: Work.Status
    var coverArt: String?
    var bannerArt: String?
    var kind: Work.Kind
    var license: Work.License
    var attributions: [Work.Attribution: [String]]
    var words: Int64
    var views: Int64
    var likes: Int64
    var dislikes: Int64
    var createdAt: Date?
    var updatedAt: Date?
    var publishedOn: Date?

    func toModel() -> Work {
        let model = Work()

        model.id = self.id
        model.$author.id = authorID
        model.title = self.title
        model.blurb = self.blurb
        model.desc = self.desc
        model.category = self.category
        model.rating = self.rating
        model.status = self.status
        model.coverArt = self.coverArt
        model.bannerArt = self.bannerArt
        model.kind = self.kind
        model.license = self.license
        model.attributions = self.attributions
        model.createdAt = self.createdAt
        model.updatedAt = self.createdAt

        return model
    }
}