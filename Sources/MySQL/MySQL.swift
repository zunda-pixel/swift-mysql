import CMySQL
import Foundation

protocol Database {
  func connect() async throws
  func shutdown() async throws
  func close() async throws
  func commit() async throws
  func beginTransaction() async throws
  func rollBack() async throws
  func query(_ query: String) async throws
}


public struct SQLDatabase: Database {
  private let mysql: UnsafeMutablePointer<MYSQL>
  public let configration: Configuration
  
  public init(configration: Configuration) {
    self.configration = configration
    //let mysql: UnsafeMutablePointer<MYSQL>! = nil
    //mysql_options(mysql, MYSQL_OPT_CONNECT_TIMEOUT, nil)
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
  }
  
  public func commit() async throws {
    mysql_commit(mysql)
  }
  
  public func beginTransaction() async throws {
    mysql_stat(mysql)
  }
  
  public func shutdown() async throws {
    mysql_shutdown(mysql, SHUTDOWN_DEFAULT)
  }
  
  func rollBack() async throws {
    mysql_rollback(mysql)
  }
  
  public func valueType(from type: enum_field_types) -> ValueType {
    switch type {
    case MYSQL_TYPE_DECIMAL: return .decimal
    case MYSQL_TYPE_TINY: return .tiny
    case MYSQL_TYPE_SHORT: return .short
    case MYSQL_TYPE_LONG: return .long
    case MYSQL_TYPE_FLOAT: return .float
    case MYSQL_TYPE_DOUBLE: return .double
    case MYSQL_TYPE_NULL: return .null
    case MYSQL_TYPE_TIMESTAMP: return .timestamp
    case MYSQL_TYPE_LONGLONG: return .longLong
    case MYSQL_TYPE_INT24: return .int24
    case MYSQL_TYPE_DATE: return .date
    case MYSQL_TYPE_TIME: return .time
    case MYSQL_TYPE_DATETIME: return .dateTime
    case MYSQL_TYPE_YEAR: return .year
    case MYSQL_TYPE_VARCHAR: return .varchar
    case MYSQL_TYPE_BIT: return .bit
    case MYSQL_TYPE_TIMESTAMP2: return .timestamp2
      //case MYSQL_TYPE_TYPED_ARRAY, /**< Used for replication only */
    case MYSQL_TYPE_INVALID: return .invalid
    case MYSQL_TYPE_BOOL: return .bool// = 244, /**< Currently just a placeholder */
    case MYSQL_TYPE_JSON: return .json
    case MYSQL_TYPE_NEWDECIMAL: return .newDecimal
    case MYSQL_TYPE_ENUM: return .enum
    case MYSQL_TYPE_SET: return .set
    case MYSQL_TYPE_TINY_BLOB : return .tinyBlob
    case MYSQL_TYPE_MEDIUM_BLOB: return .mediumBlob
    case MYSQL_TYPE_LONG_BLOB: return .longBlob
    case MYSQL_TYPE_BLOB: return .blob
    case MYSQL_TYPE_VAR_STRING: return .varString
    case MYSQL_TYPE_STRING: return .string
    case MYSQL_TYPE_GEOMETRY: return .geometry
    default: fatalError()
    }
  }
  
  public func query(_ query: String) async throws {
    guard mysql_real_query(mysql, query, UInt(query.utf8.count)) == 0 else {
      fatalError()
    }

    guard let response: UnsafeMutablePointer<MYSQL_RES> = mysql_use_result(mysql) else {
      fatalError()
    }
    
    defer {
      mysql_free_result(response)
    }
    
    let fieldCount = Int(mysql_num_fields(response))
    
    guard let fields = mysql_fetch_fields(response) else { fatalError() }
        
    var allRows: [[String: (ValueType, Data)]] = []
    
    while true {
      guard let row = mysql_fetch_row(response) else { break }
      guard let lengths = mysql_fetch_lengths(response) else { fatalError() }
      var columns: [String: (ValueType, Data)] = [:]
      
      for i in 0..<fieldCount {
        guard let pointer = row[i] else { fatalError() }
        let field = fields[i]
        guard let key = String(validatingUTF8: field.name) else { fatalError() }
        let type = valueType(from: field.type)
        let value = Data(bytes: UnsafeRawPointer(pointer), count: Int(lengths[i]))
        columns[key] = (type, value)
      }
      
      allRows.append(columns)
    }
    
    for row in allRows {
//      let values = [row["id"]!.1, row["lastName"]!.1, row["firstName"]!.1, row["age"]!.1]
//      let formattedValues = values.map { String(decoding: $0, as: UTF8.self) }
//      let idData = UUID(from: row["id"]!.1)
//      print(formattedValues)
      
      for (key, (type, value)) in row {
        print(key, type, String(decoding: value, as: UTF8.self))
      }
    }
  }
}

public extension UUID {
  init(from data: Data) {
    let binaries = Array(data)
    let uuid: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) = (
      binaries[0],
      binaries[1],
      binaries[2],
      binaries[3],
      binaries[4],
      binaries[5],
      binaries[6],
      binaries[7],
      binaries[8],
      binaries[9],
      binaries[10],
      binaries[11],
      binaries[12],
      binaries[13],
      binaries[14],
      binaries[15]
    )
    
    self.init(uuid: uuid)
  }
}

public enum CharacterEncoding: String {
  case utf8
  case utf8mb4
}

public enum ConnectionError: LocalizedError {
  case failedConnect
}

public enum ValueType {
  case decimal
  case tiny
  case short
  case long
  case float
  case double
  case null
  case timestamp
  case longLong
  case int24
  case date
  case time
  case dateTime
  case year
  case varchar
  case bit
  case timestamp2
  case invalid
  case bool
  case json
  case newDecimal
  case `enum`
  case set
  case tinyBlob
  case mediumBlob
  case longBlob
  case blob
  case varString
  case string
  case geometry
}
