import Foundation
import ZeroMQSwiftKit
import Client

class Consumer {
    private let settings: Settings
    private let client: Client
    
    init() throws {
        settings = Settings(scheme: .tcp, host: "localhost", port: 5560, type: .pull)
        client = try Client(settings)
    }
    
    func connect() throws {
        try client.connect()
    }
    
    func monitor() throws {
        try client.receive { (action: Message) in
            guard
                let id = action.id,
                let description = action.description,
                let person = action.person else {
                    return
            }
            
            print("[\(id)] Action: \(description) | Proposal: \(person)")
        }
    }
}

