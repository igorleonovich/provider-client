import Foundation

let cliTool = CLITool()
cliTool.run()

let core = Core()
core.setup()
core.connect {
    core.fullClientUpdate {
        core.statsController.startStatsUpdating()
    }
}

RunLoop.main.run()
