import Foundation

public protocol Modelable {
  static var tableName: String { get }
}

public extension Modelable {
  static var tableName: String { String(describing: Self.self) }
}
