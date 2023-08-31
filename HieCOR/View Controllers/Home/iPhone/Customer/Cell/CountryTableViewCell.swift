//
//  CountryTableViewCell.swift
//  HieCOR
//
//  Created by Apple on 31/10/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    //MARK: IBOutlet
    @IBOutlet var nameLabel: UILabel!
    
    //MARK: Class Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
