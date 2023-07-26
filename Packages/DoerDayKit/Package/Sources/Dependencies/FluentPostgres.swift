struct FluentPostgresDriver: PackageDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0")
  }
}
