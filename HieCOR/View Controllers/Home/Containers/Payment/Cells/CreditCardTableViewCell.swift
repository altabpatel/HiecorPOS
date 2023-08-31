//
//  CreditCardTableViewCell.swift
//  PaymentsModule
//
//  Created by HTS on 3/22/18.
//  Copyright © 2018 HTS. All rights reserved.
//

import UIKit

class CreditCardTableViewCell: UITableViewCell
{
     //MARK: IBOutlet
    @IBOutlet var CCNoField: UITextField!
    @IBOutlet var ccExpMM: UITextField!
    @IBOutlet var ccExpyear: UITextField!
    @IBOutlet var ccCVV: UITextField!
    @IBOutlet var ccAmountField: UITextField!
    @IBOutlet var ccTripAmount: UITextField!
    @IBOutlet var ccRemoveBtn: UIButton!
    @IBOutlet var backView: UIView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet var voidButton: UIButton!
    @IBOutlet weak var btnSavedCard: UIButton!
    
    //MARK: Class Life Cycle
    override func layoutSubviews()
    {
        //...
    }
    
    func load() {
        //Empty TextField
        CCNoField.text = ""
        ccExpMM.text = ""
        ccExpyear.text = ""
        ccCVV.text = ""
        ccAmountField.text = ""
        ccTripAmount.text = ""
        //Set Border Lines
//        CCNoField.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        ccExpMM.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        ccExpyear.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        ccCVV.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        ccAmountField.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        ccTripAmount.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        //Set DropDown
        ccExpMM.setDropDown()
        ccExpyear.setDropDown()
        //Set Dollar
        ccAmountField.setDollar(font: ccAmountField.font!)
        ccTripAmount.setDollar(font: ccTripAmount.font!)
        //Set Placeholder
        CCNoField.setPlaceholder()
        ccExpMM.setPlaceholder()
        ccExpyear.setPlaceholder()
        ccCVV.setPlaceholder()
        ccAmountField.setPlaceholder()
        ccTripAmount.setPlaceholder()
        //Hide Tip
        ccTripAmount.isHidden = !DataManager.collectTips
        
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    override var frame: CGRect {
        get
        {
            return super.frame
        }
        set (newFrame)
        {
            var frame = newFrame
            frame.origin.x += 10
            frame.size.width -= 20
            frame.origin.y += 05
            frame.size.height -= 10
            super.frame = frame
        }
    }
}
