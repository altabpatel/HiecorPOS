//
//  DrawerHistoryCell.swift
//  HieCOR
//
//  Created by Rajshekar Pothu on 23/11/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class DrawerHistoryCell: UITableViewCell {

    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblSalesLocation: UILabel!
    @IBOutlet weak var labelName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
