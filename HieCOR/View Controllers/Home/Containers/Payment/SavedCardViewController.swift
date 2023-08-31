//
//  SavedCardViewController.swift
//  HieCOR
//
//  Created by Hiecor Software on 23/07/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire

//MARK: step 1 Add Protocol here
protocol ClassBVCDelegate: class {
    func savedCardInfoInphone(cartSavedArray:Array<AnyObject>)
}

protocol ClassEMVDelegate: class {
    func savedCardEMVInfoInphone(cartSavedArray:Array<AnyObject>)
}

class SavedCardViewController: BaseViewController {
    
    @IBOutlet weak var tableCard: UITableView!
    
    var delegate: PaymentTypeContainerViewControllerDelegate?
    var delegateCard: savedCardDelegate?
    var closeDelegate: EditProductDelegate?
    var customerSavedCardDelegate: CustomerDelegates?
    var cardSavedModel = [SavedCardList]()
    var customerList = CustomerListModel()
    var userId  = String()
    var bpidCard = String()
    var selectedIndex = Int()
    //var selectedIndexMulti = [Int]()
    private var arraySelectedIndex = [String]()
    var objectSaved = Array<AnyObject>()
    private var MM_Array = [String]()
    private var YY_Array = [String]()
    var selectedYear = String()
    var indexPathAll = NSIndexPath()
    var tableData = [[String:AnyObject]]()
    
    var indexEdit = Int()
    var strMonth = ""
    var strYear = ""
    var strPaymentName = ""
    
    weak var delegateOne: ClassBVCDelegate?
    
