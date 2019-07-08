import Vapor
import FluentPostgreSQL

final class Endorsement: Codable {
    public static var entity: String {
        return "endorsement"
    }
    var id          : UUID?
    var fromPerson  : UUID?
    var toPerson    : UUID!
    var campaign    : UUID!
    var description : String?
    var value       : Int!
    
    init(id: UUID, fromPerson: UUID?, toPerson: UUID, campaign: UUID, description: String, value: Int) {
        self.id          = id
        self.fromPerson  = fromPerson
        self.toPerson    = toPerson
        self.campaign    = campaign
        self.description = description
        self.value       = value
    }
}

extension Endorsement: PostgreSQLUUIDModel {
    typealias Database = PostgreSQLDatabase
    typealias ID = UUID
    public static var idKey: IDKey = \Endorsement.id
}

extension Endorsement: Content, Parameter, Migration {}



