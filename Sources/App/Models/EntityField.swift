
import Vapor
import FluentPostgreSQL

final class EntityField: Codable {
    public static var entity: String {
        return "entity_field"
    }
    var id: UUID?
    var entity: String!
    var name: String!
    init(id: UUID, entity: String, name: String) {
        self.id = id
        self.entity = entity
        self.name = name
    }
}

extension EntityField: PostgreSQLUUIDModel {
    typealias Database = PostgreSQLDatabase
    typealias ID = UUID
    public static var idKey: IDKey = \EntityField.id
}

extension EntityField: Content, Migration, Parameter {}
