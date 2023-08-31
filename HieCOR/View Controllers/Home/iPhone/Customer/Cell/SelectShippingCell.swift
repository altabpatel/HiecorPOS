//
//  SelectShippingCell.swift
//  HieCOR
//
//  Created by Hiecor Software on 03/09/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import UIKit

class SelectShippingCell: UITableViewCell {

    @IBOutlet weak var viewZipCountryIpad: UIView!
    @IBOutlet weak var viewCityRegIpad: UIView!
    @IBOutlet weak var tfCountryIphone: UITextField!
    @IBOutlet weak var tfZipIphone: UITextField!
    @IBOutlet weak var tfStateIphone: UITextField!
    @IBOutlet weak var tfCityIphone: UITextField!
    @IBOutlet weak var viewCityIphone: UIView!
    @IBOutlet weak var viewStateIphone: UIView!
    @IBOutlet weak var viewZipIphone: UIView!
    @IBOutlet weak var viewCountryIphone: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var tfCountry: UITextField!
    @IBOutlet weak var tfZip: UITextField!
    @IBOutlet weak var tfRegion: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    @IBOutlet weak var tfAddress2: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var viewPartCountryipad: UIView!
    
    @IBOutlet weak var heightConstOfView1: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.loadUI()
    }
    
    func loadUI()  {
        
        
        
        
        
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            tfCountry.setDropDown()
            tfRegion.setDropDown()
        }else{
            tfCountryIphone.setDropDown()
            tfStateIphone.setDropDown()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
