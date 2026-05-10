// The build-time tool the plugin invokes. Writes a trivial Swift source.
import Foundation

guard CommandLine.arguments.count == 2 else {
  FileHandle.standardError.write(Data("codegen: expected one output path\n".utf8))
  exit(1)
}

let outputPath = CommandLine.arguments[1]
let body = """
  enum Generated {
    static let generated = 42
  }

  """
try body.write(toFile: outputPath, atomically: true, encoding: .utf8)
