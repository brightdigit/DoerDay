struct Fluent: PackageDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0")
  }
}
