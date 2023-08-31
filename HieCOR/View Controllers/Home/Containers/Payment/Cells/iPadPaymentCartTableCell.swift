//
//  iPadPaymentCartTableCell.swift
//  HieCOR
//
//  Created by Deftsoft on 12/11/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class iPadPaymentCartTableCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var priceQtyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
