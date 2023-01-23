//
//  Created by Alyx Mote on 1/17/23.
//

import Foundation
import Vapor
import Fluent
import Queues
import SendGrid

struct NewEmail: Codable {
    var to: String
    var subject: String
    var kind: EmailKind
    var context: [String: String]
    
    enum EmailKind: Codable {
        case confirmEmail
        case resetPassword
        case notifyUser
    }
}

struct AddEmailJob: AsyncJob {
    typealias Payload = NewEmail
    
    func dequeue(_ context: QueueContext, _ payload: Payload) async throws {
        var template: Optional<String>
        switch payload.kind {
        case .confirmEmail:
            template = Environment.get("CONFIRM_EMAIL_TEMPLATE")
            break
        case .resetPassword:
            template = Environment.get("RESET_PASSWORD_TEMPLATE")
            break
        case .notifyUser:
            template = Environment.get("NOTIFY_USER_TEMPLATE")
            break
        }
        let emailConfig: Personalization = .init(
            to: [.init(email: payload.to)],
            subject: payload.subject,
            dynamicTemplateData: payload.context
        )
        let email: SendGridEmail = .init(
            personalizations: [emailConfig],
            from: .init(email: "beatriz@offprint.net"),
            templateId: template
        )
        try await context.application.sendgrid.client.send(email: email)
    }
}
