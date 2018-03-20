import Foundation

do {
    let firer = try Firer()
    try firer.connect()
    
    try firer.dispatchEvents()
}
catch let error {
    fatalError(error.localizedDescription)
}

RunLoop.main.run()
