//
//  iPad_AccessPINViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 29/01/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import Alamofire

class iPad_AccessPINViewController: BaseViewController {
    
    //MARK: IBOutlets  iPad_AccessPINViewController
    @IBOutlet var dotViews: [UIView]!
    @IBOutlet var textField: UITextField!
    @IBOutlet weak var lblDateDay: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var inputFieldView: UIView!
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var pinPageLogo: UIImageView!
    
    //MARK: Private Variables
    private var arrayNumbers = Array<String>()
    private var accessPin = String()
    private var dummyCardNumber = String()
    var ACCEPTABLE_CHARACTERS = "0123456789"
    var delegate: HieCORPinDelegate?
    static var isPresented = Bool()
    var gameTimer: Timer?
    
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if DataManager.userTypeFlag == true{
            pinPageLogo.image = UIImage(named: ("logo1"))
        }else{
           // pinPageLogo.image = UIImage(named: ("cancelCard"))
            pinPageLogo.isHidden = true
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        iPad_AccessPINViewController.isPresented = true
        self.customizeUI()
        self.clearData()
        inputFieldView.roundCorners(corners: [.topLeft, .topRight], radius: 4.0)
        numberView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 4.0)
        //Add Observer
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "ExternalKeyboardStatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(externalKeyboardStatus(notification:)), name: Notification.Name(rawValue: "ExternalKeyboardStatus"), object: nil)
        
        //Enable Keyboard If External Keyboard Attached
        if Keyboard._isExternalKeyboardAttached() {
            self.textField.keyboardToolbar.isHidden = true
            self.textField.hideAssistantBar()
            self.textField.autocorrectionType = .no
            self.textField.shouldHideToolbarPlaceholder = true
            self.textField.addTarget(self, action: #selector(self.textDidChange(_:)), for: .editingChanged)
            self.textField.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.delegate = nil
        iPad_AccessPINViewController.isPresented = false
        //Remove Observer
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "ExternalKeyboardStatus"), object: nil)
        
        gameTimer?.invalidate()
        
        if Keyboard._isExternalKeyboardAttached() {
            textField.resignFirstResponder()
        }
    }
    
    //MARK: Private Functions
    private func customizeUI() {
        //Set Corner Radius
        for subView in dotViews {
            subView.setCornerRadius()
        }
        
        self.lblTime.text = Date().string(format: "h:mm a")
        self.lblDateDay.text = Date().string(format: "E, MMMM d")
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
        
    }
    
    @objc func runTimedCode() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.lblTime.text = Date().string(format: "h:mm a")
            self.lblDateDay.text = Date().string(format: "E, MMMM d")
            //print("date formate",Date().string(format: "h:mm a") )
            //print("date formate",Date().string(format: "E,MMMM d") )
        }
    }
    
    
    private func updateUI() {
        if accessPin.isEmpty {
            self.clearData()
            return
        }
        //Show Dots
        for subView in dotViews {
            subView.isHidden = (subView.tag <= accessPin.count) ? false : true
        }
        //Call API
        if accessPin.count == 6 {
            self.callAPIToValidatePIN(pin: accessPin)
        }
    }
    
    private func clearData() {
        self.textField.text = ""
        self.accessPin = ""
        //Hide All Dots
        for subView in dotViews {
            subView.isHidden = true
        }
    }
    
    //ExternalKeyboardStatus
    @objc func externalKeyboardStatus(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            if !Keyboard._isExternalKeyboardAttached() {
                UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
                self.textField.resignFirstResponder()
            }else {
                self.textField.becomeFirstResponder()
            }
        }
    }
    
    //MARK: IBActions Method
    @IBAction func numberButtonActions(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.8862745098, green: 0.9294117647, blue: 0.9647058824, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  .white
        }
        if sender.tag != 10 && sender.tag != 20 {
            accessPin.append((sender.titleLabel?.text!)!)
        }
        //Back Space
        if sender.tag == 10 {
            if accessPin != "" {
                accessPin.removeLast()
            }
        }
        //Update UI
        self.updateUI()
        //Enter Button
        if sender.tag == 20 {
            if self.accessPin.isEmpty {
//                self.showAlert(message: "Please Enter Pin.")
                appDelegate.showToast(message: "Please Enter Pin.")
                return
            }
            self.callAPIToValidatePIN(pin: accessPin)
        }
        
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        gameTimer?.invalidate()
        SwipeAndSearchVC.shared.isEnable = false
        UserDefaults.standard.removeObject(forKey: "recentOrder")
        UserDefaults.standard.removeObject(forKey: "recentOrderID")
        UserDefaults.standard.removeObject(forKey: "isCheckUncheckShippingBilling")
        UserDefaults.standard.removeObject(forKey: "cartdata")
        UserDefaults.standard.removeObject(forKey: "CustomerObj")
        UserDefaults.standard.removeObject(forKey: "SelectedCustomer")
        UserDefaults.standard.removeObject(forKey: "cartProductsArray")
        UserDefaults.standard.removeObject(forKey: "addnotesordersummary")
        UserDefaults.standard.removeObject(forKey: "isUserLogin")
        UserDefaults.standard.removeObject(forKey: "offline")
        //        UserDefaults.standard.removeObject(forKey: "LoginBaseUrl")
        UserDefaults.standard.removeObject(forKey: "LoginUsername")
        UserDefaults.standard.removeObject(forKey: "LoginPassword")
        UserDefaults.standard.synchronize()
        
        self.dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            self.gameTimer?.invalidate()
            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "iPad_LoginViewController")
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }
    
}

