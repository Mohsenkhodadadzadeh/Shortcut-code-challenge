//
//  Int.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import Foundation

extension Int {
  public var isSuccessHTTPCode: Bool {
    return 200 <= self && self < 300
  }
}
