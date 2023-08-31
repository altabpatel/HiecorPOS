//
//  SubscriptionContainerViewController.swift
//  HieCOR
//
//  Created by Hiecor Software on 17/02/20.
//  Copyright © 2020 HyperMacMini. All rights reserved.
//

import UIKit

class SubscriptionContainerViewController: BaseViewController {
    
    //MARK: Variables
    var delegate: EditProductDelegate?
    var subDelegate : SubscriptionDelegate?
    var strSubscriptionValueCheck = ""
    var subAction = ""
    
    @IBOutlet weak var btnSusbscriptionNoChange: UIButton!
    @IBOutlet weak var btnSubscriptionWithOrder: UIButton!
    @IBOutlet weak var btnSubscriptionWithUser: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UI_USER_INTERFACE_IDIOM() == .phone{
            switch strSubscriptionValueCheck {
            case "cancel_all":
                btnSubscriptionWithUser.isSelected = true
                btnSubscriptionWithOrder.isSelected = false
                btnSusbscriptionNoChange.isSelected = false
                break
            case "cancel_order":
                btnSubscriptionWithUser.isSelected = false
                btnSubscriptionWithOrder.isSelected = true
                btnSusbscriptionNoChange.isSelected = false
                break
            case "no_change" :
                btnSubscriptionWithUser.isSelected = false
                btnSubscriptionWithOrder.isSelected = false
                btnSusbscriptionNoChange.isSelected = true
                break
            default:
                btnSubscriptionWithUser.isSelected = false
                btnSubscriptionWithOrder.isSelected = false
                btnSusbscriptionNoChange.isSelected = true
                break
            }
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad{
            btnSubscriptionWithUser.isSelected = false
            btnSubscriptionWithOrder.isSelected = false
            btnSusbscriptionNoChange.isSelected = true
            
            btnSubscriptionWithUser.titleLabel?.font = btnSubscriptionWithUser.titleLabel?.font.withSize(15)
            btnSubscriptionWithOrder.titleLabel?.font =  btnSubscriptionWithOrder.titleLabel?.font.withSize(15)
            btnSusbscriptionNoChange.titleLabel?.font =  btnSubscriptionWithOrder.titleLabel?.font.withSize(15)
        }
        
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        
        if subAction == "" ||  subAction == "no_change" {
            btnSubscriptionWithUser.isSelected = false
            btnSubscriptionWithOrder.isSelected = false
            btnSusbscriptionNoChange.isSelected = true
        }else if subAction == "cancel_all" {
            btnSubscriptionWithUser.isSelected = true
            btnSubscriptionWithOrder.isSelected = false
            btnSusbscriptionNoChange.isSelected = false
            
        }else if subAction == "cancel_order"{
            btnSubscriptionWithUser.isSelected = false
            btnSubscriptionWithOrder.isSelected = true
            btnSusbscriptionNoChange.isSelected = false
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad{
            self.delegate?.hideSubscriptionView?()
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func actionSubsbcriptionWithUsers(_ sender: Any) {
        btnSubscriptionWithUser.isSelected = true
        btnSubscriptionWithOrder.isSelected = false
        btnSusbscriptionNoChange.isSelected = false
    }
    
    @IBAction func actionSubscriptionWithOrder(_ sender: Any) {
        btnSubscriptionWithUser.isSelected = false
        btnSubscriptionWithOrder.isSelected = true
        btnSusbscriptionNoChange.isSelected = false
    }
    
    @IBAction func actionSubscriptionNoChange(_ sender: Any) {
        btnSubscriptionWithUser.isSelected = false
        btnSubscriptionWithOrder.isSelected = false
        btnSusbscriptionNoChange.isSelected = true
    }
    
    @IBAction func actionSaveChanges(_ sender: Any) {
        subAction = "no_change"
        
        if btnSubscriptionWithUser.isSelected {
            subAction = "cancel_all"
        }
        
        if btnSubscriptionWithOrder.isSelected {
            subAction = "cancel_order"
        }
        
        if btnSusbscriptionNoChange.isSelected {
            subAction = "no_change"
        }
        delegate?.sendSelectedSubscription?(StrSubscription: subAction)
        if UI_USER_INTERFACE_IDIOM() == .phone {
            subDelegate?.sendSelectedSubscriptionForiPhone?(StrSubscription: subAction)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension SubscriptionContainerViewController: EditProductDelegate {
    func sendSelectedSubscription(StrSubscription: String) {
        print("StrSubscription",StrSubscription)
    }
}
extension SubscriptionContainerViewController: SubscriptionDelegate {
    
}
