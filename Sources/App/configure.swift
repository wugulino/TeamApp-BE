import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
/*    let path = DirectoryConfig.detect().workDir + "teamapp.db"
    let sqlite = try SQLiteDatabase(storage: .file(path: path))

    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite) */
    
    // Configure a database
    var databases = DatabasesConfig()
    // 3
    let databaseConfig = PostgreSQLDatabaseConfig(
        hostname: "localhost",
        username: "vapor",
        database: "teamapp-be",
        password: "password")
    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Entity.self, database: .psql)
    migrations.add(model: Person.self, database: .psql)
    migrations.add(model: Campaign.self, database: .psql)
    migrations.add(model: Pool.self, database: .psql)
    migrations.add(model: SkillSet.self, database: .psql)
    migrations.add(model: Skill.self, database: .psql)
    migrations.add(model: Group.self, database: .psql)
    migrations.add(model: GroupMember.self, database: .psql)
    migrations.add(model: Endorsement.self, database: .psql)

    services.register(migrations)
    
    var commands = CommandConfig.default()
    commands.useFluentCommands()
    services.register(commands)
}
