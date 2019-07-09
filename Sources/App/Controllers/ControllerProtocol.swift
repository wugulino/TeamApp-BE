import Vapor


/// Controls basic CRUD operations on `Entity`s.
protocol ControllerProtocol {
    associatedtype YourEntity
    /// Returns a list of all entities.
    func find(_ req: Request) throws -> Future<YourEntity>;
    func list(_ req: Request) throws -> Future<[YourEntity]>;
    func insert(_ req: Request) throws -> Future<YourEntity>;
    func update(_ req: Request) throws -> Future<YourEntity>;
    func delete(_ req: Request) throws -> Future<HTTPStatus>;
}

/*
 func search<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
    return map { $0[keyPath: keyPath] }
 }
 
 */
