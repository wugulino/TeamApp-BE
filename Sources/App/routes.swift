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
    
    // 1
    router.post(LoginData.self, at: "login2") { req, data -> LoginResponse in
        // 2
        return LoginResponse(request: data)
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}


struct LoginData: Content {
    let username: String
    let password: String
}

struct LoginResponse: Content {
    let request: LoginData
}
