//
//  AddDiscountPopupVC.swift
//  HieCOR
//
//  Created by Deftsoft on 31/10/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class AddDiscountPopupVC: BaseViewController {

    //MARK: Variables
    var delegate: AddDiscountPopupVCDelegate?
    
    //MARK: IBOutlets
    @IBOutlet weak var applyCouponView: UIView!

    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.applyCouponView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
    }
    
    //MARK: IBAction Method 
    @IBAction func applyCouponAction(_ sender: Any) {
        //Offline
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
//            self.showAlert(title: "Oops!", message: "Coupons are not avalable in the offline mode!")
            appDelegate.showToast(message: "Coupons are not avalable in the offline mode!")
            return
        }
        //Online
        self.delegate?.didSelectApplyCoupon?()
    }
    
    @IBAction func manualFlatDiscountAction(_ sender: Any) {
        self.delegate?.didSelectManualFlatDiscount?()
    }
    
    @IBAction func manualPrcentageDiscountAction(_ sender: Any) {
        self.delegate?.didSelectManualPrcentageDiscount?()
    }
}
