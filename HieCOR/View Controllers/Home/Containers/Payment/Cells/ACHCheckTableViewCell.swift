//
//  ACHCheckTableViewCell.swift
//  PaymentsModule
//
//  Created by HTS on 3/22/18.
//  Copyright © 2018 HTS. All rights reserved.
//

import UIKit

class ACHCheckTableViewCell: UITableViewCell {

     //MARK: IBOutlet
    @IBOutlet var achRoutingNoField: UITextField!
    @IBOutlet var achAccountNoField: UITextField!
    @IBOutlet var achDLField: UITextField!
    @IBOutlet var achSelectDLField: UITextField!
    @IBOutlet var achRemoveBtn: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var backView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet var amountField: UITextField!
    @IBOutlet var voidButton: UIButton!

    //MARK: Class Life Cycle
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    override func layoutSubviews()
    {
        //...
    }
    
    func load() {
        //Empty TextField
        achRoutingNoField.text = ""
        achAccountNoField.text = ""
        achDLField.text = ""
        achSelectDLField.text = ""
        amountField.text = ""
        //Set Border
        achRoutingNoField.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        achAccountNoField.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        achDLField.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        achSelectDLField.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        amountField.setBorder(color: UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0))
        //Set DropDown
        achSelectDLField.setDropDown()
        //Set Placeholder
        achRoutingNoField.setPlaceholder()
        achAccountNoField.setPlaceholder()
        achDLField.setPlaceholder()
        achSelectDLField.setPlaceholder()
        amountField.setPlaceholder()
        amountField.setDollar(font: amountField.font!)
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
