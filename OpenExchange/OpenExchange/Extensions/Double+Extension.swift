//
//  Double+Extension.swift
//  OpenExchange
//
//  Created by Abhishek Kashyap on 11/08/22.
//

import Foundation

extension Double{
  var roundOfValue: Double{
    return Double(floor(1000 * self) / 1000)
  }
}


extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
