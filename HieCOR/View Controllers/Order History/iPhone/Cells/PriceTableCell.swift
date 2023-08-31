//
//  PriceTableCell.swift
//  HieCOR
//
//  Created by Deftsoft on 31/08/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class PriceTableCell: UITableViewCell {

    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var shipingLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var subTotalStackView: UIStackView!
    @IBOutlet weak var tipStackView: UIStackView!
    @IBOutlet weak var discountStackView: UIStackView!
    @IBOutlet weak var shipingStackView: UIStackView!
    @IBOutlet weak var taxStackView: UIStackView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
