import Vapor
import Fluent

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "TeamApp - Back End (v1 - build: 122)"
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
	// get all
    router.get("entities", use: entityController.list)
	
	// insert
    router.post("entity", use: entityController.save)
	
	// update
	//router.post(Entity.self, at: ["entity","update"]) {
	//	req, entity -> Future<Entity> in
	//	return try entityController.update(req, entity: entity)
	//}
	
	// delete
    router.post(Entity.self, at: ["entity","delete"]){
        req, entity -> Future<String> in
		return try entityController.deleteEntity(req, entity: entity)
    }
    
    
//    PERSON
    let personController = PersonController()
    // Find a person given the ID
	router.post(Person.self, at: ["person","get"]){
		(req, p) throws -> Future<Person>
		in
			return try personController.find(p.id!, on: req)
	}
	
	
    
    // List all the records
    router.get(["person","list"]) { req -> Future<[Person]> in
       return try personController.list(req)
    }
    
    // insert a record in table person given all the data (JSON) from Person.
    // ID must not be sent on the request, it will be generated, saved in database
    // and the entire record will be returned to the client in JSON format
    router.post(Person.self, at:["person","add"]) { req, person -> Future<Person> in
        return try personController.insert(person, on: req)
    }
    
    // updates Person. Person must be serialized to JSON format.
    // ID is required and must be correctly. It returns the updated state of Person
    router.post(Person.self, at:["person","update"]) { req, person -> Future<Person> in
        return try personController.modify(person, on: req)
    }
    
    // deletes one record from Person.
    // It only uses the ID field, all the other fields are ignored (even if filled/sent)
    router.post(Person.self, at:["person","delete"]) { req, person -> Future<HTTPStatus> in
        return try personController.delete(this: person, on: req).transform(to: HTTPStatus.ok)
    }
    
    // Searches and returns all Person records that match the filled data.
    // All the values sent are compared and the operator AND is used among all logical operations.
    router.post(Person.self, at:["person","searchAND"]) { req, person -> Future<[Person]> in
        return try personController.searchAND(req, theseValues: person)
    }
    
    
}


struct LoginData: Content {
    let username: String
    let password: String
}

struct UUIDParam: Content {
    let id: UUID
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
