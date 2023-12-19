import Foundation

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
