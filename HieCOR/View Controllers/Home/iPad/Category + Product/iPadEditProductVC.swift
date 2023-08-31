//
//  EditProductVC.swift
//  HieCOR
//
//  Created by Deftsoft on 24/10/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

@objc protocol EditProductDelegate : class {
    @objc optional func didClickOnCrossButton()
    @objc optional func didClickOnDoneButton()
}

class EditProductVC: BaseViewController {
    
    //MARK: Variables
    var delegate: EditProductDelegate?
    var productDict = JSONDictionary()
    var allAttributesArray = Array<Any>()
    var selectedAttributesArray = [JSONDictionary]()
    var selectedProductIndex = Int()
    
    //MARK: IBOutlets
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var manualDescriptionTextField: UITextField!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var discountBackView: UIView!
    @IBOutlet weak var discountView: UIView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var qtyTextField: UITextField!
    @IBOutlet weak var taxExemptButtton: UIButton!
    @IBOutlet weak var taxExemptButttonPortrait: UIButton!
    @IBOutlet weak var defaultDiscountButton: UIButton!
    @IBOutlet weak var tenPerDiscountButton: UIButton!
    @IBOutlet weak var twentyPerDiscountButton: UIButton!
    @IBOutlet weak var seventyPerDiscountButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customtextField: UITextField!
    @IBOutlet weak var discountViewPortrait: UIView!
    @IBOutlet weak var defaultDiscountButtonPortrait: UIButton!
    @IBOutlet weak var tenPerDiscountButtonPortrait: UIButton!
    @IBOutlet weak var twentyPerDiscountButtonPortrait: UIButton!
    @IBOutlet weak var seventyPerDiscountButtonPortrait: UIButton!
    @IBOutlet weak var customtextFieldPortrait: UITextField!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var discountStackBackView: UIView!
    @IBOutlet weak var discountStackBackViewPortrait: UIView!
    @IBOutlet weak var discountViewPortraitHeight: NSLayoutConstraint!
    @IBOutlet var discountStackView: UIStackView!
    @IBOutlet var minusButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet var productImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet var stackHeightConstraint: NSLayoutConstraint!
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextFields()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.customizeUI()
        self.updateUI()
        self.updateButtonUI(tag: 1)
        self.updateButtonTitle()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.view.endEditing(true)
        self.updateUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Private FUnctions
    private func customizeUI() {
        //Set Place Holder Color
        customtextField.setPlaceholder(color: #colorLiteral(red: 1, green: 0.2784860432, blue: 0.9018586278, alpha: 1))
        manualDescriptionTextField.setPlaceholder(color: #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1))
        if UI_USER_INTERFACE_IDIOM() == .pad {
            customtextFieldPortrait.setPlaceholder(color: #colorLiteral(red: 1, green: 0.2784860432, blue: 0.9018586278, alpha: 1))
            self.taxExemptButttonPortrait.isHidden = !DataManager.isLineItemTaxExempt
            //Add Shadow
            self.discountView.layer.shadowColor = UIColor.darkGray.cgColor
            self.discountView.layer.shadowOffset = CGSize.zero
            self.discountView.layer.shadowOpacity = 0.5
            self.discountView.layer.shadowRadius = 3
        }else {
            manualDescriptionTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            manualDescriptionTextField.leftViewMode = .always
        }
        // Set Padding
        priceTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        priceTextField.leftViewMode = .always
        priceTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        priceTextField.rightViewMode = .always
        
        self.taxExemptButtton.isHidden = !DataManager.isLineItemTaxExempt
    }
    
    private func setupTextFields() {
        //Set Delegate To Self
        customtextField.delegate = self
        if UI_USER_INTERFACE_IDIOM() == .pad {
            customtextFieldPortrait.delegate = self
            customtextFieldPortrait.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        manualDescriptionTextField.delegate = self
        customtextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func updateUI() {
        //Hide View
        if UI_USER_INTERFACE_IDIOM() == .pad  {
            self.discountBackView.isHidden = !(UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height)
            self.discountViewPortrait.isHidden = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height
            self.discountStackBackViewPortrait.isHidden = !DataManager.isDiscountOptions
            self.discountViewPortraitHeight.constant = DataManager.isDiscountOptions ? 70 : 40
            self.tableViewTopConstraint.constant = !self.discountViewPortrait.isHidden ? 15 : 0
            self.discountView.layer.shadowColor = DataManager.isDiscountOptions ? UIColor.darkGray.cgColor : UIColor.clear.cgColor
        }else {
            self.discountStackView.axis = UIScreen.main.bounds.width < 385 ? .vertical : .horizontal
            if UIScreen.main.bounds.height < 666  {
                self.minusButtonWidthConstraint.constant = 30.0
                self.productImageWidthConstraint.constant = 65.0
                self.stackHeightConstraint.constant = 25.0
            }
        }
        
        self.discountLabel.isHidden = !DataManager.isDiscountOptions
        self.discountStackBackView.isHidden = !DataManager.isDiscountOptions
        self.discountView.isHidden = !DataManager.isDiscountOptions && !DataManager.isLineItemTaxExempt
    }
    
    private func updateTotal() {
        let price = Double((self.priceTextField.text ?? "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "$", with: "")) ?? 0.0
        self.priceTextField.text = "$\(price.roundToTwoDecimal)"
    }
    
    private func handleDoneAction() {
        
        if var dict = DataManager.cartProductsArray?[selectedProductIndex] as? JSONDictionary {
            dict["attributesArray"] = selectedAttributesArray
            dict["productqty"] = self.qtyTextField.text ?? ""
            dict["productNotes"] = self.manualDescriptionTextField.text ?? ""
            var price = self.priceTextField.text ?? ""
            price = price.replacingOccurrences(of: " ", with: "")
            price = price.replacingOccurrences(of: "$", with: "")
            dict["productprice"] = price
            
            if DataManager.isLineItemTaxExempt {
                dict["isTaxExempt"] = taxExemptButtton.isSelected ? "Yes" : "No"
            }
            
            var attributeIdArray = [Int]()
            
            for data in self.selectedAttributesArray {
                let id = data["id"] as! Int
                attributeIdArray.append(id)
            }
            
            attributeIdArray = attributeIdArray.sorted()
            dict["attributesID"] = attributeIdArray
            
            DataManager.cartProductsArray![selectedProductIndex] = dict
        }
        
        delegate?.didClickOnDoneButton?()
    }
    
    private func updateButtonTitle() {
        tenPerDiscountButton.setTitle("\(DataManager.tenDiscountValue.roundToTwoDecimal)% of Sale", for: .normal)
        twentyPerDiscountButton.setTitle("\(DataManager.twentyDiscountValue.roundToTwoDecimal)% of Sale", for: .normal)
        seventyPerDiscountButton.setTitle("\(DataManager.seventyDiscountValue.roundToTwoDecimal)% of Sale", for: .normal)
        //Portrait
        if UI_USER_INTERFACE_IDIOM() == .pad {
            tenPerDiscountButtonPortrait.setTitle("\(DataManager.tenDiscountValue.roundToTwoDecimal)% of Sale", for: .normal)
            twentyPerDiscountButtonPortrait.setTitle("\(DataManager.twentyDiscountValue.roundToTwoDecimal)% of Sale", for: .normal)
            seventyPerDiscountButtonPortrait.setTitle("\(DataManager.seventyDiscountValue.roundToTwoDecimal)% of Sale", for: .normal)
        }
    }
    
    private func updateButtonUI(tag: Int) {
        switch tag {
        case 1:
            customtextField.text = ""
            defaultDiscountButton.setTitleColor(UIColor.white, for: .normal)
            defaultDiscountButton.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
            tenPerDiscountButton.setTitleColor(UIColor.init(red: 0/255, green: 155/255, blue: 68/255, alpha: 1.0), for: .normal)
            tenPerDiscountButton.backgroundColor = UIColor.white
            twentyPerDiscountButton.setTitleColor(UIColor.blue, for: .normal)
            twentyPerDiscountButton.backgroundColor = UIColor.white
            seventyPerDiscountButton.setTitleColor(UIColor.init(red: 255/255, green: 52/255, blue: 74/255, alpha: 1.0), for: .normal)
            seventyPerDiscountButton.backgroundColor = UIColor.white
            //Portrait
            if UI_USER_INTERFACE_IDIOM() == .pad  {
                customtextFieldPortrait.text = ""
                defaultDiscountButtonPortrait.setTitleColor(UIColor.white, for: .normal)
                defaultDiscountButtonPortrait.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
                tenPerDiscountButtonPortrait.setTitleColor(UIColor.init(red: 0/255, green: 155/255, blue: 68/255, alpha: 1.0), for: .normal)
                tenPerDiscountButtonPortrait.backgroundColor = UIColor.white
                twentyPerDiscountButtonPortrait.setTitleColor(UIColor.blue, for: .normal)
                twentyPerDiscountButtonPortrait.backgroundColor = UIColor.white
                seventyPerDiscountButtonPortrait.setTitleColor(UIColor.init(red: 255/255, green: 52/255, blue: 74/255, alpha: 1.0), for: .normal)
                seventyPerDiscountButtonPortrait.backgroundColor = UIColor.white
            }
            
            break
        case 2:
            customtextField.text = ""
            defaultDiscountButton.setTitleColor(UIColor.HieCORColor.blue.colorWith(alpha: 1.0), for: .normal)
            defaultDiscountButton.backgroundColor = UIColor.white
            tenPerDiscountButton.setTitleColor(UIColor.white, for: .normal)
            tenPerDiscountButton.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
            twentyPerDiscountButton.setTitleColor(UIColor.blue, for: .normal)
            twentyPerDiscountButton.backgroundColor = UIColor.white
            seventyPerDiscountButton.setTitleColor(UIColor.init(red: 255/255, green: 52/255, blue: 74/255, alpha: 1.0), for: .normal)
            seventyPerDiscountButton.backgroundColor = UIColor.white
            //Portrait
            if UI_USER_INTERFACE_IDIOM() == .pad {
                customtextFieldPortrait.text = ""
                defaultDiscountButtonPortrait.setTitleColor(UIColor.HieCORColor.blue.colorWith(alpha: 1.0), for: .normal)
                defaultDiscountButtonPortrait.backgroundColor = UIColor.white
                tenPerDiscountButtonPortrait.setTitleColor(UIColor.white, for: .normal)
                tenPerDiscountButtonPortrait.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
                twentyPerDiscountButtonPortrait.setTitleColor(UIColor.blue, for: .normal)
                twentyPerDiscountButtonPortrait.backgroundColor = UIColor.white
                seventyPerDiscountButtonPortrait.setTitleColor(UIColor.init(red: 255/255, green: 52/255, blue: 74/255, alpha: 1.0), for: .normal)
                seventyPerDiscountButtonPortrait.backgroundColor = UIColor.white
            }
            
            break
        case 3:
            customtextField.text = ""
            defaultDiscountButton.setTitleColor(UIColor.HieCORColor.blue.colorWith(alpha: 1.0), for: .normal)
            defaultDiscountButton.backgroundColor = UIColor.white
            tenPerDiscountButton.setTitleColor(UIColor.init(red: 0/255, green: 155/255, blue: 68/255, alpha: 1.0), for: .normal)
            tenPerDiscountButton.backgroundColor = UIColor.white
            twentyPerDiscountButton.setTitleColor(UIColor.white, for: .normal)
            twentyPerDiscountButton.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
            seventyPerDiscountButton.setTitleColor(UIColor.init(red: 255/255, green: 52/255, blue: 74/255, alpha: 1.0), for: .normal)
            seventyPerDiscountButton.backgroundColor = UIColor.white
            //Portrait
            if UI_USER_INTERFACE_IDIOM() == .pad {
                customtextFieldPortrait.text = ""
                defaultDiscountButtonPortrait.setTitleColor(UIColor.HieCORColor.blue.colorWith(alpha: 1.0), for: .normal)
                defaultDiscountButtonPortrait.backgroundColor = UIColor.white
                tenPerDiscountButtonPortrait.setTitleColor(UIColor.init(red: 0/255, green: 155/255, blue: 68/255, alpha: 1.0), for: .normal)
                tenPerDiscountButtonPortrait.backgroundColor = UIColor.white
                twentyPerDiscountButtonPortrait.setTitleColor(UIColor.white, for: .normal)
                twentyPerDiscountButtonPortrait.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
                seventyPerDiscountButtonPortrait.setTitleColor(UIColor.init(red: 255/255, green: 52/255, blue: 74/255, alpha: 1.0), for: .normal)
                seventyPerDiscountButtonPortrait.backgroundColor = UIColor.white
            }
            
            break
        case 4:
            customtextField.text = ""
            defaultDiscountButton.setTitleColor(UIColor.HieCORColor.blue.colorWith(alpha: 1.0), for: .normal)
            defaultDiscountButton.backgroundColor = UIColor.white
            tenPerDiscountButton.setTitleColor(UIColor.init(red: 0/255, green: 155/255, blue: 68/255, alpha: 1.0), for: .normal)
            tenPerDiscountButton.backgroundColor = UIColor.white
            twentyPerDiscountButton.setTitleColor(UIColor.blue, for: .normal)
            twentyPerDiscountButton.backgroundColor = UIColor.white
            seventyPerDiscountButton.setTitleColor(UIColor.white, for: .normal)
            seventyPerDiscountButton.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
            //Portrait
            if UI_USER_INTERFACE_IDIOM() == .pad {
                customtextFieldPortrait.text = ""
                defaultDiscountButtonPortrait.setTitleColor(UIColor.HieCORColor.blue.colorWith(alpha: 1.0), for: .normal)
                defaultDiscountButtonPortrait.backgroundColor = UIColor.white
                tenPerDiscountButtonPortrait.setTitleColor(UIColor.init(red: 0/255, green: 155/255, blue: 68/255, alpha: 1.0), for: .normal)
                tenPerDiscountButtonPortrait.backgroundColor = UIColor.white
                twentyPerDiscountButtonPortrait.setTitleColor(UIColor.blue, for: .normal)
                twentyPerDiscountButtonPortrait.backgroundColor = UIColor.white
                seventyPerDiscountButtonPortrait.setTitleColor(UIColor.white, for: .normal)
                seventyPerDiscountButtonPortrait.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
            }
            break
        case 5:
            defaultDiscountButton.setTitleColor(UIColor.HieCORColor.blue.colorWith(alpha: 1.0), for: .normal)
            defaultDiscountButton.backgroundColor = UIColor.white
            tenPerDiscountButton.setTitleColor(UIColor.init(red: 0/255, green: 155/255, blue: 68/255, alpha: 1.0), for: .normal)
            tenPerDiscountButton.backgroundColor = UIColor.white
            twentyPerDiscountButton.setTitleColor(UIColor.blue, for: .normal)
            twentyPerDiscountButton.backgroundColor = UIColor.white
            seventyPerDiscountButton.setTitleColor(UIColor.init(red: 255/255, green: 52/255, blue: 74/255, alpha: 1.0), for: .normal)
            seventyPerDiscountButton.backgroundColor = UIColor.white
            //Portrait
            if UI_USER_INTERFACE_IDIOM() == .pad {
                defaultDiscountButtonPortrait.setTitleColor(UIColor.HieCORColor.blue.colorWith(alpha: 1.0), for: .normal)
                defaultDiscountButtonPortrait.backgroundColor = UIColor.white
                tenPerDiscountButtonPortrait.setTitleColor(UIColor.init(red: 0/255, green: 155/255, blue: 68/255, alpha: 1.0), for: .normal)
                tenPerDiscountButtonPortrait.backgroundColor = UIColor.white
                twentyPerDiscountButtonPortrait.setTitleColor(UIColor.blue, for: .normal)
                twentyPerDiscountButtonPortrait.backgroundColor = UIColor.white
                seventyPerDiscountButtonPortrait.setTitleColor(UIColor.init(red: 255/255, green: 52/255, blue: 74/255, alpha: 1.0), for: .normal)
                seventyPerDiscountButtonPortrait.backgroundColor = UIColor.white
            }
            
            break
            
        default: break
        }
    }
    
    //MARK: IBAction
    @IBAction func doneAction(_ sender: Any) {
        self.view.endEditing(true)
        handleDoneAction()
    }
    
    @IBAction func crossAction(_ sender: Any) {
        self.view.endEditing(true)
        delegate?.didClickOnCrossButton?()
    }
    
    @IBAction func addToCartAction(_ sender: Any) {
        self.view.endEditing(true)
        handleDoneAction()
    }
    
    @IBAction func plusButtonAction(_ sender: Any) {
        if let value = Double(qtyTextField.text ?? "") {
            if let dict = DataManager.cartProductsArray?[selectedProductIndex] as? JSONDictionary {
                let productTitle = dict["producttitle"] as? String ?? ""
                let stock = dict["productstock"] as? String ?? ""
                let unlimitedStock = dict["productunlimitedstock"] as? String ?? ""
                let limitQty = dict["productlimitqty"] as? String ?? ""
                
                var availableqty:Double = 1
                
                if unlimitedStock == "Yes" && limitQty == "0" {
                    availableqty = 100
                }else if (unlimitedStock == "No" && limitQty == "0") {
                    availableqty = Double(stock) ?? 0
                } else {
                    availableqty = Double(limitQty) ?? 0
                }
                
                if (value + 1) > availableqty {
                    self.showAlert(title: "Warning!", message: "\(productTitle) Has Limited Purchase - \(availableqty)")
                    return
                }
            }
            
            qtyTextField.text = (value + 1).roundToTwoDecimal
            self.updateTotal()
        }
    }
    
    @IBAction func minusButtonAction(_ sender: Any) {
        if let value = Double(qtyTextField.text ?? "") {
            if (value - 1) <= 0 {
                return
            }
            qtyTextField.text = (value - 1).roundToTwoDecimal
            self.updateTotal()
        }
    }
    
    @IBAction func defaultDiscountButtonAction(_ sender: Any) {
        self.updateButtonUI(tag: 1)
        let price = Double(productDict["mainprice"] as? String ?? "") ?? 0
        self.priceTextField.text = "$\(price.roundToTwoDecimal)"
    }
    
    @IBAction func tenPerSaleAction(_ sender: Any) {
        self.updateButtonUI(tag: 2)
        var price = Double(productDict["mainprice"] as? String ?? "") ?? 0
        price = price - (price/100 * Double(DataManager.tenDiscountValue))
        self.priceTextField.text = "$\(price.roundToTwoDecimal)"
    }
    
    @IBAction func twentyPerSaleAction(_ sender: Any) {
        self.updateButtonUI(tag: 3)
        var price = Double(productDict["mainprice"] as? String ?? "") ?? 0
        price = price - (price/100 * Double(DataManager.twentyDiscountValue))
        self.priceTextField.text = "$\(price.roundToTwoDecimal)"
    }
    
    @IBAction func seventyPersaleAction(_ sender: Any) {
        self.updateButtonUI(tag: 4)
        var price = Double(productDict["mainprice"] as? String ?? "") ?? 0
        price = price - (price/100 * Double(DataManager.seventyDiscountValue))
        self.priceTextField.text = "$\(price.roundToTwoDecimal)"
    }
    
    @IBAction func taxExemptAction(_ sender: UIButton) {
        taxExemptButtton.isSelected = !taxExemptButtton.isSelected
        if UI_USER_INTERFACE_IDIOM() == .pad {
            taxExemptButttonPortrait.isSelected = !taxExemptButttonPortrait.isSelected
        }
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension EditProductVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allAttributesArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "iPadTableViewCell", for: indexPath) as! iPadTableViewCell
        
        if let dict = self.allAttributesArray[indexPath.section] as? JSONDictionary {
            if let data = dict["attribute_values"] as? Array<Any> {
                var selectedId = -1
                let allIds = data.compactMap({Int((($0 as! JSONDictionary)["attribute_value_id"] as? String ?? ""))})
                
                if let idArray =  self.productDict["attributesID"] as? [Int] {
                    for id in idArray {
                        if allIds.contains(id) {
                            selectedId = id
                        }
                    }
                }
                
                cell.loadCell(with: data, section: indexPath.section,selectedId: selectedId == -1 ? nil : selectedId)
            }
        }
        
        cell.collectionView.tag = indexPath.section
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerViewcell = tableView.dequeueReusableCell(withIdentifier: "cellproductdetailsHeader")!
        let titleLabel = headerViewcell.contentView.viewWithTag(3) as? UILabel
        let requiredButton = headerViewcell.contentView.viewWithTag(2) as? UIButton
        let requiredImageView = headerViewcell.contentView.viewWithTag(4) as? UIImageView
        
        if let dict = self.allAttributesArray[section] as? JSONDictionary {
            if let name = dict["attribute_name"] as? String {
                titleLabel?.text = name
            }
        }
        
        requiredButton?.isHidden = section != 0
        requiredImageView?.isHidden = section != 0
        
        return headerViewcell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}


//MARK: iPadTableViewCellDelegate
extension EditProductVC :iPadTableViewCellDelegate {
    func didSelectAttribute(name: String, id: Int, index: Int) {
        if index < allAttributesArray.count {
            let attributeName = (self.allAttributesArray[index] as AnyObject).value(forKey: "attribute_name") as? String ?? ""
            let dict: JSONDictionary = ["name" : name, "id" : id , "attributeName": attributeName] as [String : Any]
            
            if let index = selectedAttributesArray.index(where: {($0["attributeName"] as? String ?? "") == attributeName}) {
                selectedAttributesArray[index] = dict
            }else {
                selectedAttributesArray.append(dict)
            }
        }
    }
}

//MARK: CatAndProductsViewControllerDelegate
extension EditProductVC: CatAndProductsViewControllerDelegate {
    func didTapOnEditButton(index: Int) {
        if let dict = DataManager.cartProductsArray?[index] as? JSONDictionary {
            self.productDict.removeAll()
            self.selectedAttributesArray.removeAll()
            self.allAttributesArray.removeAll()
            self.productDict = dict
            self.selectedProductIndex = index
            
            //Update Label
            let qty = Double(dict["productqty"] as? String ?? "") ?? 0
            let imageURL = dict["productimage"] as? String ?? ""
            let imageData = dict["productimagedata"] as? Data
            let price = Double(dict["productprice"] as? String ?? "") ?? 0
            let isTaxable = dict["productistaxable"] as? String ?? ""
            let isTaxExempt = dict["isTaxExempt"] as? String ?? "No"
            let notes = dict["productNotes"] as? String ?? ""
            
            let image = UIImage(named: "category-bg")
            if let url = URL(string: imageURL) {
                self.productImage.kf.setImage(with: url, placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
            }else {
                if  let data = imageData {
                    self.productImage?.image = UIImage(data: data)
                }
            }
            
            self.manualDescriptionTextField.text = notes
            self.productName.text = dict["producttitle"] as? String ?? ""
            self.qtyTextField.text = qty.roundToTwoDecimal
            self.priceTextField.text = "$\(price.roundToTwoDecimal)"
            self.taxExemptButtton.isSelected = isTaxExempt.lowercased() != "no"
            
            if UI_USER_INTERFACE_IDIOM() == .pad  {
                self.taxExemptButttonPortrait.isSelected = isTaxExempt.lowercased() != "no"
                self.taxExemptButttonPortrait.isHidden = !DataManager.isLineItemTaxExempt || isTaxable.lowercased() == "no"
            }
            
            self.taxExemptButtton.isHidden = !DataManager.isLineItemTaxExempt || isTaxable.lowercased() == "no"
            self.selectedAttributesArray = dict["attributesArray"] as? [JSONDictionary] ?? [JSONDictionary]()
            self.allAttributesArray = dict["allAttributesArray"] as? Array<Any> ?? Array<Any>()
            
            self.tableView.reloadData{
                self.tableView.scrollToTop()
            }
            
            self.updateButtonUI(tag: 1)
        }
    }
}

//MARK: TextFieldDelegate
extension EditProductVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == customtextField || textField == customtextFieldPortrait {
            updateButtonUI(tag: 5)
            let text = Double((textField.text ?? "").replacingOccurrences(of: "%", with: "")) ?? 0.0
            customtextField.text = text == 0 ? "" : text.roundToTwoDecimal
            if UI_USER_INTERFACE_IDIOM() == .pad {
                customtextFieldPortrait.text = text == 0 ? "" : text.roundToTwoDecimal
            }
        }

        if textField == priceTextField {
            let text = Double((textField.text ?? "").replacingOccurrences(of: "$", with: "")) ?? 0.0
            textField.text = text == 0 ? "" : text.roundToTwoDecimal
            self.updateButtonUI(tag: 1)
        }
        
        if textField == priceTextField || textField == qtyTextField || textField == customtextField || textField == customtextFieldPortrait {
            textField.selectAll(nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == qtyTextField {
            let text = Double(textField.text ?? "") ?? 0.0
            textField.text = text <= 0 ? "1.00" : text.roundToTwoDecimal
        }
        
        if textField == priceTextField  {
            let text = Double((textField.text ?? "").replacingOccurrences(of: "$", with: "")) ?? 0.0
            textField.text = "$\(text.roundToTwoDecimal)"
        }
        
        if textField == customtextField || textField == customtextFieldPortrait {
            let text = Double((textField.text ?? "").replacingOccurrences(of: "%", with: "")) ?? 0.0
            customtextField.text = "\(text.roundToTwoDecimal)%"
            if UI_USER_INTERFACE_IDIOM() == .pad {
                customtextFieldPortrait.text = "\(text.roundToTwoDecimal)%"
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
        var replacementText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        if textField == customtextField || textField == customtextFieldPortrait {
            let amount = Double(replacementText) ?? 0.0
            return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= 100
        }

        if textField == priceTextField {
            replacementText = replacementText.replacingOccurrences(of: "$", with: "")
            return replacementText.isValidDecimal(maximumFractionDigits: 2) && charactersCount <= 8
        }
        
        if textField == qtyTextField  {
            if let dict = DataManager.cartProductsArray?[selectedProductIndex] as? JSONDictionary {
                
                let stock = dict["productstock"] as? String ?? ""
                let unlimitedStock = dict["productunlimitedstock"] as? String ?? ""
                let limitQty = dict["productlimitqty"] as? String ?? ""
                
                var availableqty:Double = 1
                
                if unlimitedStock == "Yes" && limitQty == "0" {
                    availableqty = 100
                }else if (unlimitedStock == "No" && limitQty == "0") {
                    availableqty = Double(stock) ?? 0
                } else {
                    availableqty = Double(limitQty) ?? 0
                }
                
                return replacementText.isValidDecimal(maximumFractionDigits: 2) && (Double(replacementText) ?? 0.0) <= availableqty
            }
            
            return false
        }
        
        if textField == manualDescriptionTextField {
            if string == " " {
                return charactersCount <= 200
            }
            let cs = CharacterSet.alphanumerics.inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if charactersCount > 200 {
                return false
            }
            return string == filtered
        }
        return false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == customtextField || textField == customtextFieldPortrait {
            self.updateButtonUI(tag: 5)
            let amountInPer = Double((textField.text ?? "").replacingOccurrences(of: "%", with: "")) ?? 0.0
            var price = Double(productDict["mainprice"] as? String ?? "") ?? 0
            price = price - (price/100 * amountInPer)
            self.priceTextField.text = "$\(price.roundToTwoDecimal)"
        }
    }
}
