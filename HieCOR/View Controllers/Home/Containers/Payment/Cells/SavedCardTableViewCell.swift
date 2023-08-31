//
//  SavedCardTableViewCell.swift
//  HieCOR
//
//  Created by Hiecor Software on 23/07/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import UIKit

class SavedCardTableViewCell: UITableViewCell {

    //MARK: IBOutlet
    @IBOutlet weak var labelCardDate: UILabel!
    @IBOutlet weak var labelSavedCard: UILabel!
    @IBOutlet weak var btnSelection: UIButton!
    @IBOutlet weak var ViewCellEdit: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var viewUpdate: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var txfYear: UITextField!
    @IBOutlet weak var txfMonth: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
