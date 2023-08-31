//
//  DrawerHistoryDetailViewController.swift
//  HieCOR
//
//  Created by Rajshekar Pothu on 27/11/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class DrawerHistoryDetailViewController: BaseViewController {
    //MARK: Variables
    
    @IBOutlet weak var lblHeadDrawer: UILabel!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblsaleLocation: UILabel!
    @IBOutlet weak var viewBottomDrawerDes: UIView!
    @IBOutlet var lblDrawerdescription: UILabel!
    @IBOutlet weak var lblExpectedDrawer: UILabel!
    @IBOutlet weak var lblDifference: UILabel!
    @IBOutlet weak var lblActualInDrawer: UILabel!
    @IBOutlet weak var lblStartingCash: UILabel!
    @IBOutlet weak var lblTotalPaidInOut: UILabel!
    @IBOutlet weak var lblPaidOutAmount: UILabel!
    @IBOutlet weak var lblPaidOutTime: UILabel!
    @IBOutlet weak var lblPaidAmount: UILabel!
    @IBOutlet weak var lblPaidTime: UILabel!
    
    @IBOutlet weak var lblStarted: UILabel!
    @IBOutlet weak var lblEnded: UILabel!
    @IBOutlet weak var lblClosed: UILabel!
    @IBOutlet weak var lblCashRefund: UILabel!
    @IBOutlet weak var lblCashSales: UILabel!
    @IBOutlet weak var lblPaidIn: UILabel!
    @IBOutlet weak var lblPaidOut: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var viewPaidInOutHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblDescHead: UILabel!
    @IBOutlet weak var btnPrintReceipt: UIButton!
    
    var drawerHistoryDelegate : DetailReportViewControllerDelegate?
    var currentDrawerDelegate : DetailReportViewControllerDelegate?
    var drawerDetailData = DrawerHistoryModel()
    var drawerDetailEndData = DrawerHistoryModel()
    var isEndDrawer = Bool()
    
    var str_DrawerId = ""
    var str_GooglePrint = ""
    
    var receiptDetailsModel = ReceiptEndDrawerDetailsModel()
    var receiptURLModel = ReceiptEndDrawerURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.checkPrinterConnection()
        loadPrinter()
        fillData()
        loadDataForiPhone()
    }
    
    func fillData()  {
        let origImage = UIImage(named: "cancel")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        buttonCancel.setImage(tintedImage, for: .normal)
        buttonCancel.tintColor = UIColor(red: 11/255, green: 118/255, blue: 201/255, alpha: 1)
    }
    
    func loadDataForiPhone() {
        if isEndDrawer{
            lblHeadDrawer.text  = "Closed Drawer"
            lblUser.text = drawerDetailEndData.user_name
            lblsaleLocation.text = drawerDetailEndData.source
            lblStarted.text = drawerDetailEndData.started
            lblClosed.text = drawerDetailEndData.end_time
            lblEnded.text = drawerDetailEndData.end_time
            lblStartingCash.text = "$\(drawerDetailEndData.starting_cash)"
            //lblExpectedDrawer.text = "$\(drawerDetailEndData.expected_in_drawer)"
            //   lblActualInDrawer.text = "$\(drawerDetailEndData.actualin_drawer)"
            //lblDifference.text = "$\(drawerDetailEndData.drawer_difference)"
            
            lblActualInDrawer.text = "$\(drawerDetailEndData.actualin_drawer)"
            lblDifference.text = "$\(drawerDetailEndData.drawer_difference)"
            
            lblPaidIn.text = "$\(drawerDetailEndData.paid_in)"
            lblPaidOut.text = "$\(drawerDetailEndData.paid_out)"
            lblCashSales.text = "$\(drawerDetailEndData.cash_sales)"
            lblCashRefund.text = "$\(drawerDetailEndData.cash_refunds)"
            
            if drawerDetailData.drawer_desc == "" {
                lblDrawerdescription.isHidden = true
                lblDescHead.isHidden = true
                viewBottomDrawerDes.isHidden = true
            } else {
                lblDrawerdescription.text = drawerDetailEndData.drawer_desc.capitalized
            }
            
            var newValue = ""
            let diff : String = (drawerDetailEndData.drawer_difference)
            let replaced = diff.replacingOccurrences(of: ",", with: "")
            var drawer_difference = (replaced as NSString).doubleValue
            
            if (drawer_difference < 0) {
                drawer_difference = -(drawer_difference);
                newValue = "-$\(drawer_difference.roundToTwoDecimal)"
            } else {
                newValue = "$\(drawer_difference.roundToTwoDecimal)"
            }
            //   lblDifference.text = newValue
            
            var newValue1 = ""
            let expected : String = (drawerDetailData.expected_in_drawer)
            let replaced1 = expected.replacingOccurrences(of: ",", with: "")
            var expected_in_drawer = (replaced1 as NSString).doubleValue
            
            if (expected_in_drawer < 0) {
                expected_in_drawer = -(expected_in_drawer);
                newValue1 = "-$\(expected_in_drawer.roundToTwoDecimal)"
            } else {
                newValue1 = "$\(expected_in_drawer.roundToTwoDecimal)"
            }
            lblExpectedDrawer.text = newValue1
            
            
            btnPrintReceipt.isHidden = false
            
        }else{
            
            btnPrintReceipt.isHidden = true
            
            lblHeadDrawer.text  = "Open Drawer"
            lblUser.text = drawerDetailData.user_name
            lblsaleLocation.text = drawerDetailData.source
            lblStarted.text = drawerDetailData.started
            
            lblStartingCash.text = "$\(drawerDetailData.starting_cash)"
            //lblExpectedDrawer.text = "$\(drawerDetailData.expected_in_drawer)"
            lblActualInDrawer.text = "$\(drawerDetailData.actualin_drawer)"
            //lblDifference.text = "$\(drawerDetailData.drawer_difference)"
            lblPaidIn.text = "$\(drawerDetailData.paid_in)"
            lblPaidOut.text = "$\(drawerDetailData.paid_out)"
            lblCashSales.text = "$\(drawerDetailData.cash_sales)"
            lblCashRefund.text = "$\(drawerDetailData.cash_refunds)"
            
            if drawerDetailData.drawer_desc == "" {
                lblDrawerdescription.isHidden = true
                lblDescHead.isHidden = true
                viewBottomDrawerDes.isHidden = true
            } else {
                lblDrawerdescription.text = drawerDetailData.drawer_desc.capitalized
            }
            
            
            var newValue = ""
            let diff : String = (drawerDetailData.drawer_difference)
            let replaced = diff.replacingOccurrences(of: ",", with: "")
            var drawer_difference = (replaced as NSString).doubleValue
            
            if (drawer_difference < 0) {
                drawer_difference = -(drawer_difference);
                newValue = "-$\(drawer_difference.roundToTwoDecimal)"
            } else {
                newValue = "$\(drawer_difference.roundToTwoDecimal)"
            }
            lblDifference.text = newValue
            
            var newValue1 = ""
            let expected : String = (drawerDetailData.expected_in_drawer)
            let replaced1 = expected.replacingOccurrences(of: ",", with: "")
            var expected_in_drawer = (replaced1 as NSString).doubleValue
            
            if (expected_in_drawer < 0) {
                expected_in_drawer = -(expected_in_drawer);
                newValue1 = "-$\(expected_in_drawer.roundToTwoDecimal)"
            } else {
                newValue1 = "$\(expected_in_drawer.roundToTwoDecimal)"
            }
            lblExpectedDrawer.text = newValue1
            lblDifference.textAlignment = .right
            lblActualInDrawer.textAlignment = .right
            lblEnded.textAlignment = .right
            lblClosed.textAlignment = .right
            lblClosed.text = "-" //drawerDetailData.end_time
            lblEnded.text = "-" //drawerDetailData.end_time
            lblActualInDrawer.text = "-" //"$\(drawerDetailData.actualin_drawer)"
            lblDifference.text =  "-"//newValue
        }
        
    }
    
    //MARK: Action Methods
    @IBAction func buttonBackAction(_ sender: Any) {
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            let returnData = ["hide":true] as [String : Any]
            drawerHistoryDelegate?.didUpdateDrawerHistoryDetailScreen?(with: returnData)
            
            let returnDataEnd = ["hide":true] as [String : Any]
            drawerHistoryDelegate?.didUpdateDrawerHistoryDetailScreenEndDrawer?(with: returnDataEnd)
            
        }else{
            self.navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    @IBAction func btn_PrintAction(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            sender.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        if !DataManager.isBluetoothPrinter && !DataManager.isGooglePrinter {
//            self.showAlert(message: "Please first enable the printer from settings")
            appDelegate.showToast(message: "Please first enable the printer from settings")
            return
        }
        
        if DataManager.isBluetoothPrinter || DataManager.isGooglePrinter {
            
            callAPItoGetReceiptDetails()
            
            //let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        }
        
//        if DataManager.isGooglePrinter {
//            let Url = self.str_GooglePrint
//            //let str = Url.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//            if let url:NSURL = NSURL(string: Url) {
//                UIApplication.shared.open(url as URL)
//            }
//        }
    }
    
    private func checkPrinterConnection() {
        if PrintersViewController.centeralManager == nil || PrintersViewController.printerManager == nil {
            return
        }
        
        if let manager = PrintersViewController.printerManager, !manager.canPrint {
            if let index = PrintersViewController.printerArray.firstIndex(where: {$0.identifier == PrintersViewController.printerUUID}) {
                DispatchQueue.main.async {
                    PrintersViewController.printerManager?.connect(PrintersViewController.printerArray[index])
                }
            }
        }
    }
    
    private func handlePrinterAction() {
        if BluetoothPrinter.sharedInstance.isConnected() || DataManager.isStarPrinterConnected
        {
            //let str_footerText = receiptModel.card_agreement_text + "<br>" + receiptModel.refund_policy_text + "<br>" + receiptModel.footer_text
            
            let order: JSONDictionary = ["title" : self.receiptDetailsModel.siteName ,
                                         "address" : "\(self.receiptDetailsModel.address_line1)\n\(self.receiptDetailsModel.address_line2)" ,
                "addressDetail" : "\(self.receiptDetailsModel.city),\(self.receiptDetailsModel.region) \(self.receiptDetailsModel.postal_code)",
                "show_site_name": self.receiptDetailsModel.show_site_name,
                "siteName": self.receiptDetailsModel.siteName,
                "company_address": self.receiptDetailsModel.company_address,
                "address_line1": self.receiptDetailsModel.address_line1,
                "address_line2": self.receiptDetailsModel.address_line2,
                "city": self.receiptDetailsModel.city,
                "region": self.receiptDetailsModel.region,
                "postal_code": self.receiptDetailsModel.postal_code,
                "packing_slip_title": self.receiptDetailsModel.packing_slip_title,
                "customer_service_email": self.receiptDetailsModel.customer_service_email,
                "customer_service_phone": self.receiptDetailsModel.customer_service_phone,
                "cashdrawerID": self.receiptDetailsModel.cashdrawerID,
                "cash_refunds": self.receiptDetailsModel.cash_refunds,
                "cash_sales": self.receiptDetailsModel.cash_sales,
                "pay_in": self.receiptDetailsModel.pay_in,
                "pay_out": self.receiptDetailsModel.pay_out,
                "starting_cash": self.receiptDetailsModel.starting_cash,
                "started": self.receiptDetailsModel.started,
                "end_time": self.receiptDetailsModel.end_time,
                "actualin_drawer": self.receiptDetailsModel.actualin_drawer,
                "drawer_desc": self.receiptDetailsModel.drawer_desc,
                "expected_in_drawer": self.receiptDetailsModel.expected_in_drawer,
                "drawer_difference": self.receiptDetailsModel.drawer_difference,
                "source": self.receiptDetailsModel.source,
                "user_name": self.receiptDetailsModel.user_name
                
            ]
            
            if BluetoothPrinter.sharedInstance.isConnected() {
                BluetoothPrinter.sharedInstance.printEndDrawer(dict:order)
            } else if DataManager.isStarPrinterConnected {
                BluetoothPrinter.sharedInstance.callStarPrinterEndDrawerMethod(dict: order)
            }
            
        }
        else
        {
//            self.showAlert(message: "No Printer Found.")
            appDelegate.showToast(message: "No Printer Found.")
        }
    }
    
    
    // MARK: - API :-
    
    func callAPItoGetReceiptContentURL()
    {
        
        HomeVM.shared.getReceiptEndDrawerContentURL(orderID: str_DrawerId, responseCallBack: { (success, message, error) in
            if success == 1 {
                self.receiptURLModel = HomeVM.shared.receiptEndDrawerURL
                self.str_GooglePrint = self.receiptURLModel.receipt_url
                //self.handlePrinterAction()
            }else {
                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
    
    func callAPItoGetReceiptDetails()
    {
        HomeVM.shared.getReceiptEndDrawerDetails(orderID: str_DrawerId, responseCallBack: { (success, message, error) in
            if success == 1 {
                self.receiptDetailsModel = HomeVM.shared.receiptDetailsModel
                self.handlePrinterAction()
            }else {
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
//MARK: DetailReportViewControllerDelegate
extension DrawerHistoryDetailViewController: DetailReportViewControllerDelegate {
    
    func didUpdateDrawerHistoryDetailScreen(with data: JSONDictionary) {
        lblHeadDrawer.text  = "Open Drawer"
        btnPrintReceipt.isHidden = true
        if data["items"] != nil
        {
            drawerDetailData = data["items"] as! DrawerHistoryModel
            lblStarted.text = drawerDetailData.started
            lblClosed.text = drawerDetailData.end_time
            lblEnded.text = drawerDetailData.end_time
            lblStartingCash.text = "$\(drawerDetailData.starting_cash)"
            // lblExpectedDrawer.text = "$\(drawerDetailData.expected_in_drawer)"
            lblActualInDrawer.text = "$\(drawerDetailData.actualin_drawer)"
            //lblDifference.text = "$\(drawerDetailData.drawer_difference)"
            lblPaidIn.text = "$\(drawerDetailData.paid_in)"
            lblPaidOut.text = "$\(drawerDetailData.paid_out)"
            lblCashSales.text = "$\(drawerDetailData.cash_sales)"
            lblCashRefund.text = "$\(drawerDetailData.cash_refunds)"
            //            lblDrawerdescription.text = drawerDetailData.drawer_desc.capitalized
            
            if drawerDetailData.drawer_desc == "" {
                lblDrawerdescription.isHidden = true
                lblDescHead.isHidden = true
                viewBottomDrawerDes.isHidden = true
                
            } else {
                lblDrawerdescription.text = drawerDetailData.drawer_desc.capitalized
            }
            lblUser.text = drawerDetailData.user_name
            lblsaleLocation.text = drawerDetailData.source
            
            var newValue = ""
            let diff : String = (drawerDetailData.drawer_difference)
            let replaced = diff.replacingOccurrences(of: ",", with: "")
            var drawer_difference = (replaced as NSString).doubleValue
            
            if (drawer_difference < 0) {
                drawer_difference = -(drawer_difference);
                newValue = "-$\(drawer_difference.roundToTwoDecimal)"
            } else {
                newValue = "$\(drawer_difference.roundToTwoDecimal)"
            }
            lblDifference.text = newValue
            
            var newValue1 = ""
            let expected : String = (drawerDetailData.expected_in_drawer)
            let replaced1 = expected.replacingOccurrences(of: ",", with: "")
            var expected_in_drawer = (replaced1 as NSString).doubleValue
            
            if (expected_in_drawer < 0) {
                expected_in_drawer = -(expected_in_drawer);
                newValue1 = "-$\(expected_in_drawer.roundToTwoDecimal)"
            } else {
                newValue1 = "$\(expected_in_drawer.roundToTwoDecimal)"
            }
            lblExpectedDrawer.text = newValue1
            
            
            
            
            //            lblDifference.textAlignment = .left
            //            lblActualInDrawer.textAlignment = .left
            //            lblEnded.textAlignment = .left
            //            lblClosed.textAlignment = .left
            lblClosed.text = "-" //drawerDetailData.end_time
            lblEnded.text = "-" //drawerDetailData.end_time
            lblActualInDrawer.text = "-" //"$\(drawerDetailData.actualin_drawer)"
            lblDifference.text =  "-"//newValue
            
        }
    }
    
    
    func didUpdateDrawerHistoryDetailScreenEndDrawer(with data: JSONDictionary) {
        
        lblHeadDrawer.text  = "Closed Drawers"
        if data["items"] != nil
        {
            drawerDetailData = data["items"] as! DrawerHistoryModel
            
            str_DrawerId = drawerDetailData.cashdrawerID
            callAPItoGetReceiptContentURL()
            btnPrintReceipt.isHidden = false
            lblStarted.text = drawerDetailData.started
            lblClosed.text = drawerDetailData.end_time
            lblEnded.text = drawerDetailData.end_time
            lblStartingCash.text = "$\(drawerDetailData.starting_cash)"
            // lblExpectedDrawer.text = "$\(drawerDetailData.expected_in_drawer)"
            //lblDifference.text = "$\(drawerDetailData.drawer_difference)"
            
            lblActualInDrawer.text = "$\(drawerDetailData.actualin_drawer)"
            lblDifference.text = "$\(drawerDetailData.drawer_difference)"
            lblPaidIn.text = "$\(drawerDetailData.paid_in)"
            lblPaidOut.text = "$\(drawerDetailData.paid_out)"
            lblCashSales.text = "$\(drawerDetailData.cash_sales)"
            lblCashRefund.text = "$\(drawerDetailData.cash_refunds)"
            //            lblDrawerdescription.text = drawerDetailData.drawer_desc.capitalized
            
            if drawerDetailData.drawer_desc == "" {
                lblDrawerdescription.isHidden = true
                lblDescHead.isHidden = true
                viewBottomDrawerDes.isHidden = true
                
            } else {
                lblDrawerdescription.text = drawerDetailData.drawer_desc.capitalized
            }
            lblUser.text = drawerDetailData.user_name
            lblsaleLocation.text = drawerDetailData.source
            
            var newValue = ""
            let diff : String = (drawerDetailData.drawer_difference)
            let replaced = diff.replacingOccurrences(of: ",", with: "")
            var drawer_difference = (replaced as NSString).doubleValue
            
            if (drawer_difference < 0) {
                drawer_difference = -(drawer_difference);
                newValue = "-$\(drawer_difference.roundToTwoDecimal)"
            } else {
                newValue = "$\(drawer_difference.roundToTwoDecimal)"
            }
            
            
            var newValue1 = ""
            let expected : String = (drawerDetailData.expected_in_drawer)
            let replaced1 = expected.replacingOccurrences(of: ",", with: "")
            var expected_in_drawer = (replaced1 as NSString).doubleValue
            
            if (expected_in_drawer < 0) {
                expected_in_drawer = -(expected_in_drawer);
                newValue1 = "-$\(expected_in_drawer.roundToTwoDecimal)"
            } else {
                newValue1 = "$\(expected_in_drawer.roundToTwoDecimal)"
            }
            lblExpectedDrawer.text = newValue1
            
            //            lblDifference.textAlignment = .right
            //            lblActualInDrawer.textAlignment = .right
            
        }
    }
}

//MARK: PrinterManagerDelegate
extension DrawerHistoryDetailViewController: PrinterManagerDelegate {
    
    func loadPrinter() {
        PrintersViewController.printerManager = PrinterManager()
        PrintersViewController.printerManager?.delegate = self
        PrintersViewController.printerArray = PrintersViewController.printerManager!.nearbyPrinters
        PrintersViewController.printerUUID = nil
        //self.tbl_Settings.reloadData()
    }
    
    public func nearbyPrinterDidChange(_ change: NearbyPrinterChange) {
        switch change {
        case let .add(p):
            PrintersViewController.printerArray.append(p)
        case let .update(p):
            guard let row = (PrintersViewController.printerArray.index() { $0.identifier == p.identifier } ) else {
                return
            }
            if p.state == .connected {
                DataManager.receipt = true
                PrintersViewController.printerUUID = p.identifier
            }
            else if p.state == .disconnected {
                PrintersViewController.printerUUID = nil
            }
            PrintersViewController.printerArray[row] = p
            print(p.state)
        case let .remove(identifier):
            guard let row = (PrintersViewController.printerArray.index() { $0.identifier == identifier } ) else {
                return
            }
            
            if PrintersViewController.printerUUID == PrintersViewController.printerArray[row].identifier {
                PrintersViewController.printerUUID = nil
            }
            PrintersViewController.printerArray.remove(at: row)
        }
        
        //self.tbl_Settings.reloadData()
    }
    
    func moveToSettings() {
        //        if !isShowAlert {
        //            return
        //        }
        self.showAlert(title: "Alert", message: "Please enable the bluetooth from Settings.", otherButtons: nil, cancelTitle: kOkay) { (action) in
            guard let url = URL(string: "App-Prefs:root=Bluetooth") else {return}
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

