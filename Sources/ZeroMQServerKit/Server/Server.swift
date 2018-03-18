import Foundation
import ZeroMQKit

public enum SocketTransport: String {
    case tcp
    case ipc
    case inproc
    case pgm
    case epgm
    case vmci
}

public struct Server {
    private let context: Context
    private let sockets: [SocketProtocol]
    
    public init?(sockets: SocketProtocol...) throws {
        guard sockets.count > 0 else {
            fatalError("To instantiate the server, you need at least one object conforming to SocketProtocol")
        }
        
        guard let context = try? Context() else {
            fatalError("Context could not be instantiated")
        }
        
        self.sockets = sockets
        self.context = context
    }
    
    public func start() {
        let welcome = """
                    ######################################################\n\
                    ######################################################\n\
                    \n\n\
                    ######## ######## #######  #######   ##   ##   #####\n\
                        ###                 ##       ##  ### ###  ##   ##\n\
                       ###    #######  ######   ##   ##  #######  ##   ##\n\
                      ###     ###      ##  ##   ##   ##  ## # ##  ## ####\n\
                     #######  #######  ##   ##   #####   ##   ##   #####\n\
                                                         ##            ##\n
                                             Swift\n\n\
                    ######################################################\n\
                    ######################################################\n\n
                    """
        print(welcome)

        let sockets: [SocketTuple] = self.sockets.flatMap {
            do {
                guard let socket = try? context.socket($0.type) else {
                    fatalError("Cannot create socket for type .\(String(describing: $0.type))")
                }
                
                guard let url = $0.fullURL() else {
                    return nil
                }
                
                try socket.bind(url)
                print("✅  Socket binded: \(url)")
                
                return (socket, url, $0.type)
            }
            catch {
                print("❌  Error: \(error.localizedDescription)")
                return nil
            }
        }
        
        defer {
            sockets.forEach { try? $0.socket.close() }
            try? context.terminate()
        }
        
        // If we have more than one socket and each of them using .pull and .push, we will configure a proxy
        if sockets.count > 1, let frontend = sockets.get(by: .pull), let backend = sockets.get(by: .push) {
            proxy(frontend: frontend.socket,
                  backend: backend.socket)
        }
        
        RunLoop.main.run()
    }
}
