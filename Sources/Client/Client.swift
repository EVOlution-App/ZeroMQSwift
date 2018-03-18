import Foundation
import ZeroMQKit
import ZeroMQSwiftKit

public struct Client {
    private let context: Context
    private let config: SocketTuple
    
    // MARK: - Initialization
    public init(_ settings: SettingsProtocol) throws {
        context = try Context()
        
        let socket = try context.socket(settings.type)
        
        guard let url = settings.fullURL() else {
            throw CustomError.invalidURL
        }
        
        self.config = (socket, url, settings.type)
    }
    
    // MARK: - Connection
    public func connect() throws {
        try self.config.socket.connect(self.config.url)
    }
    
    // MARK: - Receiving Messages
    public func receive<T: Codable>(_ completion: (T) -> Void) throws {
        while let data: Data = try self.config.socket.receive() {
            let message = try JSONDecoder().decode(T.self, from: data)
            completion(message)
        }
    }
    
    public func receive(_ completion: (String) -> Void) throws {
        while let value: String = try self.config.socket.receive() {
            completion(value)
        }
    }
    
    public func receive(_ completion: (Data) -> Void) throws {
        while let value: Data = try self.config.socket.receive() {
            completion(value)
        }
    }
 
    // MARK: - Sending Messages
    public func send<T: Encodable>(_ object: T) throws -> Bool {
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        let value = String(data: data, encoding: .utf8)
        
        return try send(value)
    }
    
    public func send(_ value: String) throws -> Bool {
        return try config.socket.send(value)
    }
    
    public func send(_ data: Data) throws -> Bool {
        return try config.socket.send(data)
    }
}
