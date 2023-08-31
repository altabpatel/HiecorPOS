//
//  SettingsTableCell.swift
//  HieCOR
//
//  Created by Deftsoft on 08/08/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class SettingsTableCell: UITableViewCell {

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var newTextfield: UITextField!
    @IBOutlet weak var redTextfield: UITextField!
    @IBOutlet weak var greenTextfield: UITextField!
    @IBOutlet weak var blueTextfield: UITextField!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var discountView: UIView!
    
    @IBOutlet weak var paperSizeTextfield: UITextField!
    @IBOutlet weak var lblLeadingConstant: NSLayoutConstraint!
    @IBOutlet weak var searchBtn_widthConst: NSLayoutConstraint!
    @IBOutlet weak var paperWidth_widthConst: NSLayoutConstraint!
    @IBOutlet weak var viewLineLeadingConstrant: NSLayoutConstraint!
    
    @IBOutlet weak var viewStarCloudPrnt: UIView!
    @IBOutlet weak var lblMacAdrs: UILabel!
    @IBOutlet weak var btnDefault: UIButton!
    @IBOutlet weak var btnCheckMark: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblMacAdrsMob: UILabel!
    @IBOutlet weak var txtStarPrinterName: UITextField!
    var activity = UIActivityIndicatorView()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
     
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
