protocol TestTarget: Target {}

extension TestTarget {
  var targetType: TargetType {
    .test
  }
}
