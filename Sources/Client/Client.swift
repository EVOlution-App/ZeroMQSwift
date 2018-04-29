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
    public func receive<T>(_ type: T.Type = T.self, _ completion: (T) throws -> Void) throws where T: Codable {
        while let data: Data = try self.config.socket.receive() {
            let message: T = try JSONDecoder().decode(T.self, from: data)
            try completion(message)
        }
    }
    
    public func receiveData(_ completion: (Data) throws -> Void) throws {
        while let data: Data = try self.config.socket.receive() {
            try completion(data)
        }
    }
    
    // MARK: - Sending Messages
    public func send<T: Encodable>(_ object: T) throws -> Bool {
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        
        guard let value = String(data: data, encoding: .utf8) else {
            throw CustomError.convertionFailed
        }
        
        return try send(value)
    }
    
    public func send(_ value: String) throws -> Bool {
        return try config.socket.send(value)
    }
    
    public func send(_ data: Data) throws -> Bool {
        return try config.socket.send(data)
    }
}
