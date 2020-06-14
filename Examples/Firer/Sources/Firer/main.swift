import Foundation

let firer = try Firer()

do {
    print("Connecting to ZeroMQ Server")
    try firer.connect()
    
    try firer.dispatchEvents()
}
catch let error {
    fatalError(error.localizedDescription)
}

RunLoop.main.run()
