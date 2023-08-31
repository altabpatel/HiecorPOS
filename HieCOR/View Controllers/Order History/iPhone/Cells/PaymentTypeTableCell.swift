//
//  PaymentTypeTableCell.swift
//  HieCOR
//
//  Created by Deftsoft on 10/12/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class PaymentTypeTableCell: UITableViewCell {

    @IBOutlet weak var iphoneWidthConstraintCrossbtn: NSLayoutConstraint!
    @IBOutlet weak var labelDot: UILabel!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var voidViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var fullRefundButton: UIButton!
    @IBOutlet weak var partialRefundButton: UIButton!
    @IBOutlet weak var partialRefundTextField: UITextField!
    @IBOutlet weak var partialRefundTextFieldSmall: UITextField!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var voidButton: UIButton!
    @IBOutlet weak var optionsStackView: UIStackView!
    @IBOutlet weak var voidBackView: UIView!
    @IBOutlet var paymentTypeLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var voidButtonStack: UIStackView!
    @IBOutlet weak var ViewRefund: UIStackView!
    @IBOutlet weak var viewPrizeLable: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
