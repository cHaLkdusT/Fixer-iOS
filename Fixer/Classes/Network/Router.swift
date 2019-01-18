//
//  Router.swift
//  Fixer
//
//  Created by Julius Lundang on 17/01/2019.
//


import Alamofire

enum Router: URLRequestConvertible {
  case symbols
  case latest(base: String, symbols: [String])
  
  #if RELEASE
  static let baseURLString = "https://data.fixer.io/api"
  #else
  static let baseURLString = "http://data.fixer.io/api"
  #endif
  
  var method: HTTPMethod {
    return .get
  }
  
  var path: String {
    switch self {
    case .symbols:
      return "/symbols"
    case .latest:
      return "/latest"
    }
  }
  
  // MARK: URLRequestConvertible
  func asURLRequest() throws -> URLRequest {
    let url = try Router.baseURLString.asURL()
    
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    
    
    switch self {
    case let .latest(base, symbols):
      let parameters: Parameters = [
        "base": base,
        "symbols": symbols.joined(separator: ",")
      ]
      urlRequest = try URLEncoding.queryString.encode(urlRequest, with: parameters)
    default:
      urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
    }
    
    return urlRequest
  }
}
