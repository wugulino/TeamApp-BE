
import Vapor
import FluentSQLite

final class EntityData: Codable {
    var id: UUID?
    var entity: String!
    var entityField: String!
    var value: String!
    init(id: UUID, entity: String, entityField: String, value: String) {
        self.id = id
        self.entity = entity
        self.entityField = entityField
        self.value = value
    }
}


extension EntityData: SQLiteUUIDModel {
    typealias Database = SQLiteDatabase
    typealias ID = UUID
    public static var idKey: IDKey = \EntityData.id
}

extension EntityData: Content {}
