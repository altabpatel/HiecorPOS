//
//  AddPaymentCollectionCell.swift
//  HieCOR
//
//  Created by Sudama dewda on 21/08/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import UIKit

class AddPaymentCollectionCell: UICollectionViewCell {
    @IBOutlet weak var paymentTypeImage: UIImageView!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    @IBOutlet weak var payemntCellView: UIView!
    @IBOutlet weak var lblTransactionName: UILabel!
    @IBOutlet weak var btncheckAmount: UIButton!
    @IBOutlet weak var txfAmount: UITextField!
    @IBOutlet weak var viewEMV: UIView!
    @IBOutlet weak var txfPaxDevice: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
