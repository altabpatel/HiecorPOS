//
//  PaxTableViewCell.swift
//  PaymentsModule
//
//  Created by HTS on 3/22/18.
//  Copyright © 2018 HTS. All rights reserved.
//

import UIKit
import Foundation

class PaxTableViewCell: UITableViewCell {

     //MARK: IBOutlet
    
    @IBOutlet weak var tfTipAmount: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var selectDeviceTextField: UITextField!
    @IBOutlet var paxRemoveBtn: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var backView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet var paxTypeSegemnt: UISegmentedControl!
    @IBOutlet var voidButton: UIButton!

    //MARK: Class Life Cycle
    override func layoutSubviews()
    {
        //...
    }
    
    func load() {
        //Empty TextField
        amountTextField.text = ""
        tfTipAmount.text = ""
        selectDeviceTextField.text = ""
        //Remove Border
        amountTextField.removeInLineBorder()
        tfTipAmount.removeInLineBorder()
        selectDeviceTextField.removeInLineBorder()
        //Set Border
        tfTipAmount.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        amountTextField.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        selectDeviceTextField.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        //Set Dollar
        amountTextField.setDollar(font: amountTextField.font!)
        tfTipAmount.setDollar(font: tfTipAmount.font!)
        //Set DropDown
        selectDeviceTextField.setDropDown()
        //Set Placeholder
        amountTextField.setPlaceholder()
        tfTipAmount.setPlaceholder()
        selectDeviceTextField.setPlaceholder()
        //Hide Tip
        tfTipAmount.isHidden = !DataManager.collectTips
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
