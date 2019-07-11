import Vapor
import FluentPostgreSQL

/// Controls basic CRUD operations on `Entity`s.
final class PersonController: ControllerProtocol {
    func find(_ id: UUID, on req: Request) throws -> EventLoopFuture<Person?> {
        return Person.find(id, on: req)
    }
    
    func list(_ req: Request) throws -> Future<[Person]> {
        return Person.query(on: req).all()
    }
    
    func insert(_ newItem: Person, on req: Request) throws -> Future<Person> {
        return newItem.save(on: req)
    }
    
    func modify(_ newValue: Person, on req: Request) throws -> Future<Person> {
        return newValue.update(on: req)
    }
    
    func delete(this: Person, on req: Request) throws -> String {
        let personID = this.id
        return Person.find(personID!, on: req).flatMap {
            maybePerson in
            guard let this = maybePerson else {
                return "ERROR: Person not found."
            }
            return this.delete(on: req).map {
                print("deleted entity: \(this.id!)")
                return "OK"
            }
        }
    }

    func searchAND(_ req: Request, theseValues: Person) throws -> Future<[Person]> {
        do {
            
            let mirroredObject = Mirror(reflecting: theseValues)
            var rawSQLQuery: String = " SELECT * person WHERE deleted = false AND "
            var i = 1
            
            for (_, fieldName) in mirroredObject.children.enumerated() {
                if let field = fieldName.label {
                    rawSQLQuery += " AND \(field)  like $\(i) "
                    i += 1
                }
            }
            
            print(rawSQLQuery)
            let persons = req.withPooledConnection(to: .psql) { (conn) -> Future<[Person]> in
                conn.raw(rawSQLQuery).all(decoding: Person.self)
            }
            return persons
        }
    }
    
    func searchOR(_ req: Request, theseValues: Person)  throws -> Future<[Person]>{
        do {
            let mirroredObject = Mirror(reflecting: theseValues)
            var rawSQLQuery: String = " SELECT * person WHERE deleted = false AND ("
            var i = 1
            
            for (_, fieldName) in mirroredObject.children.enumerated() {
                let disjunction: String = (i > 1) ? " OR " : ""
                if let field = fieldName.label {
                    rawSQLQuery += disjunction + "  \(field)  like $\(i) "
                    i += 1
                }
            }
            
            rawSQLQuery += ")"
            print(rawSQLQuery)
            let persons = req.withPooledConnection(to: .psql) { (conn) -> Future<[Person]> in
                conn.raw(rawSQLQuery).all(decoding: Person.self)
            }
            return persons
        }
    }
    
}

/*
 func getByDate(_ request: Request) throws -> Future<[Post]> {
 let day = 13, month = 3, year = 2018
 let components = DateComponents(calendar: Calendar.current, timeZone: nil, era: nil, year: year, month: month, day: day, hour: 0, minute: 0, second: 0, nanosecond: 0, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
 guard let marchThirteenth = components.date else { throw Abort.init(HTTPStatus.badRequest, reason: "invalid date", identifier: nil)}
 return Post.query(on: request).filter(\Post.created_at > marchThirteenth).all()
 }
 */
