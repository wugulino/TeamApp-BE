
import Vapor


/// Controls basic CRUD operations on `Entity`s.
 final class EntityController {
 /// Returns a list of all entities.
     func index(_ req: Request) throws -> Future<[Entity]> {
        return Entity.query(on: req).all()
    }
    
     /// Saves a decoded `Entity` to the database.
     func create(_ req: Request) throws -> Future<Entity> {
        return try req.content.decode(Entity.self).flatMap { entity in
            return entity.save(on: req)
        }
     }
    
     /// Deletes a parameterized `Todo`.
     /*func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Entity.self).flatMap { entity in
            return entity.delete(on: req)
        }.transform(to: .ok)
     }*/
 }
