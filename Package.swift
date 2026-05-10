// swift-tools-version: 6.0
import PackageDescription

// Minimal repro for a build-tool plugin failure when SDKROOT points at
// WindowsExperimental.sdk on Windows, using the 2026-04-30 development
// snapshot's new Swift Build driver.
let package = Package(
  name: "plugintest",
  targets: [
    .executableTarget(
      name: "plugintest",
      plugins: ["BuildPlugin"]),
    .executableTarget(name: "codegen"),
    .plugin(
      name: "BuildPlugin",
      capability: .buildTool(),
      dependencies: [.target(name: "codegen")]),
  ])
