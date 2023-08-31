//
//  CardReaderDeviceCell.swift
//  HieCOR
//
//  Created by Hiecor on 05/06/20.
//  Copyright © 2020 HyperMacMini. All rights reserved.
//

import UIKit

class CardReaderDeviceCell: UITableViewCell {
    
    @IBOutlet weak var deviceNameLbl: UILabel!
    
    override func awakeFromNib() {
          super.awakeFromNib()
      }
      
      override func setSelected(_ selected: Bool, animated: Bool) {
          super.setSelected(selected, animated: animated)
      }
}
