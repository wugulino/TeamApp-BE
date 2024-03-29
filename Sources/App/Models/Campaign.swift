import Vapor
import FluentPostgreSQL

final class Campaign: Codable {
    public static var entity: String {
        return "campaign"
    }
    var id: UUID?
    var title: String!
    var description: String!
    var groups: [Group.ID]?
    var admins: [Person.ID]?
    init(id: UUID, name: String, description: String, groups: [Group.ID], admins: [Person.ID]) {
        self.id          = id
        self.title       = name
        self.description = description
        self.groups      = groups
        self.admins      = admins
    }
}

extension Campaign: PostgreSQLUUIDModel {
    typealias Database = PostgreSQLDatabase
    typealias ID = UUID
    public static var idKey: IDKey = \Campaign.id
}

extension Campaign: Content, Parameter {}

extension Campaign: Migration {
    public static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.title)
        }
    }
}

extension PartialKeyPath where Root == Campaign {
    var stringValue: String {
        switch self {
        case \Campaign.id			: return "id"
        case \Campaign.title    	: return "title"
        case \Campaign.description  : return "description"
        case \Campaign.groups      	: return "groups"
        case \Campaign.admins   	: return "admins"
        default: fatalError("Unexpected key path")
        }
    }
}
