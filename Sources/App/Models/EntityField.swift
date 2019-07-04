
import Vapor
import FluentSQLite

final class EntityField: Codable {
    var id: UUID?
    var entity: String!
    var name: String!
    init(id: UUID, entity: String, name: String) {
        self.id = id
        self.entity = entity
        self.name = name
    }
}

extension EntityField: SQLiteUUIDModel {
    typealias Database = SQLiteDatabase
    typealias ID = UUID
    public static var idKey: IDKey = \EntityField.id
}

extension EntityField: Content {}
