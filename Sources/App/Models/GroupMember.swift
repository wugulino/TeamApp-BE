import Vapor
import FluentPostgreSQL

final class GroupMember: Codable {
    public static var entity: String {
        return "group_member"
    }
    var id          : UUID?
    var group       : Group.ID!
    var role        : String
    var person      : Person.ID!
    
    init(id: UUID, group: Group.ID, role: String, person: Person.ID) {
        self.id     = id
        self.group  = group
        self.role   = role
        self.person = person
    }
}

extension GroupMember: PostgreSQLUUIDModel {
    typealias Database = PostgreSQLDatabase
    typealias ID = UUID
    public static var idKey: IDKey = \GroupMember.id
}

extension GroupMember: Content, Parameter {}

extension GroupMember: Migration {
    public static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.group, \.person)
        }
    }
}

extension PartialKeyPath where Root == GroupMember {
    var stringValue: String {
        switch self {
        case \GroupMember.id    : return "id"
        case \GroupMember.group : return "group"
        case \GroupMember.role  : return "role"
        case \GroupMember.person: return "person"
        default: fatalError("Unexpected key path")
        }
    }
}
