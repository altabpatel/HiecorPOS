//
//  ReturnViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 07/12/17.
//  Copyright © 2017 HyperMacMini. All rights reserved.
//

import UIKit
import Alamofire

class ReturnViewController: BaseViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var btn_CancelForIpad: UIButton!
    @IBOutlet weak var btn_Return: UIButton!
    @IBOutlet weak var btn_Back: UIButton!
    @IBOutlet var txt_Notes: UITextView!
    @IBOutlet var tf_Condition: UITextField!
    @IBOutlet var tbl_Returns: UITableView!
    @IBOutlet var view_Condition: UIView!
    @IBOutlet var view_Notes: UIView!
    @IBOutlet weak var returnLabel: UILabel!
    @IBOutlet weak var returnButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var returnButtonBottomConstraint: NSLayoutConstraint!

    //MARK: Variables
    var customView = UIView()
    var orderInfoModelObj = OrderInfoModel()
    var searchArray = [ItemsDetailModel]()
    var SelecetedReturnProductID = String()
    var orderID = String()
    var array_Conditions = [ConditionsForReturnModel]()
    var Str_Condition = String()
    var SelectedProductIDs = [String]()
    var myPickerView: UIPickerView!
    var isSearching = false
    
    //MARK: Delegate
    var orderInfoDelegate : OrderInfoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeUI()
        //Call API To Get Contitions
        if UI_USER_INTERFACE_IDIOM() == .phone {
            self.callAPItoGetReturnConditions()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            btn_Return.setCornerRadius(cornerRadius: 5.0)
            self.returnButtonBottomConstraint.constant = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height ? 15 : 300
        }else {
            btn_Return.setCornerRadius(cornerRadius: 0)
            self.returnButtonBottomConstraint.constant = 0
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        tf_Condition.updateCustomBorder()
        txt_Notes.updateCustomBorder()
        if UI_USER_INTERFACE_IDIOM() == .pad {
            btn_Return.setCornerRadius(cornerRadius: 5.0)
            self.returnButtonBottomConstraint.constant = UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height ? 15 : 300
        }else {
            btn_Return.setCornerRadius(cornerRadius: 0)
            self.returnButtonBottomConstraint.constant = 0
        }
    }
    
    //MARK: Private Functions
    private func customizeUI() {
        UIApplication.shared.isStatusBarHidden = true
        searchBarTextField.keyboardType = .asciiCapable
        
        tbl_Returns.tableFooterView = UIView()
        customView = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.size.width, height: self.view.frame.size.height))
        customView.backgroundColor = UIColor.black
        customView.alpha = 0.5
        customView.isUserInteractionEnabled = false
        customView.isHidden = true
        self.view.addSubview(customView)
        
        view_Notes.layer.borderWidth = 0.0
        view_Notes.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        view_Notes.layer.masksToBounds = true
        
        view_Condition.layer.borderWidth = 1.0
        view_Condition.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        view_Condition.layer.cornerRadius = 0.0
        view_Condition.layer.masksToBounds = true
        
        tf_Condition.delegate = self
        tf_Condition.hideAssistantBar()
        tf_Condition.layer.borderWidth = 1.0
        tf_Condition.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        tf_Condition.layer.cornerRadius = 4.0
        tf_Condition.layer.masksToBounds = true
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0 , width: 20, height: self.tf_Condition.frame.height))
        tf_Condition.leftView = paddingView
        tf_Condition.leftViewMode = UITextFieldViewMode.always
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 10))
        let image = UIImage(named: "dropdown-arrow")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        tf_Condition.rightView = imageView
        tf_Condition.rightViewMode = UITextFieldViewMode.always
        
        txt_Notes.delegate = self
        txt_Notes.layer.borderWidth = 1.0
        txt_Notes.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        txt_Notes.layer.cornerRadius = 4.0
        txt_Notes.layer.masksToBounds = true
        
        searchBarTextField.text = ""
        txt_Notes.text = "Add Note"
        txt_Notes.textColor = UIColor.lightGray
        
        tf_Condition.text = "Please select condition"
        if SelecetedReturnProductID != "" {
            SelectedProductIDs.append(SelecetedReturnProductID)
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            returnLabel.isHidden = true
            btn_Back.isHidden = true
            btn_CancelForIpad.isHidden = false
            returnButtonWidth.constant = 250
        }
        else
        {
            returnLabel.isHidden = false
            btn_Back.isHidden = false
            btn_CancelForIpad.isHidden = true
            returnButtonWidth.constant = self.view.frame.size.width
        }
    }
    
    //MARK: IBAction
    @IBAction func btn_BackAction(_ sender: Any) {
        self.view.endEditing(true)
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            SelectedProductIDs.removeAll()
            let returnData = ["hide":true] as [String : Any]
            orderInfoDelegate?.didUpdateReturnScreen?(with: returnData)
            UIApplication.shared.isStatusBarHidden = false
        }
        else
        {
            SelectedProductIDs.removeAll()
            UIApplication.shared.isStatusBarHidden = false
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func tf_ConditionAction(_ sender: Any)
    {
        tf_Condition.resetCustomError()
        let array = array_Conditions.compactMap({$0.name})
        self.pickerDelegate = self
        self.setPickerView(textField: tf_Condition, array: array)
    }
    
    @IBAction func btn_ReturnAction(_ sender: Any)
    {
        //Validate Data
        if SelectedProductIDs.count <= 0 {
            self.showAlert(message: "Please select atleast one product.")
            return
        }
        if tf_Condition.text == "Please select condition" || tf_Condition.text == "" {
            tf_Condition.setCustomError(text: "Please select condition")
            return
        }
        if txt_Notes.text == "Add Note" || txt_Notes.text == "" {
            txt_Notes.setCustomError(text: "Please add notes.")
            return
        }
        
        //Prepare Parameters For API
        var dict = [String: Any]()
        var ProductsArray = Array<Any>()
        let arrayData = self.orderInfoModelObj.productsArray
        for i in (0..<self.SelectedProductIDs.count)
        {
            for j in (0..<arrayData.count)
            {
                if(self.SelectedProductIDs[i] == arrayData[j].productID)
                {
                    dict["id"] = arrayData[j].productID
                    dict["name"] = arrayData[j].title
                    dict["quantity"] = arrayData[j].qty
                    ProductsArray.append(dict)
                }
            }
        }
        
        let parameters: Parameters = [
            "custID": DataManager.userID,
            "order_id": orderID,
            "products":ProductsArray,
            "ship_condition": Str_Condition,
            "ship_other_condition": "",
            "ship_method": "",
            "ship_other": "",
            "tracking_number": "",
            "next_step": "",
            "notes": txt_Notes.text
        ]
        //Call API
        callAPItoReturn(parameters: parameters)
    }
    
}

