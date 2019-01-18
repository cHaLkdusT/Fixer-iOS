//
//  MainTableViewController.swift
//  Fixer_Example
//
//  Created by Julius Lundang on 18/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

import Fixer

class MainTableViewController: UITableViewController {
  
  let fx = Fixer(accessKey: "")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let supportedSymbolsVC = segue.destination as? SupportedSymbolsViewController {
      supportedSymbolsVC.fx = fx
    } else if let latestRatesVC = segue.destination as? LatestRatesViewController {
      latestRatesVC.fx = fx
    }
  }
}
