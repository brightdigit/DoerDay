struct Sublimation: PackageDependency {
  var dependency: Package.Dependency {
    .package(
      url: "https://github.com/brightdigit/Sublimation.git",
      from: "1.0.0-alpha.2"
    )
  }
}
