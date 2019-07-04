
import Vapor
import FluentSQLite

final class Entity: Codable, Migration {
    var id: UUID?
    var name: String!
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}

extension Entity: SQLiteUUIDModel {
    typealias Database = SQLiteDatabase
    typealias ID = UUID
    public static var idKey: IDKey = \Entity.id
}

 extension Entity: Content {}
