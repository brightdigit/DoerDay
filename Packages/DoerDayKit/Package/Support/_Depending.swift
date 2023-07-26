protocol _Depending {
  @DependencyBuilder
  var dependencies: any Dependencies { get }
}

extension _Depending {
  var dependencies: any Dependencies {
    [Dependency]()
  }
}

extension _Depending {
  func allDependencies() -> [Dependency] {
    dependencies.compactMap {
      $0 as? _Depending
    }.flatMap {
      $0.allDependencies()
    }.appending(dependencies)
  }
}
