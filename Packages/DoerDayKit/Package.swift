// swift-tools-version: 5.9
extension Array: Dependencies where Element == Dependency {
  func appending(_ dependencies: any Dependencies) -> [Dependency] {
    self + dependencies
  }
}
extension Array: SupportedPlatforms where Element == SupportedPlatform {
  func appending(_ platforms: any SupportedPlatforms) -> Self {
    self + .init(platforms)
  }
}
extension Array: TestTargets where Element == TestTarget {
  func appending(_ testTargets: any TestTargets) -> [TestTarget] {
    self + testTargets
  }
}
protocol Dependencies: Sequence where Element == Dependency {
  // swiftlint:disable:next identifier_name
  init<S>(_ s: S) where S.Element == Dependency, S: Sequence
  func appending(_ dependencies: any Dependencies) -> Self
}
protocol Dependency {
  var targetDepenency: _PackageDescription_TargetDependency { get }
}
@resultBuilder
enum DependencyBuilder {
  static func buildPartialBlock(first: Dependency) -> any Dependencies {
    [first]
  }

  static func buildPartialBlock(accumulated: any Dependencies, next: Dependency) -> any Dependencies {
    accumulated + [next]
  }
}
extension LanguageTag {
  static let english: LanguageTag = "en"
}
extension Package {
  convenience init(
    name: String? = nil,
    @ProductsBuilder entries: @escaping () -> [Product],
    @TestTargetBuilder testTargets: @escaping () -> any TestTargets = { [TestTarget]() }
  ) {
    let packageName: String
    if let name {
      packageName = name
    } else {
      var pathComponents = #filePath.split(separator: "/")
      pathComponents.removeLast()
      packageName = String(pathComponents.last!)
    }
    let allTestTargets = testTargets()
    let entries = entries()
    let products = entries.map(_PackageDescription_Product.entry)
    var targets = entries.flatMap(\.productTargets)
    let dependencies = targets.flatMap { $0.allDependencies() } + allTestTargets.flatMap { $0.allDependencies() }
    let targetDependencies = dependencies.compactMap { $0 as? Target }
    let packageDependencies = dependencies.compactMap { $0 as? PackageDependency }
    targets += targetDependencies
    targets += allTestTargets.map { $0 as Target }
    assert(targetDependencies.count + packageDependencies.count == dependencies.count)

    let packgeTargets = Dictionary(grouping: targets, by: { $0.name }).values.compactMap(\.first).map(_PackageDescription_Target.entry(_:))

    let packageDeps = Dictionary(grouping: packageDependencies, by: { $0.packageName }).values.compactMap(\.first).map(\.dependency)

    self.init(name: packageName, products: products, dependencies: packageDeps, targets: packgeTargets)
  }
}

extension Package {
  func supportedPlatforms(
    @SupportedPlatformBuilder supportedPlatforms: @escaping () -> any SupportedPlatforms
  ) -> Package {
    platforms = .init(supportedPlatforms())
    return self
  }

  func defaultLocalization(_ defaultLocalization: LanguageTag) -> Package {
    self.defaultLocalization = defaultLocalization
    return self
  }
}
import PackageDescription

protocol PackageDependency: Dependency {
  var packageName: String { get }
  var dependency: _PackageDescription_PackageDependency { get }
}

extension PackageDependency {
  var productName: String {
    "\(Self.self)"
  }

  var packageName: String {
    switch dependency.kind {
    case let .sourceControl(name: name, location: location, requirement: _):
      return name ?? location.packageName ?? productName

    case let .fileSystem(name: name, path: path):
      return name ?? path.packageName ?? productName

    case let .registry(id: id, requirement: _):
      return id
    @unknown default:
      return productName
    }
  }

  var targetDepenency: _PackageDescription_TargetDependency {
    switch dependency.kind {
    case let .sourceControl(name: name, location: location, requirement: _):
      let packageName = name ?? location.packageName
      return .product(name: productName, package: packageName)

    @unknown default:
      return .byName(name: productName)
    }
  }
}
// swiftlint:disable type_name

import PackageDescription

typealias _PackageDescription_Product = PackageDescription.Product
typealias _PackageDescription_Target = PackageDescription.Target
typealias _PackageDescription_TargetDependency = PackageDescription.Target.Dependency
typealias _PackageDescription_PackageDependency = PackageDescription.Package.Dependency
protocol PlatformSet {
  @SupportedPlatformBuilder
  var body: any SupportedPlatforms { get }
}
extension Product where Self: Target {
  var productTargets: [Target] {
    [self]
  }

  var targetType: TargetType {
    switch productType {
    case .library:
      .regular

    case .executable:
      .executable
    }
  }
}
protocol Product: _Named {
  var productTargets: [Target] { get }
  var productType: ProductType { get }
}

extension Product {
  var productType: ProductType {
    .library
  }
}
enum ProductType {
  case library
  case executable
}
@resultBuilder
enum ProductsBuilder {
  static func buildPartialBlock(first: Product) -> [Product] {
    [first]
  }

  static func buildPartialBlock(accumulated: [Product], next: Product) -> [Product] {
    accumulated + [next]
  }
}
extension String {
  var packageName: String? {
    split(separator: "/").last?.split(separator: ".").first.map(String.init)
  }
}
import PackageDescription

@resultBuilder
enum SupportedPlatformBuilder {
  static func buildPartialBlock(first: SupportedPlatform) -> any SupportedPlatforms {
    [first]
  }

  static func buildPartialBlock(first: PlatformSet) -> any SupportedPlatforms {
    first.body
  }

  static func buildPartialBlock(first: any SupportedPlatforms) -> any SupportedPlatforms {
    first
  }

  static func buildPartialBlock(accumulated: any SupportedPlatforms, next: any SupportedPlatforms) -> any SupportedPlatforms {
    accumulated.appending(next)
  }

