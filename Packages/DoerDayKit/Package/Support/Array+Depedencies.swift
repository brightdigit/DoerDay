extension Array: Dependencies where Element == Dependency {
  func appending(_ dependencies: any Dependencies) -> [Dependency] {
    self + dependencies
  }
}
