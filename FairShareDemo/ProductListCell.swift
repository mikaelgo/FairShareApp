//
//  ProductListCell.swift
//  FairShareDemo
//
//  Created by Mikael on 13/11/2017.
//  Copyright © 2017 Mikael. All rights reserved.
//

import UIKit

class ProductListCell: UITableViewCell {
    
    //This ViewController is just for the single cell in the tableview
    
    @IBOutlet weak var productNameLabel: UILabel!
    var productListItem: ProductListItem?

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(productListItem: ProductListItem) {
        self.productListItem = productListItem
        productNameLabel.text = productListItem.product?.productname ?? ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
