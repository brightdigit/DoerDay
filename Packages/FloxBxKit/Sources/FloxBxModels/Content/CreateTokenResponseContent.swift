import PrchModel
public struct CreateTokenResponseContent: Codable, Content {
  public let token: String

  public init(token: String) {
    self.token = token
  }
}
