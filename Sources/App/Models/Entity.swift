
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

 extension Entity: Content, Migration, Parameter {}
