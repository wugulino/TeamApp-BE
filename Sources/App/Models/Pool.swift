
import Vapor
import FluentPostgreSQL

final class Pool: Codable {
    public static var entity: String {
        return "pool"
    }
    var id: UUID?
    var title: String!
    var description: String!
    var creator: Person.ID!
    var admins: [Person.ID]?
    init(id: UUID, name: String, description: String, creator: Person.ID, admins: [Person.ID]) {
        self.id          = id
        self.title       = name
        self.description = description
        self.creator     = creator
        self.admins      = admins
    }
}

extension Pool: PostgreSQLUUIDModel {
    typealias Database = PostgreSQLDatabase
    typealias ID = UUID
    public static var idKey: IDKey = \Pool.id
}

extension Pool: Content, Parameter {}

extension Pool: Migration {
    public static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.title)
        }
    }
}

