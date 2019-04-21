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

//protocol CanReceive {
//    func dataReceived(data: String)
//}

class StockSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    //var delegate : CanReceive?
    
    var stockKeyWord: String = ""
    let stockApiURL: String = "https://www.alphavantage.co/query"
    
    let stockApiKey = "DPNE9POYWU8W7IWW"
    
    var searchActive : Bool = false
    @IBOutlet var StockSearchBar: UISearchBar!
    @IBOutlet var StockSearchTableView: UITableView!
    
    
    var stockSearchArray = [stockNames]()
    //var stockNames = [String]()
    
    
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
        let params : [String : String] = ["function" : "SYMBOL_SEARCH", "keywords" : stockKeyWord, "apikey" : stockApiKey]
        self.stockSearchArray.removeAll()
        searchStocks(url: stockApiURL, parameters: params)
        self.StockSearchTableView.reloadData()
    }
    
    func searchStocks(url: String, parameters : [String : String]){
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess{
                print("success")
                let stockJSON : JSON = JSON(response.result.value!)
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
                print("error \(response.result.error)")
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomStockSearchCell", for: indexPath) as! CustomStockSearchCell
        
        print(stockSearchArray[indexPath.row].stockName)
        StockSearchTableView.deselectRow(at: indexPath, animated: true)
        
        //delegate?.dataReceived(data: stockSearchArray[indexPath.row].stockName)
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
