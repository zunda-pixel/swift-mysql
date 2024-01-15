import Foundation

protocol Database {
  func connect() async throws
  func shutdown() async throws
  func close() async throws
  func commit() async throws
  func beginTransaction() async throws
  func rollBack() async throws
  func query(_ query: String) async throws -> [[String: (type: FieldType, data: Data)]]
}
