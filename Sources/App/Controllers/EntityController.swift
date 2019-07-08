
import Vapor


/// Controls basic CRUD operations on `Entity`s.
 final class EntityController {
 /// Returns a list of all entities.
     func list(_ req: Request) throws -> Future<[Entity]> {
        return Entity.query(on: req).all()
    }
    
     /// Saves a decoded `Entity` to the database.
     func save(_ req: Request) throws -> Future<Entity> {
        return try req.content.decode(Entity.self).flatMap { entity in
            return entity.save(on: req)
        }
     }
    
    func deleteEntity(_ req: Request) throws -> Future<HTTPStatus>  {
		return try req.parameters.next(Entity.self).flatMap {e in return e.delete(on: req)}.transform(to: .ok)
    }
    
     /// Deletes a parameterized Entity.
}
