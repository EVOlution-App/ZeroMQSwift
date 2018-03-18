import Foundation
import ZeroMQSwiftKit
import Server

let frontend = Settings(scheme: .tcp, host: "127.0.0.1", port: 5559, type: .pull)
let backend  = Settings(scheme: .tcp, host: "127.0.0.1", port: 5560, type: .push)

guard let server = try Server(sockets: frontend, backend) else {
    fatalError("[ZeroMQServer] Server could not be started.")
}
server.start()
