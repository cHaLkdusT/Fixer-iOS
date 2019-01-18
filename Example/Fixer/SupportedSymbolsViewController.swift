//
//  SupportedSymbolsViewController.swift
//  Fixer_Example
//
//  Created by Julius Lundang on 18/01/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

import Fixer
import MBProgressHUD

class SupportedSymbolsViewController: UITableViewController {

  weak var fx: Fixer!
  var symbols: [(symbol: String, description: String?)] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    MBProgressHUD.showAdded(to: self.view, animated: true)
    
    fx.supportedSymbols { response, error in
      if let symbolsObj = response?["symbols"] as? [String: String] {
        let keys = [String] (symbolsObj.keys)
        var symbols = [(symbol: String, description: String?)]()
        for key in keys.sorted() {
          symbols.append((symbol: key, description: symbolsObj[key]))
        }
        self.symbols = symbols
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
          MBProgressHUD.hide(for: self.view, animated: true)
        }
      }
    }
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return symbols.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SupportedSymbolCell", for: indexPath)
    
    let (symbol, description) = symbols[indexPath.item]
    // Configure the cell...
    cell.textLabel?.text = description
    cell.detailTextLabel?.text = symbol
    
    return cell
  }
}
