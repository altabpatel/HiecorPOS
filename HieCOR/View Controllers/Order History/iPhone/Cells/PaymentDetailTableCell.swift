//
//  PaymentDetailTableCell.swift
//  HieCOR
//
//  Created by Deftsoft on 10/12/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class PaymentDetailTableCell: UITableViewCell {
    
    @IBOutlet weak var labelTitleDiscount: UILabel!
    @IBOutlet weak var labelTitleApplyCoupon: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet var couponLabel: UILabel!
    @IBOutlet var couponView: UIView!
    @IBOutlet weak var subtotalView: UIStackView!
    @IBOutlet weak var discountView: UIStackView!
    @IBOutlet weak var tipView: UIStackView!
    @IBOutlet weak var shippingView: UIStackView!
    @IBOutlet weak var taxView: UIStackView!
    
    @IBOutlet var subtotalWidthConstraint: NSLayoutConstraint!
    @IBOutlet var subtotalStackViewRightConstraint: NSLayoutConstraint!
    @IBOutlet var subtotalAmountWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewRefundExchange: UIStackView!
    @IBOutlet weak var btnVoid: UIButton!
    @IBOutlet weak var btnRefund: UIButton!
    
    @IBOutlet weak var btnTipRefund: UIButton!
    
    @IBOutlet weak var refundShipping: UIButton!
    @IBOutlet weak var labelTotalMain: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
