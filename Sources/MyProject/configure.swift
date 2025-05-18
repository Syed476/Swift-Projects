import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // Bind to all interfaces so it's accessible from outside the container
    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 8080 // Change this if you want a different port

    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreateTodo())

    // register routes
    try routes(app)
}

