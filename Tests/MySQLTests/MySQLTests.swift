import XCTest
@testable import MySQL

final class MySQLTests: XCTestCase {
  let configuration = SQLDatabase.Configuration(
    host: ProcessInfo.processInfo.environment["host"]!,
    user: ProcessInfo.processInfo.environment["user"]!,
    password: ProcessInfo.processInfo.environment["password"]!,
    databaseName: ProcessInfo.processInfo.environment["databaseName"]!,
    port: 3306,
    unixSocket: nil,
    clientFlag: true,
    encoding: .utf8mb4,
    timeout: .max
  )
  
  func testConnection() async throws {
    let database = SQLDatabase(configration: configuration)
    database.setConnectTimeout(timeout: 10)
    try await database.connect()
    try await database.beginTransaction()
    try await database.rollBack()
    try await database.close()
    try await database.shutdown()
  }
  
  func testQuery() async throws {
    let database = SQLDatabase(configration: configuration)
    try await database.connect()
    let rows = try await database.query("SELECT * FROM User")
    print(rows.count)
    try await database.close()
    try await database.shutdown()
  }
}
