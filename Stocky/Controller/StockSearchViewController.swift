//
//  StockSearchViewController.swift
//  Stocky
//
//  Created by Kevin John on 11/04/19.
//  Copyright © 2019 Kevin John. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct stockNames:Decodable {
    var stockName: String
    var stockDesc: String
    
}

protocol CanReceive {
    func dataReceived(data: String)
}

class StockSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var DataSendDelegate : CanReceive?
    
    var stockKeyWord: String = ""
    var stockTickerName: String = ""
    let stockApiURL: String = "https://www.alphavantage.co/query"
    
    let stockApiKey = "DPNE9POYWU8W7IWW"
    let stockApiKeyTwo = "BT1EF6MOQYENMWH7"
    let stockApiKeyThree = "D8KI7A3DAF6BM2UC"
    let stockApiKeyFour = "O6GAZGZF794QC1KB"
    let stockApikeyFive = "THOGQBG3405YULKF"
    var stockErrorBool: Bool = false
    
    var searchActive : Bool = false
    @IBOutlet var StockSearchBar: UISearchBar!
    @IBOutlet var StockSearchTableView: UITableView!
    
    
    var stockSearchArray = [stockNames]()
    //var stockNames = [String]()
    
    var count:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        StockSearchTableView.delegate = self
        StockSearchTableView.dataSource = self
        StockSearchTableView.backgroundColor = UIColor.black
        StockSearchBar.delegate = self
        // Do any additional setup after loading the view.
        
        StockSearchTableView.register(UINib(nibName: "CustomStockSearchCell", bundle: nil), forCellReuseIdentifier: "CustomStockSearchCell")
        
            configureTableView()
        
    }
  
    
    func configureTableView(){
        
        StockSearchTableView.rowHeight = UITableView.automaticDimension
        
        StockSearchTableView.estimatedRowHeight = 120.0
    }
    
    func searchFieldEnterPressed(searchField: UISearchBar) -> Bool{
        
        searchField.resignFirstResponder()
        
        
        return true
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        //print("called")
        stockKeyWord = searchText
        if stockKeyWord != "" {
            //stockKeyWord = searchText
            let params : [String : String]
        
            if count == 1{
                params = ["function" : "SYMBOL_SEARCH", "keywords" : stockKeyWord, "apikey" : self.stockApiKey]
                self.stockKeyWord = ""
                print("count1")
            }
            else if count == 2{
                params = ["function" : "SYMBOL_SEARCH", "keywords" : stockKeyWord, "apikey" : stockApiKeyTwo]
                self.stockKeyWord = ""
                print("2")
            }
            else if count == 3{
                params = ["function" : "SYMBOL_SEARCH", "keywords" : stockKeyWord, "apikey" : stockApiKeyThree]
                self.stockKeyWord = ""
                print("3")
            }
            else if count == 4{
                params = ["function" : "SYMBOL_SEARCH", "keywords" : stockKeyWord, "apikey" : stockApiKeyFour]
                self.stockKeyWord = ""
                print("4")
            }
            else if count == 5{
                params = ["function" : "SYMBOL_SEARCH", "keywords" : stockKeyWord, "apikey" : stockApikeyFive]
                self.count = 0
                self.stockKeyWord = ""
                print("5")
            }
            else{
                params = ["function" : "SYMBOL_SEARCH", "keywords" : stockKeyWord, "apikey" : stockApiKey]
                self.stockKeyWord = ""
                print("0")
            }
        
        
        //let params : [String : String] = ["function" : "SYMBOL_SEARCH", "keywords" : stockKeyWord, "apikey" : stockApiKey]
        
            self.stockSearchArray.removeAll()
            searchStocks(url: stockApiURL, parameters: params)
            self.StockSearchTableView.reloadData()
            self.count += 1
        }
    }
    
    func searchStocks(url: String, parameters : [String : String]){
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess{
                //print("success")
                let stockJSON : JSON = JSON(response.result.value!)
                if stockJSON["Note"] == "Thank you for using Alpha Vantage! Our standard API call frequency is 5 calls per minute and 500 calls per day. Please visit https://www.alphavantage.co/premium/ if you would like to target a higher API call frequency."{
                    self.stockErrorBool = true
                }
                for (_, subJson):(String, JSON) in stockJSON["bestMatches"]{
                    //print(subJson["1. symbol"])
                    let name = subJson["1. symbol"].stringValue
                    let desc = subJson["2. name"].stringValue
                    //print(name)
                    //print(desc)
                    self.stockSearchArray.append(stockNames.init(stockName: name, stockDesc: desc))
                    //print(self.stockSearchArray.count)
                }
                
                self.StockSearchTableView.reloadData()
            }
            else{
                print("error \(response.result.error!)")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomStockSearchCell", for: indexPath) as! CustomStockSearchCell
        
        cell.StockName.text = stockSearchArray[indexPath.row].stockName
        cell.StockDesc.text = stockSearchArray[indexPath.row].stockDesc
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockSearchArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CustomStockSearchCell", for: indexPath) as! CustomStockSearchCell
        
        //print(stockSearchArray[indexPath.row].stockName)
        self.stockTickerName = stockSearchArray[indexPath.row].stockName
        StockSearchTableView.deselectRow(at: indexPath, animated: true)
        let goToRoot = self.navigationController?.viewControllers[0] as! TableViewController
        goToRoot.dataReceived(data: stockTickerName)
        //print(self.stockKeyWord)
        self.DataSendDelegate?.dataReceived(data: stockTickerName)
        self.navigationController?.popToRootViewController(animated: true)
        
        //delegate?.dataReceived(data: stockSearchArray[indexPath.row].stockName)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
