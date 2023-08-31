//
//  MenuTableViewCell.swift
//  HieCOR
//
//  Created by Priya  on 29/11/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewBase: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
