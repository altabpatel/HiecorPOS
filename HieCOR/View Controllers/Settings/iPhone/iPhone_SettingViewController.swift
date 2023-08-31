//
//  iPhone_SettingViewController.swift
//  HieCOR
//
//  Created by Hiecor on 04/03/21.
//  Copyright © 2021 HyperMacMini. All rights reserved.
//


import UIKit

class iPhone_SettingViewController :  BaseViewController, SWRevealViewControllerDelegate{
    
    //MARK: IBOutlet
    
    @IBOutlet weak var btn_Menu: UIButton!
    @IBOutlet weak var containerView_CheckoutOptionsiPhone: UIView!
    @IBOutlet weak var containerView_PaymentMethodiPhone: UIView!
    @IBOutlet weak var containerView_SignatureAndReceiptiPhone: UIView!
    @IBOutlet weak var containerView_HardwareiPhone: UIView!
    @IBOutlet weak var containerView_PrintersiPhone: UIView!
    @IBOutlet weak var containerView_AdvancedSettingsiPhone: UIView!
    @IBOutlet weak var containerView_SettingListiPhone: UIView!
    @IBOutlet weak var containerView_CardReaderiPhone: UIView!
    
    
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
        containerView_SettingListiPhone.isHidden = true
        containerView_SignatureAndReceiptiPhone.isHidden = true
        containerView_HardwareiPhone.isHidden = true
        containerView_PrintersiPhone.isHidden = true
        containerView_AdvancedSettingsiPhone.isHidden = true
        containerView_CheckoutOptionsiPhone.isHidden = true
        containerView_PaymentMethodiPhone.isHidden = true
        containerView_SettingListiPhone.isHidden = false
        containerView_CardReaderiPhone.isHidden = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingListiPhone" {
            let vc = segue.destination as! SettingListViewController
            vc.settingListDelegate = self
            //vc.PayInOutDelegate = self
        }
        if segue.identifier == "signatureAndReceiptiPhone" {
            let vc = segue.destination as! SignatureAndReceiptViewController
            vc.signatureAndReceiptDelegate = self
            // vc.PayInOutDelegate = self
        }
        if segue.identifier == "advanceSettingsiPhone" {
            let vc = segue.destination as! AdvancedSettingsViewController
            vc.advanceSettingsDelegate = self
            // drawerHistoryDelegate = vc as? DetailReportViewControllerDelegate
        }
        if segue.identifier == "printersiPhone" {
            let vc = segue.destination as! PrintersViewController
            vc.printersSettingDelegate = self
            
            // returnDelegate = vc
        }
        if segue.identifier == "hardwareiPhone" {
            let vc = segue.destination as! HardwareViewController
            vc.hardwareSettingDelegate = self
            //returnDrawerHistory = vc
        }
        if segue.identifier == "checkoutOptionsiPhone" {
            let vc = segue.destination as! CheckoutOptionsListViewController
            vc.checkoutOptionsSettingDelegate = self
            // checkoutOptionsListVC = vc
        }
        
        if segue.identifier == "paymentMethodiPhone" {
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
extension iPhone_SettingViewController: SettingViewControllerDelegate {
    func didMoveToNextScreen(with string: String) {
        containerView_CheckoutOptionsiPhone.isHidden = true
        containerView_SettingListiPhone.isHidden = true
        containerView_SignatureAndReceiptiPhone.isHidden = true
        containerView_HardwareiPhone.isHidden = true
        containerView_PrintersiPhone.isHidden = true
        containerView_AdvancedSettingsiPhone.isHidden = true
        containerView_PaymentMethodiPhone.isHidden = true
        containerView_CardReaderiPhone.isHidden = true
        if string == "Checkout Options" {
            containerView_CheckoutOptionsiPhone.isHidden = false
            
        }else if  string == "Hardware" {
            containerView_HardwareiPhone.isHidden = false
            
        }else if  string == "Advanced Setting" {
            containerView_AdvancedSettingsiPhone.isHidden = false
            
        }else if string == "Payment Method"{
            containerView_PaymentMethodiPhone.isHidden = false
            
        } else if string == "Signature And Receipt"{
            containerView_SignatureAndReceiptiPhone.isHidden = false
            
        }else if string == "Printers"{
            containerView_PrintersiPhone.isHidden = false
            
        } else {
            containerView_SettingListiPhone.isHidden = false
            //  containerView_CheckoutOptions.isHidden = false
        }
    }
    
    func cardReaderViewShowHide(with bool: Bool) {
        containerView_CardReaderiPhone.isHidden = bool
        if bool {
            paymentScreenTableRealoadByDelegate?.paymentScreenReloadDelegate?()
        }
    }
    
    func IngenicoDeviceListDelegate() {
          sendToCardReaderViewController?.IngenicoDeviceDataDelegate?()
        
      }
    
    func IngenicoDeviceDataDelegateData(with data: [RUADevice]) {
        sendToCardReaderViewController?.IngenicoDeviceDataDelegateData?(with: data)
    }
    
}


