import Vapor
import JWT
import struct Foundation.UUID
import struct Foundation.Date

struct SessionToken: Content, Authenticatable, JWTPayload {
    // Token Data
    var expiration: ExpirationClaim
    var accountId: UUID

    init(accountId: UUID, roles: [Account.Roles], duration: SessionDuration) {
        self.accountId = accountId
        self.expiration = switch duration {
            case .long:
                ExpirationClaim(value: Date().addingTimeInterval(LONG_SESSION))
            case .short:
                ExpirationClaim(value: Date().addingTimeInterval(SHORT_SESSION))
        }
    }

    init(for account: Account, duration: SessionDuration) throws {
        self.accountId = try account.requireID()
        self.expiration = switch duration {
            case .long:
                ExpirationClaim(value: Date().addingTimeInterval(LONG_SESSION))
            case .short:
                ExpirationClaim(value: Date().addingTimeInterval(SHORT_SESSION))
        }
    }

    func verify(using signer: JWTSigner) throws {
        try expiration.verifyNotExpired()
    }
}

extension SessionToken {
    enum SessionDuration: String, Codable {
        case long = "long"
        case short = "short"
    }
}