//
//  Created by Alyx Mote on 1/21/23.
//

import Vapor

/// Verifies that a user has both agreed to the ToS and has confirmed their email address.
struct ConfirmationGuard: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        let account = try request.authService.getUser().account
        if account.termsAgree == false {
            throw Abort(.forbidden, reason: "You haven't agreed to Offprint's Terms of Service and Privacy Policy")
        }
        if account.emailConfirmed == false {
            throw Abort(.forbidden, reason: "You haven't confirmed your email yet.")
        }
        return try await next.respond(to: request)
    }
}
