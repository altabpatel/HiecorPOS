//
//  TransactionTableCell.swift
//  HieCOR
//
//  Created by Deftsoft on 13/12/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class TransactionTableCell: UITableViewCell {
    
    @IBOutlet var tfpaxDevice2heightCons: NSLayoutConstraint!
    @IBOutlet var tfpaxDevice1WidthCons: NSLayoutConstraint!
    @IBOutlet var paymentNameLabel: UILabel!
    @IBOutlet var paymentTypeLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var textfield1: UITextField!
    @IBOutlet var textfield2: UITextField!
    
    @IBOutlet var tfPaxDevice2: UITextField!
    @IBOutlet var tfPaxDevice1: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
