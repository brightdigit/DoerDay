protocol Target: _Depending, Dependency, _Named {
  var targetType: TargetType { get }
}

extension Target {
  var targetType: TargetType {
    .regular
  }

  var targetDepenency: _PackageDescription_TargetDependency {
    .target(name: name)
  }
}
