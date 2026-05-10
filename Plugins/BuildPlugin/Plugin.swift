import Foundation
import PackagePlugin

@main
struct BuildPlugin: BuildToolPlugin {
  func createBuildCommands(
    context: PluginContext, target: any Target
  ) async throws -> [Command] {
    let output = context.pluginWorkDirectoryURL
      .appending(component: "Generated.swift")
    return [
      .buildCommand(
        displayName: "Generating \(output.path)",
        executable: try context.tool(named: "codegen").url,
        arguments: [output.path],
        inputFiles: [],
        outputFiles: [output])
    ]
  }
}
