//
//  Created by Alyx Mote on 7/30/23.
//

import Vapor
import Fluent
import SQLKit

final class SectionView: Model, Content {
    static let schema = "section_view"
    
    @ID(custom: FieldKeys.id, generatedBy: .user)
    var id: String?
    
    @Group(key: FieldKeys.workGroup)
    var work: WorkFields
    
    @Group(key: FieldKeys.volumeGroup)
    var volume: VolumeFields
    
    @Group(key: FieldKeys.authorGroup)
    var author: AuthorFields
    
    @Group(key: FieldKeys.sectionGroup)
    var section: SectionFields
    
    init() { }
}

extension SectionView {
    final class WorkFields: Fields {
        @Field(key: FieldKeys.workId)
        var id: String
        
        @Field(key: FieldKeys.workTitle)
        var title: String
        
        @Field(key: FieldKeys.workShortDesc)
        var desc: String
        
        @OptionalField(key: FieldKeys.workCoverArt)
        var coverArt: String?
        
        init() { }
    }
    
    final class VolumeFields: Fields {
        @OptionalField(key: FieldKeys.volumeId)
        var id: String?
        
        @OptionalField(key: FieldKeys.volumeTitle)
        var title: String?
    }
    
    final class AuthorFields: Fields {
        @Field(key: FieldKeys.authorId)
        var id: String
        
        @Field(key: FieldKeys.authorName)
        var name: String
        
        @Field(key: FieldKeys.authorInfo)
        var info: Profile.Info
        
        @Field(key: FieldKeys.authorAvatar)
        var avatar: String
        
        @Field(key: FieldKeys.authorLinks)
        var links: [String: String]
        
        init() { }
    }
    
    final class SectionFields: Fields {
        @Field(key: FieldKeys.sectionTitle)
        var title: String
        
        @Field(key: FieldKeys.sectionBody)
        var body: String
        
        @Field(key: FieldKeys.sectionWords)
        var words: Int64
        
        @Field(key: FieldKeys.sectionCheers)
        var cheers: Int64
        
        @Field(key: FieldKeys.sectionComments)
        var comments: Int64
        
        @OptionalField(key: FieldKeys.sectionNoteTop)
        var noteTop: String?
        
        @OptionalField(key: FieldKeys.sectionNoteBottom)
        var noteBottom: String?
        
        @Field(key: FieldKeys.sectionLang)
        var lang: Language
        
        @Field(key: FieldKeys.sectionRank)
        var rank: Int64
        
        @OptionalField(key: FieldKeys.sectionPublishedOn)
        var publishedOn: Date?
        
        @OptionalField(key: FieldKeys.sectionFirstPublished)
        var firstPublished: Date?

        @Timestamp(key: FieldKeys.sectionCreatedAt, on: .create)
        var createdAt: Date?

        @Timestamp(key: FieldKeys.sectionUpdatedAt, on: .update)
        var updatedAt: Date?
        
        @Timestamp(key: FieldKeys.sectionDeletedAt, on: .delete)
        var deletedAt: Date?
        
        init() { }
    }
    
    enum FieldKeys {
        static let id: FieldKey = "id"
        static let workGroup: FieldKey = "work"
        static let workId: FieldKey = "id"
        static let workTitle: FieldKey = "title"
        static let workShortDesc: FieldKey = "desc"
        static let workCoverArt: FieldKey = "cover_art"
        static let volumeGroup: FieldKey = "volume"
        static let volumeId: FieldKey = "id"
        static let volumeTitle: FieldKey = "title"
        static let authorGroup: FieldKey = "author"
        static let authorId: FieldKey = "id"
        static let authorName: FieldKey = "name"
        static let authorInfo: FieldKey = "info"
        static let authorAvatar: FieldKey = "avatar"
        static let authorLinks: FieldKey = "links"
        static let sectionGroup: FieldKey = "section"
        static let sectionTitle: FieldKey = "title"
        static let sectionBody: FieldKey = "body"
        static let sectionWords: FieldKey = "words"
        static let sectionCheers: FieldKey = "cheers"
        static let sectionComments: FieldKey = "comments"
        static let sectionNoteTop: FieldKey = "note_top"
        static let sectionNoteBottom: FieldKey = "note_bottom"
        static let sectionLang: FieldKey = "lang"
        static let sectionRank: FieldKey = "rank"
        static let sectionPublishedOn: FieldKey = "published_on"
        static let sectionFirstPublished: FieldKey = "first_published"
        static let sectionCreatedAt: FieldKey = "created_at"
        static let sectionUpdatedAt: FieldKey = "updated_at"
        static let sectionDeletedAt: FieldKey = "deleted_at"
    }
    
    struct Create: AsyncMigration {
        private typealias WorkKeys = Work.FieldKeys
        private typealias VolumeKeys = Volume.FieldKeys
        private typealias AuthorKeys = Profile.FieldKeys
        private typealias SectionKeys = Section.FieldKeys
        private typealias SectionViewKeys = SectionView.FieldKeys
        private typealias CheersKeys = Cheer.FieldKeys
        private typealias CommentsKeys = Comment.FieldKeys
        
        func prepare(on database: Database) async throws {
            let sqlDb = database as! SQLDatabase
            
            let query = sqlDb.raw("""
                CREATE VIEW "\(raw: SectionView.schema)" AS
                    SELECT  section.id,
                            work.id AS work_id,
                            work.title AS work_title,
                            work.short_desc AS work_desc,
                            work.cover_art AS work_cover_art,
                            volume.id AS volume_id,
                            volume.title AS volume_title,
                            profile.id AS author_id,
                            profile.username AS author_name,
                            profile.info AS author_info,
                            profile.avatar AS author_avatar,
                            profile.links AS author_links,
                            section.title AS section_title,
                            section.body AS section_body,
                            section.words AS section_words,
                            COUNT(cheer.id) AS section_cheers,
                            COUNT(comment.id) AS section_comments,
                            section.note_top AS section_note_top,
                            section.note_bottom AS section_note_bottom,
                            section.lang AS section_lang,
                            section.rank AS section_rank,
                            section.published_on AS section_published_on,
                            section.first_published AS section_first_published,
                            section.created_at AS section_created_at,
                            section.updated_at AS section_updated_at,
                            section.deleted_at AS section_deleted_at
                    FROM sections section
                    LEFT JOIN section_cheers cheer ON section.id = cheer.section_id
                    LEFT JOIN works work ON section.work_id = work.id
                    LEFT JOIN volumes volume ON section.volume_id = volume.id
                    LEFT JOIN profiles profile ON work.author_id = profile.id
                    LEFT JOIN comments comment ON comment.section_id = section.id
                    GROUP BY section.id, work.id, profile.id, volume.id
            """)
            
            try await query.run()
        }
        
        func revert(on database: Database) async throws {
            let sqlDb = database as! SQLDatabase
            try await sqlDb.raw("DROP VIEW \(raw: SectionView.schema)").run()
        }
    }
}