//API Methods
extension iPad_AccessPINViewController {
    func callAPIToValidatePIN(pin: String) {
        let userId = DataManager.userID
        LoginVM.shared.validatePIN(pin: pin) { (success, message, error) in
            if success == 1 {
                self.gameTimer?.invalidate()
                //self.delegate?.didGetSuccess?()
//                self.dismiss(animated: true, completion: nil)
                
                if DataManager.userID != userId {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        UserDefaults.standard.removeObject(forKey: "recentOrder")
                        UserDefaults.standard.removeObject(forKey: "recentOrderID")
                        UserDefaults.standard.removeObject(forKey: "isCheckUncheckShippingBilling")
                        UserDefaults.standard.removeObject(forKey: "cartdata")
                        if appDelegate.UserTaxData == true {
                            UserDefaults.standard.removeObject(forKey: "CustomerObj")
                            appDelegate.UserTaxData = false
                        }
                        UserDefaults.standard.removeObject(forKey: "SelectedCustomer")
                        UserDefaults.standard.removeObject(forKey: "cartProductsArray")
                        UserDefaults.standard.removeObject(forKey: "addnotesordersummary")
                        UserDefaults.standard.removeObject(forKey: "defaultTaxID")
                        //DataManager.selectedPaxDeviceName = ""
                        UserDefaults.standard.synchronize()
                        DataManager.isshipOrderButton = false
                        DataManager.isPromptAddCustomer = false
                        DataManager.selectedCategory = "Home"
                        DataManager.isCheckForAppUpdate = false
                        HomeVM.shared.amountPaid = 0.0
                        HomeVM.shared.tipValue = 0.0
                        HomeVM.shared.DueShared = 0.0
                        DataManager.isBalanceDueData = false
                        DataManager.isLoginByPin = true
                        self.dismiss(animated: true, completion: nil)
                        if UI_USER_INTERFACE_IDIOM() == .pad {
                            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController") as! SWRevealViewController
                            appDelegate.window?.rootViewController = controller
                            appDelegate.window?.makeKeyAndVisible()
                        }else {
                            self.setRootViewControllerForIphone()
                        }
                    }
                }else {
                    self.dismiss(animated: true, completion: nil)
                    if UI_USER_INTERFACE_IDIOM() == .pad {
                        let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController") as! SWRevealViewController
                        appDelegate.window?.rootViewController = controller
                        appDelegate.window?.makeKeyAndVisible()
                    }else {
                        self.setRootViewControllerForIphone()
                    }
                }
                                
            } else {
                //Clear Data
                self.clearData()
                if message != nil {
//                    self.showAlert(message: message)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
}

//MARK: UITextFieldDelegate
extension iPad_AccessPINViewController: UITextFieldDelegate {
    @objc func textDidChange(_ textField: UITextField) {
        self.accessPin = textField.text ?? ""
        //Update UI
        self.updateUI()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        //Handle Swipe Reader Data
        dummyCardNumber.append(string)
        if String(describing: dummyCardNumber.prefix(1)) == "%" || String(describing: dummyCardNumber.prefix(2)) == "%B" ||  String(describing: dummyCardNumber.prefix(1)) == ";" {
            return false
        }
        dummyCardNumber = ""
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        return string == filtered
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.accessPin.isEmpty {
//            self.showAlert(message: "Please Enter Pin.")
            appDelegate.showToast(message: "Please Enter Pin.")
            self.updateUI()
            return true
        }
        textField.text = ""
        dummyCardNumber = ""
        self.callAPIToValidatePIN(pin: accessPin)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            textField.text = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                textField.becomeFirstResponder()
            }
            return
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        dummyCardNumber = ""
        if !Keyboard._isExternalKeyboardAttached() {
            textField.text = ""
            textField.resignFirstResponder()
        }
    }
    
}
