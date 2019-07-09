import Vapor
import FluentPostgreSQL

final class Endorsement: Codable {
    public static var entity: String {
        return "endorsement"
    }
    var id          : UUID?
    var fromPerson  : Person.ID?
    var toPerson    : Person.ID!
    var campaign    : Campaign.ID!
    var description : String?
    var value       : Int!
    
    init(id: UUID, fromPerson: Person.ID?, toPerson: Person.ID, campaign: Campaign.ID, description: String, value: Int) {
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



