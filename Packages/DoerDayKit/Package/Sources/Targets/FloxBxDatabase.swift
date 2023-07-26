struct FloxBxDatabase: Target {
  var dependencies: any Dependencies {
    Fluent()
    FloxBxUtilities()
  }
}
