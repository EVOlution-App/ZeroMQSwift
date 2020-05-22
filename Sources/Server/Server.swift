import Foundation
import ZeroMQKit
import ZeroMQSwiftKit

public struct Server {
    private let context: Context
    private let settings: [SettingsProtocol]
    
    // MARK: - Initialization
    public init(_ settings: SettingsProtocol...) throws {
        guard settings.count > 0 else {
            throw CustomError.noSettingsInjected
        }
        
        self.context = try Context()
        self.settings = settings
    }
    
    // MARK: - Start
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

        let sockets: [SocketTuple] = self.settings.compactMap {
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
