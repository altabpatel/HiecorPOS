//
//  CartTableCell.swift
//  HieCOR
//
//  Created by Deftsoft on 27/07/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class CartTableCell: UITableViewCell {
    
    @IBOutlet weak var stackViewCondition: UIStackView!
    @IBOutlet weak var tfSelectCondition: UITextField!
    @IBOutlet var proImgWidthConstarint: NSLayoutConstraint!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var crossButton: UIButton!   //Only for Cart Cell
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var priceQtyLabel: UILabel!
    @IBOutlet weak var productCodeLabel: UILabel!
    @IBOutlet weak var productDiscountLabel: UILabel!
    @IBOutlet weak var returnToStockButton: UIButton!   //Only for Refund Cell
    @IBOutlet weak var returnToStockButtoniPhone: UIButton!   //Only for Refund Cell iPhone
    @IBOutlet weak var returnToStockBackView: UIView!   //Only for Refund Cell
    @IBOutlet weak var btnShowDetails: UIButton!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDisccount: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var showAttributeLabel: UILabel!
    
    @IBOutlet weak var stackViewLeading4: NSLayoutConstraint!
    @IBOutlet weak var stackViewLeading3: NSLayoutConstraint!
    @IBOutlet weak var stackViewLeading2: NSLayoutConstraint!
    @IBOutlet weak var stackViewLeading1: NSLayoutConstraint!
    @IBOutlet weak var proImgHeightConstarint: NSLayoutConstraint!
    
    @IBOutlet weak var btn_DeleteProduct: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
