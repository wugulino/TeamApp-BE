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
    var pools           : [Pool.ID]?
    var skills          : [Skill.ID]?
    var passwordHash    : String?
    var deleted         : Bool
	
	static let formDateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.calendar = Calendar(identifier: .iso8601)
		formatter.locale = Locale(identifier: "en_US_POSIX")
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		formatter.dateFormat = "yyyy-MM-dd"
		return formatter
	}()
    
    init(id: UUID, name: String, nickname: String, sex: String, title: String, foto: String, telegramID: String, email: String, dateOfBirth: Date, shortBio: String, pools: [Pool.ID], skills: [Skill.ID], passwordHash: String, deleted: Bool) {
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
	init(from decoder: Decoder)throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		if let start = try? container.decode(String.self, forKey: .dateOfBirth), let date = Event.formDateFormatter.string(from: start) {
			self.dateOfBirth = date
		} else {
			self.dateOfBirth = try container.decode(Date.self, forKey: .dateOfBirth)
		}
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

extension PartialKeyPath where Root == Person {
    var stringValue: String {
        switch self {
            case \Person.id           : return "id"
            case \Person.name         : return "name"
            case \Person.nickname     : return "nickname"
            case \Person.sex          : return "sex"
            case \Person.title        : return "title"
            case \Person.foto         : return "foto"
            case \Person.telegramID   : return "telegramID"
            case \Person.email        : return "email"
            case \Person.dateOfBirth  : return "dateOfBirth"
            case \Person.shortBio     : return "shortBio"
            case \Person.pools        : return "pools"
            case \Person.skills       : return "skills"
            case \Person.passwordHash : return "passwordHash"
            case \Person.deleted      : return "deleted"
            default: fatalError("Unexpected key path")
        }
    }
}
