import Vapor
import FluentPostgreSQL

final class Group: Codable {
    public static var entity: String {
        return "group"
    }
    var id          : UUID?
    var name        : String!
    var campaign    : Campaign.ID!
    
    init(id: UUID, name: String, campaign: Campaign.ID) {
        self.id          = id
        self.name        = name
        self.campaign    = campaign
    }
}

extension Group: PostgreSQLUUIDModel {
    typealias Database = PostgreSQLDatabase
    typealias ID = UUID
    public static var idKey: IDKey = \Group.id
}

extension Group: Content, Parameter {}

extension Group: Migration {
    public static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.name, \.campaign)
        }
    }
}

extension PartialKeyPath where Root == Group {
    var stringValue: String {
        switch self {
        case \Group.id       : return "id"
        case \Group.name     : return "group"
        case \Group.campaign : return "role"
        default: fatalError("Unexpected key path")
        }
    }
}
