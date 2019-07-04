
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
    
    func deleteEntity(entity: Entity, req: Request) -> EventLoopFuture<Void>  {
        print("going to delete \(entity) ...")
        return entity.delete(on: req)
    }
    
     /// Deletes a parameterized Entity.
    func delete(_ req: Request, entity: Entity) throws -> Future<HTTPStatus> {
        print("entrou aqui")
        return try req.parameters.next(Entity.self).flatMap {
            entity in return self.deleteEntity(entity: entity, req: req)  //entity.delete(on: req)
        }.transform(to: .ok)
     }
 }
