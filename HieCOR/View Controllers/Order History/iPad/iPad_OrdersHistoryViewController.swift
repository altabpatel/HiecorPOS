//
//  iPad_OrdersHistoryViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 04/04/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class iPad_OrdersHistoryViewController: BaseViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var posLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var containerView_TransactionInfo: UIView!
    @IBOutlet weak var containerView_Returns: UIView!
    @IBOutlet weak var btn_Menu: UIButton!
    @IBOutlet weak var containerView_Refund: UIView!
    @IBOutlet weak var defaultSelectView: UIView!
    @IBOutlet weak var lblSelectOrderMessage: UILabel!
    @IBOutlet weak var imgNoRecordFoundImg: UIImageView!
    
    //MARK: Delegate
    var orderInfoDelegate: OrderInfoViewControllerDelegate?
    var returnDelegate: OrderInfoViewControllerDelegate?
    var transactionDelegate: OrderInfoViewControllerDelegate?
    var refundDelegate: OrderInfoViewControllerDelegate?
    var userDetailDelegate: UserDetailsDelegate?
    var orderID = String()
    var recentOrderID: String?
    var refundOrder: JSONDictionary?
    var customerPickupDelegete: CustomerPickupDelegete?
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultSelectView.isHidden = false
        
        loadViews()
        //Reset Header Text
        self.headerLabel.text = "---"
        appDelegate.isOderHistoryOpen = true
        NotificationCenter.default.addObserver(self, selector: #selector(openUrlOrderHistoryReload(notification:)), name: Notification.Name(rawValue: "OpenUrlOrderHistoryReload"), object: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        OfflineDataManager.shared.orderHistoryDelegate = self
        //Update Name
        if let name = DataManager.deviceNameText {
            posLabel.text = name
        }else {
            let nameDevice = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
            posLabel.text = nameDevice//UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
        }
        if appDelegate.authOrderIdForOrderHistory  != ""{
           recentOrderID = appDelegate.authOrderIdForOrderHistory
          
        }
        
        
        if recentOrderID != nil {
            Indicator.isEnabledIndicator = false
            Indicator.sharedInstance.showIndicator()
            orderInfoDelegate?.didGetOrderInformation?(with: recentOrderID!, defualtView: false)
            defaultSelectView.isHidden = true
            orderID = recentOrderID!
            recentOrderID = nil
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        OfflineDataManager.shared.orderHistoryDelegate = nil
        appDelegate.isOderHistoryOpen = false
    }
    // OpenUrlOrderHistoryReload  // for deeplinking (13 sept 200) by altab
    @objc func openUrlOrderHistoryReload(notification: Notification) {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        recentOrderID = appDelegate.openUrlOrderId
        orderID = recentOrderID!
        orderInfoDelegate?.didGetOrderInformation?(with: recentOrderID!, defualtView: false)
        defaultSelectView.isHidden = true
       // appDelegate.isOpenUrl = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderslist" {
            let vc = segue.destination as! OrdersViewController
            vc.orderInfoDelegate = self
            vc.orderId = recentOrderID ?? ""
            customerPickupDelegete = vc
        }
        if segue.identifier == "ordersinfo" {
            let vc = segue.destination as! OrderInfoViewController
            vc.orderInfoDelegate = self
            orderInfoDelegate = vc
            vc.delegateForCustomer = self
        }
        if segue.identifier == "transactoninfo" {
            let vc = segue.destination as! TransactionsInfoViewController
            vc.orderInfoDelegate = self
            transactionDelegate = vc
        }
        if segue.identifier == "refund" {
            let vc = segue.destination as! RefundViewController
            vc.orderInfoDelegate = self
            refundDelegate = vc
        }
        if segue.identifier == "cart" {
            let vc = segue.destination as! CatAndProductsViewController
            if DataManager.isCaptureButton == true {
                vc.orderType = .newOrder
            } else {
                vc.orderType = .refundOrExchangeOrder
            }
            vc.refundOrder = refundOrder
        }
        
        if segue.identifier == "UserDetailViewController" {
            let vc = segue.destination as! UserDetailViewController
            //vc.userDetailDelegate = self
            userDetailDelegate = vc
        }
    }
    
    //Private Functions
    private func loadViews() {
        
        if (self.revealViewController() != nil)
        {
            revealViewController().delegate = self
            btn_Menu?.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        containerView_Returns.isHidden = true
        containerView_TransactionInfo.isHidden = true
        containerView_Refund.isHidden = true
        UIApplication.shared.isStatusBarHidden = false
    }
    
    //MARK: IBAction
    @IBAction func btn_HomeAction(_ sender: Any) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController")
                
                for navvc in vc.childViewControllers {
                    if navvc.isKind(of: UINavigationController.self) {
                        if let homevc = navvc.childViewControllers.first as? CatAndProductsViewController {
                            homevc.orderType = .newOrder
                        }
                        break
                    }
                }
                appDelegate.window?.rootViewController = vc
                appDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    @IBAction func btn_LockAction(_ sender: Any) {
        //...
    }
    
    @IBAction func btn_LogOutAction(_ sender: Any) {
        alertForLogOut()
    }
}

