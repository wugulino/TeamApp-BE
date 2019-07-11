import Vapor
import Foundation


/// Controls basic CRUD operations on `Entity`s.
protocol ControllerProtocol {
    associatedtype YourEntity
    /// Returns a list of all entities.
    func find(_ id: UUID, on req: Request) throws -> EventLoopFuture<YourEntity?>;
    func list(_ req: Request) throws -> Future<[YourEntity]>;
    func insert(_ newItem: YourEntity, on req: Request) throws -> Future<YourEntity>;
    func modify(_ newValue: YourEntity, on req: Request) throws -> Future<YourEntity>;
    func delete(this: YourEntity, on req: Request) throws -> String;
    
//    func searchAND(_ req: Request, theseValues: YourEntity, onFields: [PartialKeyPath<YourEntity>]) throws -> Future<[YourEntity]>;
//    func searchOR(_ req: Request, theseValues: YourEntity, onFields: [PartialKeyPath<YourEntity>]) throws -> Future<[YourEntity]>;
    
    func searchAND(_ req: Request, theseValues: YourEntity) throws -> Future<[YourEntity]>;
    func searchOR(_ req: Request, theseValues: YourEntity) throws -> Future<[YourEntity]>;

}
