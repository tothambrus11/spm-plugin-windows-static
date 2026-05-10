# spm-plugin-windows-static

Minimal reproducer for two suspected regressions in the
`DEVELOPMENT-SNAPSHOT-2026-04-30-a` Swift toolchain on Windows when a
SwiftPM package uses a **build-tool plugin** together with
`-static-stdlib`.

## Layout

- `Sources/plugintest/main.swift` — the product, prints a value provided by
  generated code.
- `Sources/codegen/main.swift` — the build-time tool that writes
  `Generated.swift`.
- `Plugins/BuildPlugin/Plugin.swift` — a `BuildToolPlugin` that invokes
  `codegen` to produce `Generated.swift`.

## CI matrix

Four cells: `{x86_64, arm64} × {dynamic, static}` on Windows. Every cell
uses the same toolchain (`DEVELOPMENT-SNAPSHOT-2026-04-30-a`) installed
through `compnerd/gha-setup-swift@main`. The only difference between
`dynamic` and `static` is:

- `dynamic`: leaves `SDKROOT` as installed (`Windows.sdk`), runs
  `swift build --verbose --triple <arch>`.
- `static`: repoints `SDKROOT` at the sibling `WindowsExperimental.sdk`
  (which ships the static stdlib archives), then runs
  `swift build --verbose --triple <arch> -Xswiftc -static-stdlib`.

## Observation under test

- Claim 2 (separate): when `swift build` forwards `-Xswiftc -sdk
  -Xswiftc <ALT>` to `swiftc`, the new Swift Build driver appends
  `-sdk $SDKROOT` after it, so the user override is silently clobbered.
  Worked around in this repo by setting `SDKROOT` directly.
- Claim 3 (under investigation): with `SDKROOT` pointing at
  `WindowsExperimental.sdk` and `-static-stdlib`, the build-tool plugin
  fails with an opaque
  `error: build planning stopped due to build-tool plugin failures`
  while the `dynamic` cells succeed.
