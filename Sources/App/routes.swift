import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("hello", "workshop") { req async -> String in
        "Hello Vapor Workshop!"
    }
    
    app.get("bottles", ":count") { req -> String in
        let count = try req.parameters.require("count", as: Int.self)
        return "There were \(count) bottles on the wall"
    }

    app.get("hello", ":name") { req -> String in
        let name = try req.parameters.require("name", as: String.self)
        return "Hello \(name)"
    }
    try app.register(collection: TodoController())
}
