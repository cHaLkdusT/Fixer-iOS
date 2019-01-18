//
//  LatestRatesViewController.swift
//  Fixer_Example
//
//  Created by Julius Lundang on 18/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

import Fixer
import MBProgressHUD

class LatestRatesViewController: UIViewController {
  
  @IBOutlet weak var txtResponse: UITextView!
  
  var fx: Fixer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    MBProgressHUD.showAdded(to: self.view, animated: true)
    
    fx.latestRates { response, error in
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
}
