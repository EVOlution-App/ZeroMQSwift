import Foundation
import Server
import ZeroMQSwiftKit

let frontend = Settings(scheme: .tcp, host: "127.0.0.1", port: 5559, type: .pull)
let backend  = Settings(scheme: .tcp, host: "127.0.0.1", port: 5560, type: .push)
let server = try Server(frontend, backend)

server.start()
