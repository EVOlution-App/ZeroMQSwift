import Foundation
import ZeroMQKit

public struct Settings: SocketProtocol {
    public let scheme: Scheme
    public let host: String
    public let port: Int
    public let type: SocketType
    
    public init(scheme: Scheme, host: String, port: Int, type: SocketType) {
        self.scheme = scheme
        self.host = host
        self.port = port
        self.type = type
    }
    
    public func fullURL() -> String? {
        guard self.port != 0 else {
            return nil
        }
        
        guard self.host != "" else {
            return nil
        }
        
        return "\(self.scheme.rawValue)://\(self.host):\(self.port)"
    }
}
