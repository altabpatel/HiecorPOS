//
//  ItemsValueCell.swift
//  HieCOR
//
//  Created by Hiecor on 31/07/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import UIKit

class ItemsValueCell: UITableViewCell {
    
    @IBOutlet weak var tfItemHeightCons: NSLayoutConstraint!
    @IBOutlet weak var itemStackView: UIStackView!
    @IBOutlet weak var tfItems: UITextField!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var txfProductqauntity: UITextField!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var tfOther: UITextField!
    @IBOutlet weak var btnReturnBacktoStock: UIButton!
    
    //@IBOutlet weak var lblReturnCondition: UILabel!
    // @IBOutlet weak var viewReturnCondition: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
