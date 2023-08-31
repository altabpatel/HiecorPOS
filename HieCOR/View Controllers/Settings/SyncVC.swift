//
//  SyncVC.swift
//  HieCOR
//
//  Created by Deftsoft on 11/10/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

enum SyncingType {
    case category
    case product
    case customer
    case tax
    case region
    case order
}

class SyncVC: BaseViewController {
    
    //MARK: IBOutlet
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var syncButton: UIButton!
    @IBOutlet weak var buttonsHeightConstraint: NSLayoutConstraint!
    
    //MARK: Variables
    var selectedButtonsTag = [Int]()
    var syncingType = [SyncingType]()

    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSWRevealView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.syncButton.setTitle("Sync", for: .normal)
        updateButtons()
    }
    
    //MARK Private Functions
    private func loadSWRevealView() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            menuButton.setImage(#imageLiteral(resourceName: "menu-blue"), for: .normal)
            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController") as? SWRevealViewController
            if (vc != nil)
            {
                vc!.delegate = self
                menuButton.addTarget(vc, action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
        }else {
            menuButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
            if (self.revealViewController() != nil)
            {
                revealViewController().delegate = self
                menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
        }
    }

    private func updateButtons() {
        for button in buttons {
            if selectedButtonsTag.contains(button.tag) {
                button.backgroundColor = #colorLiteral(red: 0.6078431373, green: 0.831372549, blue: 0.9921568627, alpha: 1)
                button.setBorder(borderWidth: 1.0, borderColor: UIColor.HieCORColor.blue.colorWith(alpha: 1.0), cornerRadius: 5.0)
            }else {
                button.backgroundColor = UIColor.white
                button.setBorder(borderWidth: 1.0, borderColor: #colorLiteral(red: 0.8431372549, green: 0.8470588235, blue: 0.8509803922, alpha: 1), cornerRadius: 5.0)
            }
        }
        buttonsHeightConstraint.constant = UIScreen.main.bounds.height <= 667.0 ? 40 : 50
        syncButton.isEnabled = selectedButtonsTag.count > 0
        syncButton.alpha = selectedButtonsTag.count > 0 ? 1.0 : 0.5
    }
    
    private func getAllSelectedData() {
        guard let type = syncingType.first else {
            Indicator.isEnabledIndicator = true
            Indicator.sharedInstance.hideIndicator()
            self.syncButton.setTitle("Synced", for: .normal)
//            self.showAlert(title: kAlert, message: "Successfully Synced.", otherButtons: nil, cancelTitle: kOkay) { (_) in
                self.navigationController?.popViewController(animated: true)
                appDelegate.showToast(message: "Successfully Synced.")
//            }
            return
        }
       
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        self.syncButton.setTitle("Syncing...", for: .normal)

        switch type {
        case .category:
            getAllCategoryList()
            break
        case .product:
            getAllProductList()
            break
        case .customer:
            getAllCustomerList()
            break
        case .tax:
            getAllTaxList()
            break
        case .region:
            getAllRegionList()
        default: break
        }
    }
    
    private func updateSelectedValues() {
        syncingType.removeAll()
        for tag in selectedButtonsTag {
            switch tag {
            case 10:
                syncingType.append(.product)
                break
            case 20:
                syncingType.append(.customer)
                break
            case 30:
                syncingType.append(.category)
                break
            case 40:
                syncingType.append(.tax)
                break
            case 50:
                syncingType.append(.region)
                break
            default: break
            }
        }
    }
    @IBAction func buttonsAction(_ sender: UIButton) {
        //Update values
        if let index = selectedButtonsTag.firstIndex(where: {$0 == sender.tag}) {
            selectedButtonsTag.remove(at: index)
        }else {
            selectedButtonsTag.append(sender.tag)
        }
        updateButtons()
    }
    
    @IBAction func syncButtonActiom(_ sender: UIButton) {
        updateSelectedValues()
        getAllSelectedData()
    }
}

//MARK: SWRevealViewControllerDelegate
extension SyncVC: SWRevealViewControllerDelegate {
    func revealController(_ revealController: SWRevealViewController, willMoveTo position: FrontViewPosition) {
        if position == FrontViewPositionRight {
            self.view.alpha = 0.5
            self.view.endEditing(true)
        }
        else if position == FrontViewPositionLeft {
            self.view.alpha = 1.0
        }
    }
}

//MARK: API Methods
extension SyncVC {
    
    func getAllCategoryList() {
        HomeVM.shared.getCategory(pageNumber: -1) { (success, message, error) in
            if success == 1 {
                if let index = self.syncingType.firstIndex(where: {$0 == .category}) {
                    self.syncingType.remove(at: index)
                }
                self.getAllSelectedData()
            }
            else
            {
                CDManager.shared.deleteAllData(with: .category)
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
                self.syncButton.setTitle("Sync", for: .normal)
                
                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    
    func getAllProductList() {
        HomeVM.shared.getProduct(categoryName: "", pageNumber: -1, responseCallBack: { (success, message, error) in
            if success == 1 {
                if let index = self.syncingType.firstIndex(where: {$0 == .product}) {
                    self.syncingType.remove(at: index)
                }
                self.getAllSelectedData()
            }
            else
            {
                CDManager.shared.deleteAllData(with: .product)
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
                self.syncButton.setTitle("Sync", for: .normal)
                
                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }

    func getAllCustomerList() {
        HomeVM.shared.getCustomerList(indexOfPage: -1, responseCallBack: { (success, message, error) in
            if success == 1 {
                if let index = self.syncingType.firstIndex(where: {$0 == .customer}) {
                    self.syncingType.remove(at: index)
                }
                self.getAllSelectedData()
            }
            else
            {
                CDManager.shared.deleteAllData(with: .customer)
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
                self.syncButton.setTitle("Sync", for: .normal)
                
                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }

    func getAllTaxList() {
        HomeVM.shared.getTaxList(isForOffline: true, responseCallBack: { (success, message, error) in
            if success == 1 {
                if let index = self.syncingType.firstIndex(where: {$0 == .tax}) {
                    self.syncingType.remove(at: index)
                }
                self.getAllSelectedData()
            }
            else
            {
                CDManager.shared.deleteAllData(with: .tax)
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
                self.syncButton.setTitle("Sync", for: .normal)

                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }

    func getAllRegionList() {
        HomeVM.shared.getRegionList(isForOffline: true, responseCallBack: { (success, message, error) in
            if success == 1 {
                if let index = self.syncingType.firstIndex(where: {$0 == .region}) {
                    self.syncingType.remove(at: index)
                }
                self.getAllSelectedData()
            }
            else
            {
                CDManager.shared.deleteAllData(with: .region)
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
                self.syncButton.setTitle("Sync", for: .normal)

                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }

}
