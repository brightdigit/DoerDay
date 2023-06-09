#if canImport(SwiftUI)
  import os
  import SwiftUI

  public protocol Application: App {
    var appDelegate: AppDelegate { get }
  }

  extension Application {
    public var body: some Scene {
      WindowGroup {
        EmptyView()
      }
    }
  }
#endif
