//
//  Created by Alyx Mote on 12/25/22.
//

import Foundation
import Fluent

protocol HasComments {
    func fetchComments(for id: String) async throws -> Page<Comment>
    func addComment(for id: String, with formInfo: Comment.CommentForm) async throws -> Comment
    func editComment(_ id: String, for itemId: String, with formInfo: Comment.CommentForm) async throws -> Comment
}
