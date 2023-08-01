//
//  Created by Alyx Mote on 7/31/23.
//

import Vapor
import Fluent
import SQLKit

final class SectionList: Model, Content {
    static let schema = "section_list"
    
    @ID(custom: FieldKeys.id, generatedBy: .user)
    var id: String?
    
    @Parent(key: FieldKeys.workId)
    var work: Work
    
    @OptionalParent(key: FieldKeys.volumeId)
    var volume: Volume?
    
    @OptionalField(key: FieldKeys.volumeTitle)
    var volumeTitle: String?
    
    @Field(key: FieldKeys.title)
    var title: String
    
    @Field(key: FieldKeys.words)
    var words: Int64
    
    @Field(key: FieldKeys.cheers)
    var cheers: Int64
    
    @Field(key: FieldKeys.comments)
    var comments: Int64
    
    @Field(key: FieldKeys.lang)
    var lang: Language
    
    @Field(key: FieldKeys.rank)
    var rank: Int64
    
    @Field(key: FieldKeys.publishedOn)
    var publishedOn: Date?
    
    @Timestamp(key: FieldKeys.createdAt, on: .create)
    var createdAt: Date?
    
    init() { }
}

extension SectionList {
    struct Create: AsyncMigration {
        func prepare(on database: Database) async throws {
            let sqlDb = database as! SQLDatabase
            
            let query = sqlDb.raw("""
                CREATE VIEW "\(raw: SectionList.schema)" AS
                    SELECT  section.id,
                            work.id AS \(raw: FieldKeys.workId.description),
                            volume.id AS \(raw: FieldKeys.volumeId.description),
                            volume.title AS \(raw: FieldKeys.volumeTitle.description),
                            section.title AS \(raw: FieldKeys.title.description),
                            section.words AS \(raw: FieldKeys.words.description),
                            COUNT(cheer.id) AS \(raw: FieldKeys.cheers.description),
                            COUNT(comment.id) AS \(raw: FieldKeys.comments.description),
                            section.lang AS \(raw: FieldKeys.lang.description),
                            section.rank AS \(raw: FieldKeys.rank.description),
                            section.published_on AS \(raw: FieldKeys.publishedOn.description),
                            section.created_at AS \(raw: FieldKeys.createdAt.description)
                    FROM sections section
                    LEFT JOIN section_cheers cheer ON section.id = cheer.section_id
                    LEFT JOIN works work ON section.work_id = work.id
                    LEFT JOIN volumes volume ON section.volume_id = volume.id
                    LEFT JOIN comments comment ON comment.section_id = section.id
                    GROUP BY section.id, work.id, volume.id
            """)
            
            try await query.run()
        }
        
        func revert(on database: Database) async throws {
            let sqlDb = database as! SQLDatabase
            try await sqlDb.raw("DROP VIEW \(raw: SectionView.schema)").run()
        }
    }
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let workId: FieldKey = "work_id"
        static let volumeId: FieldKey = "volume_id"
        static let volumeTitle: FieldKey = "volume_title"
        static let title: FieldKey = "title"
        static let words: FieldKey = "words"
        static let cheers: FieldKey = "cheers"
        static let comments: FieldKey = "comments"
        static let lang: FieldKey = "lang"
        static let rank: FieldKey = "rank"
        static let publishedOn: FieldKey = "published_on"
        static let createdAt: FieldKey = "created_at"
    }
}
