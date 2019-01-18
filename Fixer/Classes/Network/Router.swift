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
  case history(date: Date, base: String, symbols: [String])
  case convert(amount: Double, from: String, to: String, date: Date?)
  case timeSeries(base: String, symbols: [String], startDate: Date, endDate: Date)
  case fluctuation(base: String, symbols: [String], startDate: Date, endDate: Date)
  
  #if DEBUG
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
    case let .history(date, _, _):
      return "/\(format(date: date))"
    case .convert:
      return "/convert"
    case .timeSeries:
      return "/timeseries"
    case .fluctuation:
      return "/fluctuation"
    }
  }
  
  // MARK: URLRequestConvertible
  func asURLRequest() throws -> URLRequest {
    let url = try Router.baseURLString.asURL()
    
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    
    var parameters: Parameters? = nil
    switch self {
    case let .latest(base, symbols),
         let .history(_, base, symbols):
      parameters = [
        "base": base,
        "symbols": symbols.joined(separator: ",")
      ]
    case let .convert(amount, from, to, date):
      parameters = [
        "amount": amount,
        "from": from,
        "to": to
      ]
      if let date = date {
        parameters?["date"] = format(date: date)
      }
    case let .timeSeries(base, symbols, startDate, endDate),
         let .fluctuation(base, symbols, startDate, endDate):
      parameters = [
        "base": base,
        "symbols": symbols.joined(separator: ","),
        "start_date": format(date: startDate),
        "end_date": format(date: endDate)
      ]
    default:
      break
    }
    
    urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
    
    return urlRequest
  }
  
  func format(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    return dateFormatter.string(from: date)
  }
}
