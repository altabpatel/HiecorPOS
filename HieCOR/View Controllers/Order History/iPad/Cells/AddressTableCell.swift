//
//  AddressTableCell.swift
//  HieCOR
//
//  Created by Deftsoft on 16/08/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class AddressTableCell: UITableViewCell {

    
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var billingLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
