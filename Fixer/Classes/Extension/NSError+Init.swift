//
//  NSError+Init.swift
//  Fixer
//
//  Created by Julius Lundang on 18/01/2019.
//

import Foundation

extension NSError {
  convenience init(code: Int, type: String, info: String?) {
    let userInfo: [String: Any] = [
      "code": code,
      "type": type,
      "info": info,
      NSLocalizedDescriptionKey: info
    ]
  
    self.init(domain: "io.fixer.error", code: code, userInfo: userInfo)
  }
}
