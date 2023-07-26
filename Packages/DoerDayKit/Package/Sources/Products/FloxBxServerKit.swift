struct FloxBxServerKit: Product, Target {
  var dependencies: any Dependencies {
    FluentPostgresDriver()
    Vapor()
    SublimationVapor()
    VaporAPNS()
    FloxBxModels()
    FloxBxDatabase()
    RouteGroups()
    FloxBxLogging()
//  swiftSettings: [
//    .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
//  ]
  }
}
