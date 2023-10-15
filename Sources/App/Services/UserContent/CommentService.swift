//
//  Created by Alyx Mote on 8/6/23.
//

import Vapor
import Fluent

struct CommentService {
    let request: Request
    
    func fetchHistory(_ commentId: String) async throws -> [CommentHistory] {
        guard let comment = try await Comment.find(commentId, on: request.db) else {
            throw Abort(.notFound, reason: "The comment you're trying to look up does not exist.")
        }
        
        return try await comment.$history.query(on: request.db).all()
    }

    func fetchVotes(for profileId: String, across commentIds: [String]) async throws -> [CommentVote] {
        
    }
    
    func adjustVote(_ commentId: String, rating: CommentVote.Rating) async throws -> CommentVote{
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let comment = try await Comment.find(commentId, on: request.db) else {
            throw Abort(.notFound, reason: "The comment you're trying to modify does not exist.")
        }
        try await request.db.transaction { database in
            try await comment.$votes.query(on: database)
                .filter(\.$profile.$id == profile.requireID())
                .delete()
        }
        let newVote = CommentVote(from: try profile.requireID(), rating: rating)
        try await request.db.transaction { database in
            try await comment.$votes.create(newVote, on: database)
        }
        return newVote
    }
    
    func removeVote(_ commentId: String) async throws -> HTTPResponseStatus {
        let profile = try request.authService.getUser(withProfile: true).profile!
        guard let comment = try await Comment.find(commentId, on: request.db) else {
            throw Abort(.notFound, reason: "The comment you're trying to modify does not exist.")
        }
        try await request.db.transaction { database in
            try await comment.$votes.query(on: database)
                .filter(\.$profile.$id == profile.requireID())
                .delete()
        }
        return .ok
    }
}

extension Request {
    var commentService: CommentService {
        .init(request: self)
    }
}
