//
//  iPadCollectionViewCell.swift
//  HieCOR
//
//  Created by Deftsoft on 26/07/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class iPadCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet var clickButton: UIButton!
    @IBOutlet var backView: UIView!
    @IBOutlet weak var txfSurchargeAmount: UITextField!
    @IBOutlet weak var btnVariationPrice: UIButton!

    var isSelect : Bool?

}
