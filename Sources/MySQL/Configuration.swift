import Foundation

extension SQLDatabase {
  public struct Configuration {
    public let host: String
    public let user: String
    public let password: String
    public let databaseName: String
    public let port: UInt32
    public let unixSocket: String?
    public let clientFlag: Bool
    public let encoding: CharacterEncoding
    public let timeout: Int
    
    public init(
      host: String,
      user: String,
      password: String,
      databaseName: String,
      port: UInt32,
      unixSocket: String?,
      clientFlag: Bool,
      encoding: CharacterEncoding,
      timeout: Int
    ) {
      self.host = host
      self.user = user
      self.password = password
      self.databaseName = databaseName
      self.port = port
      self.unixSocket = unixSocket
      self.clientFlag = clientFlag
      self.encoding = encoding
      self.timeout = timeout
    }
  }
}
