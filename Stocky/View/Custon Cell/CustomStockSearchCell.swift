//
//  CustomStockSearchCell.swift
//  Stocky
//
//  Created by Kevin John on 11/04/19.
//  Copyright © 2019 Kevin John. All rights reserved.
//

import UIKit

class CustomStockSearchCell: UITableViewCell {

    
    @IBOutlet var StockName: UILabel!
    
    @IBOutlet var StockDesc: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
