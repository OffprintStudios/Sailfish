import Vapor
import Fluent

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")

        auth.grouped(Account.authenticator()).post("log-in", use: self.logIn)
        auth.post("sign-up", use: self.signUp)
        auth.post("generate-reset", use: self.generateResetCode)
        auth.patch("reset-password", use: self.resetPassword)
        auth.patch("confirm-email", use: self.confirmEmail)
    }

    @Sendable
    func logIn(request: Request) async throws -> AccountObject {
        let account = try request.auth.require(Account.self)
        guard let rememberMe = request.headers.first(name: "X-Offprint-Remember-Me") else {
            throw Abort(.badRequest, reason: "Missing duration setting.")
        }

        if account.emailConfirmed {
            guard let duration = Session.Duration(rawValue: rememberMe) else {
                throw Abort(.badRequest, reason: "Malformed duration setting.")
            }

            let session = Session(duration: duration)
            try await account.$sessions.create(session, on: request.db)

            let token = try Session.Token(for: account, with: session, expiration: session.$expiresOn.value!)

            return account.toObject(with: try request.jwt.sign(token))
        } else {
            throw Abort(.methodNotAllowed, reason: "You must confirm your email before logging in.")
        }
    }

    @Sendable
    func signUp(request: Request) async throws -> HTTPStatus {
        try Account.RegisterForm.validate(content: request)
        
        let formInfo = try request.content.decode(Account.RegisterForm.self)
        if formInfo.ageCheck != true {
            throw Abort(.unauthorized, reason: "You must be at least 13 years of age or older to register.")
        }
        if formInfo.termsAgree != true {
            throw Abort(.unauthorized, reason: "You must agree to the Terms of Service, Privacy Policy, and Offprint Constitution in order to register.")
        }

        let newAccount = Account(with: formInfo)
        try await newAccount.save(on: request.db)

        let confirmationCode = ConfirmEmail(expiresOn: Date().addingTimeInterval(60 * 60)) // 1 hour as 60 seconds * 60 minutes
        try await newAccount.$confirmEmailCodes.create(confirmationCode, on: request.db)

        try await request.queue.dispatch(
            EmailJob.self, 
            .init(
                to: newAccount.$email.value!,
                name: nil, 
                token: confirmationCode.$id.value,
                kind: .confirmation
            ),
            maxRetryCount: 3
        )

        return .ok
    }

    @Sendable
    func generateResetCode(request: Request) async throws -> String { "hello world" }

    @Sendable
    func resetPassword(request: Request) async throws -> String { "hello world" }

    @Sendable
    func confirmEmail(request: Request) async throws -> String { "hello world" }
}