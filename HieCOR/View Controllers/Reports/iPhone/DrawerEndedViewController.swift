//
//  DrawerEndedViewController.swift
//  HieCOR
//
//  Created by Rajshekar Pothu on 29/11/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class DrawerEndedViewController: BaseViewController {

    @IBOutlet weak var buttonCancel: UIButton!
    
    var str_DrawerId = ""
    var str_GooglePrint = ""
    
    var receiptDetailsModel = ReceiptEndDrawerDetailsModel()
    var receiptURLModel = ReceiptEndDrawerURL()
    
    //MARK: Delegate
    var currentDrawerDelegate : DetailReportViewControllerDelegate?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkPrinterConnection()
        loadPrinter()
        callAPItoGetReceiptContentURL()
        fillData()
       
    }
    
    func fillData()  {
        let origImage = UIImage(named: "cancel")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        buttonCancel.setImage(tintedImage, for: .normal)
        buttonCancel.tintColor = UIColor(red: 11/255, green: 118/255, blue: 201/255, alpha: 1)
    }

    
    // MARK: - Action:-
    @IBAction func buttonBackAction(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            sender.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            self.navigationController?.popToRootViewController(animated: true)
        }
        
       
//        let returnData = ["hide":true] as [String : Any]
//        currentDrawerDelegate?.checkEndDrawerCloseOrNot?(with: returnData)
//
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
//        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }

    @IBAction func buttonStartDrawerAction(_ sender: Any) {
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "iPad_ReportsViewController") as! iPad_ReportsViewController
           self.navigationController?.pushViewController(controller, animated: true)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "DetailReportViewController") as! DetailReportViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func btn_PrintAction(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            sender.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        if !DataManager.isBluetoothPrinter && !DataManager.isGooglePrinter {
//            self.showAlert(message: "Please first enable the printer from settings")
            appDelegate.showToast(message: "Please first enable the printer from settings")
            return
        }
        
        if DataManager.isBluetoothPrinter || DataManager.isGooglePrinter {
            
            callAPItoGetReceiptDetails()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
//                if UI_USER_INTERFACE_IDIOM() == .pad
//                {
//                    let storyboard = UIStoryboard(name: "iPad", bundle: nil)
//                    let controller = storyboard.instantiateViewController(withIdentifier: "iPad_ReportsViewController") as! iPad_ReportsViewController
//                   self.navigationController?.pushViewController(controller, animated: true)
//                }else{
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let controller = storyboard.instantiateViewController(withIdentifier: "DetailReportViewController") as! DetailReportViewController
//                    self.navigationController?.pushViewController(controller, animated: true)
//                }
//            })
            
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    if UI_USER_INTERFACE_IDIOM() == .pad
                    {
                        let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "iPad_ReportsViewController") as! iPad_ReportsViewController
                       self.navigationController?.pushViewController(controller, animated: true)
                    }else{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "DetailReportViewController") as! DetailReportViewController
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                })
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

//MARK: PrinterManagerDelegate
extension DrawerEndedViewController: PrinterManagerDelegate {
    
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

//MARK: DetailReportViewControllerDelegate
extension DrawerEndedViewController: DetailReportViewControllerDelegate {
    
    
}
