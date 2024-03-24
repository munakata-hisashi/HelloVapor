import Vapor
import Fluent

struct UserController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.post("api", "users", use: createHandler)
        routes.get("api", "users", use: getAllHandler)
        routes.get("api", "users", ":id", use: getSingleHandler)
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
}
