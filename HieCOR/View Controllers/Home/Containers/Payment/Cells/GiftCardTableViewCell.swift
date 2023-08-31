//
//  GiftCardTableViewCell.swift
//  PaymentsModule
//
//  Created by HTS on 3/22/18.
//  Copyright © 2018 HTS. All rights reserved.
//

import UIKit

class GiftCardTableViewCell: UITableViewCell {

     //MARK: IBOutlet
    @IBOutlet var giftCardNoField: UITextField!
    @IBOutlet var giftCardPinField: UITextField!
    @IBOutlet var giftCardRemoveBtn: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var backView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet var amountField: UITextField!
    @IBOutlet var voidButton: UIButton!

    //MARK: Class Life Cycle
    override func layoutSubviews()
    {
        //...
    }
    
    func load() {
        //Empty TextField
        giftCardNoField.text = ""
        giftCardPinField.text = ""
        amountField.text = ""
        //Set Border
//        giftCardNoField.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        giftCardPinField.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        amountField.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        //Set Placeholder
        giftCardNoField.setPlaceholder()
        giftCardPinField.setPlaceholder()
        amountField.setPlaceholder()
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
