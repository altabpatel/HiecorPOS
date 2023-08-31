//
//  AuthorizeViewController.swift
//  HieCOR
//
//  Created by Hiecor Software on 17/09/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import UIKit
import SocketIO

class AuthorizeViewController: BaseViewController {
    
    @IBOutlet weak var viewAuthCodeLine: UIView!
    @IBOutlet weak var viewAuthCode: UIView!
    @IBOutlet weak var labelAuthCode: UILabel!
    @IBOutlet weak var view2Heightcons: NSLayoutConstraint!
    @IBOutlet weak var viewUpCons: NSLayoutConstraint!
    @IBOutlet weak var view1heightCon: NSLayoutConstraint!
    @IBOutlet weak var viewAddressHeightCons: NSLayoutConstraint!
    @IBOutlet weak var viewNameHeightCons: NSLayoutConstraint!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var viewBase: UIView!
    @IBOutlet weak var lblNameHead: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var lblAddressHead: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var btnOrderId: UIButton!
    
    @IBOutlet weak var viewTestMode: UIView!
    @IBOutlet weak var viewOrderSuccessLine: UIView!
    
    var delegate: PaymentTypeContainerViewControllerDelegate?
    var Orderedobj = [String:AnyObject]()
    var orderId = String()
    var address = String()
    var userName = String()
    var authCode = String()
    var isHomeTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.isCaptureButton = false
        DataManager.OrderDataModel = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
        // socket sudama
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            useForSocket()
        }
    }
    func useForSocket(){
           MainSocketManager.shared.emitselectRecieptOption { (selectRecieptOptionForSocketObj) in
               //Parameters
               if DataManager.sessionID == selectRecieptOptionForSocketObj.session_id {
                   MainSocketManager.shared.onreset()
                   self.showHomeScreeen()
               }
           }
       }
    
    func loadData() {
        
        if let id = Orderedobj["order_id"]as? Int {
            self.orderId = "\(id)"
        }
        btnOrderId.setTitle("\(self.orderId)", for: .normal)
        
        if let id = Orderedobj["order_id"]as? String {
            self.orderId = id
        }
        btnOrderId.setTitle("\(self.orderId)", for: .normal)
        
        if let name = Orderedobj["userName"]as? String {
            self.userName = name
        }
        if let authCode = Orderedobj["auth_code"] as? String {
            self.authCode = authCode
        }
        if authCode == "" || authCode == " "{
            viewAuthCode.isHidden = true
            viewAuthCodeLine.isHidden = true
        }else{
            labelAuthCode.text = authCode
        }
        if userName == "" || userName == " "{
            viewNameHeightCons.constant = 0
            view1heightCon.constant = 0
            viewUpCons.constant = 1
            viewName.isHidden = true
            view1.isHidden = true
            view.setNeedsLayout()
            view.setNeedsDisplay()
        }else{
            lblName.text = userName
        }
        
        if let uaddress = Orderedobj["address"]as? String {
            self.address = uaddress
        }
        if address == ""{
        //    viewNameHeightCons.constant = 0
            view2Heightcons.constant = 0
            viewUpCons.constant = 1
            viewAddress.isHidden = true
            view2.isHidden = true
            view.setNeedsLayout()
            view.setNeedsDisplay()
        }else{
            lblAddress.text = address
        }
        // *****************
        self.viewTestMode.isHidden = true
        if let test_order = Orderedobj["test_order"]as? Int {
            if test_order == 0 {
                self.viewTestMode.isHidden = true
                viewOrderSuccessLine.isHidden = false
            } else {
                 self.viewTestMode.isHidden = false
                 viewOrderSuccessLine.isHidden = true
            }
        }
    }
    
    private func showHomeScreeen() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController") as! SWRevealViewController
            appDelegate.window?.rootViewController = controller
            appDelegate.window?.makeKeyAndVisible()
        }else {
            self.setRootViewControllerForIphone()
        }
    }
    
    private func showOrderHistoryScreeen() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
//            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "iPad_OrdersHistoryViewController") as! iPad_OrdersHistoryViewController
//            controller.recentOrderID = self.orderId
//            self.present(controller, animated: true, completion: nil)
            appDelegate.isOrderHistoryFirstTime = true
            appDelegate.authOrderIdForOrderHistory = orderId
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController") as! SWRevealViewController
                appDelegate.window?.rootViewController = controller
                appDelegate.window?.makeKeyAndVisible()
            }
        }else {
            self.setRootOrderHistoryViewControllerForIphone()
        }
    }
    
    @IBAction func actionClose(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sender.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        self.isHomeTapped = true
        HomeVM.shared.tipValue = 0.0
        HomeVM.shared.errorTip = 0.0
        appDelegate.tipRefundOnly = 0.0
        HomeVM.shared.coupanDetail.code = ""
        self.showHomeScreeen()
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            MainSocketManager.shared.onreset()
        }
    }
    
    @IBAction func actionOrderId(_ sender: Any) {
        self.isHomeTapped = false
        HomeVM.shared.tipValue = 0.0
        HomeVM.shared.errorTip = 0.0
        appDelegate.tipRefundOnly = 0.0
        HomeVM.shared.coupanDetail.code = ""
        self.showOrderHistoryScreeen()
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            MainSocketManager.shared.onreset()
        }
    }
    
    
}
