//  Copyright © MonitorControl. @JoniVR, @theOneyouseek, @waydabber and others

import Foundation
import os.log

class Display: Equatable {
  let identifier: CGDirectDisplayID
  let prefsId: String
  var name: String
  var vendorNumber: UInt32?
  var modelNumber: UInt32?
  var serialNumber: UInt32?
  var arm64ddc: Bool = false
  var arm64avService: IOAVService?

  static func == (lhs: Display, rhs: Display) -> Bool {
    lhs.identifier == rhs.identifier
  }


  init(_ identifier: CGDirectDisplayID, name: String, vendorNumber: UInt32?, modelNumber: UInt32?, serialNumber: UInt32?) {
    self.identifier = identifier
    self.name = name
    self.vendorNumber = vendorNumber
    self.modelNumber = modelNumber
    self.serialNumber = serialNumber
    self.prefsId = "(\(name.filter { !$0.isWhitespace })\(vendorNumber ?? 0)\(modelNumber ?? 0)@\(identifier))"
    os_log("Display init with prefsIdentifier %{public}@", type: .info, self.prefsId)
  }

  func isBuiltIn() -> Bool {
    if CGDisplayIsBuiltin(self.identifier) != 0 {
      return true
    } else {
      return false
    }
  }
}
