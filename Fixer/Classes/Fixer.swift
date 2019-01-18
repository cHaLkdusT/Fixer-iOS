//
//  API.swift
//  Fixer
//
//  Created by Julius Lundang on 17/01/2019.
//

import Alamofire

public typealias FixerCompletionHandler = (_ response: [String: Any]?, _ error: Error?) -> Void

public final class Fixer {
  let sessionManager: SessionManager
  
  /// Creates a Fixer client
  ///
  /// - Parameter accessKey: A unique key assigned to each API account used to authenticate with the API.
  public init(accessKey: String) {
    sessionManager = SessionManager()
    sessionManager.adapter = AccessKeyAdapter(accessKey: accessKey)
  }
  
  /// [Supported Symbols Endpoint](https://fixer.io/documentation#supportedsymbols).
  /// The Fixer API comes with a constantly updated endpoint returning all available currencies.
  /// To access this list, make a request to the API's symbols endpoint.
  ///
  /// - Parameter completionHandler: Completion handler
  public func getSupportedSymbols(completionHandler: @escaping FixerCompletionHandler) {
    sessionManager.request(Router.symbols)
      .validate()
      .responseJSON { response in
        switch response.result {
        case .success(let json):
          if let json = json as? [String: Any] {
            let error = Fixer.parseError(json)
            guard error == nil else {
              completionHandler(nil, error)
              return
            }
            
            completionHandler(json, nil)
          }
        case .failure(let error):
          completionHandler(nil, error)
        }
    }
  }
  
  /// [Latest Rates Endpoint](https://fixer.io/documentation#latestrates).
  /// Depending on your subscription plan, the API's latest endpoint will return real-time exchange
  /// rate data updated every 60 minutes, every 10 minutes or every 60 seconds.
  ///
  /// - Parameters:
  ///   - currency: Base currency. Defaults to "EUR"
  ///   - symbols: Currency codes to limit output currencies
  ///   - completionHandler: Completion handler
  public func getLatestRates(base currency: String = "EUR",
                             symbols: [String] = [],
                             completionHandler: @escaping FixerCompletionHandler) {
    sessionManager.request(Router.latest(base: currency, symbols: symbols))
      .validate()
      .responseJSON { response in
        switch response.result {
        case .success(let json):
          if let json = json as? [String: Any] {
            let error = Fixer.parseError(json)
            guard error == nil else {
              completionHandler(nil, error)
              return
            }
            
            completionHandler(json, nil)
          }
        case .failure(let error):
          completionHandler(nil, error)
        }
    }
  }
  
  /// Static helper function that parses the Fixer.io JSON response. It returns an NSError object
  /// if the response has `error` key-value
  ///
  /// - Parameter response: Fixer.io JSON response
  /// - Returns: An error if response has `error` key-value
  static func parseError(_ response: [String: Any]) -> NSError? {
    guard let error = response["error"] as? [String: Any],
      let code = error["code"] as? Int,
      let type = error["type"] as? String else {
        return nil
    }
    let info = error["info"] as? String
    
    return NSError(code: code, type: type, info: info)
  }
}