  static func buildPartialBlock(accumulated: any SupportedPlatforms, next: SupportedPlatform) -> any SupportedPlatforms {
    accumulated.appending([next])
  }
}
protocol SupportedPlatforms: Sequence where Element == SupportedPlatform {
  // swiftlint:disable:next identifier_name
  init<S>(_ s: S) where S.Element == SupportedPlatform, S: Sequence
  func appending(_ platforms: any SupportedPlatforms) -> Self
}
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
enum TargetType {
  case regular
  case executable
  case test
}
protocol TestTarget: Target {}

extension TestTarget {
  var targetType: TargetType {
    .test
  }
}
@resultBuilder
enum TestTargetBuilder {
  static func buildPartialBlock(first: TestTarget) -> any TestTargets {
    [first]
  }

  static func buildPartialBlock(accumulated: any TestTargets, next: TestTarget) -> any TestTargets {
    accumulated + [next]
  }
}
protocol TestTargets: Sequence where Element == TestTarget {
  // swiftlint:disable:next identifier_name
  init<S>(_ s: S) where S.Element == TestTarget, S: Sequence
  func appending(_ testTargets: any TestTargets) -> Self
}
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
protocol _Named {
  var name: String { get }
}

extension _Named {
  var name: String {
    "\(Self.self)"
  }
}
extension _PackageDescription_Product {
  static func entry(_ entry: Product) -> _PackageDescription_Product {
    let targets = entry.productTargets.map(\.name)

    switch entry.productType {
    case .executable:
      return Self.executable(name: entry.name, targets: targets)

    case .library:
      return Self.library(name: entry.name, targets: targets)
    }
  }
}
extension _PackageDescription_Target {
  static func entry(_ entry: Target) -> _PackageDescription_Target {
    let dependencies = entry.dependencies.map(\.targetDepenency)
    switch entry.targetType {
    case .executable:
      return .executableTarget(name: entry.name, dependencies: dependencies)

    case .regular:
      return .target(name: entry.name, dependencies: dependencies)

    case .test:
      return .testTarget(name: entry.name, dependencies: dependencies)
    }
  }
}
struct FelinePine: PackageDependency {
  var dependency: Package.Dependency {
    .package(
      url: "https://github.com/brightdigit/FelinePine.git",
      from: "0.1.0-alpha.3"
    )
  }
}
struct Fluent: PackageDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0")
  }
}
struct FluentPostgresDriver: PackageDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0")
  }
}
struct Prch: PackageDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/brightdigit/Prch.git", from: "1.0.0-alpha.1")
  }
}
struct PrchModel: PackageDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/brightdigit/Prch.git", from: "1.0.0-alpha.1")
  }
}
struct RouteGroups: PackageDependency {
  var dependency: Package.Dependency {
    .package(
      url: "https://github.com/brightdigit/RouteGroups.git",
      from: "0.1.0-alpha.3"
    )
  }
}
struct StealthyStash: PackageDependency {
  var dependency: Package.Dependency {
    .package(
      url: "https://github.com/brightdigit/StealthyStash.git",
      from: "0.1.0-alpha.1"
    )
  }
}
struct Sublimation: PackageDependency {
  var dependency: Package.Dependency {
    .package(
      url: "https://github.com/brightdigit/Sublimation.git",
      from: "1.0.0-alpha.2"
    )
  }
}
struct SublimationVapor: PackageDependency {
  var dependency: Package.Dependency {
    .package(
      url: "https://github.com/brightdigit/Sublimation.git",
      from: "1.0.0-alpha.2"
    )
  }
}
struct Vapor: PackageDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0")
  }
}
struct VaporAPNS: PackageDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/vapor/apns.git", from: "4.0.0-beta.3")
  }
}
struct XCTVapor: PackageDependency {
  var dependency: Package.Dependency {
    .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0")
  }
}
struct DoerDayApp: Product, Target {
  var dependencies: any Dependencies {
    DoerDayViews()
  }
}
import Foundation

struct DoerDayServer: Product, Target {
  var name: String {
    "fbd"
  }

  var dependencies: any Dependencies {
    FloxBxServerKit()
  }

  var productType: ProductType {
    .executable
  }
}
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
struct DoerDayViews: Target {}
struct FloxBxAuth: Target {
  var dependencies: any Dependencies {
    FloxBxLogging()
    StealthyStash()
  }
}
struct FloxBxDatabase: Target {
  var dependencies: any Dependencies {
    Fluent()
    FloxBxUtilities()
  }
}
struct FloxBxGroupActivities: Target {
  var dependencies: any Dependencies {
    FloxBxLogging()
  }
}
struct FloxBxLogging: Target {
  var dependencies: any Dependencies {
    FelinePine()
  }
}
struct FloxBxModels: Target {
  var dependencies: any Dependencies {
    FloxBxUtilities()
  }
}
struct FloxBxRequests: Target {
  var dependencies: any Dependencies {
    FloxBxModels()
    PrchModel()
  }
}
struct FloxBxUtilities: Target {}
struct FloxBxServerKitTests: TestTarget {
  var dependencies: any Dependencies {
    FloxBxServerKit()
    XCTVapor()
  }
}
Package {
  DoerDayApp()
  DoerDayServer()
  FloxBxServerKit()
  FloxBxUI()
}

testTargets: {
  FloxBxServerKitTests()
}
.supportedPlatforms {
  WWDC2023()
}
import PackageDescription

struct WWDC2023: PlatformSet {
  var body: any SupportedPlatforms {
    SupportedPlatform.macOS(.v14)
    SupportedPlatform.iOS(.v17)
    SupportedPlatform.watchOS(.v10)
    SupportedPlatform.tvOS(.v17)
  }
}
