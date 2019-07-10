import Vapor
import FluentPostgreSQL

final class Skill: Codable {
    public static var entity: String {
        return "skill"
    }
    var id          : UUID?
    var title       : String!
    var skillset    : SkillSet.ID!
    var aggregate   : Bool
    init(id: UUID, title: String, skillset: SkillSet.ID, aggregate: Bool) {
        self.id          = id
        self.title       = title
        self.skillset    = skillset
        self.aggregate   = aggregate
    }
}

extension Skill: PostgreSQLUUIDModel {
    typealias Database = PostgreSQLDatabase
    typealias ID = UUID
    public static var idKey: IDKey = \Skill.id
}

extension Skill: Content, Parameter {}

extension Skill: Migration {
    public static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.title)
        }
    }
}

extension PartialKeyPath where Root == Skill {
    var stringValue: String {
        switch self {
        case \Skill.id          : return "id"
        case \Skill.title        : return "title"
        case \Skill.skillset     : return "skillset"
        case \Skill.aggregate    : return "aggregate"
        default: fatalError("Unexpected key path")
        }
    }
}
