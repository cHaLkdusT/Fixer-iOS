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
        case .failure(let err):
          completionHandler(nil, err)
        }
    }
  }
  
  static func parseError(_ response: [String: Any]) -> NSError? {
    guard let error = response["error"] as? [String: Any],
      let code = error["code"] as? Int,
      let type = error["type"] as? String,
      let info = error["info"] as? String else {
        return nil
    }
    
    return NSError(code: code, type: type, info: info)
  }
}
