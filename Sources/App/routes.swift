import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "TeamApp - Back End"
    }
    
    router.post(LoginData.self, at: "login") { req, data -> String in
//        Encontrar usuario no sistema e comparar senha
        return "Hello \(data.username), your password is \(data.password)!"
    }
    
    router.post(LoginData.self, at: "login2") { req, data -> LoginResponse in
        return LoginResponse(request: data)
    }

    // Example of configuring a controller
    
    
    let entityController = EntityController()
    router.get("entities", use: entityController.list)
    router.post("entity", use: entityController.save)
    
    router.post(Entity.self, at: ["entity","delete"]){
        req, entity -> Future<String> in
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
}


struct LoginData: Content {
    let username: String
    let password: String
}

struct LoginResponse: Content {
    let request: LoginData
}


/*
 
 // How to add records given a POST request
 
 router.post("api", "entities") { req -> Future<Entity> in
 return try req.content.decode(Entity.self)
 .flatMap(to: Entity.self) { entity in
 print("saved entity: \(entity)")
 return entity.save(on: req)
 }
 }
 
 // How to list all records given a GET request

 router.get("api","list") { req -> Future< [Entity] > in
 return  Entity.query(on: req).all()
 }
 
 */
