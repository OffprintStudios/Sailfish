//
//  SessionToken.swift
//
//
//  Created by Alyx Mote on 11/27/23.
//

import Vapor
import JWT

struct SessionToken: Content, Authenticatable, JWTPayload {
    // Token Data
    var expiration: ExpirationClaim
    var accountId: UUID
    
    init(accountId: UUID) {
        self.accountId = accountId
        self.expiration = ExpirationClaim(value: Date().addingTimeInterval(LONG_SESSION))
    }
    
    init(account: Account) throws {
        self.accountId = try account.requireID()
        self.expiration = ExpirationClaim(value: Date().addingTimeInterval(LONG_SESSION))
    }
    
    func verify(using signer: JWTSigner) throws {
        try expiration.verifyNotExpired()
    }
}
