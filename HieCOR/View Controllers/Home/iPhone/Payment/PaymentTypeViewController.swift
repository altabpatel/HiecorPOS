//
//  PaymentTypeViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 04/12/17.
//  Copyright © 2017 HyperMacMini. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class PaymentTypeViewController: BaseViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var lbl_TotalAmount: UILabel!
    @IBOutlet weak var lblAmountPaid: UILabel!
    @IBOutlet weak var lblBalanceDue: UILabel!
    @IBOutlet weak var viewBalanceDue: UIView!
    @IBOutlet weak var viewTipAmount: UIView!
    @IBOutlet weak var lblTipAMount: UILabel!
    @IBOutlet weak var constViewHieght: NSLayoutConstraint!
    @IBOutlet weak var constTopViewContainer: NSLayoutConstraint!
    
    //MARK: Variables
    var paymentMethodName = String()
    var CustomerObj = CustomerListModel()
    var cartProductsArray = Array<Any>()
    var str_ShippingANdHandling = String()
    var str_AddDiscount = String()
    var str_AddCouponName = String()
    var str_AddNote = String()
    var TotalPrice = Double()
    var SubTotalPrice = Double()
    var str_TaxAmount = String()
    var str_RegionName = String()  
    var isCreditCardNumberDetected = false
    var orderType: OrderType = .newOrder
    var orderInfoObj = OrderInfoModel()
    var isOpenToOrderHistory = false

    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
            lbl_TotalAmount.text = "$" + TotalPrice.roundToTwoDecimal
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewBalanceDue.isHidden = true
        if UI_USER_INTERFACE_IDIOM() == .phone {
            //if HomeVM.shared.DueShared > 0{
            //    self.lbl_TotalAmount.text = "$\((HomeVM.shared.DueShared).roundToTwoDecimal)"
            //}else{
                lbl_TotalAmount.text = "$" + TotalPrice.roundToTwoDecimal
            //}
            
            if DataManager.isBalanceDueData {
                viewBalanceDue.isHidden = false
                lblAmountPaid.text = HomeVM.shared.amountPaid.currencyFormat
                lblBalanceDue.text = HomeVM.shared.DueShared.currencyFormat
                constTopViewContainer.constant = 45
                constViewHieght.constant = 210
                if HomeVM.shared.tipValue > 0 {
                    viewTipAmount.isHidden = false
                    lblTipAMount.text = HomeVM.shared.tipValue.currencyFormat
                    
                    constViewHieght.constant = 280
                } else {
                    viewTipAmount?.isHidden = true
                }
                
            } else {
                viewBalanceDue.isHidden = true
                viewTipAmount.isHidden = true
                constTopViewContainer.constant = 0
                constViewHieght.constant = 150
            }
        }
    }
    
    func resetCartData()
    {
        
        //self.delegate?.didResetCart?()
        self.cartProductsArray.removeAll()
        UserDefaults.standard.removeObject(forKey: "recentOrder")
        UserDefaults.standard.removeObject(forKey: "recentOrderID")
        UserDefaults.standard.removeObject(forKey: "isCheckUncheckShippingBilling")
        UserDefaults.standard.removeObject(forKey: "cartdata")
        UserDefaults.standard.removeObject(forKey: "CustomerObj")
        UserDefaults.standard.removeObject(forKey: "SelectedCustomer")
        UserDefaults.standard.removeObject(forKey: "cartProductsArray")
        DataManager.selectedCarrierName = ""
        DataManager.selectedService = ""
        DataManager.selectedCarrier = ""
        DataManager.selectedServiceName = ""
        DataManager.selectedServiceId = ""
        DataManager.selectedShippingRate = ""
        DataManager.shippingWeight = 0
        DataManager.shippingWidth = 0
        DataManager.shippingLength = 0
        DataManager.shippingHeight = 0
        DataManager.selectedFullfillmentId = ""
        DataManager.cartShippingProductsArray?.removeAll()
        DataManager.isshipOrderButton = false
        appDelegate.localBezierPath.removeAllPoints()
        UserDefaults.standard.synchronize()
        PaymentsViewController.paymentDetailDict.removeAll()
        DataManager.CardCount = 0
        self.str_AddDiscount = ""
        self.str_AddCouponName = ""
        self.str_ShippingANdHandling = ""
        CustomerObj = CustomerListModel()
        //customerNameLabel.text = "Customer #"
        appDelegate.isOpenToOrderHistory = false
        DataManager.duebalanceData = 0.0
        HomeVM.shared.amountPaid = 0.0
        HomeVM.shared.tipValue = 0.0
        HomeVM.shared.DueShared = 0.0
        HomeVM.shared.coupanDetail.code = ""
        
        //        self.showAlert(title: "Alert", message: "Cart items removed!", otherButtons: nil, cancelTitle: kOkay) { (action) in
        self.navigationController?.popViewController(animated: true)
        appDelegate.showToast(message: "Cart items removed!")
        //        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func popViewControllerss(popViews: Int, animated: Bool = true) {
        if self.navigationController!.viewControllers.count > popViews
        {
            let vc = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - popViews - 1]
            self.navigationController?.popToViewController(vc, animated: animated)
        }
    }
    
    //MARK: -- Action Method
    
    @IBAction func btn_BackAction(_ sender: Any) {
        
        if DataManager.isBalanceDueData {
            //viewBalanceDue.isHidden = false
            //let refreshAlert = UIAlertController(title: "Alert", message: "Incomplete Split Payment,\n if continue then all data will be reset.", preferredStyle: UIAlertControllerStyle.alert)
            
            var strId = 0
            if let id = DataManager.recentOrderID {
                strId = id
            }
            
            let refreshAlert = UIAlertController(title: "Cancel Order", message: "Navigating away from this order will \nleave the existing order #\(strId) \nwith total paid: \(HomeVM.shared.amountPaid.currencyFormat) you can \nreview and refund these \ncharges from Past Orders.", preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                //...
            }))
            refreshAlert.addAction(UIAlertAction(title: "Proceed", style: .destructive, handler: { (action: UIAlertAction!) in
                //self.isDefaultTaxChanged = false
                //self.isDefaultTaxSelected = false
                //self.taxTitle = DataManager.defaultTaxID
                DataManager.isBalanceDueData = false
                PaymentsViewController.paymentDetailDict.removeAll()
                self.resetCartData()
                HomeVM.shared.customerUserId = ""
                self.popViewControllerss(popViews: 3)
                appDelegate.localBezierPath.removeAllPoints()
                appDelegate.amount = 0.0
                appDelegate.isOpenUrl = false
                //self.navigationController?.popViewController(animated: true)
            }))
            present(refreshAlert, animated: true, completion: nil)

        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "paymenttype"
        {
            let ptvc = segue.destination as! PaymentTypeContainerViewController
            
            if UI_USER_INTERFACE_IDIOM() == .phone {
                if HomeVM.shared.DueShared > 0{
                    ptvc.totalAmount = HomeVM.shared.DueShared
                }else{
                    ptvc.totalAmount = self.TotalPrice
                }
            } else {
                ptvc.totalAmount = self.TotalPrice
            }
            
            //ptvc.totalAmount = self.TotalPrice
            ptvc.CustomerObj = self.CustomerObj
            ptvc.cartProductsArray = self.cartProductsArray
            ptvc.str_AddNote = self.str_AddNote
            ptvc.str_AddDiscount = self.str_AddDiscount //Manual Discount
            ptvc.str_AddCouponName = self.str_AddCouponName
            ptvc.str_ShippingANdHandling = self.str_ShippingANdHandling
            ptvc.SubTotalPrice = self.SubTotalPrice
            ptvc.str_TaxAmount = self.str_TaxAmount
            ptvc.str_RegionName = self.str_RegionName
            ptvc.isCreditCardNumberDetected = isCreditCardNumberDetected
            ptvc.orderType = self.orderType
            ptvc.orderInfoObj = self.orderInfoObj
            ptvc.isOpenToOrderHistory = isOpenToOrderHistory
        }
        
        if segue.identifier == "multicard" {
            let ptvc = segue.destination as! MultiCardContainerViewController
            if UI_USER_INTERFACE_IDIOM() == .phone {
                if HomeVM.shared.DueShared > 0{
                    ptvc.totalAmount = HomeVM.shared.DueShared
                }else{
                    ptvc.totalAmount = self.TotalPrice
                }
            } else {
                ptvc.totalAmount = self.TotalPrice
            }
        }
    }
}