//MARK: OrderInfoViewControllerDelegate
extension iPad_OrdersHistoryViewController: OrderInfoViewControllerDelegate {
    func didMoveToCartScreen(with data: JSONDictionary?) {
        self.refundOrder = data
        self.performSegue(withIdentifier: "cart", sender: nil)
    }
    func didMoveToCartShipingScreen() {
        self.performSegue(withIdentifier: "cart", sender: nil)
    }
    
    func didHideRefundView(isRefresh: Bool) {
        if isRefresh {
            orderInfoDelegate?.didGetOrderInformation?(with: orderID, defualtView: true)
        }
        containerView_Refund.isHidden = true
    }
    
    func didProductReturned() {
        orderInfoDelegate?.didProductReturned?()
    }
    
    func didProductRefunded() {
        orderInfoDelegate?.didProductRefunded?()
    }
    
    func didGetOrderInformation(with orderId: String, defualtView : Bool) {
        if defualtView {
            defaultSelectView.isHidden = false
        }else{
            defaultSelectView.isHidden = true
        }
        imgNoRecordFoundImg.isHidden = true
        lblSelectOrderMessage.isHidden = false
        lblSelectOrderMessage.text = "Select an order to view details."
        orderID = orderId
        containerView_Refund.isHidden = true
        containerView_TransactionInfo.isHidden = true
        orderInfoDelegate?.didGetOrderInformation?(with: orderID, defualtView: defualtView)
    }
    
    func didUpdateRefundScreen(with data: JSONDictionary) {
        if data["show"] != nil
        {
            if data["show"] as! Bool == true
            {
                containerView_Refund.isHidden = false
            }
            else
            {
                containerView_Refund.isHidden = true
            }
            refundDelegate?.didUpdateRefundScreen?(with: data)
        }
        if data["hide"] != nil
        {
            containerView_Refund.isHidden = true
        }
    }
    
    
    func didUpdateReturnScreen(with data: JSONDictionary) {
        if data["show"] != nil
        {
            if data["show"] as! Bool == true
            {
                containerView_Returns.isHidden = false
            }
            else
            {
                containerView_Returns.isHidden = true
            }
            returnDelegate?.didUpdateReturnScreen?(with: data)
        }
        if data["hide"] != nil
        {
            containerView_Returns.isHidden = true
        }
    }
    
    func didUpdateTransactionScreen(with data: JSONDictionary) {
        if data["show"] != nil
        {
            if data["show"] as! Bool == true
            {
                containerView_TransactionInfo.isHidden = false
            }
            else
            {
                containerView_TransactionInfo.isHidden = true
            }
            transactionDelegate?.didUpdateTransactionScreen?(with: data)
        }
        if data["hide"] != nil
        {
            containerView_TransactionInfo.isHidden = true
        }
    }
    func didUpdateHeaderText(with string: String) {
        self.headerLabel.text = (string == "#") ?  "---" : string
//        if string != nil  && string != "#" {
//             defaultSelectView.isHidden = true
//        }else {
//             defaultSelectView.isHidden = false
//        }
    }
    func didGetOrdersListNotFound(defualtView: Bool) {
        if defualtView {
            defaultSelectView.isHidden = false
        }else{
            defaultSelectView.isHidden = true
        }
        imgNoRecordFoundImg.isHidden = false
        lblSelectOrderMessage.isHidden = true
        //lblSelectOrderMessage.text = "Sorry, No Record Found."
        containerView_Refund.isHidden = true
        containerView_TransactionInfo.isHidden = true
    }
}


//MARK: OfflineDataManagerDelegate
extension iPad_OrdersHistoryViewController: OfflineDataManagerDelegate {
    func didUpdateInternetConnection(isOn: Bool) {
        if !isOn {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController")
                appDelegate.window?.rootViewController = vc
                appDelegate.window?.makeKeyAndVisible()
            }
        }
    }
}

//MARK: SWRevealViewControllerDelegate
extension iPad_OrdersHistoryViewController: SWRevealViewControllerDelegate {
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }
}

extension iPad_OrdersHistoryViewController: CustomerPickupDelegete {
    func reloadDataByCustomerPickUp(){
        customerPickupDelegete?.reloadDataByCustomerPickUp?()
    }
}