//MARK: OrderInfoViewControllerDelegate
extension ReturnViewController: OrderInfoViewControllerDelegate {
    func didUpdateReturnScreen(with data: JSONDictionary) {
        self.view.endEditing(true)
        self.callAPItoGetReturnConditions()
        tf_Condition.resetCustomError()
        txt_Notes.resetCustomError()
        tf_Condition.text = "Please select condition"
        txt_Notes.text = "Add Note"
        searchBarTextField.text = ""
        isSearching = false
        txt_Notes.textColor = UIColor.lightGray
        SelectedProductIDs.removeAll()
        
        if data["items"] != nil
        {
            self.orderInfoModelObj.productsArray =  data["items"] as! [ItemsDetailModel]
        }
        if data["orderID"] != nil
        {
            orderID = data["orderID"] as! String
        }
        if data["returnProductID"] != nil
        {
            SelecetedReturnProductID = data["returnProductID"] as! String
            SelectedProductIDs.append(SelecetedReturnProductID)
        }
        
        tbl_Returns.reloadData()
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension ReturnViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return isSearching ? searchArray.count :  self.orderInfoModelObj.productsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let arrayItemsData =  isSearching ? searchArray[indexPath.row] : self.orderInfoModelObj.productsArray[indexPath.row]
        let lbl_NameAndQty = cell.contentView.viewWithTag(2) as? UILabel
        lbl_NameAndQty?.text = "\(arrayItemsData.title) (\(arrayItemsData.qty))"
        let lbl_Price = cell.contentView.viewWithTag(3) as? UILabel
        lbl_Price?.text = "$" + arrayItemsData.price.roundToTwoDecimal
        
        let btn_CheckUncheck = cell.contentView.viewWithTag(1) as? UIButton
        
        if SelectedProductIDs.contains(arrayItemsData.productID)
        {
            btn_CheckUncheck?.setImage(UIImage(named: "checkbox-checked"), for: .normal)
            lbl_NameAndQty?.textColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
            lbl_Price?.textColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
        }
        else
        {
            btn_CheckUncheck?.setImage(UIImage(named: "checkbox-unchecked"), for: .normal)
            lbl_NameAndQty?.textColor = UIColor.black
            lbl_Price?.textColor = UIColor.black
        }
        btn_CheckUncheck?.addTarget(self, action:#selector(btn_SelectProductAction(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func btn_SelectProductAction(sender: UIButton)
    {
        let button = sender
        let cell = button.superview?.superview as! UITableViewCell
        var index: IndexPath? = tbl_Returns?.indexPath(for: cell)
        let arrayModel = isSearching ? searchArray[index!.row] : self.orderInfoModelObj.productsArray[(index?.row)!]
        if SelectedProductIDs.contains(arrayModel.productID) {
            let index = SelectedProductIDs.index(of: arrayModel.productID)
            SelectedProductIDs.remove(at: index!)
        }
        else
        {
            SelectedProductIDs.append(arrayModel.productID)
            
        }
        self.tbl_Returns.reloadData()
    }
}

//MARK: UITextFieldDelegate
extension ReturnViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == searchBarTextField {
            updateSearchData(text: textField.text)
            return
        }
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            if textField == tf_Condition
            {
                self.tf_ConditionAction(tf_Condition!)
                customView.isHidden = false
                customView.isUserInteractionEnabled = true
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == searchBarTextField {
            updateSearchData(text: textField.text)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == searchBarTextField {
            let text = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            updateSearchData(text: text)
            return true
        }
        return true
    }
    
    func updateSearchData(text: String? = "")
    {
        if text == "" {
            isSearching = false
            searchBarTextField.text = text
        }else {
            let array = orderInfoModelObj.productsArray.filter({$0.title.lowercased().contains(text!.lowercased())})
            searchArray = array
            isSearching = true
        }
        self.tbl_Returns.reloadData()
    }

}


//MARK: UITextViewDelegate
extension ReturnViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.resetCustomError()
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Add Note"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

//MARK: HieCORPickerDelegate
extension ReturnViewController: HieCORPickerDelegate {
    func didClickOnPickerViewDoneButton() {
        customView.isHidden = true
        customView.isUserInteractionEnabled = false
        tf_Condition.resignFirstResponder()
    }
    
    func didClickOnPickerViewCancelButton() {
        customView.isHidden = true
        customView.isUserInteractionEnabled = false
        tf_Condition.resignFirstResponder()
        tf_Condition.text = "Please select condition"
        Str_Condition = ""
    }
    
    func didSelectPickerViewAtIndex(index: Int) {
        tf_Condition.text = "\(array_Conditions[index].name)"
        Str_Condition = array_Conditions[index].name
    }
}

//MARK: API Methods
extension ReturnViewController {
    func callAPItoReturn(parameters: JSONDictionary) {
        OrderVM.shared.returnOrder(parameters: parameters, responseCallBack: { (success, message, error) in
            if success == 1 {
                self.showAlert(title: "Alert", message: "Successfully return.", otherButtons: nil, cancelTitle: "Okay", cancelAction: { (action) in
                    if UI_USER_INTERFACE_IDIOM() == .pad
                    {
                        let returnData = ["hide":true] as [String : Any]
                        self.orderInfoDelegate?.didProductReturned?()
                        self.orderInfoDelegate?.didUpdateReturnScreen?(with: returnData)
                        UIApplication.shared.isStatusBarHidden = false
                    }
                    else
                    {
                        UIApplication.shared.isStatusBarHidden = false
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }else {
                if message != nil {
                    self.showAlert(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
    
    func callAPItoGetReturnConditions() {
        OrderVM.shared.getReturnConditions(responseCallBack: { (success, message, error) in
            if success == 1 {
                self.array_Conditions = OrderVM.shared.returnConditions
            }else {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    Indicator.sharedInstance.hideIndicator()
                }
                if message != nil {
                    self.showAlert(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
}
