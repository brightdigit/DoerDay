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
