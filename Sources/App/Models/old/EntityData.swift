
import Vapor
import FluentPostgreSQL

final class EntityData: Codable {
    public static var entity: String {
        return "entity_data"
    }
    var id: UUID?
    var storedEntity: String!
    var entityField: String!
    var value: String!
    init(id: UUID, storedEntity: String, entityField: String, value: String) {
        self.id = id
        self.storedEntity = storedEntity
        self.entityField = entityField
        self.value = value
    }
}


extension EntityData: PostgreSQLUUIDModel {
    typealias Database = PostgreSQLDatabase
    typealias ID = UUID
    public static var idKey: IDKey = \EntityData.id
}

extension EntityData: Content, Migration, Parameter {}
