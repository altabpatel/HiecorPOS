//
//  iPadTableViewCell.swift
//  HieCOR
//
//  Created by Deftsoft on 26/07/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class iPadTableViewCell: UITableViewCell {
    
    //MARK: IBOutlet
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textFieldVIew: UIView!
    @IBOutlet weak var textTypeTextView: UITextView!
    @IBOutlet weak var txtDatePicker: UITextField!
    @IBOutlet weak var txtDatePickerView: UIView!
    
    var textData = UITextField()
    var indexSurchargeText = 999
    
    //Uidate picker
    let datePicker = UIDatePicker()
    
    //MARK: Variables
    var arrayAttributes = [AttributesModel]()
    var arrayAttrData = [AttributeValues]()
    var arraysurchargeData = [SurchageModel]()
    var arrProductDetailsSurcharge = [ProductSurchageVariationDetail]()
    var arrayNewAttributes: AttributesModel?
    var delegate: iPadTableViewCellDelegate?
    var arrayAttributeValue: JSONArray?
    var arraySurchageModel = JSONArray()
    var cartProductsArray = Array<Any>()
    var arraySurchageVariation = JSONArray()
    var prizeValue : Double = 0.0
    var strName = ""
    var stockDictValue = JSONDictionary()
    var checkSingleVariation_attribute = Bool()
    
    //MARK: Class Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
   
    }
    
    func showDatePickerCustomeText1(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePickerCustomText1));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePickerCustomText1));
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        
        txtDatePicker.inputAccessoryView = toolbar
        txtDatePicker.inputView = datePicker
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
    }
    
    @objc func donedatePickerCustomText1(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        txtDatePicker.text = formatter.string(from: datePicker.date)
        contentView.endEditing(true)
    }
    
    @objc func cancelDatePickerCustomText1(){
        contentView.endEditing(true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    func getdataSurchargevariation(surchargevalue: [String], arraySurchage: JSONArray) {
        arraySurchageVariation = arraySurchage
        
        print(arraySurchageVariation)
    }
    
    func showPopUpTextFiled() {
        let alert = UIAlertController(title: "Surcharge Amount", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            //self.shippingTextField = textField
            //textField.delegate = self
            textField.keyboardType = .decimalPad
            textField.tag = 2000
            textField.placeholder = "Please enter Amount ($)"
            //textField.setDollar(color: UIColor.darkGray, font: textField.font!)
            let indexPathVal = IndexPath(item: self.indexSurchargeText, section: 0)
            
            if let cell = self.collectionView.cellForItem(at: indexPathVal) as? iPadCollectionViewCell {
                textField.text = cell.txfSurchargeAmount.text
                //textField.becomeFirstResponder()
                //textField.selectAll(nil)
            }
            //self.str_ShippingANdHandling = self.str_ShippingANdHandling.replacingOccurrences(of: ".00", with: "")
            //self.str_ShippingANdHandling = self.str_ShippingANdHandling.replacingOccurrences(of: ".0", with: "")
            //textField.text = self.str_ShippingANdHandling == "0.0" ? "" : self.str_ShippingANdHandling
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                textField.becomeFirstResponder()
                textField.selectAll(nil)
            }
            
        }
        alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            //self.handleShippingAndHandling(textField: textField)
            
            let indexPathVal = IndexPath(item: self.indexSurchargeText, section: 0)
            
            if let cell = self.collectionView.cellForItem(at: indexPathVal) as? iPadCollectionViewCell {
                //if textField == cell.txfSurchargeAmount{
                    let text = Double((textField.text ?? "").replacingOccurrences(of: "$", with: "")) ?? 0.0
                    textField.text = "$\(text.roundToTwoDecimal)"
                    
                    let arrayData  = self.arrayAttributes as NSArray
                    let attributeModel = arrayData[0] as! AttributesModel
                    var dictAttributevalue = self.arrayAttrData[self.indexSurchargeText]
                    var surcharge = self.arraySurchageVariation[self.indexSurchargeText]
                    print(dictAttributevalue)
                    print(surcharge)
                    
                    let arrSurchargevalue = self.arraySurchageVariation
                    
                    
                    self.arrProductDetailsSurcharge.removeAll()
                    self.arrProductDetailsSurcharge = AttributeSubCategory.shared.getProductDetailSurchargeVariationStructNewData(jsonArray: self.arraySurchageModel, price: text.roundToTwoDecimal, attId: dictAttributevalue.attribute_value_id)
    //                arraySurchageVariation =
                                    
                    
                    for valdata in self.arrayAttrData {
                        
                        for i in 0..<self.arraySurchageVariation.count {
                            
                            let valId = self.arraySurchageVariation[i]["attributevalueId"] as! String
                            
                            if valId == self.arrayAttrData[self.indexSurchargeText].attribute_value_id {
                                let prize = self.arraySurchageVariation[i]["surchargePrize"] as? String ?? "0"
                                if Double(prize) ?? 0.0 > 0.0 {
                                    
                                    self.arraySurchageVariation[i].updateValue("\(text.roundToTwoDecimal)", forKey: "surchargePrizeClone")
                                } else {
                                    self.arraySurchageVariation[i].updateValue("\(text.roundToTwoDecimal)", forKey: "surchargePrizeClone")
                                    //cell.namelabel.text = "\(valOne["attributeName"] as! String)"
                                }
                            }
                        }
                    }
                    
    //
    //                let arrSurchargevalue = arraySurchageVariation[indexSurchargeText]
    //                arraySurchageVariation.remove(at: indexSurchargeText)
    //                arraySurchageVariation.insert(arrSurchargevalue, at: indexSurchargeText)
                    //arraySurchageVariation = arrSurchargevalue
                   
                    print(self.arraySurchageVariation[self.indexSurchargeText])
                    
                    self.delegate?.didUpdateSurchargeAttribute(indexPath: IndexPath(row: self.indexSurchargeText, section: self.collectionView.tag), attributes: self.arrayAttributes, isRadio: attributeModel.attribute_type, isSelect: dictAttributevalue.isSelect, price: text, isSurchargeValueChange: true, arraySuchargevariationData: self.arraySurchageVariation, arrSurchargeModel: self.arrProductDetailsSurcharge)
                    
                    self.delegate?.didUpdateAttribute(indexPath: IndexPath(row: self.indexSurchargeText, section: self.collectionView.tag), attributes: self.arrayAttributes, isRadio: attributeModel.attribute_type, isSelect: dictAttributevalue.isSelect, price: text)
                    
                //}
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            //self.catAndProductDelegate?.hideView?(with: "alertblurcancel")
        }))
        //self.catAndProductDelegate?.hideView?(with: "alertblur")
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)


        //self.present(alert, animated: true, completion: self)
    }
    
    @objc func actionUpdate(_ sender: UIButton) {
        
        indexSurchargeText = sender.tag
        
        let indexPathVal = IndexPath(item: indexSurchargeText, section: 0)
        
        if let cell = collectionView.cellForItem(at: indexPathVal) as? iPadCollectionViewCell {
            if cell.btnVariationPrice == sender {
                showPopUpTextFiled()
            }
        }
    }
}

