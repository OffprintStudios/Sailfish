//
//  Created by Alyx Mote on 11/14/22.
//

import Vapor
import Fluent

struct WorkController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let works = routes.grouped("works")
        let worksWithAuth = works.grouped([
            IdentityGuard(needs: [.user], checkProfile: true),
            BannedGuard(),
        ])
        let workComments = works.grouped([
            IdentityGuard(needs: [.user], checkProfile: true),
            MutedGuard(),
            BannedGuard(),
        ])
        
        works.get("fetch-work", ":id") { request async throws -> WorkService.FetchWork in
            let id = request.parameters.get("id")!
            let sectionId: String? = request.query["sectionId"]
            return try await request.workService.fetchWork(id, sectionId: sectionId)
        }
        
        works.get("fetch-works") { request async throws -> Page<Work> in
            let query = try request.query.decode(FetchWorksQuery.self)
            if let authorId = query.authorId {
                return try await request.workService.fetchWorks(for: authorId, published: query.published ?? false, filter: query.filter ?? .restricted)
            } else {
                return try await request.workService.fetchWorks(filter: query.filter ?? .restricted)
            }
        }
        
        worksWithAuth.post("create-work") { request async throws -> Work in
            try Work.WorkForm.validate(content: request)
            let workForm = try request.content.decode(Work.WorkForm.self)
            return try await request.workService.createWork(with: workForm)
        }
        
        worksWithAuth.patch("update-work", ":id") { request async throws -> Work in
            let id = request.parameters.get("id")!
            try Work.WorkForm.validate(content: request)
            let workForm = try request.content.decode(Work.WorkForm.self)
            return try await request.workService.updateWork(id, with: workForm)
        }
        
        worksWithAuth.on(.PATCH, "update-cover", ":id", body: .collect(maxSize: "5mb")) { request async throws -> Work in
            let id = request.parameters.get("id")!
            let data = try request.content.decode(UtilityService.UploadImage.self)
            let coverUrl = try await request.utilityService.uploadImage(
                data,
                itemId: id,
                folder: "coverart"
            )
            return try await request.workService.updateCoverArt(id, coverUrl: coverUrl)
        }
        
        worksWithAuth.on(.PATCH, "update-banner", ":id", body: .collect(maxSize: "5mb")) { request async throws -> Work in
            let id = request.parameters.get("id")!
            let data = try request.content.decode(UtilityService.UploadImage.self)
            let bannerUrl = try await request.utilityService.uploadImage(
                data,
                itemId: id,
                folder: "work-banners"
            )
            return try await request.workService.updateBannerArt(id, bannerUrl: bannerUrl)
        }

        worksWithAuth.patch("publish-work", ":id") { request async throws -> Response in
            let id = request.parameters.get("id")!
            return try await request.workService.publishWork(id)
        }
        
        worksWithAuth.patch("hide-show", ":id") { request async throws -> Response in
            let id = request.parameters.get("id")!
            return try await request.workService.hideShow(id)
        }
        
        worksWithAuth.delete("delete-work", ":id") { request async throws -> HTTPResponseStatus in
            let id = request.parameters.get("id")!
            try await request.workService.deleteWork(id)
            return .ok
        }
        
        works.get(":id", "comments") { request async throws -> Page<Comment> in
            let id = request.parameters.get("id")!
            let sectionId: String? = request.query["sectionId"]
            return try await request.workService.fetchComments(for: id, sectionId: sectionId)
        }
        
        workComments.post(":id", "comments", "add") { request async throws -> Comment in
            let id = request.parameters.get("id")!
            try Comment.CommentForm.validate(content: request)
            let commentForm = try request.content.decode(Comment.CommentForm.self)
            return try await request.workService.addComment(for: id, with: commentForm)
        }
        
        workComments.patch(":id", "comments", ":commentId", "edit") { request async throws -> Comment in
            let id = request.parameters.get("id")!
            let commentId = request.parameters.get("commentId")!
            try Comment.CommentForm.validate(content: request)
            let commentForm = try request.content.decode(Comment.CommentForm.self)
            return try await request.workService.editComment(commentId, for: id, with: commentForm)
        }
    }
}

extension WorkController {
    struct FetchWorksQuery: Content {
        var authorId: String?
        var published: Bool?
        var filter: ContentFilter?
        var page: Int?
        var per: Int?
    }
}
