//
// Created by Alyx Mote on 7/29/22.
//

import Foundation
import Vapor
import Fluent
import SwiftSoup
import NanoID
import Argon2Swift

/// Offprint Account Service
///
/// Contains functions dedicated to the processing of account-related requests, such as
/// information updates, profile creation, and more.
struct AccountService {
    let request: Request

    /// Fetches a user's profile by its ID
    func fetchProfile(_ id: String) async throws -> Profile {
        let account = try request.authService.getUser().account
        guard let profile = try await account.$profiles.query(on: request.db).filter(\.$id == id).first() else {
            throw Abort(.notFound, reason: "Could not find the specified profile.")
        }
        return profile
    }

    /// Fetches all profiles belonging to a user
    func fetchProfiles() async throws -> [Profile] {
        let account = try request.authService.getUser().account
        return try await account.$profiles.get(on: request.db)
    }

    /// Creates a new profile for a user
    func createProfile(with profileForm: Profile.ProfileForm) async throws -> Profile {
        let account = try request.authService.getUser().account
        let existingUser = try await Profile.query(on: request.db).filter(\.$username == profileForm.username).first()
        
        if existingUser != nil {
            throw Abort(.conflict, reason: "This username has already been taken.")
        }
        
        try await account.$profiles.load(on: request.db)
        if account.profiles.count == MAX_PROFILE_LIMIT {
            throw Abort(.conflict, reason: "Only \(MAX_PROFILE_LIMIT) profiles are allowed per account.")
        }
        
        let newProfile = try Profile(from: profileForm)
        try await account.$profiles.create(newProfile, on: request.db)
        return newProfile
    }
    
    /// Sends a password reset email
    func sendPasswordResetEmail(accountId: UUID) async throws -> Response {
        guard let account = try await Account.find(accountId, on: request.db) else {
            return .init(status: .ok)
        }
        let resetCode = NanoID.with(size: NANO_ID_SIZE)
        let recovery = PasswordReset(code: resetCode)
        try await request.db.transaction { database in
            try await account.$recovery.create(recovery, on: database)
        }
        try await request.queue.dispatch(AddEmailJob.self, .init(
            to: account.email,
            subject: "Reset Your Password — Offprint",
            kind: .resetPassword,
            context: ["url": "https://offprint.net/recovery/reset-password?userId=\(try account.requireID())&token=\(resetCode)"]
        ))
        return .init(status: .ok)
    }
    
    /// Sends a confirmation email
    func sendConfirmationEmail() async throws -> Response {
        let account = try request.authService.getUser().account
        let confirmCode = NanoID.with(size: NANO_ID_SIZE)
        let confirmation = EmailConfirmation(code: confirmCode)
        try await request.db.transaction { database in
            try await account.$confirmation.create(confirmation, on: database)
        }
        try await request.queue.dispatch(AddEmailJob.self, .init(
            to: account.email,
            subject: "Confirm Your Email Address — Offprint",
            kind: .confirmEmail,
            context: ["url": "https://offprint.net/recovery/confirm-email?userId=\(try account.requireID())&token=\(confirmCode)"]
        ))
        return .init(status: .ok)
    }
    
    /// Resets a user's password
    func resetPassword(with formInfo: PasswordReset.PasswordResetForm) async throws -> Response {
        guard let account = try await Account.find(formInfo.accountId, on: request.db) else {
            return .init(status: .ok)
        }
        guard let resetPassword = try await account.$recovery.query(on: request.db).filter(\.$recoveryCode == formInfo.resetCode).filter(\.$used == false).filter(\.$expiresOn < Date()).first() else {
            return .init(status: .ok)
        }
        guard let hashedPassword = try? Argon2Swift.hashPasswordString(password: formInfo.newPassword, salt: Salt.newSalt(), type: Argon2Type.id) else {
            return .init(status: .ok)
        }
        account.password = hashedPassword.encodedString().trimmingCharacters(in: CharacterSet(charactersIn: "\0"))
        resetPassword.used = true
        try await request.db.transaction { database in
            try await account.save(on: database)
            try await resetPassword.save(on: database)
        }
        return .init(status: .ok)
    }
    
    /// Confirms a user's email
    func confirmEmail(with formInfo: EmailConfirmation.EmailConfirmationForm) async throws -> ClientAccount {
        let account = try request.authService.getUser().account
        guard let confirmation = try await account.$confirmation.query(on: request.db).filter(\.$confirmationCode == formInfo.confirmCode).filter(\.$used == false).filter(\.$expiresOn < Date()).first() else {
            throw Abort(.badRequest, reason: "You haven't initiated any confirmation process.")
        }
        account.emailConfirmed = true
        confirmation.used = true
        try await request.db.transaction { database in
            try await account.save(on: database)
            try await confirmation.save(on: database)
        }
        return ClientAccount(from: account)
    }
    
    /// Sets the `termsAgree` account flag to `true`
    func agreeToTerms() async throws -> ClientAccount {
        let account = try request.authService.getUser().account
        account.termsAgree = true
        try await request.db.transaction { database in
            try await account.save(on: database)
        }
        return .init(from: account)
    }

    /// Soft-deletes a given profile
    func deleteProfile(_ id: String) async throws {
        let account = try request.authService.getUser().account
        try await account.$profiles.query(on: request.db).filter(\.$id == id).delete()
    }
}

extension Request {
    var accountService: AccountService {
        .init(request: self)
    }
}
