import Foundation
import ZeroMQKit

public struct Client {
    private let context: Context
    private let config: SocketTuple
    
    // MARK: - Initialization
    public init?(_ config: SocketProtocol) throws {
        guard let context = try? Context() else {
            fatalError("Context could not be instantiated")
        }
        
        guard let socket = try? context.socket(config.type) else {
            fatalError("Socket could not be instantiated")
        }
        
        guard let url = config.fullURL() else {
            fatalError("URL not defined")
        }
        
        self.context = context
        self.config = (socket, url, config.type)
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
