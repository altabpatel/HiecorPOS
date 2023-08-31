//
//  iPad_SettingViewController.swift
//  HieCOR
//
//  Created by Hiecor on 16/02/21.
//  Copyright © 2021 HyperMacMini. All rights reserved.
//

import UIKit
import CoreData
import CoreBluetooth
import CoreBluetooth.CBService
import MobileCoreServices
import IQKeyboardManagerSwift

class iPad_SettingViewController :  BaseViewController, SWRevealViewControllerDelegate{
    
    //MARK: IBOutlet
    
    @IBOutlet weak var containerView_CheckoutOptions: UIView!
    @IBOutlet weak var containerView_PaymentMethod: UIView!
    @IBOutlet weak var containerView_SignatureAndReceipt: UIView!
    @IBOutlet weak var containerView_Hardware: UIView!
    @IBOutlet weak var containerView_Printers: UIView!
    @IBOutlet weak var containerView_AdvancedSettings: UIView!
    
    @IBOutlet weak var containerView_CardReader: UIView!
    //MARK: IBOutlet

    
    @IBOutlet weak var btn_Menu: UIButton!
    @IBOutlet weak var posLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var lockLineView: UIView!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var logoutLineView: UIView!
    
    
    @IBOutlet weak var tbl_CardReaderDevice: UITableView!
    @IBOutlet weak var cardReaderMainView: UIView!
    @IBOutlet weak var cardReaderDeviceViewWidth: NSLayoutConstraint!
    @IBOutlet weak var cardReaderDeviceViewHeight: NSLayoutConstraint!
    
    //MARK: Delegate
    