//MARK: UICollectionViewDataSource & UICollectionViewDelegate
extension iPadTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayAttrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iPadCollectionViewCell", for: indexPath) as! iPadCollectionViewCell
        cell.clickButton.tag = indexPath.row
        cell.clickButton.addTarget(self, action: #selector(self.selectProductItem), for: .touchUpInside)
        cell.txfSurchargeAmount.delegate = self
        textData =  cell.txfSurchargeAmount
        let dictAttributevalue = arrayAttrData[indexPath.row]
        
        print(dictAttributevalue.attribute_value)
        
        // cell.namelabel.text = dictAttributevalue.attribute_value
        if checkSingleVariation_attribute {
            var stockQty = "0"
            for (key, value) in stockDictValue {
                if key == dictAttributevalue.attribute_value_id {
                    stockQty = "\(value)"
                }
            }
            let temprange = " (Qty: \(stockQty))"
            let text = NSMutableAttributedString()
            text.append(NSAttributedString(string: dictAttributevalue.attribute_value, attributes: [NSAttributedString.Key.foregroundColor: dictAttributevalue.isSelect ? .white : #colorLiteral(red: 0.3136949539, green: 0.3137450218, blue: 0.3136840463, alpha: 1)]));
            if temprange.contains("-") {
                text.append(NSAttributedString(string: temprange, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]))
            }else{
                text.append(NSAttributedString(string: temprange, attributes: [NSAttributedString.Key.foregroundColor: dictAttributevalue.isSelect ? .white : #colorLiteral(red: 0.3136949539, green: 0.3137450218, blue: 0.3136840463, alpha: 1)]))
            }
            
            cell.namelabel.attributedText = text
        }else{
            cell.namelabel.text = dictAttributevalue.attribute_value
            cell.namelabel.textColor = dictAttributevalue.isSelect ? UIColor.white : #colorLiteral(red: 0.3136949539, green: 0.3137450218, blue: 0.3136840463, alpha: 1)
        }
        
        let arrayData  = arrayAttributes as NSArray
        let attributeModel = arrayData[0] as! AttributesModel

        cell.backView.borderColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
        cell.backView.backgroundColor = dictAttributevalue.isSelect ? UIColor.HieCORColor.blue.colorWith(alpha: 1.0) : UIColor.white
     //   cell.namelabel.textColor = dictAttributevalue.isSelect ? UIColor.white : #colorLiteral(red: 0.3136949539, green: 0.3137450218, blue: 0.3136840463, alpha: 1)

        cell.txfSurchargeAmount.tag = indexPath.row
        cell.txfSurchargeAmount.addTarget(self, action: #selector(self.selectSurchargeTextField), for: .editingDidBegin)
        
        cell.btnVariationPrice.tag = indexPath.row
        cell.btnVariationPrice.addTarget(self, action: #selector(self.actionUpdate), for: .touchUpInside)
        cell.txfSurchargeAmount.isHidden = true
        cell.btnVariationPrice.isHidden = true
        if attributeModel.attribute_type == "radio" {
            cell.checkButton.setImage(dictAttributevalue.isSelect ? UIImage(named: "checkCircle") : UIImage(named: "unCheckCircle"), for: .normal)
            cell.txfSurchargeAmount.isHidden = true
        } else {
            
            for valOne in arraySurchageVariation {
                
                let valId = valOne["attributevalueId"] as! String
                
                if valId == dictAttributevalue.attribute_value_id {
                    let prize = valOne["surchargePrize"] as? String ?? "0"
                    if Double(prize) ?? 0.0 > 0.0 {
                        cell.namelabel.text = "\(valOne["attributeName"] as! String) $\(valOne["surchargePrize"] as! String)"
                        cell.txfSurchargeAmount.text = "$\(valOne["surchargePrizeClone"] as? String ?? "0")"
                    } else {
                        cell.namelabel.text = "\(valOne["attributeName"] as! String)"
                        cell.txfSurchargeAmount.text = "$\(valOne["surchargePrizeClone"] as? String ?? "0")"
                    }
                }
                if valId == dictAttributevalue.attribute_value_id {
                if dictAttributevalue.isSelect {
                    if (valOne["showAdditinalPriceInput"] as? Bool ?? false) == true {
                        print("dsadsadsa")
                        cell.txfSurchargeAmount.isHidden = false
                        cell.btnVariationPrice.isHidden = false
                    } else {
                        print("dsadddddddddsadsa")
                        cell.txfSurchargeAmount.isHidden = true
                        cell.btnVariationPrice.isHidden = true
                    }
                } else {
                    cell.txfSurchargeAmount.isHidden = true
                    cell.btnVariationPrice.isHidden = true
                }
                }
            }
            cell.checkButton.setImage(dictAttributevalue.isSelect ? UIImage(named: "checkSquare") : UIImage(named: "unCheckSquare"), for: .normal)
        }
        
        //collectionView.layoutIfNeeded()
        //collectionView.setNeedsLayout()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        //collectionView.layoutIfNeeded()
        //collectionView.setNeedsLayout()
        var isselect = false
        let dictAttributevalue = arrayAttrData[indexPath.row]
        
        let arrayData  = arrayAttributes as NSArray
        let attributeModel = arrayData[0] as! AttributesModel
        
        print(dictAttributevalue)
        
        var name = dictAttributevalue.attribute_value ?? ""
        
        for valOne in arraySurchageVariation {
            
            let valId = valOne["attributevalueId"] as! String
            
            if valId == dictAttributevalue.attribute_value_id {
                name = "\(valOne["attributeName"] as! String) (+$\(valOne["surchargePrize"] as! String))"
            }
            isselect = dictAttributevalue.isSelect
        }
        if checkSingleVariation_attribute {
            var stockQty = "0"
            for (key, value) in stockDictValue {
                if key == dictAttributevalue.attribute_value_id {
                    stockQty = "\(value)"
                }
            }
            
            name = name + " " + "(Qty: \(stockQty))"
        }
        
        var newSizer = name.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0)])
        if UI_USER_INTERFACE_IDIOM() == .phone {
            newSizer.width = collectionView.frame.width - 10
            newSizer.width += 20
        }else{
            newSizer.width += 80
        }
       
        newSizer.height = (UI_USER_INTERFACE_IDIOM() == .pad ? 60 : 50)
        if attributeModel.attribute_type == "radio" {
            newSizer.height = (UI_USER_INTERFACE_IDIOM() == .pad ? 60 : 60)
        } else {
            for valOne in arraySurchageVariation {
                let valId = valOne["attributevalueId"] as! String
                if valId == dictAttributevalue.attribute_value_id {
                    if dictAttributevalue.isSelect {
                        if (valOne["showAdditinalPriceInput"] as? Bool ?? false) == true {
                            newSizer.height = (UI_USER_INTERFACE_IDIOM() == .pad ? 90 : 90)
                        } else {
                            newSizer.height = (UI_USER_INTERFACE_IDIOM() == .pad ? 60 : 60)
                        }
                    } else {
                        newSizer.height = (UI_USER_INTERFACE_IDIOM() == .pad ? 60 : 60)
                    }
                } else {
                    //newSizer.height = (UI_USER_INTERFACE_IDIOM() == .pad ? 60 : 50)
                }
            }
        }
        return newSizer
    }
    
    @objc func selectProductItem(_ sender: UIButton) {
        ////
        
        let indexPath = IndexPath(item: sender.tag, section: 0)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iPadCollectionViewCell", for: indexPath) as! iPadCollectionViewCell
        cell.txfSurchargeAmount.becomeFirstResponder()
        
        let dict = arrayAttrData[sender.tag]
        
        print(dict)
        
        var name = dict.attribute_value ?? ""
        print(name)
        
        var prizeVal = 0.0
        
        for valOne in arraySurchageVariation {
            
            let valId = valOne["attributevalueId"] as! String
            
            if valId == dict.attribute_value_id {
                name = "\(valOne["attributeName"] as! String) (+$\(valOne["surchargePrize"] as! String))"
                
                prizeVal = Double(valOne["surchargePrize"] as! String)!
            }
        }
        
        print(name)
        print(prizeValue)
        
        prizeValue =  prizeValue + prizeVal
        print(prizeValue)
        
        /////
        let arrayData  = arrayAttributes as NSArray
        let attributeModel = arrayData[0] as! AttributesModel
        var dictAttributevalue = arrayAttrData[sender.tag]
 
        if dictAttributevalue.isSelect == true, attributeModel.attribute_type != "radio" {
            dictAttributevalue.isSelect = false
        } else {
            dictAttributevalue.isSelect = true
        }
        
        arrProductDetailsSurcharge.removeAll()
        arrProductDetailsSurcharge = AttributeSubCategory.shared.getProductDetailSurchargeVariationStructNewData(jsonArray: arraySurchageModel, price: "\(prizeVal)", attId: dictAttributevalue.attribute_value_id)
        
        for valdata in arrayAttrData {
            
            for i in 0..<arraySurchageVariation.count {
                
                let valId = arraySurchageVariation[i]["attributevalueId"] as! String
                
                if valId == arrayAttrData[sender.tag].attribute_value_id {
                    let prize = arraySurchageVariation[i]["surchargePrize"] as? String ?? "0"
                    if Double(prize) ?? 0.0 > 0.0 {
                        
                        arraySurchageVariation[i].updateValue("\(prizeVal.roundToTwoDecimal)", forKey: "surchargePrizeClone")
                    } else {
                        //cell.namelabel.text = "\(valOne["attributeName"] as! String)"
                    }
                }
            }
        }
        
        arrayAttrData.removeAll()
        arrayAttrData = AttributeSubCategory.shared.getUpdateAttribute(with: arrayAttributeValue!, isSelected: dictAttributevalue.isSelect, index: sender.tag, type: attributeModel.attribute_type, attributeId: attributeModel.attribute_id)
        
        let jso = AttributeSubCategory.shared.attributevalueConvertJSon(with: arrayAttrData, attributeId: attributeModel.attribute_id)
        
        print(jso)
        
        arrayAttributes[0].jsonArray = jso
        
        self.delegate?.didUpdateSurchargeAttribute(indexPath: IndexPath(row: indexSurchargeText, section: self.collectionView.tag), attributes: arrayAttributes, isRadio: attributeModel.attribute_type, isSelect: dictAttributevalue.isSelect, price: prizeVal, isSurchargeValueChange: true, arraySuchargevariationData: arraySurchageVariation, arrSurchargeModel: arrProductDetailsSurcharge)


        self.delegate?.didUpdateAttribute(indexPath: IndexPath(row: sender.tag, section: self.collectionView.tag), attributes: arrayAttributes, isRadio: attributeModel.attribute_type, isSelect: dictAttributevalue.isSelect, price: prizeVal)
    }
    
    @objc func selectSurchargeTextField(_ sender: UIButton) {
        print(sender.tag)
        
        indexSurchargeText = sender.tag
    }
}

//MARK: TextFieldDelegate
extension iPadTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //
//        if Keyboard._isExternalKeyboardAttached() {
//            IQKeyboardManager.shared.enable = true
//            IQKeyboardManager.shared.enableAutoToolbar = true
//        }
                
        let indexPathVal = IndexPath(item: indexSurchargeText, section: 0)
        
        if let cell = collectionView.cellForItem(at: indexPathVal) as? iPadCollectionViewCell {
            if textField == cell.txfSurchargeAmount{
                textField.selectAll(nil)
                showPopUpTextFiled()
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let indexPathVal = IndexPath(item: indexSurchargeText, section: 0)
        
        if let cell = collectionView.cellForItem(at: indexPathVal) as? iPadCollectionViewCell {
            if textField == cell.txfSurchargeAmount{
                let text = Double((textField.text ?? "").replacingOccurrences(of: "$", with: "")) ?? 0.0
                textField.text = "$\(text.roundToTwoDecimal)"
                
                let arrayData  = arrayAttributes as NSArray
                let attributeModel = arrayData[0] as! AttributesModel
                var dictAttributevalue = arrayAttrData[indexSurchargeText]
                var surcharge = arraySurchageVariation[indexSurchargeText]
                print(dictAttributevalue)
                print(surcharge)
                
                let arrSurchargevalue = arraySurchageVariation
                
                
                arrProductDetailsSurcharge.removeAll()
                arrProductDetailsSurcharge = AttributeSubCategory.shared.getProductDetailSurchargeVariationStructNewData(jsonArray: arraySurchageModel, price: text.roundToTwoDecimal, attId: dictAttributevalue.attribute_value_id)
//                arraySurchageVariation =
                                
                
                for valdata in arrayAttrData {
                    
                    for i in 0..<arraySurchageVariation.count {
                        
                        let valId = arraySurchageVariation[i]["attributevalueId"] as! String
                        
                        if valId == arrayAttrData[indexSurchargeText].attribute_value_id {
                            let prize = arraySurchageVariation[i]["surchargePrize"] as? String ?? "0"
                            if Double(prize) ?? 0.0 > 0.0 {
                                
                                arraySurchageVariation[i].updateValue("\(text.roundToTwoDecimal)", forKey: "surchargePrizeClone")
                            } else {
                                arraySurchageVariation[i].updateValue("\(text.roundToTwoDecimal)", forKey: "surchargePrizeClone")
                                //cell.namelabel.text = "\(valOne["attributeName"] as! String)"
                            }
                        }
                    }
                }
                
//
//                let arrSurchargevalue = arraySurchageVariation[indexSurchargeText]
//                arraySurchageVariation.remove(at: indexSurchargeText)
//                arraySurchageVariation.insert(arrSurchargevalue, at: indexSurchargeText)
                //arraySurchageVariation = arrSurchargevalue
               
                print(arraySurchageVariation[indexSurchargeText])
                
                self.delegate?.didUpdateSurchargeAttribute(indexPath: IndexPath(row: indexSurchargeText, section: self.collectionView.tag), attributes: arrayAttributes, isRadio: attributeModel.attribute_type, isSelect: dictAttributevalue.isSelect, price: text, isSurchargeValueChange: true, arraySuchargevariationData: arraySurchageVariation, arrSurchargeModel: arrProductDetailsSurcharge)
                
                self.delegate?.didUpdateAttribute(indexPath: IndexPath(row: indexSurchargeText, section: self.collectionView.tag), attributes: arrayAttributes, isRadio: attributeModel.attribute_type, isSelect: dictAttributevalue.isSelect, price: text)
                
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let indexPathVal = IndexPath(item: indexSurchargeText, section: 0)
        
        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
        var replacementText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        if range.location == 0 && string == " " {
            return false
        }
        
        if string == "\t" {
            return false
        }
        
        if let cell = collectionView.cellForItem(at: indexPathVal) as? iPadCollectionViewCell {
            if textField == cell.txfSurchargeAmount {
                if string == " " {
                    return false
                }
                replacementText = replacementText.replacingOccurrences(of: "$", with: "")
                return replacementText.isValidDecimal(maximumFractionDigits: 2)
            }
        }
        
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {

    }
}

