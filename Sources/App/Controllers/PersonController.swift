import Vapor


/// Controls basic CRUD operations on `Entity`s.
final class PersonController {
    /// Returns a list of all entities.
    func list(_ req: Request) throws -> Future<[Person]> {
        return Person.query(on: req).all()
    }
    
    /// Saves a decoded `Entity` to the database.
    func insert(_ req: Request) throws -> Future<Person> {
        return try req.content.decode(Entity.self).flatMap { entity in
            return entity.save(on: req)
        }
    }
    
    func deleteEntity(entity: Entity, req: Request) -> EventLoopFuture<Void>  {
        print("going to delete \(entity) ...")
        return entity.delete(on: req)
    }
    
    /// Deletes a parameterized Entity.
    
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Entity.self).flatMap { entity in
            return entity.delete(on: req)
        }.transform(to: .ok)
    }
}

