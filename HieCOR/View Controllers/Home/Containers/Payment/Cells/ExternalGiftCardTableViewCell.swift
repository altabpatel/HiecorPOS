//
//  ExternalGiftCardTableViewCell.swift
//  HieCOR
//
//  Created by Deftsoft on 27/08/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class ExternalGiftCardTableViewCell: UITableViewCell {
    
    //MARK: IBOutlet
    @IBOutlet var giftCardNoField: UITextField!
    @IBOutlet var giftCardRemoveBtn: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var backView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet var amountField: UITextField!
    @IBOutlet var voidButton: UIButton!

    //MARK: Class LIfe Cycle
    override func layoutSubviews()
    {
        //...
    }
    
    func load() {
        //Empty TextField
        amountField.text = ""
        giftCardNoField.text = ""
        //Set Placeholder
        giftCardNoField.setPlaceholder()
        amountField.setPlaceholder()
        //Set Border
//        giftCardNoField.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        amountField.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        amountField.setDollar(font: amountField.font!)
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

