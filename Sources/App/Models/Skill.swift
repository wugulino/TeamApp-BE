import Vapor
import FluentPostgreSQL

final class Skill: Codable {
    public static var entity: String {
        return "skill"
    }
    var id          : UUID?
    var title       : String!
    var skillset    : UUID!
    var aggregate   : Bool
    init(id: UUID, title: String, skillset: UUID, aggregate: Bool) {
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
