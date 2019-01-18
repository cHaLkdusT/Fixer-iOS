//
//  AccessKeyAdapter.swift
//  Fixer
//
//  Created by Julius Lundang on 17/01/2019.
//

import Alamofire

class AccessKeyAdapter: RequestAdapter {
  private let accessKey: String
  
  init(accessKey: String) {
    self.accessKey = accessKey
  }
  
  func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
    let parameters = [
      "access_key": accessKey
    ]
    return try URLEncoding.queryString.encode(urlRequest, with: parameters)
  }
}
