import Vapor

/// Controls basic CRUD operations on `Entity`s.
final class PersonController: ControllerProtocol {
    func find(_ id: UUID, on req: Request) throws -> EventLoopFuture<Person?> {
        return Person.find(id, on: req)
    }
    
    func list(_ req: Request) throws -> Future<[Person]> {
        return Person.query(on: req).all()
    }
    
    func insert(_ newItem: Person, on req: Request) throws -> EventLoopFuture<Person> {
        return newItem.save(on: req)
    }
    
    func update(_ newValue: Person, on req: Request) throws -> EventLoopFuture<Person> {
        return newValue.update(on: req)
    }
    
    func delete(this: Person, on req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let personID = this.id
        return Person.find(personID!, on: req).flatMap {
            maybePerson in
            guard let this = maybePerson else {
                throw Abort(.notFound)
            }
            return this.delete(on: req).map {
                print("deleted entity: \(this.id!)")
                return HTTPStatus.ok
            }
        }
    }

    func searchAND(_ req: Request, theseValues: Person, onFields: [PartialKeyPath<Person>]) throws -> EventLoopFuture<[Person]> {
        var rawSQLQuery: String = " SELECT * person WHERE deleted = false AND "
        for i in 0 ..< onFields.count {
            let value = theseValues[keyPath: onFields[i]] as! String
            rawSQLQuery += " AND " + onFields[i].stringValue + " = " + value + "  "
        }
        print(rawSQLQuery)
    }
    
    func searchOR(_ req: Request, theseValues: Person, onFields: [PartialKeyPath<Person>])  throws -> EventLoopFuture<[Person]>{
        var rawSQLQuery: String = " SELECT * person WHERE deleted = false AND ("
        for i in 0 ..< onFields.count {
            let value = theseValues[keyPath: onFields[i]] as! String
            let disjunction: String = (i > 0) ? " OR " : ""
            rawSQLQuery += disjunction + onFields[i].stringValue + " = " + value + "  "
        }
        rawSQLQuery += ")"
        print(rawSQLQuery)
    }
    
}

