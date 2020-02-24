import Foundation

class Core {
    
    var clientController: ClientController!
    var statsController: StatsController!
    var webSocketController: WebSocketController?
    
    func setup() {
        print("\(Date()) [setup] started")
        clientController = ClientController(core: self)
        statsController = StatsController(core: self)
    }
    
    func connect(_ completion: @escaping (Error?) -> Void) {
        if let clientID = Environment.clientID {
            print("\(Date()) [setup] clientID detected \(clientID)")
            webSocketController = WebSocketController(core: self, clientID: clientID)
            webSocketController!.start {
                completion(nil)
            }
        } else {
            print("\(Date()) [setup] clientID not detected]")
            clientController.createClient { error in
                if error == nil {
                    print("[setup] try to connect ws again")
                    self.connect(completion)
                } else {
                    completion(error)
                }
            }
        }
    }
    
    func fullClientUpdate(_ completion: @escaping () -> Void) {
        core.clientController.getFullClientUpdateData() { fullClientUpdateData in
            core.webSocketController?.webSocket.send(fullClientUpdateData)
            completion()
        }
    }
}
