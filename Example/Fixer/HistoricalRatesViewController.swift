//
//  HistoricalRatesViewController.swift
//  Fixer_Example
//
//  Created by Julius Lundang on 18/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

import Fixer
import MBProgressHUD

class HistoricalRatesViewController: UIViewController {
  
  @IBOutlet weak var txtResponse: UITextView!
  
  weak var fx: Fixer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    let now = Date()
    let sevenDaysAgo = now.addingTimeInterval(-7*24*60*60)
    
    fx.historicalRates(on: sevenDaysAgo) { response, error in
      if let response = response,
        let jsonData = try? JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
        let jsonText = String(data: jsonData, encoding: .utf8){
        DispatchQueue.main.async {
          self.txtResponse.text = jsonText
          MBProgressHUD.hide(for: self.view, animated: true)
        }
      }
    }
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
