//
//  Review.swift
//  
//
//  Created by Alyx Mote on 8/26/23.
//

import Vapor
import Fluent
import SwiftSoup
import NanoID

final class Review: Content, Model {
    static let schema = "reviews"
    
    @ID(custom: FieldKeys.id, generatedBy: .user)
    var id: String?
    
    @Parent(key: FieldKeys.work)
    var work: Work
    
    @Parent(key: FieldKeys.profile)
    var profile: Profile
    
    @Parent(key: FieldKeys.section)
    var section: Section
    
    @Field(key: FieldKeys.body)
    var body: String
    
    @Field(key: FieldKeys.recommended)
    var recommended: Bool
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: FieldKeys.updatedAt, on: .update)
    var updatedAt: Date?
    
    @Timestamp(key: FieldKeys.deletedAt, on: .delete)
    var deletedAt: Date?
    
    init() { }
    
    init(id: String? = nil, with formInfo: ReviewForm) {
        self.id = id
        self.$work.id = formInfo.workId
        self.$section.id = formInfo.sectionId
        self.body = formInfo.body
        self.recommended = formInfo.recommended
    }
}

extension Review {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            return try await database.schema(Review.schema)
                .field(FieldKeys.id, .string, .identifier(auto: false))
                .field(FieldKeys.work, .string, .required, .references(Work.schema, Work.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.profile, .string, .required, .references(Profile.schema, Profile.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.section, .string, .required, .references(Section.schema, Section.FieldKeys.id, onDelete: .cascade))
                .field(FieldKeys.body, .string, .required)
                .field(FieldKeys.recommended, .bool, .required)
                .field(FieldKeys.createdAt, .datetime)
                .field(FieldKeys.updatedAt, .datetime)
                .field(FieldKeys.deletedAt, .datetime)
                .create()
        }
        
        func revert(on database: Database) async throws {
            return try await database.schema(Review.schema).delete()
        }
    }
    
    struct Middleware: AsyncModelMiddleware {
        func create(model: Review, on db: Database, next: AnyAsyncModelResponder) async throws {
            if let hasId = model.id {
                model.id = hasId
            } else {
                model.id = NanoID.with(size: NANO_ID_SIZE)
            }
            model.body = try SwiftSoup.clean(model.body, defaultWhitelist())!
            try await next.create(model, on: db)
        }
        
        func update(model: Review, on db: Database, next: AnyAsyncModelResponder) async throws {
            model.body = try SwiftSoup.clean(model.body, defaultWhitelist())!
            try await next.update(model, on: db)
        }
    }
    
    struct ReviewForm: Content {
        let workId: String
        let sectionId: String
        let body: String
        let recommended: Bool
    }
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let work: FieldKey = "work_id"
        static let profile: FieldKey = "profile_id"
        static let section: FieldKey = "section_id"
        static let body: FieldKey = "body"
        static let recommended: FieldKey = "recommended"
        static let createdAt: FieldKey = "created_at"
        static let updatedAt: FieldKey = "updated_at"
        static let deletedAt: FieldKey = "deleted_at"
    }
}
