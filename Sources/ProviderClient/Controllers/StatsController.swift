import Foundation
import ProviderSDK

class StatsController {
    
    weak var core: Core?
    
    init(core: Core) {
        self.core = core
    }
    
    func startStatsUpdating() {
        
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                
                guard let `self` = self else { return }
                
                self.updateStats()
                
                guard let core = self.core,
                    let currentLocalClient = core.clientController.currentLocalClient,
                    let previousLocalClient = core.clientController.previousLocalClient else { return }
                
                // Check updates
                
                var newLocalClient = ProviderLocalClient()
                var shouldUpdate = false
                
                if currentLocalClient.state != previousLocalClient.state {
                    newLocalClient.state = currentLocalClient.state
                    shouldUpdate = true
                }
                if currentLocalClient.cpuUsage != previousLocalClient.cpuUsage {
                    newLocalClient.cpuUsage = currentLocalClient.cpuUsage
                    shouldUpdate = true
                }
                if currentLocalClient.freeRAM != previousLocalClient.freeRAM {
                    newLocalClient.freeRAM = currentLocalClient.freeRAM
                    shouldUpdate = true
                }
                
                core.clientController.previousLocalClient = core.clientController.currentLocalClient
                
                // Send updated object
                
                if shouldUpdate {
                    do {
                        let updatedClientData = try JSONEncoder().encode(newLocalClient)
                        let clientToServerAction = ClientToServerAction(type: ClientToServerActionType.partialClientUpdate.rawValue, data: updatedClientData)
                        let clientToServerActionData = try JSONEncoder().encode(clientToServerAction)
                        core.webSocketController?.webSocket.send(clientToServerActionData)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    private func updateStats() {
        guard let core = self.core else { return }
        core.clientController.currentLocalClient?.cpuUsage = ClientInfo.cpuUsage
        core.clientController.currentLocalClient?.freeRAM = ClientInfo.freeRAM
        core.clientController.currentLocalClient?.state = ProviderClientState.available.rawValue
    }
}
