//
//  Created by Alyx Mote on 1/21/23.
//

import Foundation
import Vapor
import Fluent

final class PasswordReset: Model, Content {
    static let schema = "password_resets"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "account_id")
    var account: Account
    
    @Field(key: "recovery_code")
    var recoveryCode: String
    
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
        self.recoveryCode = code
        used = false
        expiresOn = Date(timeIntervalSinceNow: ACCOUNT_UPDATE_EXPIRATION)
    }
}

extension PasswordReset {
    struct PasswordResetForm: Content, Validatable {
        var accountId: UUID
        var resetCode: String
        var newPassword: String
        
        static func validations(_ validations: inout Validations) {
            validations.add("accountId", as: UUID.self, is: .valid, required: true)
            validations.add("resetCode", as: String.self, required: true)
            validations.add("newPassword", as: String.self, is: .alphanumeric)
            validations.add("newPassword", as: String.self, is: .count(8...))
        }
    }
}
