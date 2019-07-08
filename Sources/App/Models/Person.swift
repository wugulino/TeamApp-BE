import Vapor
import FluentPostgreSQL

final class Person: Codable {
    public static var entity: String {
        return "person"
    }
    var id              : UUID?
    var name            : String!
    var nickname        : String?
    var sex             : String?
    var title           : String?
    var foto            : String?
    var telegramID      : String!
    var email           : String!
    var dateOfBirth     : Date
    var shortBio        : String?
    var pools           : [UUID]?
    var skills          : [UUID]?
    var passwordHash    : String?
    var deleted         : Bool
    
    init(id: UUID, name: String, nickname: String, sex: String, title: String, foto: String, telegramID: String, email: String, dateOfBirth: Date, shortBio: String, pools: [UUID], skills: [UUID], passwordHash: String, deleted: Bool) {
        self.id           = id
        self.name         = name
        self.nickname     = nickname
        self.sex          = sex
        self.title        = title
        self.foto         = foto
        self.telegramID   = telegramID
        self.email        = email
        self.dateOfBirth  = dateOfBirth
        self.shortBio     = shortBio
        self.pools        = pools
        self.skills       = skills
        self.passwordHash = passwordHash
        self.deleted      = deleted
    }
}

extension Person: PostgreSQLUUIDModel {
    typealias Database = PostgreSQLDatabase
    typealias ID = UUID
    public static var idKey: IDKey = \Person.id
}

extension Person: Content, Parameter {}

extension Person: Migration {
    public static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return Database.create(self, on: connection) { builder in
            try addProperties(to: builder)
            builder.unique(on: \.name)
            builder.unique(on: \.email)
            builder.unique(on: \.telegramID)
        }
    }
}
