import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    router.get("hello", "vapor") { req -> String in
        return "Hello Vapor!"
    }
    
    router.post(LoginData.self, at: "login") { req, data -> String in
        return "Hello \(data.username), your password is \(data.password)!"
    }
    
    router.post(LoginData.self, at: "login2") { req, data -> LoginResponse in
        return LoginResponse(request: data)
    }
    
    // Link to save entities
    router.post("api", "entities") { req -> Future<Entity> in
        return try req.content.decode(Entity.self)
            .flatMap(to: Entity.self) { entity in
                print("saved entity: \(entity)")
                return entity.save(on: req)
        }        
    }
    
    router.get("api","list") { req -> Future< [Entity] > in
        return  Entity.query(on: req).all()
    }

    // Example of configuring a controller
    
    
    let entityController = EntityController()
    router.get("entity", use: entityController.list)
    router.post("entity", use: entityController.save)
    router.delete("entity", Entity.parameter, use: entityController.delete)
}


struct LoginData: Content {
    let username: String
    let password: String
}

struct LoginResponse: Content {
    let request: LoginData
}

/*
 
 GET https://localhost:8080/api/acronyms/: get all the acronyms.
 POST https://localhost:8080/api/acronyms: create a new acronym.
 GET https://localhost:8080/api/acronyms/1: get the acronym with ID 1.
 PUT https://localhost:8080/api/acronyms/1: update the acronym with ID 1.
 DELETE https://localhost:8080/api/acronyms/1: delete the acronym with ID 1.
 
 */
