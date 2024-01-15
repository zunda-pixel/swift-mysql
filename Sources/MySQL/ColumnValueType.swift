import CMySQL

public enum FieldType {
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
  
  public init(from type: enum_field_types) {
    switch type {
    case MYSQL_TYPE_DECIMAL: self = .decimal
    case MYSQL_TYPE_TINY: self = .tiny
    case MYSQL_TYPE_SHORT: self = .short
    case MYSQL_TYPE_LONG: self = .long
    case MYSQL_TYPE_FLOAT: self = .float
    case MYSQL_TYPE_DOUBLE: self = .double
    case MYSQL_TYPE_NULL: self = .null
    case MYSQL_TYPE_TIMESTAMP: self = .timestamp
    case MYSQL_TYPE_LONGLONG: self = .longLong
    case MYSQL_TYPE_INT24: self = .int24
    case MYSQL_TYPE_DATE: self = .date
    case MYSQL_TYPE_TIME: self = .time
    case MYSQL_TYPE_DATETIME: self = .dateTime
    case MYSQL_TYPE_YEAR: self = .year
    case MYSQL_TYPE_VARCHAR: self = .varchar
    case MYSQL_TYPE_BIT: self = .bit
    case MYSQL_TYPE_TIMESTAMP2: self = .timestamp2
    case MYSQL_TYPE_INVALID: self = .invalid
    case MYSQL_TYPE_JSON: self = .json
    case MYSQL_TYPE_NEWDECIMAL: self = .newDecimal
    case MYSQL_TYPE_ENUM: self = .enum
    case MYSQL_TYPE_SET: self = .set
    case MYSQL_TYPE_TINY_BLOB : self = .tinyBlob
    case MYSQL_TYPE_MEDIUM_BLOB: self = .mediumBlob
    case MYSQL_TYPE_LONG_BLOB: self = .longBlob
    case MYSQL_TYPE_BLOB: self = .blob
    case MYSQL_TYPE_VAR_STRING: self = .varString
    case MYSQL_TYPE_STRING: self = .string
    case MYSQL_TYPE_GEOMETRY: self = .geometry
    default: fatalError()
    }
  }
}
