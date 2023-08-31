//
//  ItemsDetailTableCell.swift
//  HieCOR
//
//  Created by Deftsoft on 10/12/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class ItemsDetailTableCell: UITableViewCell {

    @IBOutlet weak var viewWidthRefExc: UIView!

    @IBOutlet weak var labelNotes: UILabel!
    @IBOutlet weak var btnCrossWidthCons: NSLayoutConstraint!
    
    @IBOutlet weak var viewBtnRefExcConstraint: NSLayoutConstraint!
    @IBOutlet weak var variationTitleLabel: UILabel!
    @IBOutlet weak var viewSamebtnCrossWidthCons: NSLayoutConstraint!
    @IBOutlet weak var viewSameBtnCrosee: UIView!
    @IBOutlet weak var lblRefundWidthConstraint: NSLayoutConstraint!
    //@IBOutlet weak var btncrosswidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnExchangeWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bntRefundWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var refundTable: UIButton!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var refundButton: UIButton!
    @IBOutlet weak var exchangeButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var refundedLabel: UILabel!
    @IBOutlet weak var headerView: UIStackView!
    @IBOutlet weak var footerView: UIStackView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var refundExchangeStackView: UIStackView!
    @IBOutlet var labelAction: UILabel!
    @IBOutlet var actionWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var itemHeadLabel: UILabel!
    @IBOutlet weak var constraintHeadItem: NSLayoutConstraint!
    @IBOutlet weak var ConstraintProductName: NSLayoutConstraint!
    
    @IBOutlet weak var lblProductRefundDate: UILabel!
    @IBOutlet weak var productConditionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
//TransactionsCell
class TransactionsListCell: UITableViewCell {
    
    @IBOutlet weak var btnTranxPrnt: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
