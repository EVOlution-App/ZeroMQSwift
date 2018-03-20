import Foundation

let consumer = try Consumer()

try consumer.connect()
try consumer.monitor()

RunLoop.main.run()
