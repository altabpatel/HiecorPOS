//
//  ShippingIphoneVC.swift
//  HieCOR
//
//  Created by Sudama dewda on 31/07/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import UIKit
import Alamofire

class ShippingIphoneVC: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tfSelectCarrier: UITextField!
    @IBOutlet weak var tfSelectService: UITextField!
    @IBOutlet weak var tfWeight: UITextField!
    @IBOutlet weak var tfLength: UITextField!
    @IBOutlet weak var tfWidth: UITextField!
    @IBOutlet weak var tfHeight: UITextField!
    @IBOutlet weak var labErrorMessae: UILabel!
    @IBOutlet weak var constantTopView: NSLayoutConstraint!
    
    @IBOutlet weak var selectServiceView: UIView!
    @IBOutlet weak var stackViewForWLHW: UIStackView!
    //MARK: Variables
    var delegate: EditProductDelegate?
    var array_ShippingCarrierList = [ShippingCarrierDataModel]()
    var array_ShippingServiceList = [ShippingServiceDataModel]()
    var showCarrier  = [String]()
    var showService  = [String]()
    var indexCellPax = 0
    var ischeckCarrier = false
    var indexPathAll = NSIndexPath()
    var tempModel = CustomerListModel()
    var obRate = ""
    var oldListCount = Int()
    var duplicateArrayList = Array<Any>()
    var cartList = Array<Any>()
    var shipWidth = Double()
    var shipLength = Double()
    var shipWeight = Double()
    var shipHeight = Double()
    var newQty = Double()
    var productQty = Double()
    var height = Double()
    //MARK: -- View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        height = Double(stackViewForWLHW.frame.height + selectServiceView.frame.height + 10)
        tfWeight.delegate = self
        tfHeight.delegate = self
        tfLength.delegate = self
        tfWidth.delegate = self
        
        tfSelectCarrier.addTarget(self, action: #selector(handleSelectCarrierTextField(sender:)), for: .editingDidBegin)
        tfSelectService.addTarget(self, action: #selector(handleSelectServiceTextField(sender:)), for: .editingDidBegin)
        
        tfWeight.addTarget(self, action: #selector(handleWeightTextField(sender:)), for: .editingChanged)
        tfHeight.addTarget(self, action: #selector(handleHeightTextField(sender:)), for: .editingChanged)
        tfLength.addTarget(self, action: #selector(handleLengthTextField(sender:)), for: .editingChanged)
        tfWidth.addTarget(self, action: #selector(handleWidthTextField(sender:)), for: .editingChanged)
        
        
        tfSelectCarrier.setDropDown()
        tfSelectService.setDropDown()
        
        
        if tempModel.str_address != "" && tempModel.str_city != ""  && tempModel.str_region != "" && tempModel.str_postal_code != "" && tempModel.country != "" {
            labErrorMessae.isHidden = true
        }else{
            labErrorMessae.isHidden = false
        }
        
        if DataManager.selectedCarrier == "" || DataManager.selectedCarrier == nil {
            tfSelectCarrier.text = "Select Carrier"
        }else{
            tfSelectCarrier.text = DataManager.selectedCarrier
        }
        if DataManager.selectedService == "" ||  DataManager.selectedService == nil{
            tfSelectService.text = "Select Service"
        }else{
            tfSelectService.text = DataManager.selectedService
        }
      
        
    }
    override func viewWillAppear(_ animated: Bool) {
        height = Double(stackViewForWLHW.frame.height + selectServiceView.frame.height + 10)
        self.stackViewForWLHW.isHidden = false
        self.selectServiceView.isHidden = false
        self.labErrorMessae.isHidden = false
        constantTopView.constant = UIScreen.main.bounds.height - 333
        if DataManager.selectedCarrierName != "" && DataManager.selectedCarrierName != nil {
            let rateCarrier = ["fedex","ups","dhl","usps"]
            if !rateCarrier.contains(DataManager.selectedCarrierName!) {
                self.stackViewForWLHW.isHidden = true
                self.selectServiceView.isHidden = true
                self.labErrorMessae.isHidden = true
                constantTopView.constant = UIScreen.main.bounds.height - 333 + CGFloat(height)
            }
        }
        
    }
    
    //MARK: -- Action Method for shipping
    @IBAction func btnShippingCancelAction(_ sender: Any) {
        delegate?.hideShippingCard?()
        tfSelectService.text = "Select Service"
        tfWeight.resignFirstResponder()
        tfWidth.resignFirstResponder()
        tfLength.resignFirstResponder()
        tfHeight.resignFirstResponder()
    }
    
    
    @IBAction func btnShippingDoneAction(_ sender: Any) {
        print( DataManager.selectedShippingRate ?? "")
        if selectServiceView.isHidden == true {
            delegate?.hideShippingCard?()
            return
        }
        if tempModel.str_address != "" && tempModel.str_city != ""  && tempModel.str_region != "" && tempModel.str_postal_code != "" && tempModel.country != "" {
            if tfLength.text == "" ||  tfWidth.text == "" ||  tfHeight.text == "" ||  tfWeight.text == "" {
//                self.showAlert(message: "Please fill dimensions")
                appDelegate.showToast(message: "Please fill dimensions")
            }else{
                if tfSelectService.text == "Select Service" || tfSelectService.text == "" {
                    labErrorMessae.isHidden = false
                    labErrorMessae.text = "Please select valid service"
                }else{
                    if tfSelectCarrier.text != "Select Carrier" {
                        if DataManager.shippingWeight > 0  && DataManager.shippingWidth > 0 && DataManager.shippingHeight > 0 && DataManager.shippingLength > 0 {
                            delegate?.doneShippingCard?(rate:  DataManager.selectedShippingRate ?? "")
                            delegate?.hideShippingCardFromDoneBtn?()
                            tfWeight.resignFirstResponder()
                            tfWidth.resignFirstResponder()
                            tfLength.resignFirstResponder()
                            tfHeight.resignFirstResponder()
                        }else {
                            DataManager.selectedService = ""
                            DataManager.selectedServiceName = ""
                            DataManager.selectedServiceId = ""
                            tfSelectService.text = "Select Service"
                            array_ShippingServiceList.removeAll()
                        }
                    }
                }
                
            }
            
        } else if tfLength.text == "" ||  tfWidth.text == "" ||  tfHeight.text == "" ||  tfWeight.text == "" {
//            self.showAlert(message: "Please fill dimensions")
            appDelegate.showToast(message: "Please fill dimensions")
        } else {
            // delegate?.hideShippingCard?()
        }
    }
    
    @objc func handleSelectCarrierTextField(sender: UITextField) {
        ischeckCarrier = true
        self.pickerDelegate = self
        showCarrier.removeAll()
        for ob in self.array_ShippingCarrierList{
            let aa = ob
            showCarrier.append(aa.carrier_display_name)
        }
        self.setPickerView(textField: sender, array: showCarrier)
    }
    
    @objc func handleSelectServiceTextField(sender: UITextField) {
        ischeckCarrier = false
        self.pickerDelegate = self
        showService.removeAll()
        
        for ob in self.array_ShippingServiceList{
            let aa = ob
            showService.append(aa.desc + "($\(aa.rate))")
        }
        self.setPickerView(textField: sender, array: showService)
    }
    @objc func handleWeightTextField(sender: UITextField) {
        
        DataManager.shippingWeight = Double(sender.text ?? "0") ?? 0.0
        if DataManager.shippingWeight == 0 {
            labErrorMessae.isHidden = false
            labErrorMessae.text = "Please fill dimensions"
        }else {
            labErrorMessae.isHidden = true
        }
    }
    @objc func handleHeightTextField(sender: UITextField) {
        
        DataManager.shippingHeight =  Double(sender.text ?? "0") ?? 0.0
        if DataManager.shippingHeight == 0 {
            labErrorMessae.isHidden = false
            labErrorMessae.text = "Please fill dimensions"
        }else {
            labErrorMessae.isHidden = true
        }
    }
    @objc func handleWidthTextField(sender: UITextField) {
        DataManager.shippingWidth = Double(sender.text ?? "0") ?? 0.0
        if DataManager.shippingWidth == 0 {
            labErrorMessae.isHidden = false
            labErrorMessae.text = "Please fill dimensions"
        }else {
            labErrorMessae.isHidden = true
        }
        
    }
    @objc func handleLengthTextField(sender: UITextField) {
        
        DataManager.shippingLength =  Double(sender.text ?? "0") ?? 0.0
        if DataManager.shippingLength == 0 {
            labErrorMessae.isHidden = false
            labErrorMessae.text = "Please fill dimensions"
        }else {
            labErrorMessae.isHidden = true
        }
        
    }
    
    func forTrailingZero(temp: Double) -> String {
        let tempVar = String(format: "%g", temp)
        return tempVar
    }
    
    //MARK: API Method
    func callAPItoGetShippingCarrierList() {
        HomeVM.shared.getShippingCarrierList(responseCallBack: {(success, message, error) in
            if success == 1 {
                self.array_ShippingCarrierList =  HomeVM.shared.shippingCarrierList
                if self.selectServiceView.isHidden {
                    self.constantTopView.constant = UIScreen.main.bounds.height - 333 + CGFloat(self.height) + 30
                    return
                }
                if self.tempModel.str_address != "" && self.tempModel.str_address2 != "" && self.tempModel.str_city != ""  && self.tempModel.str_region != "" && self.tempModel.str_postal_code != "" && self.tempModel.country != "" {
                    if DataManager.selectedService == "" || DataManager.selectedService == nil {
                        self.tfSelectService.text = "Select Service"
                    }else{
                        self.tfSelectService.text = DataManager.selectedService
                    }
                    
                    self.array_ShippingServiceList.removeAll()
                    if self.tfLength.text == "" ||  self.tfWidth.text == "" ||  self.tfHeight.text == "" ||  self.tfWeight.text == "" {
//                        self.showAlert(message: "Please fill dimensions")
                        appDelegate.showToast(message: "Please fill dimensions")
                    }else {
                        if DataManager.selectedCarrier != "" &&  DataManager.selectedCarrier != nil  {
                            self.callApi()
                        }
                    }
                }
            }else {
                if message != nil {
//                    self.showAlert(message: message!)
                    if message == "Something went wrong." {
                        
                    } else {
                        appDelegate.showToast(message: message!)
                    }
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
    
    func callAPItoSendShippingService(parameters: JSONDictionary) {
        
        HomeVM.shared.sendShippingService(parameters: parameters) { (success, message, error) in
            if success == 1 {
                self.array_ShippingServiceList = HomeVM.shared.shippingServiceList
            }else {
                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    
    func callApi(){
       // labErrorMessae.isHidden = true
        let parameters: Parameters = [
            "carrier": DataManager.selectedCarrierName ?? "",
            "length": DataManager.shippingLength,
            "width": DataManager.shippingWidth,
            "height": DataManager.shippingHeight,
            "weight": DataManager.shippingWeight,
            "shipping_address": [
                "address_line_1": tempModel.str_address,
                "address_line_2": tempModel.str_address2,
                "city": tempModel.str_city,
                "region": tempModel.str_region,
                "postal_code": tempModel.str_postal_code,
                "country": tempModel.country
            ]
        ]
        if DataManager.shippingWeight > 0  && DataManager.shippingWidth > 0 && DataManager.shippingHeight > 0 && DataManager.shippingLength > 0 {
            self.callAPItoSendShippingService(parameters: parameters)
        }else {
            DataManager.selectedService = ""
            DataManager.selectedServiceName = ""
            DataManager.selectedServiceId = ""
            tfSelectService.text = "Select Service"
            array_ShippingServiceList.removeAll()
        }
        
    }
}


//MARK: HieCORPickerDelegate
extension ShippingIphoneVC: HieCORPickerDelegate {
    func checkRateCarrier(index: Int) -> Bool{
        let rateCarrier = ["fedex","ups","dhl","usps"]
        if rateCarrier.contains(array_ShippingCarrierList[pickerView.selectedRow(inComponent: 0)].carrier_name) {
            return true
        }
        return false
    }
    func didClickOnPickerViewDoneButton() {
        if ischeckCarrier {
            if array_ShippingCarrierList.count > 0 {
            let ob = array_ShippingCarrierList[pickerView.selectedRow(inComponent: 0)].carrier_display_name
            DataManager.selectedFullfillmentId = array_ShippingCarrierList[pickerView.selectedRow(inComponent: 0)].fullfillment_id
            DataManager.selectedCarrier = ob
            DataManager.selectedCarrierName = array_ShippingCarrierList[pickerView.selectedRow(inComponent: 0)].carrier_name
            tfSelectCarrier.text = ob
            
                if !checkRateCarrier(index: pickerView.selectedRow(inComponent: 0)) {
                   
                    stackViewForWLHW.isHidden = true
                    selectServiceView.isHidden = true
                    labErrorMessae.isHidden = true
                    constantTopView.constant = UIScreen.main.bounds.height - 333 + CGFloat(height) + 30
                }else {
                    stackViewForWLHW.isHidden = false
                    selectServiceView.isHidden = false
                    constantTopView.constant = UIScreen.main.bounds.height - 333
                    if  DataManager.selectedCarrier != "" {
                        labErrorMessae.isHidden = true
                        if tfSelectService.text == "Select Service" || tfSelectService.text == "" {
                            labErrorMessae.isHidden = false
                            labErrorMessae.text = "Please select valid service"
                        }
                        
                    }

            if tempModel.str_address != "" && tempModel.str_city != ""  && tempModel.str_region != "" && tempModel.str_postal_code != "" && tempModel.country != "" {
                tfSelectService.text = "Select Service"
                DataManager.selectedService = ""
                DataManager.selectedServiceName = ""
                DataManager.selectedServiceId = ""
                array_ShippingServiceList.removeAll()
                if  DataManager.selectedCarrier != "" {
                    labErrorMessae.isHidden = true
                    if tfSelectService.text == "Select Service" || tfSelectService.text == "" {
                        labErrorMessae.isHidden = false
                        labErrorMessae.text = "Please select valid service"
                    }
                    
                }
                
                if tfLength.text == "" ||  tfWidth.text == "" ||  tfHeight.text == "" ||  tfWeight.text == "" {
//                    self.showAlert(message: "Please fill dimensions")
                    appDelegate.showToast(message: "Please fill dimensions")
                }else {
                    callApi()
                }
                
                
            }else {
                labErrorMessae.isHidden = false
                labErrorMessae.text = "Please enter customer address to calculate a shipping rate."
                DataManager.selectedService = ""
                DataManager.selectedServiceName = ""
                DataManager.selectedServiceId = ""
                tfSelectService.text = "Select Service"
                array_ShippingServiceList.removeAll()
            }
            
        }
    }
        }else{
            if array_ShippingServiceList.count > 0 {
                let obDes = array_ShippingServiceList[pickerView.selectedRow(inComponent: 0)].desc
                obRate = array_ShippingServiceList[pickerView.selectedRow(inComponent: 0)].rate
                DataManager.selectedShippingRate = obRate
                let ShippingServiceName = obDes + "($\(obRate))"
                DataManager.selectedService = ShippingServiceName
                DataManager.selectedServiceName = array_ShippingServiceList[pickerView.selectedRow(inComponent: 0)].service
                DataManager.selectedServiceId = array_ShippingServiceList[pickerView.selectedRow(inComponent: 0)].service_id
                pickerTextfield.text = "\(String(describing: DataManager.selectedService!))"
                labErrorMessae.isHidden = true
                constantTopView.constant = UIScreen.main.bounds.height - 333 + 30
            }
        
        }
        
        print("done")
    }
    func didClickOnPickerViewCancelButton() {
        if ischeckCarrier {
            tfSelectCarrier.text = (DataManager.selectedCarrier == "" ? "Select Carrier" : DataManager.selectedCarrier)
        }
        
    }
    func didSelectPickerViewAtIndex(index: Int) {
        if ischeckCarrier {
            if !checkRateCarrier(index: index) {
                labErrorMessae.isHidden = true
                return
            }
            
        }
        
    }
}

extension ShippingIphoneVC: EditProductDelegate {
    func didShowShippingAddress(data: CustomerListModel){
        tfLength.text = forTrailingZero(temp: shipLength)
        tfWidth.text = forTrailingZero(temp: shipWidth)
        tfHeight.text = forTrailingZero(temp: shipHeight)
        tfWeight.text = forTrailingZero(temp: shipWeight)
        tempModel = data
        callAPItoGetShippingCarrierList()
        if DataManager.selectedCarrier == "" || DataManager.selectedCarrier == nil {
            tfSelectCarrier.text = "Select Carrier"
            self.stackViewForWLHW.isHidden = false
            self.selectServiceView.isHidden = false
            self.labErrorMessae.isHidden = false
          //  constantTopView.constant = UIScreen.main.bounds.height - 333 + CGFloat(height)
        }else{
            tfSelectCarrier.text = DataManager.selectedCarrier
            labErrorMessae.isHidden = true
        }
        if tempModel.str_address != "" && tempModel.str_city != ""  && tempModel.str_region != "" && tempModel.str_postal_code != "" && tempModel.country != "" {
            
            if DataManager.selectedCarrier == "" || DataManager.selectedCarrier == nil {
                labErrorMessae.isHidden = false
                labErrorMessae.text = "Please select carrier"
            }else {
                if selectServiceView.isHidden {
                    return
                }
                if DataManager.selectedService == "" || DataManager.selectedService == nil{
                    tfSelectService.text = "Select Service"
                    labErrorMessae.isHidden = false
                    labErrorMessae.text = "Please select valid service"
                } else {
                    labErrorMessae.isHidden = true
                    tfSelectService.text = DataManager.selectedService
                    constantTopView.constant = UIScreen.main.bounds.height - 333 + 30
                }
                if tfLength.text == "" ||  tfWidth.text == "" ||  tfHeight.text == "" ||  tfWeight.text == "" {
//                    self.showAlert(message: "Please fill dimensions")
                    appDelegate.showToast(message: "Please fill dimensions")
                }else if DataManager.selectedCarrier != "" {
                  //  callApi()
                }
                //callApi()
            }
            
        }else {
            if selectServiceView.isHidden {
                labErrorMessae.isHidden = true
            }else{
                labErrorMessae.isHidden = false
            }
            labErrorMessae.text = "Please enter customer address to calculate a shipping rate."
            DataManager.selectedService = ""
            DataManager.selectedServiceName = ""
            DataManager.selectedServiceId = ""
            tfSelectService.text = "Select Service"
            array_ShippingServiceList.removeAll()
        }
    }
    func getCartProductsArray(data: Array<Any>){
        if data.count > 0 {
            
            shipWeight = DataManager.shippingWeight
            shipLength = DataManager.shippingLength
            shipHeight = DataManager.shippingHeight
            shipWidth = DataManager.shippingWidth
            
            cartList = data
            if DataManager.cartShippingProductsArray == nil {
                duplicateArrayList = []
            }else{
                duplicateArrayList = DataManager.cartShippingProductsArray!
            }
            
            
            if shipWeight != 0 {
                
                for i in 0..<cartList.count {
                    
                    if let strCount = (cartList[i] as! NSDictionary).value(forKey: "width") {
                        let Width = (cartList[i] as! NSDictionary).value(forKey: "width") as! Double
                        let height = (cartList[i] as! NSDictionary).value(forKey: "height") as! Double
                        let length = (cartList[i] as! NSDictionary).value(forKey: "length") as! Double
                        let weight = (cartList[i] as! NSDictionary).value(forKey: "weight") as! Double
                        let productQtyD = Double((cartList[i] as! NSDictionary).value(forKey: "productqty") as! String) ?? 0.0
                        
                        oldListCount = duplicateArrayList.count
                        
                        for j in 0..<duplicateArrayList.count{
                            
                            if (duplicateArrayList[j] as! NSDictionary).value(forKey: "productid") as! String == (cartList[i] as! NSDictionary).value(forKey: "productid") as! String {
                                if ((cartList[i] as! NSDictionary).value(forKey: "productqty") as! String) != "" {
                                    if Double((duplicateArrayList[j] as! NSDictionary).value(forKey: "productqty") as! String) ?? 0.0 < productQtyD {
                                        newQty = productQtyD - (Double((duplicateArrayList[j] as! NSDictionary).value(forKey: "productqty") as! String) ?? 0.0)
                                        shipWeight = shipWeight + (weight * newQty)
                                    }
                                }
                            }else{
                                oldListCount = oldListCount - 1
                                if oldListCount == 0 {
                                    if ((cartList[i] as! NSDictionary).value(forKey: "productqty") as! String) != "" {
                                        shipWeight = shipWeight + (weight * productQtyD )
                                    }else {
                                        shipWeight = shipWeight + weight
                                    }
                                    
                                    if length > shipLength {
                                        shipLength = length
                                    }
                                    
                                    if height > shipHeight {
                                        shipHeight = height
                                    }
                                    
                                    if Width > shipWidth {
                                        shipWidth = Width
                                    }
                                }
                            }
                        }
                    }
                }
            }else {
                for i in 0..<cartList.count {
                    
                    if let strCount = (cartList[i] as! NSDictionary).value(forKey: "width") {
                        let Width = (cartList[i] as! NSDictionary).value(forKey: "width") as! Double
                        let height = (cartList[i] as! NSDictionary).value(forKey: "height") as! Double
                        let length = (cartList[i] as! NSDictionary).value(forKey: "length") as! Double
                        let weight = (cartList[i] as! NSDictionary).value(forKey: "weight") as! Double
                        let productQtyy = Double((cartList[i] as! NSDictionary).value(forKey: "productqty") as! String) ?? 0.0
                        if ((cartList[i] as! NSDictionary).value(forKey: "productqty") as! String) != "" {
                            shipWeight = shipWeight + (weight * productQtyy )
                        }else {
                            shipWeight = shipWeight + weight
                        }
                        
                        //when add new product only compare this dimention
                        if length > shipLength {
                            shipLength = length
                        }
                        
                        if height > shipHeight {
                            shipHeight = height
                        }
                        
                        if Width > shipWidth {
                            shipWidth = Width
                        }
                    }
                }
            }
            duplicateArrayList = cartList
            DataManager.cartShippingProductsArray = duplicateArrayList
            DataManager.shippingLength = shipLength
            DataManager.shippingWidth = shipWidth
            DataManager.shippingHeight = shipHeight
            DataManager.shippingWeight = shipWeight
            if shipWidth == 0 || shipHeight == 0 || shipWeight == 0 || shipLength == 0 {
                labErrorMessae.isHidden = false
                labErrorMessae.text = "Please fill dimensions"
                if DataManager.selectedCarrier != "" {
                    labErrorMessae.isHidden = true
                }
            }
            tfLength.text = forTrailingZero(temp: shipLength)
            tfWidth.text = forTrailingZero(temp: shipWidth)
            tfHeight.text = forTrailingZero(temp: shipHeight)
            tfWeight.text = forTrailingZero(temp: shipWeight)
        }
    }
}
//MARK: UITextFieldDelegate
extension ShippingIphoneVC : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == tfWeight || textField == tfWidth || textField == tfLength || textField == tfHeight {
            textField.selectAll(nil)
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tfWeight || textField == tfWidth || textField == tfLength || textField == tfHeight {
            if tempModel.str_address != "" && tempModel.str_city != ""  && tempModel.str_region != "" && tempModel.str_postal_code != "" && tempModel.country != "" {
                tfSelectService.text = "Select Service"
                DataManager.selectedService = ""
                DataManager.selectedServiceName = ""
                DataManager.selectedServiceId = ""
                array_ShippingServiceList.removeAll()
                if  DataManager.selectedCarrier != "" {
                    labErrorMessae.isHidden = true
                    if tfSelectService.text == "Select Service" || tfSelectService.text == "" {
                        labErrorMessae.isHidden = false
                        labErrorMessae.text = "Please select valid service"
                    }
                    
                }
                callApi()
            }else {
                labErrorMessae.isHidden = false
                labErrorMessae.text = "Please enter customer address to calculate a shipping rate."
                DataManager.selectedService = ""
                DataManager.selectedServiceName = ""
                DataManager.selectedServiceId = ""
                tfSelectService.text = "Select Service"
                array_ShippingServiceList.removeAll()
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var replacementText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        if string == " " {
            return false
        }
        
        if string == "\t" {
            return false
        }
        
        replacementText = replacementText.replacingOccurrences(of: "$", with: "")
        return replacementText.isValidDecimal(maximumFractionDigits: 2)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfWeight.resignFirstResponder()
        tfWidth.resignFirstResponder()
        tfLength.resignFirstResponder()
        tfHeight.resignFirstResponder()
        return true
    }
}

