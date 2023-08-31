//
//  CashTableViewCell.swift
//  PaymentsModule
//
//  Created by HTS on 3/22/18.
//  Copyright © 2018 HTS. All rights reserved.
//

import UIKit

class CashTableViewCell: UITableViewCell {

     //MARK: IBOutlet
    @IBOutlet var cashAmountField: UITextField!
    @IBOutlet var cashRemoveBtn: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var backView: UIView!
    @IBOutlet var voidButton: UIButton!

    //MARK: Class Life Cycle
    override func layoutSubviews()
    {
        //...
    }
    
    func load() {
        //Empty TextField
        cashAmountField.text = ""
        //Set Border
        cashAmountField.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        //Set Dollar
        cashAmountField.setDollar(font: cashAmountField.font!)
        //Set Placeholder
        cashAmountField.setPlaceholder()
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
