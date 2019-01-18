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
  public func supportedSymbols(completionHandler: @escaping FixerCompletionHandler) {
    sessionManager.request(Router.symbols)
      .validate()
      .responseJSON { response in
        Fixer.processResponse(response: response, completionHandler: completionHandler)
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
  public func latestRates(base currency: String = "EUR",
                          symbols: [String] = [],
                          completionHandler: @escaping FixerCompletionHandler) {
    sessionManager.request(Router.latest(base: currency, symbols: symbols))
      .validate()
      .responseJSON { response in
        Fixer.processResponse(response: response, completionHandler: completionHandler)
    }
  }
  
  /// [Historical Rates Endpoint]().
  /// Historical rates are available for most currencies all the way back to the year of 1999.
  /// You can query the Fixer API for historical rates by appending a date (format YYYY-MM-DD)
  /// to the base URL.
  ///
  /// - Parameters:
  ///   - date: A date in the past for which historical rates are requested.
  ///   - currency: Currency code of your preferred base currency. Defaults to "EUR"
  ///   - symbols: Currency codes to limit output currencies
  ///   - completionHandler: Completion handler
  public func historicalRates(on date: Date,
                              base currency: String = "EUR",
                              symbols: [String] = [],
                              completionHandler: @escaping FixerCompletionHandler) {
    sessionManager.request(Router.history(date: date, base: currency, symbols: symbols))
      .validate()
      .responseJSON { response in
        Fixer.processResponse(response: response, completionHandler: completionHandler)
    }
  }
  
  /// [Convert Endpoint](https://fixer.io/documentation#convertcurrency).
  /// The Fixer API comes with a separate currency conversion endpoint, which can be used to
  /// convert any amount from one currency to another. In order to convert currencies,
  /// please use the API's convert endpoint, append the from and to parameters and
  /// set them to your preferred base and target currency codes.
  ///
  /// - Parameters:
  ///   - amount: The amount to be converted
  ///   - from: Currency you would like to convert from
  ///   - to: Currency you would like to convert to
  ///   - date: Specify a date to use historical rates for this conversion.
  ///   - completionHandler: Completion handler
  public func convert(_ amount: Double,
                      from: String,
                      to: String,
                      on date: Date? = nil,
                      completionHandler: @escaping FixerCompletionHandler) {
    sessionManager.request(Router.convert(amount: amount, from: from, to: to, date: date))
      .validate()
      .responseJSON { response in
        Fixer.processResponse(response: response, completionHandler: completionHandler)
    }
  }
  
  /// [Time-Series Endpoint](https://fixer.io/documentation#timeseries).
  /// If supported by your subscription plan, the Fixer API's timeseries endpoint lets you query
  /// the API for daily historical rates between two dates of your choice,
  /// with a maximum time frame of 365 days.
  ///
  /// - Parameters:
  ///   - base: Currency code of your preferred base currency
  ///   - symbols: Currency codes to limit output currencies
  ///   - startDate: The start date of your preferred timeframe
  ///   - endDate: The end date of your preferred timeframe
  ///   - completionHandler: Completion handler
  public func dailyHistoricalRates(base: String = "EUR",
                                   symbols: [String] = [],
                                   between startDate: Date,
                                   and endDate: Date,
                                   completionHandler: @escaping FixerCompletionHandler) {
    let urlRequest = Router.timeSeries(base: base, symbols: symbols, startDate: startDate, endDate: endDate)
    sessionManager.request(urlRequest)
      .validate()
      .responseJSON { response in
        Fixer.processResponse(response: response, completionHandler: completionHandler)
    }
  }
  
  private static func processResponse(response: DataResponse<Any>,
                                      completionHandler: FixerCompletionHandler) {
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
  
  /// Static helper function that parses the Fixer.io JSON response. It returns an NSError object
  /// if the response has `error` key-value
  ///
  /// - Parameter response: Fixer.io JSON response
  /// - Returns: An error if response has `error` key-value
  private static func parseError(_ response: [String: Any]) -> NSError? {
    guard let error = response["error"] as? [String: Any],
      let code = error["code"] as? Int,
      let type = error["type"] as? String else {
        return nil
    }
    let info = error["info"] as? String
    
    return NSError(code: code, type: type, info: info)
  }
}
