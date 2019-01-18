//
//  Router.swift
//  Fixer
//
//  Created by Julius Lundang on 17/01/2019.
//


import Alamofire

enum Router: URLRequestConvertible {
  case symbols
  
  #if RELEASE
  static let baseURLString = "https://data.fixer.io/api"
  #else
  static let baseURLString = "http://data.fixer.io/api"
  #endif
  
  var method: HTTPMethod {
    switch self {
    case .symbols:
      return .get
    }
  }
  
  var path: String {
    switch self {
    case .symbols:
      return "/symbols"
    }
  }
  
  // MARK: URLRequestConvertible
  func asURLRequest() throws -> URLRequest {
    let url = try Router.baseURLString.asURL()
    
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    
    
    switch self {
    default:
      urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
    }
    
    return urlRequest
  }
}
