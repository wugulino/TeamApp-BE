import Vapor
import FluentPostgreSQL

final class SkillSet: Codable {
    public static var entity: String {
        return "skillset"
    }
    var id          : UUID?
    var title       : String!
    var creator     : UUID!
    var skills      : [UUID]?
    var pool        : UUID?
    init(id: UUID, title: String, creator: UUID, skills: [UUID], pool: UUID) {
        self.id          = id
        self.title       = title
        self.creator     = creator
        self.skills      = skills
        self.pool        = pool
    }
}

extension SkillSet: PostgreSQLUUIDModel {
    typealias Database = PostgreSQLDatabase
    typealias ID = UUID
    public static var idKey: IDKey = \SkillSet.id
}

extension SkillSet: Content, Parameter {}

extension SkillSet: Migration {
    public static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.title)
        }
    }
}


