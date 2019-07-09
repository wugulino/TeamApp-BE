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

