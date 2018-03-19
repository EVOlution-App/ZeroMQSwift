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
    public func receive<T: Codable>(_ type: T.Type = T.self, _ completion: (T) -> Void) throws {
        while let data: Data = try self.config.socket.receive() {
            let message: T = try JSONDecoder().decode(T.self, from: data)
            completion(message)
        }
    }

    public func receive<T>(type: T.Type = T.self, _ completion: (T) -> Void) throws {
        guard T.self == String.self || T.self == Data.self || T.self == Decodable.self else {
            throw CustomError.unsupportedType
        }
        
        while let value: Data = try self.config.socket.receive() {
            switch type {
            case is Data.Type:
                completion(value as! T)

            case is String.Type:
                guard let content = String(data: value, encoding: .utf8) else {
                    throw CustomError.convertionFailed
                }
                completion(content as! T)
                
            default:
                throw CustomError.unsupportedType
            }
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
