/*

import Vapor


/// Controls basic CRUD operations on `Entity`s.
final class PersonController: ControllerProtocol {
	func find(_ req: Request) throws -> Future<Person> {
		// return Future<Person>
		return nil
	}
	
	func update(_ req: Request) throws -> Future<Person> {
		// return Future<Person>
		return nil
	}
	
    /// Returns a list of all entities.
    func list(_ req: Request) throws -> Future<[Person]> {
        return Person.query(on: req).all()
    }
    
    /// Saves a decoded `Entity` to the database.
    func insert(_ req: Request) throws -> Future<Person> {
        return try req.content.decode(Person.self).flatMap { person in
            return person.save(on: req)
        }
    }
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Person.self).flatMap { person in
            return person.delete(on: req)
        }.transform(to: .ok)
    }
}

*/
