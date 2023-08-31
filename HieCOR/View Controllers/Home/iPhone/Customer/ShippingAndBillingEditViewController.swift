//
//  ShippingAndBillingEditViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 04/01/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

@objc protocol UpdatedShippingAndBillingAddressDelegate: class {
    @objc optional func updatedShippingAndBillingAddress(customerdata: CustomerListModel)
}

protocol taxFromShippingAndBillSelectedStateCityDelegate {
    func taxFromShippingAndBillSelectedStateCity(staxtitle: String, staxType: String, staxAmountValue: String)
}

class ShippingAndBillingEditViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet var tf_BillingZip: UITextField!
    @IBOutlet var tf_BillingState: UITextField!
    @IBOutlet var tf_BillingCity: UITextField!
    @IBOutlet var tf_BillingAddress2: UITextField!
    @IBOutlet var tf_BillingAddress: UITextField!
    @IBOutlet var tf_BillingPhoneNumber: UITextField!
    @IBOutlet var view_Billing: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var view_ContentView: UIView!
    @IBOutlet var tf_Zip: UITextField!
    @IBOutlet var tf_State: UITextField!
    @IBOutlet var tf_City: UITextField!
    @IBOutlet var tf_Address2: UITextField!
    @IBOutlet var tf_Address: UITextField!
    @IBOutlet var tf_PhoneNumber: UITextField!
    @IBOutlet var btn_CheckUncheckShippingBilling: UIButton!
    @IBOutlet weak var billingCountryTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    
    //MARK: Variables
    var CustomerObj = CustomerListModel()
    var delegate:UpdatedShippingAndBillingAddressDelegate?
    var delgat: taxFromShippingAndBillSelectedStateCityDelegate? = nil
    var catAndProductDelegate: CatAndProductsViewControllerDelegate?
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setUpTextFields()
        self.customizeUI()
        self.shippingAndBillingDataFIlled(CustomerObj: CustomerObj)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        //Set Border
        bottomborderofTextField(textfield: tf_PhoneNumber)
        bottomborderofTextField(textfield: tf_Address)
        bottomborderofTextField(textfield: tf_Address2)
        bottomborderofTextField(textfield: tf_City)
        bottomborderofTextField(textfield: tf_Zip)
        bottomborderofTextField(textfield: countryTextField)
        
        bottomborderofTextField(textfield: tf_BillingPhoneNumber)
        bottomborderofTextField(textfield: tf_BillingAddress)
        bottomborderofTextField(textfield: tf_BillingAddress2)
        bottomborderofTextField(textfield: tf_BillingCity)
        bottomborderofTextField(textfield: tf_BillingZip)
        bottomborderofTextField(textfield: billingCountryTextField)
        
        tf_State.setBorder()
        tf_BillingState.setBorder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Private Functions
    private func customizeUI() {
        view_Billing.isHidden = true
        countryTextField.isHidden = !DataManager.isShowCountry
        billingCountryTextField.isHidden = !DataManager.isShowCountry

        //Status Bar
        if (UI_USER_INTERFACE_IDIOM() == .pad) {
            UIApplication.shared.isStatusBarHidden = false
        }
        else
        {
            UIApplication.shared.isStatusBarHidden = true
        }
        
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 20))
        let iconView  = UIImageView(frame: CGRect(x: 5, y: 7, width: 10, height: 7))
        iconView.image = UIImage(named: "dropdown-arrow")
        outerView.addSubview(iconView)
        tf_State?.rightView = outerView
        tf_State?.rightViewMode = .always
        
        let outerView1 = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 20))
        let iconView1  = UIImageView(frame: CGRect(x: 5, y: 7, width: 10, height: 7))
        iconView1.image = UIImage(named: "dropdown-arrow")
        outerView1.addSubview(iconView1)
        tf_BillingState?.rightView = outerView1
        tf_BillingState?.rightViewMode = .always
        
        let outerView2 = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 20))
        let iconView2  = UIImageView(frame: CGRect(x: 5, y: 7, width: 10, height: 7))
        iconView2.image = UIImage(named: "dropdown-arrow")
        outerView2.addSubview(iconView2)
        countryTextField.rightView = outerView2
        countryTextField.rightViewMode = .always
        
        let outerView3 = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 20))
        let iconView3  = UIImageView(frame: CGRect(x: 5, y: 7, width: 10, height: 7))
        iconView3.image = UIImage(named: "dropdown-arrow")
        outerView3.addSubview(iconView3)
        billingCountryTextField.rightView = outerView3
        billingCountryTextField.rightViewMode = .always
        
        view_Billing.isHidden = DataManager.isCheckUncheckShippingBilling
        btn_CheckUncheckShippingBilling.setImage( DataManager.isCheckUncheckShippingBilling ? #imageLiteral(resourceName: "shipping-check") : #imageLiteral(resourceName: "shipping-uncheck"), for: .normal)
        
    }
    
    private func setUpTextFields() {
        //Set Delegates To Self
        tf_PhoneNumber.delegate = self
        tf_Address.delegate = self
        tf_Address2.delegate = self
        tf_City.delegate = self
        tf_State.delegate = self
        tf_Zip.delegate = self
        tf_BillingPhoneNumber.delegate = self
        tf_BillingAddress.delegate = self
        tf_BillingAddress2.delegate = self
        tf_BillingCity.delegate = self
        tf_BillingState.delegate = self
        tf_BillingZip.delegate = self
        //Set Border
        bottomborderofTextField(textfield: tf_PhoneNumber)
        bottomborderofTextField(textfield: tf_Address)
        bottomborderofTextField(textfield: tf_Address2)
        bottomborderofTextField(textfield: tf_City)
        bottomborderofTextField(textfield: countryTextField)
        bottomborderofTextField(textfield: tf_Zip)
        
        bottomborderofTextField(textfield: tf_BillingPhoneNumber)
        bottomborderofTextField(textfield: tf_BillingAddress)
        bottomborderofTextField(textfield: tf_BillingAddress2)
        bottomborderofTextField(textfield: tf_BillingCity)
        bottomborderofTextField(textfield: billingCountryTextField)
        bottomborderofTextField(textfield: tf_BillingZip)
        
        tf_State.setBorder()
        tf_BillingState.setBorder()
        
    }
    
    private func bottomborderofTextField(textfield: UITextField)
    {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        border.frame = CGRect(x: 0, y: textfield.frame.size.height - width, width:  self.view.frame.size.width, height: textfield.frame.size.height)
        border.borderWidth = width
        textfield.layer.addSublayer(border)
        textfield.layer.masksToBounds = true
    }
    
    private func shippingAndBillingDataFIlled(CustomerObj: CustomerListModel)
    {
        countryTextField.text = DataManager.selectedCountry
        billingCountryTextField.text = DataManager.selectedCountry
        //Shipping Address
        tf_PhoneNumber.text = CustomerObj.str_Shippingphone != "" ? CustomerObj.str_Shippingphone : CustomerObj.str_phone
        tf_Address.text = CustomerObj.str_Shippingaddress != "" ? CustomerObj.str_Shippingaddress : CustomerObj.str_address
        tf_Address2.text = CustomerObj.str_Shippingaddress2 != "" ? CustomerObj.str_Shippingaddress2 : CustomerObj.str_address2
        tf_City.text = CustomerObj.str_Shippingcity != "" ? CustomerObj.str_Shippingcity : CustomerObj.str_city
        tf_State.text = CustomerObj.str_Shippingregion != "" ? CustomerObj.str_Shippingregion : CustomerObj.str_region
        tf_Zip.text = CustomerObj.str_Shippingpostal_code != "" ? CustomerObj.str_Shippingpostal_code : CustomerObj.str_postal_code
        countryTextField.text = CustomerObj.country
        //Billing Address
        tf_BillingPhoneNumber.text = CustomerObj.str_Billingphone
        tf_BillingAddress.text = CustomerObj.str_Billingaddress
        tf_BillingAddress2.text = CustomerObj.str_Billingaddress2
        tf_BillingCity.text = CustomerObj.str_Billingcity
        tf_BillingState.text = CustomerObj.str_Billingregion
        tf_BillingZip.text = CustomerObj.str_Billingpostal_code
        billingCountryTextField.text = CustomerObj.billingCountry
    }
    
    private func updateBillingAddress() {
        if CustomerObj.str_bpid != "" {
            return
        }
        tf_BillingPhoneNumber.text = tf_PhoneNumber.text
        //        tf_BillingAddress.text = tf_Address.text
        //        tf_BillingAddress2.text = tf_Address2.text
        //        tf_BillingCity.text = tf_City.text
        //        tf_BillingState.text = tf_State.text
        //        tf_BillingZip.text = tf_Zip.text
    }
    
    //MARK: IBActions
    @IBAction func btn_CheckUncheckShippingBillingAction(_ sender: Any)
    {
        self.view.endEditing(true)
        if btn_CheckUncheckShippingBilling.image(for: .normal) == #imageLiteral(resourceName: "shipping-check") {
            DataManager.isCheckUncheckShippingBilling = false
            btn_CheckUncheckShippingBilling.setImage(UIImage(named: "shipping-uncheck"), for: .normal)
            view_Billing.isHidden = false
        }else {
            DataManager.isCheckUncheckShippingBilling = true
            btn_CheckUncheckShippingBilling.setImage(UIImage(named: "shipping-check"), for: .normal)
            view_Billing.isHidden = true
        }
        updateBillingAddress()
    }
    
    @IBAction func btn_DoneAction(_ sender: Any)
    {
        self.view.endEditing(true)
        //Update Data
        CustomerObj.str_Shippingphone = tf_PhoneNumber.text!
        CustomerObj.str_Shippingaddress = tf_Address.text!
        CustomerObj.str_Shippingaddress2 = tf_Address2.text!
        CustomerObj.str_Shippingcity = tf_City.text!
        CustomerObj.str_Shippingregion = tf_State.text!
        CustomerObj.str_Shippingpostal_code = tf_Zip.text!
        CustomerObj.str_Billingphone = tf_BillingPhoneNumber.text!
        CustomerObj.str_Billingaddress = tf_BillingAddress.text!
        CustomerObj.str_Billingaddress2 = tf_BillingAddress2.text!
        CustomerObj.str_Billingcity = tf_BillingCity.text!
        CustomerObj.str_Billingregion = tf_BillingState.text!
        CustomerObj.str_Billingpostal_code = tf_BillingZip.text!
        
        CustomerObj.country = countryTextField.text!
        CustomerObj.billingCountry = billingCountryTextField.text!
        
        delegate?.updatedShippingAndBillingAddress?(customerdata: CustomerObj)
        
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            UIApplication.shared.isStatusBarHidden = false
        }
        else
        {
            UIApplication.shared.isStatusBarHidden = true
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    @IBAction func btn_CancelAction(_ sender: Any)
    {
        self.view.endEditing(true)
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            UIApplication.shared.isStatusBarHidden = false
            self.catAndProductDelegate?.hideView?(with: "shippingandbillingCancelIPAD")
        }
        else
        {
            UIApplication.shared.isStatusBarHidden = false
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

//MARK: UITextFieldDelegate
extension ShippingAndBillingEditViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == tf_State {
            textField.tintColor = UIColor.clear
            textField.resetCustomError(isAddAgain: true)
            if let index = HomeVM.shared.countryDetail.firstIndex(where: {$0.abbreviation == (DataManager.isShowCountry ? (countryTextField.text ?? "") : DataManager.selectedCountry)}) {
                let countryName = HomeVM.shared.countryDetail[index].abbreviation ?? "N/A"
                self.showCustomTableView(self, sourceView: textField, countryName: countryName) { (text) in
                    self.tf_State.text = text
                }
            }else {
                textField.resignFirstResponder()
                DispatchQueue.main.async {
                    textField.resignFirstResponder()
                }
                //Offline
                if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
                    self.showAlert(title: "Oops!", message: "Regions are not avalable in the offline mode!")
                    return
                }
                
                //Online
                textField.setCustomError(text: "Please select country.",bottomSpace: 0)
            }
        }
        
        if textField == tf_BillingState {
            textField.tintColor = UIColor.clear
            textField.resetCustomError(isAddAgain: true)
            if let index = HomeVM.shared.countryDetail.firstIndex(where: {$0.abbreviation == (DataManager.isShowCountry ? (billingCountryTextField.text ?? "") : DataManager.selectedCountry)}) {
                let countryName = HomeVM.shared.countryDetail[index].abbreviation ?? "N/A"
                self.showCustomTableView(self, sourceView: textField, countryName: countryName) { (text) in
                    self.tf_BillingState.text = text
                }
            }else {
                textField.resignFirstResponder()
                DispatchQueue.main.async {
                    textField.resignFirstResponder()
                }
                //Offline
                if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
                    self.showAlert(title: "Oops!", message: "Regions are not avalable in the offline mode!")
                    return
                }
                
                //Online
                textField.setCustomError(text: "Please select country.",bottomSpace: 0)
            }
        }
        
        if textField == countryTextField {
            textField.tintColor = UIColor.clear
            self.tf_State.text = ""
            self.showCustomTableView(self, sourceView: textField, countryName: "") { (text) in
                textField.text = text
            }
        }
        
        if textField == billingCountryTextField {
            textField.tintColor = UIColor.clear
            self.tf_BillingState.text = ""
            self.showCustomTableView(self, sourceView: textField, countryName: "") { (text) in
                textField.text = text
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
        
        if textField == tf_PhoneNumber || textField == tf_BillingPhoneNumber || textField == tf_Zip || textField == tf_BillingZip {
            let cs = NSCharacterSet(charactersIn: "0123456789").inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 20 {
                return false
            }
            return string == filtered
        }
        
        if textField == tf_Address || textField == tf_Address2 || textField == tf_BillingAddress || textField == tf_BillingAddress2 || textField == tf_City || textField == tf_Zip || textField == tf_BillingCity || textField == tf_BillingZip {
            if textField.text == "" && string == " " {
                return false
            }
        }
        
        if textField == tf_Address || textField == tf_Address2 || textField == tf_BillingAddress || textField == tf_BillingAddress2 {
            if charactersCount > 100 {
                return false
            }
        }
        
        if textField == tf_City || textField == tf_BillingCity {
            let cs = CharacterSet.alphanumerics.inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 20 {
                return false
            }
            
            if string == " " {
                return true
            }
            return string == filtered
        }
        
        return true
    }
    
}

extension ShippingAndBillingEditViewController: ShippingDelegate {
    func didSelectShipping(data: CustomerListModel) {
        self.CustomerObj = data
        shippingAndBillingDataFIlled(CustomerObj: data)
    }
}
