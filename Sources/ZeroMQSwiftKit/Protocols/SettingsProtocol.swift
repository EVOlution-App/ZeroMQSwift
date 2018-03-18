import Foundation
import ZeroMQKit

public protocol SettingsProtocol {
    var scheme: Scheme { get }
    var host: String { get }
    var port: Int { get }
    var type: SocketType { get }
    
    func fullURL() -> String?
}