    var settingListDelegate: SettingViewControllerDelegate?
    var signatureAndReceiptDelegate: SettingViewControllerDelegate?
    var advanceSettingsDelegate: SettingViewControllerDelegate?
    var printersSettingDelegate: SettingViewControllerDelegate?
    var hardwareSettingDelegate: SettingViewControllerDelegate?
    var paymentMethodSettingDelegate: SettingViewControllerDelegate?
    var checkoutOptionsSettingDelegate: SettingViewControllerDelegate?
    weak var sendToCardReaderViewController: SettingViewControllerDelegate?
    var paymentScreenTableRealoadByDelegate: SettingViewControllerDelegate?
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViews()
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
        containerView_PaymentMethod.isHidden = true
        containerView_CheckoutOptions.isHidden = false
        containerView_SignatureAndReceipt.isHidden = true
        containerView_Hardware.isHidden = true
        containerView_Printers.isHidden = true
        containerView_AdvancedSettings.isHidden = true
        containerView_CardReader.isHidden = true
        if let name = DataManager.deviceNameText {
            posLabel.text = name
        }else {
            let nameDevice = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
            posLabel.text = nameDevice//UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //OfflineDataManager Delegate
        OfflineDataManager.shared.settingDelegate = self
        //Disable IQKeyboardManager
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.enable = true
       // self.loadData()
        //Hide POS Label
        if UI_USER_INTERFACE_IDIOM() == .pad {
            posLabel.isHidden = false
            //Update Name
            if let name = DataManager.deviceNameText {
                posLabel.text = name
            }else {
                let nameDevice = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
                posLabel.text = nameDevice//UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
            }
          //  buttonsView.isHidden = false
        }else {
           // buttonsView.isHidden = true
            posLabel.isHidden = true
        }
        self.lockLineView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        self.lockButton.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        self.logoutButton.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        self.logoutLineView.isHidden = !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline
        SwipeAndSearchVC.shared.isEnable = false
    }
    override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           OfflineDataManager.shared.settingDelegate = nil
           //Disable IQKeyboardManager
           IQKeyboardManager.shared.enableAutoToolbar = true
       
       }
       
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingList" {
            let vc = segue.destination as! SettingListViewController
            vc.settingListDelegate = self
            //vc.PayInOutDelegate = self
        }
        if segue.identifier == "signatureAndReceipt" {
            let vc = segue.destination as! SignatureAndReceiptViewController
            vc.signatureAndReceiptDelegate = self
            // vc.PayInOutDelegate = self
        }
        if segue.identifier == "advanceSettings" {
            let vc = segue.destination as! AdvancedSettingsViewController
            vc.advanceSettingsDelegate = self
            // drawerHistoryDelegate = vc as? DetailReportViewControllerDelegate
        }
        if segue.identifier == "printers" {
            let vc = segue.destination as! PrintersViewController
            vc.printersSettingDelegate = self
            // returnDelegate = vc
        }
        if segue.identifier == "hardware" {
            let vc = segue.destination as! HardwareViewController
            vc.hardwareSettingDelegate = self
            //vc.deviceNameUpdateDelegate = self
            //returnDrawerHistory = vc
        }
        if segue.identifier == "checkoutOptions" {
            let vc = segue.destination as! CheckoutOptionsListViewController
            vc.checkoutOptionsSettingDelegate = self
            vc.deviceNameUpdateDelegate = self
            // checkoutOptionsListVC = vc
        }
        
        if segue.identifier == "paymentMethod" {
            let vc = segue.destination as! PaymentMethodViewController
            vc.paymentMethodSettingDelegate = self
            vc.cardReaderViewShowHideDelegate = self
            vc.paymentToMainiPadIngenicoDelegate = self
            paymentScreenTableRealoadByDelegate = vc
        }
        if segue.identifier == "cardReader" {
            let vc = segue.destination as! CardReaderViewController
           // vc.paymentMethodSettingDelegate = self
            vc.cardReaderViewShowHideDelegate = self
            sendToCardReaderViewController = vc
        }
        
    }
    //MARK: IBAction
    @IBAction func btn_HomeAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "iPad", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController")
        appDelegate.window?.rootViewController = vc
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func btn_LockAction(_ sender: Any) {
        //...
        let storyboard = UIStoryboard(name: "iPad", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "iPad_AccessPINViewController") as! iPad_AccessPINViewController
        if #available(iOS 13.0, *) {
            controller.modalPresentationStyle = .fullScreen
        }
        self.navigationController?.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func btn_LogOutAction(_ sender: Any) {
        alertForLogOut()
    }
    
}
//MARK: ReportInfoViewControllerDelegate
extension iPad_SettingViewController: SettingViewControllerDelegate {
    func didMoveToNextScreen(with string: String) {
        containerView_PaymentMethod.isHidden = true
        containerView_CheckoutOptions.isHidden = true
        containerView_SignatureAndReceipt.isHidden = true
        containerView_Hardware.isHidden = true
        containerView_Printers.isHidden = true
        containerView_AdvancedSettings.isHidden = true
        containerView_CardReader.isHidden = true
        
       // ------- ????------ code reduse
//        containerView_CheckoutOptions.isHidden = (string == "Checkout Options") ? false : true
//        containerView_Hardware.isHidden = (string == "Hardware") ? false : true
//        containerView_AdvancedSettings.isHidden = (string == "Advanced Setting") ? false : true
//        containerView_PaymentMethod.isHidden = (string == "Payment Method") ? false : true
//        containerView_SignatureAndReceipt.isHidden = (string == "Signature And Receipt") ? false : true
//        containerView_Printers.isHidden = (string == "Printers") ? false : true
        
       //  ------- ????------
        
        if string == "Checkout Options" {
            containerView_CheckoutOptions.isHidden = false
            
        }else if  string == "Hardware" {
            containerView_Hardware.isHidden = false
            
        } else if  string == "Advanced Setting" {
            containerView_AdvancedSettings.isHidden = false
            
        }else if string == "Payment Method"{
            containerView_PaymentMethod.isHidden = false
            
        } else if string == "Signature And Receipt"{
            containerView_SignatureAndReceipt.isHidden = false
            
        }else if string == "Printers"{
            containerView_Printers.isHidden = false
            
        } else{
            containerView_CheckoutOptions.isHidden = false
        }
    }
    func hidePaymentMethodView() {
        containerView_PaymentMethod.isHidden = true
        containerView_CheckoutOptions.isHidden = false
        containerView_SignatureAndReceipt.isHidden = true
        containerView_Hardware.isHidden = true
        containerView_Printers.isHidden = true
        containerView_AdvancedSettings.isHidden = true
    }
    func hidePrinterView() {
        containerView_PaymentMethod.isHidden = true
        containerView_CheckoutOptions.isHidden = true
        containerView_SignatureAndReceipt.isHidden = true
        containerView_Hardware.isHidden = false
        containerView_Printers.isHidden = true
        containerView_AdvancedSettings.isHidden = true
    }
    func cardReaderViewShowHide(with bool: Bool) {
         containerView_CardReader.isHidden = bool
        if bool {
            paymentScreenTableRealoadByDelegate?.paymentScreenReloadDelegate?()
        }
        
    }
    
    func  deviceNameUpdate(with string: String){
        if let name = DataManager.deviceNameText {
            posLabel.text = name
        }else {
            let nameDevice = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
            posLabel.text = nameDevice//UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
        }
    }
    
    func IngenicoDeviceListDelegate() {
          sendToCardReaderViewController?.IngenicoDeviceDataDelegate?()
        
      }
    
    func IngenicoDeviceDataDelegateData(with data: [RUADevice]) {
        sendToCardReaderViewController?.IngenicoDeviceDataDelegateData?(with: data)
    }
    
}

//MARK: OfflineDataManagerDelegate
extension iPad_SettingViewController: OfflineDataManagerDelegate {
    func didUpdateInternetConnection(isOn: Bool) {
        self.lockLineView.isHidden = !isOn
        self.lockButton.isHidden = !isOn
        self.logoutButton.isHidden = !isOn
        self.logoutLineView.isHidden = !isOn
       // self.tbl_Settings.reloadData()
    }
}
