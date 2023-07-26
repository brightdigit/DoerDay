struct FloxBxUI: Product, Target {
  var dependencies: any Dependencies {
    Sublimation()
    FloxBxRequests()
    FloxBxUtilities()
    FloxBxAuth()
    FloxBxGroupActivities()
    Prch()
  }
}
