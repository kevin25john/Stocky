//
//  CustomStockCell.swift
//  Stocky
//
//  Created by Kevin John on 11/04/19.
//  Copyright © 2019 Kevin John. All rights reserved.
//

import UIKit

class CustomStockCell: UITableViewCell {
    
    
    @IBOutlet weak var StockName: UILabel!
    @IBOutlet weak var TrackerStatusImageView: UIImageView!
    @IBOutlet weak var StockPrice: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
