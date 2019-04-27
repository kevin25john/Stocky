//
//  ViewController.swift
//  Stocky
//
//  Created by Kevin John on 21/03/19.
//  Copyright © 2019 Kevin John. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Foundation
import RealmSwift


class TableViewController: UITableViewController, CanReceive{

    
    @IBOutlet var StockViewTableView: UITableView!
    
    let realm = try! Realm()
    
    var stockCellContents = StockCellContent()
    let stockApiURL: String = "https://www.alphavantage.co/query"
    let stockApiKey = "DPNE9POYWU8W7IWW"
    let stockApiKeyTwo = "BT1EF6MOQYENMWH7"
    let stockApiKeyThree = "D8KI7A3DAF6BM2UC"
    let stockApiKeyFour = "O6GAZGZF794QC1KB"
    let stockApikeyFive = "THOGQBG3405YULKF"
    var stockKeyword: String = ""
    var stockNames = [String]()
    var stockArray = [StockCellContent]()
    //var stockList = [Category]()
    var stockUpdateFlag: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        StockViewTableView.delegate = self
        StockViewTableView.dataSource = self
        StockViewTableView.backgroundColor = UIColor.black
  
        StockViewTableView.register(UINib(nibName: "CustomStockCell", bundle: nil), forCellReuseIdentifier: "CustomStockCell")
        configureTableView()
        reloadUpdatedTableData()
        
        //updateTable()
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomStockCell", for: indexPath) as! CustomStockCell
        
        cell.StockName.text = self.stockArray[indexPath.row].StockName
        cell.StockPrice.text = String(self.stockArray[indexPath.row].StockPrice)
        //print(self.stockArray[indexPath.row].StockName)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockArray.count
    }
    
    func configureTableView(){
    
        StockViewTableView.rowHeight = UITableView.automaticDimension
        
        StockViewTableView.estimatedRowHeight = 120.0
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print(self.stockArray[indexPath.row].StockName)
        
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            stockArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    
    
//    @IBAction func unwindFromStockSearchViewController(_ sender: UIStoryboardSegue){
//
//        if sender.source is StockSearchViewController {
//            if let senderVC = sender.source as? StockSearchViewController {
//                self.stockNames.append(senderVC.stockKeyWord)
//                print(senderVC.stockKeyWord)
//            }
//            tableView.reloadData()
//        }
//
//    }
    
    
    func dataReceived(data: String) {
        self.stockNames.append(data)
        self.stockKeyword = data
        var stockData = StockCellContent()
        //var stockDataTest = StockObjectTest()
        let params = ["function" : "GLOBAL_QUOTE", "symbol" : stockKeyword, "apikey" : stockApiKey]
        stockData = getStockPriceFromJSON(url: stockApiURL, parameters: params)
        //print(stockData.StockPrice)
        self.stockArray.append(stockData)
        
        //print(stockData.StockPrice)
        //print(data)
        //print(stockData.StockName)
        //print(stockData.StockPrice)
        //print(self.stockArray[0].StockPrice)
        //self.stockCellContents = stockData
        //self.stockList.append(newCategory)
        self.save(stockCellContent: stockData)
        
        self.stockUpdateFlag = true
        //updateTable()
        //tableView.reloadData()
    }
    
    func getStockPriceFromJSON(url: String, parameters : [String : String]) -> StockCellContent{
        let stockDataa =  StockCellContent()
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess{
                //print("success")
                let stockJSON : JSON = JSON(response.result.value!)
                if stockJSON["Note"] == "Thank you for using Alpha Vantage! Our standard API call frequency is 5 calls per minute and 500 calls per day. Please visit https://www.alphavantage.co/premium/ if you would like to target a higher API call frequency."{
                    //self.stockErrorBool = true
                }
                //print(stockJSON["Global Quote"]["05. price"])
                
                
                stockDataa.StockName = stockJSON["Global Quote"]["01. symbol"].stringValue
                let price = stockJSON["Global Quote"]["05. price"].stringValue
                //print(stockData.StockName)
                //print(price)
                stockDataa.StockPrice = Double(price)!
                
                self.tableView.reloadData()
            }
            else{
                print("error \(response.result.error!)")
            }
        }
        
        
        return stockDataa
    }
    
    func save(stockCellContent: StockCellContent){
        
        let stockObject = StockCellContent()
        //print("called")
        
        try! realm.write {
            
            //let params = ["function" : "GLOBAL_QUOTE", "symbol" : stockCellContent, "apikey" : stockApiKey]
            let Stringg = stockCellContent.StockName
            let Doublee = stockCellContent.StockPrice
            stockObject.StockName = Stringg
            stockObject.StockPrice = Doublee
            
            //print(stockObject.StockPrice)
            realm.add(stockObject)
            //print("called")
            
        }
        self.test()
        tableView.reloadData()
    }
    
    func test(){
        for obs in self.stockArray{
            print(obs.StockName)
            print(obs.StockPrice)
            print("clled")
        }
        
    }
    
    func reloadUpdatedTableData(){
        print("called")
        
        var stockData = StockCellContent()
        if stockArray.count != 0{
            for index in 0...stockArray.count-1{
            
            
                let params = ["function" : "GLOBAL_QUOTE", "symbol" : self.stockArray[index].StockName, "apikey" : stockApiKey]
                stockData = getStockPriceFromJSON(url: stockApiURL, parameters: params)
                self.stockArray[index].StockPrice = stockData.StockPrice
            }
        }
        tableView.reloadData()
        
    }
    
    
    
    
}

