//
//  Created by Alyx Mote on 1/21/23.
//

import Foundation
import Vapor
import Fluent

final class EmailConfirmation: Model, Content {
    static let schema = "email_confirmations"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "account_id")
    var account: Account
    
    @Field(key: "confirmation_code")
    var confirmationCode: String
    
    @Field(key: "used")
    var used: Bool
    
    @Field(key: "expires_on")
    var expiresOn: Date
    
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?
    
    init() { }
    
    init(id: UUID? = nil, code: String) {
        self.id = id
        self.confirmationCode = code
        used = false
        expiresOn = Date(timeIntervalSinceNow: ACCOUNT_UPDATE_EXPIRATION)
    }
}

extension EmailConfirmation {
    struct EmailConfirmationForm: Content, Validatable {
        var accountId: UUID
        var confirmCode: String
        
        static func validations(_ validations: inout Validations) {
            validations.add("accountId", as: UUID.self, is: .valid, required: true)
            validations.add("confirmCode", as: String.self, required: true)
        }
    }
}
