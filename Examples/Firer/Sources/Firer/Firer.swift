import Foundation
import ZeroMQSwiftKit
import Client

class Firer {
    private let settings: Settings
    private let client: Client
    
    init() throws {
        settings = Settings(scheme: .tcp, host: "localhost", port: 5559, type: .push)
        client = try Client(settings)
    }
    
    func connect() throws {
        try client.connect()
    }
    
    func dispatchEvents() throws {
        let actions = ["created", "changed", "removed", "deferred", "improved"]
        let names = ["Hyun","Imelda","Heath","Norah","Garnett","Amos","Jann","Eduardo","Billye","Jeanice","Salvador","Alona","Tisa","Jamika","Hollis","Shanon","Madie","Gisele","Manda","Jewell","Nicolas","Jada","Rubye","Yasuko","Margart","Edda","Love","Alfred","Sybil","Angelic","Tresa","Bob","Earnestine","Enedina","Britta","Flossie","Lilian","Donetta","Dalila","Nickie","Jennie","Emiko","Suzi","Camellia","Stephany","Nadine","Luanne","Beatris","Lillian","Cristy"]
        
        for index in 0 ..< names.count {
            let action = actions[Int(arc4random_uniform(UInt32(actions.count)))]
            let name = names[index]
            let message = "[\(index)] Description: \(action) - Name: \(name)"
            
            let object = "{\"id\": \"\(index)\", \"description\": \"\(action)\", \"person\":\"\(name)\"}"
            let sent = try client.send(object)
            
            print("\(sent ? "✅" : "❌") Message: \(message)")
        }
    }
}
