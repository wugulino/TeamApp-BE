
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
    
	
     /// Deletes a parameterized Entity.
	func deleteEntity(_ req: Request, entity: Entity) throws -> Future<String> {
		print("entrei no deleteEntity")
		let entityID = entity.id
		return Entity.find(entityID!, on: req).flatMap {
			maybeEntity in
				guard let entity = maybeEntity else {
					throw Abort(.notFound)
				}
			return entity.delete(on: req).map {
				print("deleted entity: \(entity.id!)")
				return "OK"
			}
		}
	}
    
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Entity.self).flatMap { entity in
            return entity.delete(on: req)
        }.transform(to: .ok)
    }
 }
