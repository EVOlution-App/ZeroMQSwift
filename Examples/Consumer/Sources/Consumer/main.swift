import Foundation

let consumer = try Consumer()

do {
    print("Connecting to ZeroMQ Server")
    try consumer.connect()
    
    print("Starting monitor...")
    try consumer.monitor()
}
catch {
    print("Error: \(error)")
}

RunLoop.main.run()
