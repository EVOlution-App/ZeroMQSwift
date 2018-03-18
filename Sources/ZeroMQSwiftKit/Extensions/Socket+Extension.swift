import Foundation
import ZeroMQKit

public typealias SocketTuple = (socket: Socket, url: String, type: SocketType)
public extension Sequence where Self: RangeReplaceableCollection, Self: RandomAccessCollection, Iterator.Element == SocketTuple {
    func get(by url: String) -> SocketTuple? {
        guard let index = self.index(where: { $0.url == url }) else {
            return nil
        }
        
        return self[index]
    }
    
    func get(by type: SocketType) -> SocketTuple? {
        guard let index = self.index(where: { $0.type == type }) else {
            return nil
        }
        
        return self[index]
    }
}
