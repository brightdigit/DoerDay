struct StealthyStash: PackageDependency {
  var dependency: Package.Dependency {
    .package(
      url: "https://github.com/brightdigit/StealthyStash.git",
      from: "0.1.0-alpha.1"
    )
  }
}
