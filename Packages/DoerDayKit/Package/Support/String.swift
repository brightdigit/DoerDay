extension String {
  var packageName: String? {
    split(separator: "/").last?.split(separator: ".").first.map(String.init)
  }
}
