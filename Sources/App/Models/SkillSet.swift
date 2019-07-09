import Vapor
import FluentPostgreSQL

final class SkillSet: Codable {
    public static var entity: String {
        return "skillset"
    }
    var id          : UUID?
    var title       : String!
    var creator     : Person.ID!
    var skills      : [Skill.ID]?
    var pool        : Pool.ID?
    init(id: UUID, title: String, creator: Person.ID, skills: [Skill.ID], pool: Pool.ID) {
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


