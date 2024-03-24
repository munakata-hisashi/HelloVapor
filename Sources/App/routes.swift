import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello", "workshop") { req async -> String in
        "Hello Vapor Workshop!"
    }
    
    app.get("bottles", ":count") { req -> Bottles in
        let count = try req.parameters.require("count", as: Int.self)
        return Bottles(count: count)
    }

    app.get("hello", ":name") { req -> String in
        // デフォルトはas String
        let name = try req.parameters.require("name", as: String.self)
        return "Hello \(name)"
    }
    
    app.post("bottles") { req -> String in
        let bottles = try req.content.decode(Bottles.self)
        return "There were \(bottles.count) bottles"
    }
    
    app.post("user-info") { req -> UserResponse in
        let user = try req.content.decode(UserInfo.self)
        return UserResponse(message: "Hello \(user.name), you are \(user.age)")
    }
    
    try app.register(collection: TodoController())
}

struct UserInfo: Content {
    let name: String
    let age: Int
}

struct UserResponse: Content {
    let message: String
}

struct Bottles: Content {
    let count: Int
}
