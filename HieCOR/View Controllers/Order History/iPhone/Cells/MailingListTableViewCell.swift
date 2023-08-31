//
//  MailingListTableViewCell.swift
//  HieCOR
//
//  Created by Hiecor Software on 21/08/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import UIKit

class MailingListTableViewCell: UITableViewCell {

    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var lableTilte: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
