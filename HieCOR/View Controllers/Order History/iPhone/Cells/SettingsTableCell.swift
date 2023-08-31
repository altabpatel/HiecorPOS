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
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var label: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
