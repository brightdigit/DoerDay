struct XCTVapor: PackageDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0")
  }
}
