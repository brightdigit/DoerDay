struct RouteGroups: PackageDependency {
  var dependency: Package.Dependency {
    .package(
      url: "https://github.com/brightdigit/RouteGroups.git",
      from: "0.1.0-alpha.3"
    )
  }
}
