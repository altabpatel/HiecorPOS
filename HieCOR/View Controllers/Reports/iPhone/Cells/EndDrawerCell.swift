//
//  EndDrawerCell.swift
//  HieCOR
//
//  Created by Hiecor Software on 03/10/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import UIKit

class EndDrawerCell: UITableViewCell {

    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var labelEndTime: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblSalesLocation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
