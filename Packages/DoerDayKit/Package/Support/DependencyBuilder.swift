@resultBuilder
enum DependencyBuilder {
  static func buildPartialBlock(first: Dependency) -> any Dependencies {
    [first]
  }

  static func buildPartialBlock(accumulated: any Dependencies, next: Dependency) -> any Dependencies {
    accumulated + [next]
  }
}
