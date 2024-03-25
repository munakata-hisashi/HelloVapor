import Vapor
import Fluent

struct UserController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        
        // コンテキストごとのrouteをつくれる
        //let usersRoutes = routes.grouped("api", "users")
        //usersRoutes.get(":id", use: getSingleHandler)
        
        routes.post("api", "users", use: createHandler)
        routes.get("api", "users", use: getAllHandler)
        routes.get("api", "users", ":id", use: getSingleHandler)
        routes.delete("api", "users", ":id",use: deleteHandler)
    }
    
    func createHandler(req: Request) async throws -> User {
        let user = try req.content.decode(User.self)
        try await user.save(on: req.db)
        return user
    }
    
    func getAllHandler(req: Request) async throws -> [User] {
        try await User.query(on: req.db).all()
    }
    
    func getSingleHandler(req: Request) async throws -> User {
        let id = try req.parameters.require("id", as: UUID.self)
        if let user = try await User.find(id, on: req.db) {
            return user
        } else {
            throw Abort(.notFound)
        }
    }
    
    func deleteHandler(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(
            req.parameters.get("id"),
            on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return .ok
    }
}
