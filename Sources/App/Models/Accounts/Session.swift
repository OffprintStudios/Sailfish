//
// Created by Alyx Mote on 7/21/22.
//

import Vapor
import Fluent
import JWT

final class Session: Model, Content {
    static let schema = "sessions"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "account_id")
    var account: Account

    @Field(key: "device_info")
    var deviceInfo: DeviceInfo

    @Field(key: "expires")
    var expires: Date

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, via deviceInfo: DeviceInfo, expires: Date) {
        self.id = id
        self.deviceInfo = deviceInfo
        self.expires = expires
    }
}

extension Session {
    struct DeviceInfo: Codable {
        var browser: String
        var ipAddr: String
        var os: String

        init(browserName: String, browserVer: String, ipAddr: String, osName: String, osVer: String) {
            browser = browserName + " " + browserVer
            self.ipAddr = ipAddr
            os = osName + " " + osVer
        }
    }

    struct TokenPayload: JWTPayload {
        enum CodingKeys: String, CodingKey {
            case subject = "sub"
            case expiration = "exp"
            case accountId = "accountId"
            case accessKey = "accessKey"
        }

        var subject: SubjectClaim
        var expiration: ExpirationClaim
        var accountId: UUID?
        var accessKey: UUID

        func verify(using signer: JWTSigner) throws {
            try expiration.verifyNotExpired()
        }
    }

    struct ClientPackage: Content {
        var account: ClientAccount
        var profiles: [Profile]
        var token: String
    }
}
