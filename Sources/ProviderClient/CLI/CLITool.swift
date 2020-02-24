import Foundation
import SPMUtility

public final class CLITool {
    
    func run() {
        let parser = ArgumentParser(commandName: "proc", usage: "proc -h hostname -hp httpport -wp wsport", overview: "Provider Client")
        let hostArgument = parser.add(option: "--host", shortName: "-h", kind: String.self, usage: "Use custom host name")
        let httpPortArgument = parser.add(option: "--httpport", shortName: "-hp", kind: Int.self, usage: "Use custom HTTP port")
        let wsPortArgument = parser.add(option: "--wsport", shortName: "-wp", kind: Int.self, usage: "Use custom WebSockets port")
        let versionOption = parser.add(option: "--version", kind: Bool.self)
        let verboseOption = parser.add(option: "--verbose", kind: Bool.self, usage: "Show more debugging information")

        do {
            let result = try parser.parse(Array(CommandLine.arguments.dropFirst()))
            
            if result.get(versionOption) != nil {
                print("ProviderClient 0.1.0")
                return
            }
            
            if result.get(verboseOption) != nil {
                
            }
            
            if let host = result.get(hostArgument) {
                Constants.host = host
            }
            
            if let httpPort = result.get(httpPortArgument) {
                Constants.httpPort = httpPort
            }
            
            if let wsPort = result.get(wsPortArgument) {
                Constants.wsPort = wsPort
            }
        } catch {
            print(error)
        }
    }
}
