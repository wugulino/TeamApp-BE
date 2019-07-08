
import Vapor
import FluentPostgreSQL

final class Entity: Codable {
    public static var entity: String {
        return "entity"
    }
    var id: UUID?
    var name: String!
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

extension Entity: PostgreSQLUUIDModel {
    typealias Database = PostgreSQLDatabase
    typealias ID = UUID
    public static var idKey: IDKey = \Entity.id
}

 extension Entity: Content, Parameter {}

extension Entity: Migration {
    public static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.name)
//            builder.unique(on: \.email)
        }
    }
}
