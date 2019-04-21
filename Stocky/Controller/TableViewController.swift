//
//  ViewController.swift
//  Stocky
//
//  Created by Kevin John on 21/03/19.
//  Copyright © 2019 Kevin John. All rights reserved.
//

import UIKit




class TableViewController: UITableViewController{//}, CanReceive{

    
    @IBOutlet var StockViewTableView: UITableView!
    
    let stockCellContent = StockCellContent()
    
    //var stockNames = [String]()
    var stockArray = [StockCellContent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        StockViewTableView.delegate = self
        StockViewTableView.dataSource = self
        StockViewTableView.backgroundColor = UIColor.black
        
        
        
        
        StockViewTableView.register(UINib(nibName: "CustomStockCell", bundle: nil), forCellReuseIdentifier: "CustomStockCell")
        configureTableView()
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomStockCell", for: indexPath) as! CustomStockCell
        
        let messageArray = ["first Message", "Second Message", "Third Message"]
        
        cell.StockName.text = messageArray[indexPath.row]//.StockName
        //cell.StockPrice.text = messageArray[indexPath.row]//.StockPrice
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func configureTableView(){
    
        StockViewTableView.rowHeight = UITableView.automaticDimension
        
        StockViewTableView.estimatedRowHeight = 120.0
    
    }
    
//    @IBAction func unwindFromStockSearchViewController(_ sender: UIStoryboardSegue){
//
//        if sender.source is StockSearchViewController {
//            if let senderVC = sender.source as? StockSearchViewController {
//                self.stockNames.append(senderVC.stockKeyWord)
//            }
//        }
//
//    }
    
    func getStockPriceFromAPI(){
        
    }
//    func dataReceived(data: String) {
//
//    }
    
}

