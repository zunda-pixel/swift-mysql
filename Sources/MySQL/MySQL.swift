import CMySQL
import Foundation

public struct SQLDatabase: Database {
  private let mysql: UnsafeMutablePointer<MYSQL>
  public let configration: Configuration
  
  public init(configration: Configuration) {
    self.configration = configration
    self.mysql = mysql_init(nil)
  }
  
  public func connect() async throws {
    let result = mysql_real_connect(
      mysql,
      configration.host,
      configration.user,
      configration.password,
      configration.databaseName,
      configration.port,
      configration.unixSocket,
      configration.clientFlag ? 0 : 1
    )
    
    try handleError()
    
    if result == nil {
      throw ConnectionError.failedConnect
    }
    
    self.setConnectTimeout(timeout: configration.timeout)
    
    mysql_set_character_set(mysql, configration.encoding.rawValue)
  }
  
  func setConnectTimeout(timeout: Int) {
    let timeoutPointer = UnsafeMutablePointer<Int>.allocate(capacity: 1)
    timeoutPointer.pointee = timeout
    mysql_options(mysql, MYSQL_OPT_CONNECT_TIMEOUT, timeoutPointer)
    timeoutPointer.deallocate()
  }
  
  public func close() async throws {
    mysql_close(self.mysql)
    try handleError()
  }
  
  public func commit() async throws {
    mysql_commit(mysql)
    try handleError()
  }
  
  public func beginTransaction() async throws {
    mysql_stat(mysql)
    try handleError()
  }
  
  public func shutdown() async throws {
    mysql_shutdown(mysql, SHUTDOWN_DEFAULT)
    try handleError()
  }
  
  func rollBack() async throws {
    mysql_rollback(mysql)
    try handleError()
  }
  
  func handleError() throws {
    guard let error = mysql_error(mysql) else { return }
    print(String(validatingUTF8: error)!)
  }
  
  public func query(_ query: String) async throws -> [[String: (type: ColumnValueType, data: Data)]] {
    let queryResult = mysql_real_query(mysql, query, UInt(query.utf8.count))
    
    try handleError()
    
    guard queryResult == 0 else {
      fatalError()
    }
    
    guard let response: UnsafeMutablePointer<MYSQL_RES> = mysql_use_result(mysql) else {
      fatalError()
    }
    
    try handleError()
    
    defer {
      mysql_free_result(response)
    }
    
    let fieldCount = Int(mysql_num_fields(response))
    
    try handleError()

    guard let fields = mysql_fetch_fields(response) else { fatalError() }

    try handleError()

    var allRows: [[String: (ColumnValueType, Data)]] = []
    
    while true {
      guard let row = mysql_fetch_row(response) else { break }
      try handleError()
      guard let lengths = mysql_fetch_lengths(response) else { fatalError() }
      try handleError()
      var columns: [String: (ColumnValueType, Data)] = [:]
      
      for i in 0..<fieldCount {
        guard let pointer = row[i] else { fatalError() }
        let field = fields[i]
        guard let key = String(validatingUTF8: field.name) else { fatalError() }
        let type = ColumnValueType(from: field.type)
        let value = Data(bytes: UnsafeRawPointer(pointer), count: Int(lengths[i]))
        columns[key] = (type, value)
      }
      
      allRows.append(columns)
    }
    
    return allRows
  }
}
