struct VaporAPNS: PackageDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/vapor/apns.git", from: "4.0.0-beta.3")
  }
}