    var delegateEmv: ClassEMVDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate?.sendCardCustomerCardData!(data: customerList)
        if UI_USER_INTERFACE_IDIOM() == .phone {
            if strPaymentName == "paxpay" {
                callAPItoGetEmvSavedCard()
            } else {
                
                callAPItoGetSavedCard()
            }
            
        }
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableCard.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableCard.reloadData()
    }
    
    
    //MARK: -- Action Method 
    @IBAction func actionAllView(_ sender: Any) {
        
        //tableCard.reloadData()
        //closeDelegate?.didClickOnCreditSavedButton?()
    }
    
    @IBAction func actionSavedCard(_ sender: UIButton) {
        
//        if appDelegate.strPaymentType == "MULTI CARD" {
//            appDelegate.selectedIndexMulti.append(selectedIndex)
//
//        }
        sender.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if objectSaved.count > 0 {
                closeDelegate?.didClickOnCreditSavedButton?()
                closeDelegate?.didShowSavedCardDetail!(index: selectedIndex, cartSavedArray: objectSaved)
            } else {
                closeDelegate?.didClickOnCreditSavedButton?()
            }
        }else{
            if objectSaved.count > 0 {
                if strPaymentName == "paxpay" {
                    delegateEmv?.savedCardEMVInfoInphone(cartSavedArray: objectSaved)
                } else {
                    delegateOne?.savedCardInfoInphone(cartSavedArray: objectSaved)
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
        tableCard.reloadData()
    }
    
    func alertForDelete(strId:String)
    {
        let refreshAlert = UIAlertController(title: "Confirm", message: "Do You Want To Remove This Card?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: kOkay, style: .default, handler: { (action: UIAlertAction!) in
            
            self.callAPItoDeleteSavedCard(strIdVal: strId)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @objc func btnDelete_Action(_ sender: UIButton) {
        
        let obj = cardSavedModel[sender.tag]
        
        print(obj.bpid)
        
        alertForDelete(strId: obj.bpid)
    }
    
    @objc func btnEdit_Action(_ sender: UIButton) {
        
        indexEdit = sender.tag
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        tableCard.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)
    }
    
    @objc func btnCancel_Action(_ sender: UIButton) {
        indexEdit = self.cardSavedModel.count + 1
        let indexPath = NSIndexPath(row: sender.tag, section: 0)
        tableCard.reloadRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.none)
    }
    
    @objc func btnUpdate_Action(_ sender: UIButton) {
        
        let obj = cardSavedModel[sender.tag]
        
        print(obj.bpid)
        
        let parameters: Parameters = [
            "bp_id": obj.bpid,
            "update_card_yr": tableData[sender.tag]["ccYear"] ?? "",
            "update_card_mnth": tableData[sender.tag]["ccMM"] ?? ""
        ]
        
        if tableData[sender.tag]["ccMM"] as? String == "" || tableData[sender.tag]["ccYear"] as? String == "" {
//            self.showAlert(message: "Please Select Month And Year.")
            appDelegate.showToast(message: "Please Select Month And Year.")
        }else {
            self.callAPItoUpdateSavedCardData(parameters: parameters)
        }
        
    }
    
    private func upadateMonthArray() {
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        YY_Array.removeAll()
        MM_Array.removeAll()
        
        if selectedYear == "\(year)" {
            for i in (month..<13) {
                MM_Array.append(String(format: "%02d", i))
            }
        }else {
            MM_Array = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        }
        
        for i in (year..<2050) {
            YY_Array.append("\(i)")
        }
    }
    
    @objc func handleYearTypeTextField(sender: UITextField) {
        
        upadateMonthArray()
        self.pickerDelegate = self
        //indexPayment = sender.tag
        indexPathAll = NSIndexPath(row: sender.tag, section: 0)
        
        self.setPickerView(textField: sender, array: YY_Array)
    }
    
    @objc func handleMonthTypeTextField(sender: UITextField) {
        
        upadateMonthArray()
        self.pickerDelegate = self
        //indexPayment = sender.tag
        indexPathAll = NSIndexPath(row: sender.tag, section: 0)
        
        self.setPickerView(textField: sender, array: MM_Array)
    }
    
    // MARK Call API for get Saved Data
    func callAPItoGetSavedCard()
    {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()

        HomeVM.shared.getSavedCardData(id:HomeVM.shared.customerUserId, type:"SingleCreditType",responseCallBack: { (success, message, error) in
            if success == 1 {
                self.cardSavedModel = HomeVM.shared.savedCardList
                
                DataManager.CardCount = self.cardSavedModel.count
                
                for i in 0..<self.cardSavedModel.count {
                    let dict = ["index"  : 1 as AnyObject,
                                "cellID" : "SavedCardTableViewCell" as AnyObject,
                                "ccMM"   : "MM" as AnyObject,
                                "ccYear" : "Year" as AnyObject]
                    self.tableData.append(dict)
                    
                    
                    if self.cardSavedModel[i].last4 == DataManager.last4DigitCard {
                        self.selectedIndex = i
                        self.objectSaved = [self.cardSavedModel[self.selectedIndex]]
                    }
                    
//                    if self.cardSavedModel[i].bpid == DataManager.Bbpid {
//                        self.selectedIndex = i
//                        self.objectSaved = [self.cardSavedModel[self.selectedIndex]]
//                    }
                }
                
                self.indexEdit = self.cardSavedModel.count + 1
                self.tableCard.reloadData()
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
            }else {
                if message != nil {                                                                                 
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                } else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
    
        func callAPItoGetEmvSavedCard()
        {
            Indicator.isEnabledIndicator = false
            Indicator.sharedInstance.showIndicator()
            
            var strId = HomeVM.shared.customerUserId
            if HomeVM.shared.customerUserId == "" {
                if DataManager.customerId != "" {
                    strId = DataManager.customerId
                    HomeVM.shared.customerUserId = strId
                }
            }

            HomeVM.shared.getEmvSavedCardData(id:strId,responseCallBack: { (success, message, error) in
                if success == 1 {
                    self.cardSavedModel = HomeVM.shared.savedCardList
                    
                    DataManager.EmvCardCount = self.cardSavedModel.count
                    
                    for i in 0..<self.cardSavedModel.count {
                        let dict = ["index"  : 1 as AnyObject,
                                    "cellID" : "SavedCardTableViewCell" as AnyObject,
                                    "ccMM"   : "MM" as AnyObject,
                                    "ccYear" : "Year" as AnyObject]
                        self.tableData.append(dict)
                        
                        
                        if self.cardSavedModel[i].last4 == DataManager.last4DigitCard {
                            self.selectedIndex = i
                            self.objectSaved = [self.cardSavedModel[self.selectedIndex]]
                            self.closeDelegate?.didShowSavedCardDetail!(index: self.selectedIndex, cartSavedArray: self.objectSaved)
                        }
                        
    //                    if self.cardSavedModel[i].bpid == DataManager.Bbpid {
    //                        self.selectedIndex = i
    //                        self.objectSaved = [self.cardSavedModel[self.selectedIndex]]
    //                    }
                    }
                    
                    self.indexEdit = self.cardSavedModel.count + 1
                    self.tableCard.reloadData()
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                }else {
                    if message != nil {
                        Indicator.isEnabledIndicator = true
                        Indicator.sharedInstance.hideIndicator()
    //                    self.showAlert(message: message!)
                        appDelegate.showToast(message: message!)
                    } else {
                        self.showErrorMessage(error: error)
                    }
                }
            })
        }
    
    func callAPItoGetIngenicoSavedCard()
    {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        
        var strId = HomeVM.shared.customerUserId
        if HomeVM.shared.customerUserId == "" {
            if DataManager.customerId != "" {
                strId = DataManager.customerId
                HomeVM.shared.customerUserId = strId
            }
        }

        HomeVM.shared.getingenicoSavedCardData(id:strId,responseCallBack: { (success, message, error) in
            if success == 1 {
                self.cardSavedModel = HomeVM.shared.savedCardList
                
                DataManager.IngenicoCardCount = self.cardSavedModel.count
                
                for i in 0..<self.cardSavedModel.count {
                    let dict = ["index"  : 1 as AnyObject,
                                "cellID" : "SavedCardTableViewCell" as AnyObject,
                                "ccMM"   : "MM" as AnyObject,
                                "ccYear" : "Year" as AnyObject]
                    self.tableData.append(dict)
                    
                    
                    if self.cardSavedModel[i].last4 == DataManager.last4DigitCard {
                        self.selectedIndex = i
                        self.objectSaved = [self.cardSavedModel[self.selectedIndex]]
                        self.closeDelegate?.didShowSavedCardDetail!(index: self.selectedIndex, cartSavedArray: self.objectSaved)
                    }
                    
//                    if self.cardSavedModel[i].bpid == DataManager.Bbpid {
//                        self.selectedIndex = i
//                        self.objectSaved = [self.cardSavedModel[self.selectedIndex]]
//                    }
                }
                
                self.indexEdit = self.cardSavedModel.count + 1
                self.tableCard.reloadData()
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
            }else {
                if message != nil {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                } else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
    
    // MARK Call API for delete Saved Data
    func callAPItoDeleteSavedCard(strIdVal: String)
    {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        
        HomeVM.shared.deletSavedCardData(id:strIdVal, type:"SingleCreditType",responseCallBack: { (success, message, error) in
            if success == 1 {
                //self.cardSavedModel = HomeVM.shared.savedCardList
                self.callAPItoGetSavedCard()
                //self.tableCard.reloadData()
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
            }else {
                if message != nil {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                } else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
    
    // MARK Call API for Update Saved Data
    func callAPItoUpdateSavedCardData(parameters: JSONDictionary) {
        
        HomeVM.shared.updateSavedCardData(parameters: parameters) { (success, message, error) in
            if success == 1 {
//                self.showAlert(message: "Credit card updated")
                appDelegate.showToast(message: "Credit card updated")
                self.callAPItoGetSavedCard()
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
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension SavedCardViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cardSavedModel.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCardTableViewCell", for: indexPath) as! SavedCardTableViewCell
        cell.txfYear.delegate = self
        cell.txfMonth.delegate = self
        cell.selectionStyle = .none
        let obj = cardSavedModel[indexPath.row]
        
        cell.labelSavedCard.text = obj.last_4
        cell.lblCardNumber.text = obj.last4
        let obyear = obj.cardexpyr
        let obmonth = obj.cardexpmo
        bpidCard = obj.bpid
        cell.labelCardDate.text = obmonth + "/" + obyear
        
        cell.ViewCellEdit.isHidden = obj.cardvalid
        
        if indexEdit == indexPath.row {
            cell.viewUpdate.isHidden = false
        } else {
            cell.viewUpdate.isHidden = true
        }

        if let value = tableData[indexPath.row]["ccMM"] as? String, value != "" {
            cell.txfMonth.text = value
        }else {
            cell.txfMonth.text = obmonth
        }
    
        
        if let value = tableData[indexPath.row]["ccYear"] as? String, value != "" {
            cell.txfYear.text = value
        }else {
            cell.txfYear.text = obyear
        }
        
        
        cell.txfMonth.tag = indexPath.row
        cell.txfYear.tag = indexPath.row
       
        cell.txfMonth.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cell.txfYear.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(self.btnEdit_Action), for: .touchUpInside)

        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(self.btnDelete_Action), for: .touchUpInside)
        
        cell.btnCancel.tag = indexPath.row
        cell.btnCancel.addTarget(self, action: #selector(self.btnCancel_Action), for: .touchUpInside)

        cell.btnUpdate.tag = indexPath.row
        cell.btnUpdate.addTarget(self, action: #selector(self.btnUpdate_Action), for: .touchUpInside)
        
        //if appDelegate.strPaymentType == "MULTI CARD" {
//            //cell.btnSelection?.setImage(#imageLiteral(resourceName: "unselectbtn"), for: .normal)
//
////            if indexPath.row == selectedIndex {
////                cell.btnSelection?.setImage(#imageLiteral(resourceName: "radio-checked"), for: .normal)
////            } else {
////                cell.btnSelection?.setImage(#imageLiteral(resourceName: "unselectbtn"), for: .normal)
////            }
//
//            if appDelegate.selectedIndexMulti.containsSameElements(as: [indexPath.row]) {
//                cell.btnSelection?.setImage(#imageLiteral(resourceName: "radio-checked"), for: .normal)
//            }
            
      //  } else {
            if indexPath.row == selectedIndex{
                //if bpidCard ==  DataManager.Bbpid{
                    cell.btnSelection?.setImage(#imageLiteral(resourceName: "radio-checked"), for: .normal)
                    objectSaved = [cardSavedModel[selectedIndex]]
//                }else{
//                    cell.btnSelection?.setImage(#imageLiteral(resourceName: "radio-checked"), for: .normal)
//                    objectSaved = [cardSavedModel[selectedIndex]]
//                }
            }else{
                cell.btnSelection?.setImage(#imageLiteral(resourceName: "unselectbtn"), for: .normal)
            }
    //    }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        objectSaved.removeAll()
        objectSaved = [cardSavedModel[indexPath.row]]
        DataManager.last4DigitCard = cardSavedModel[indexPath.row].last4
        tableCard.reloadData()
        
//        if appDelegate.strPaymentType == "MULTI CARD" {
//
//        } else {
//            selectedIndex = indexPath.row
//            objectSaved.removeAll()
//            objectSaved = [cardSavedModel[indexPath.row]]
//            tableCard.reloadData()
//        }
    }
}

extension SavedCardViewController : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.hideAssistantBar()
        
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
        let indexPoint :CGPoint = textField.convert(.zero, to: tableCard)
        guard let indexPathValue:IndexPath = tableCard.indexPathForRow(at: indexPoint) else {
            return
        }
        print("the index of current cell \(indexPathValue.row)")
//
        //let mode = tableData[indexPathValue.row]["index"] as? Int ?? 0
        //selectedIndexPath = indexPathValue
        
        let cell = textField.superview?.superview?.superview?.superview as? SavedCardTableViewCell
        
        if textField == cell?.txfMonth {
            if tableData[indexPathValue.row]["ccYear"] as! String == "Year" {
                //self.showAlert(message: "Invalid Data.")
                //return
            }      
            self.upadateMonthArray()
            textField.tag = 10
            textField.tintColor = UIColor.clear
            self.pickerDelegate = self
            textField.text = MM_Array.first
            self.setPickerView(textField: textField, array: MM_Array)
        }
        
        if textField == cell?.txfYear {
            self.upadateMonthArray()
            textField.tag = 20
            textField.tintColor = UIColor.clear
            self.pickerDelegate = self
            textField.text = YY_Array.first
            selectedYear = textField.text ?? ""
            cell?.txfMonth.text = "MM"
            tableData[indexPathValue.row]["ccMM"] = "MM" as AnyObject
            self.setPickerView(textField: textField, array: YY_Array)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let indexPoint :CGPoint = textField.convert(.zero, to: tableCard)
        let indexPathValue:IndexPath = tableCard.indexPathForRow(at: indexPoint)!
        print("the index of current cell \(indexPathValue.row)")
        
        let cell = textField.superview as? SavedCardTableViewCell
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let indexPoint :CGPoint = textField.convert(.zero, to: tableCard)
        guard let indexPathValue:IndexPath = tableCard.indexPathForRow(at: indexPoint) else {return}
        print("the index of current cell \(indexPathValue.row)")
        
        let cell = textField.superview?.superview?.superview?.superview as? SavedCardTableViewCell
        
        tableData[indexPathValue.row]["ccMM"] = cell?.txfMonth.text as AnyObject
        tableData[indexPathValue.row]["ccYear"] = cell?.txfYear.text as AnyObject
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        
        if (cell?.txfYear.text ?? "") == "\(year)" && (Int(cell?.txfMonth.text ?? "0") ?? 0 ) < month {
            //cell?.txfMonth.text = ""
            cell?.txfMonth.text = "MM"
            tableData[indexPathValue.row]["ccMM"] = "MM" as AnyObject
            //tableData[indexPathValue.row]["ccMM"] = "" as AnyObject
        }
        
        DispatchQueue.main.async {
            textField.resignFirstResponder()
        }
        
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Handle Swipe Reader Data
        
        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
        let indexPoint :CGPoint = textField.convert(.zero, to: tableCard)
        let indexPathValue:IndexPath = tableCard.indexPathForRow(at: indexPoint)!
        let text = NSString(string: textField.text!).replacingCharacters(in: range, with: string)

        
        //let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: HieCORPickerDelegate
extension SavedCardViewController: HieCORPickerDelegate {
    func didSelectPickerViewAtIndex(index: Int) {
        
        switch pickerTextfield.tag {
        case 10:
            //pickerTextfield.text = "\(MM_Array[index])"
            strMonth = "\(MM_Array[index])"
            break
        case 20:
            //pickerTextfield.text = "\(YY_Array[index])"
            strYear = "\(YY_Array[index])"
            selectedYear = "\(YY_Array[index])"
            break

        default:
            break
        }
    }
    
    override func pickerViewDoneAction() {
        
        switch pickerTextfield.tag {
        case 10:
            pickerTextfield.text = strMonth
            break
        case 20:
            let date = Date()
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: date)
            
            
            if strYear == "\(year)" {
                
                let month = calendar.component(.month, from: date)
                
                if strMonth != "" {
                    if month > Int(strMonth)! {
                        pickerTextfield.text = ""
                    }
                }
            }
            
            pickerTextfield?.text = strYear
            selectedYear = strYear
            break
            
        default:
            break
        }
        
//        if pickerTextfield == tf_MM {
//            tf_MM?.text = strMonth
//        }
//        else {
//
//            let date = Date()
//            let calendar = Calendar.current
//
//            let year = calendar.component(.year, from: date)
//
//
//            if strYear == "\(year)" {
//
//                let month = calendar.component(.month, from: date)
//
//                if month > Int(strMonth)! {
//                    tf_MM.text = ""
//                }
//
//            }
//
//            tf_YYYY?.text = strYear
//            selectedYear = strYear
//        }
        
        pickerTextfield.resignFirstResponder()
    }
    
    override func pickerViewCancelAction() {
        //pickerTextfield.text = ""
        
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        
        
        if strYear == "\(year)" {
            
            let month = calendar.component(.month, from: date)
            
            if strMonth != "" {
                if month > Int(strMonth)! {
                    pickerTextfield.text = ""
                }
            }
        }
        
        pickerTextfield?.resignFirstResponder()
    }
}

extension SavedCardViewController: creditInfoDelegate {
    
    func didDataShowCreditcard(paymentMethod: String) {
        if DataManager.customerId != "" {
            //appDelegate.selectedIndexMulti.removeAll()
            //            Indicator.isEnabledIndicator = false
            //            Indicator.sharedInstance.showIndicator()
            if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
                //authButton.isHidden = true
            } else {
                //callAPItoGetSavedCard()
                if paymentMethod == "credit" {
                    callAPItoGetSavedCard()
                } else if paymentMethod == "cardreader"{
                    callAPItoGetIngenicoSavedCard()
                } else{
                    callAPItoGetEmvSavedCard()
                }
                
            }
            
        }
    }
}
