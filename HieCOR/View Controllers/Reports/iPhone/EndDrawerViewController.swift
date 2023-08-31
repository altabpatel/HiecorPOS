//
//  EndDrawerViewController.swift
//  HieCOR
//
//  Created by Rajshekar Pothu on 27/11/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class EndDrawerViewController: BaseViewController ,UITextFieldDelegate {
    
    var endDrawerDetailData = [DrawerHistoryModel]()
    @IBOutlet weak var tfActualInDrawer: UITextField!
    
    @IBOutlet var lblDrawerDescription: UILabel!
    @IBOutlet weak var lblStarted: UILabel!
    @IBOutlet weak var lblStartingCash: UILabel!
    @IBOutlet weak var lblPaidIn: UILabel!
    @IBOutlet weak var lblPaidOut: UILabel!
    @IBOutlet weak var lblExpectedInDrawer: UILabel!
    @IBOutlet weak var lblDifference: UILabel!
    @IBOutlet weak var lblCashSales: UILabel!
    @IBOutlet weak var lblCashRefund: UILabel!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var lblDrawerHead: UILabel!
    
    
    var strlblStartingCash = ""
    var strlblPaidIn = ""
    var strlblPaidOut = ""
    var strlblExpectedInDrawer = ""
    var strDescription = String()
    var lblExpectedInDrawerValue = Double()
    
    
    var endDrawerDelegate : DetailReportViewControllerDelegate?
    var currentDrawerDelegate : DetailReportViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("strDescription",strDescription)
        fillData()
        
        //tfActualInDrawer.setDollar(color: UIColor.HieCORColor.blue.colorWith(alpha: 1.0),font: tfActualInDrawer.font!)
    }
    
    func fillData() {
        
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            if endDrawerDetailData.count>0
            {
                for i in (0...endDrawerDetailData.count-1)
                {
                    lblStarted.text = endDrawerDetailData[i].started
                    strlblStartingCash = "$\(endDrawerDetailData[i].starting_cash)"
                    lblStartingCash.text = strlblStartingCash
                    strlblPaidIn = "$\(endDrawerDetailData[i].paid_in)"
                    lblPaidIn.text = strlblPaidIn
                    strlblPaidOut = "$\(endDrawerDetailData[i].paid_out)"
                    lblPaidOut.text = strlblPaidOut
                    //                    strlblExpectedInDrawer = "$\(endDrawerDetailData[i].expected_in_drawer)"
                    //                    lblExpectedInDrawer.text = strlblExpectedInDrawer
                    lblCashSales.text = "$\(endDrawerDetailData[i].cash_sales)"
                    lblCashRefund.text = "$\(endDrawerDetailData[i].cash_refunds)"
                    //   lblDifference.text = "$\(endDrawerDetailData[i].drawer_difference)"
                    
                    if strDescription == "" {
                        lblDrawerDescription.isHidden = true
                        lblDrawerHead.isHidden = true
                    } else {
                       lblDrawerDescription.text =  strDescription
                    }
                    var newValue = ""
                    let expected : String = (endDrawerDetailData[i].expected_in_drawer)
                    let replaced = expected.replacingOccurrences(of: ",", with: "")
                    var expected_in_drawer = (replaced as NSString).doubleValue
                    
                    if (expected_in_drawer < 0) {
                        expected_in_drawer = -(expected_in_drawer);
                        newValue = "-$\(expected_in_drawer.roundToTwoDecimal)"
                    } else {
                        newValue = "$\(expected_in_drawer.roundToTwoDecimal)"
                    }
                    lblExpectedInDrawer.text = newValue
                    
                    var newValue1 = ""
                    let diff : String = (endDrawerDetailData[i].drawer_difference)
                    let replaced1 = diff.replacingOccurrences(of: ",", with: "")
                    var drawer_difference = (replaced1 as NSString).doubleValue
                    
                    if (drawer_difference < 0) {
                        drawer_difference = -(drawer_difference);
                        newValue1 = "-$\(drawer_difference.roundToTwoDecimal)"
                    } else {
                        newValue1 = "$\(drawer_difference.roundToTwoDecimal)"
                    }
                    lblExpectedInDrawerValue = Double("\(drawer_difference.roundToTwoDecimal)") ?? 0
                    lblDifference.text = newValue1
                }
            }
            
            tfActualInDrawer.setRightPadding()
            
            let origImage = UIImage(named: "cancel")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            buttonCancel.setImage(tintedImage, for: .normal)
            buttonCancel.tintColor = UIColor(red: 11/255, green: 118/255, blue: 201/255, alpha: 1)
        }else{
            if endDrawerDetailData.count>0
            {
                for i in (0...endDrawerDetailData.count-1)
                {
                    lblStarted.text = endDrawerDetailData[i].started
                    strlblStartingCash = "$\(endDrawerDetailData[i].starting_cash)"
                    lblStartingCash.text = strlblStartingCash
                    strlblPaidIn = "$\(endDrawerDetailData[i].paid_in)"
                    lblPaidIn.text = strlblPaidIn
                    strlblPaidOut = "$\(endDrawerDetailData[i].paid_out)"
                    lblPaidOut.text = strlblPaidOut
                    //                    strlblExpectedInDrawer = "$\(endDrawerDetailData[i].expected_in_drawer)"
                    //                    lblExpectedInDrawer.text = strlblExpectedInDrawer
                    lblCashSales.text = "$\(endDrawerDetailData[i].cash_sales)"
                    lblCashRefund.text = "$\(endDrawerDetailData[i].cash_refunds)"
                    // lblDifference.text = "$\(endDrawerDetailData[i].drawer_difference)"
                    if strDescription == "" {
                        lblDrawerDescription.isHidden = true
                        lblDrawerHead.isHidden = true
                    } else {
                        lblDrawerDescription.text =  strDescription
                    }
                    var newValue = ""
                    let expected : String = (endDrawerDetailData[i].expected_in_drawer)
                    let replaced = expected.replacingOccurrences(of: ",", with: "")
                    var expected_in_drawer = (replaced as NSString).doubleValue
                    
                    if (expected_in_drawer < 0) {
                        expected_in_drawer = -(expected_in_drawer);
                        newValue = "-$\(expected_in_drawer.roundToTwoDecimal)"
                    } else {
                        newValue = "$\(expected_in_drawer.roundToTwoDecimal)"
                    }
		    
                    lblExpectedInDrawerValue = Double("\(expected_in_drawer.roundToTwoDecimal)") ?? 0
                    lblExpectedInDrawer.text = newValue
                    
                    var newValue1 = ""
                    let diff : String = (endDrawerDetailData[i].drawer_difference)
                    let replaced1 = diff.replacingOccurrences(of: ",", with: "")
                    var drawer_difference = (replaced1 as NSString).doubleValue
                    
                    if (drawer_difference < 0) {
                        drawer_difference = -(drawer_difference);
                        newValue1 = "-$\(drawer_difference.roundToTwoDecimal)"
                    } else {
                        newValue1 = "$\(drawer_difference.roundToTwoDecimal)"
                    }
                    lblDifference.text = newValue1
                }
            }
            
            tfActualInDrawer.setRightPadding()
            
            let origImage = UIImage(named: "cancel")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            buttonCancel.setImage(tintedImage, for: .normal)
            buttonCancel.tintColor = UIColor(red: 11/255, green: 118/255, blue: 201/255, alpha: 1)
        }
        
    }
    func showAlertForExpectedInDrawerValue() {
        let alert = UIAlertController(title: "Alert", message: "Expected amount is not equal to enter actual amount.",         preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "CONFIRM & CONTINUE", style: UIAlertActionStyle.default, handler: { _ in
            //Action CONFIRM & CONTINUE
           // self.showAlertForPrint()
            self.loadEndDrawer()
        }))
        alert.addAction(UIAlertAction(title: "GO BACK & RECOUNT",
                                      style: UIAlertActionStyle.default,
                                      handler: {(_: UIAlertAction!) in
                                        //action GO BACK & RECOUNT
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func showAlertForPrint() {
        let alert = UIAlertController(title: "Would you like to print an end-of-day report?", message: "",         preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { _ in
            // Action Yes
        }))
        alert.addAction(UIAlertAction(title: "No",
                                      style: UIAlertActionStyle.default,
                                      handler: {(_: UIAlertAction!) in
                                        //action No
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Action:-
    @IBAction func buttonBackAction(_ sender: Any) {
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
        //        let returnData = ["hide":true] as [String : Any]
        //        currentDrawerDelegate?.didEndDrawerScreen?(with: returnData)
    }
    
    @IBAction func endDrawerAction(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            sender.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        let tfActualInDrawerDouble = (self.tfActualInDrawer.text! as NSString).doubleValue
        let inputStr:String = tfActualInDrawer.text ?? ""
        if  inputStr == "" || tfActualInDrawer.isEmpty || (inputStr as NSString).integerValue < 0 {
//            self.showAlert(message: "Please enter Amount.")
            appDelegate.showToast(message: "Please enter Amount.")
            return
        }else{
           
            if lblDifference.text == "$0.00" {
                loadEndDrawer()
            }else{
                showAlertForExpectedInDrawerValue()
            }
        }
        
    }
    
    func loadEndDrawer() {
        
        //Device Name
        var str_DeviceName = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
        if let name = DataManager.deviceNameText {
            str_DeviceName = name
        }
        
        let tfActualInDrawerob = tfActualInDrawer.text?.replacingOccurrences(of: "$", with: "")
        
        //Parameters
        let parameters: JSONDictionary = [
            "userID":DataManager.userID,
            "cashDrawerID":endDrawerDetailData[0].drawer_id,
            "status":"closed",
            "description":strDescription,
            "end_amount": tfActualInDrawerob ?? 0.0, //tfActualInDrawer.text ?? 0.0,
            "source":str_DeviceName
            
        ]
        //callAPItoStartDrawer
        self.callAPItoEndDrawer(parameters: parameters)
    }
    
    //MARK: API Methods
    
    func callAPItoEndDrawer(parameters: JSONDictionary) {
        HomeVM.shared.endDrawer(parameters: parameters) { (success, message, error) in
            if success == 1 {
                DataManager.isDrawerOpen = false
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DrawerEndedViewController") as! DrawerEndedViewController
                vc.str_DrawerId = self.endDrawerDetailData[0].drawer_id
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                if message != nil {
                    
                    if "Cash drawer # already closed" == "\(message!)" {
                        NotificationCenter.default.post(name: Notification.Name("CheckEndDrawerEnd"), object: nil)
                    }
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    
    //MARK: Textfield Delegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resetCustomError()
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    /*
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //  difference= actual - excepted
        let inputStr:String = tfActualInDrawer.text ?? ""
        if  inputStr == "" || tfActualInDrawer.isEmpty || (inputStr as NSString).integerValue <= 0 {
            //lblDifference.text = "$0.00"
            textField.resignFirstResponder()
        }else{
            if endDrawerDetailData.count>0
            {
                for i in (0...endDrawerDetailData.count-1)
                {
                    let stringExpected:String = endDrawerDetailData[i].expected_in_drawer
                    
                    let replaced = stringExpected.replacingOccurrences(of: ",", with: "")
                    let expectedInDrawer = (replaced as NSString).doubleValue
                    
                    let actualInDrawer = Double(tfActualInDrawer.text!)!
                    if actualInDrawer > Double(expectedInDrawer){
                        var diff = actualInDrawer - Double(expectedInDrawer)
                        var newValue = ""
                        if (diff < 0) {
                            diff = -(diff);
                            newValue = "-$\(diff.roundToTwoDecimal)"
                        } else {
                            newValue = "$\(diff.roundToTwoDecimal)"
                        }
                        lblDifference.text = newValue
                        //lblDifference.text = "$\(String(diff.roundToTwoDecimal))"
                    }else{
                        var diff = actualInDrawer - Double(expectedInDrawer)
                        var newValue = ""
                        if (diff < 0) {
                            diff = -(diff);
                            newValue = "-$\(diff.roundToTwoDecimal)"
                        } else {
                            newValue = "$\(diff.roundToTwoDecimal)"
                        }
                        lblDifference.text = newValue
                        // lblDifference.text = "$\(String(diff.roundToTwoDecimal))"
                    }
                }
            }
            
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
  */
  //  by priya
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //  difference= actual - excepted
        let inputStr:String = tfActualInDrawer.text!
        if  inputStr == "" || tfActualInDrawer.isEmpty || (inputStr as NSString).integerValue <= 0 {
            //lblDifference.text = "$0.00"
            textField.resignFirstResponder()
        }else{
            if endDrawerDetailData.count>0
            {
                for i in (0...endDrawerDetailData.count-1)
                {
                    let stringExpected:String = endDrawerDetailData[i].expected_in_drawer

                    let replaced = stringExpected.replacingOccurrences(of: ",", with: "")
                    let expectedInDrawer = (replaced as NSString).doubleValue

                    let actualInDrawer = Double(tfActualInDrawer.text!)!
                    if actualInDrawer > Double(expectedInDrawer){
                        var diff = actualInDrawer - Double(expectedInDrawer)
                        var newValue = ""
                        if (diff < 0) {
                            diff = -(diff);
                            newValue = "-$\(diff.roundToTwoDecimal)"
                        } else {
                            newValue = "$\(diff.roundToTwoDecimal)"
                        }
                        lblDifference.text = newValue
                        //lblDifference.text = "$\(String(diff.roundToTwoDecimal))"
                    }else{
                        var diff = actualInDrawer - Double(expectedInDrawer)
                        var newValue = ""
                        if (diff < 0) {
                            diff = -(diff);
                            newValue = "-$\(diff.roundToTwoDecimal)"
                        } else {
                            newValue = "$\(diff.roundToTwoDecimal)"
                        }
                        lblDifference.text = newValue
                    }
                }
            }

        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }

        var newText = oldText.replacingCharacters(in: r, with: string)
        newText = newText.replacingOccurrences(of: "$", with: "")
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1

        let numberOfDecimalDigits: Int
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        if textField == tfActualInDrawer{

            if isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 {
                tfActualInDrawer.text = ""
                tfActualInDrawer.text = "$" + newText
                if newText != "" {
                    let value = Double(newText)! - Double(lblExpectedInDrawerValue)
                    
                    lblDifference.text = value.currencyFormat
                } else {
                    let value = 0 - Double(lblExpectedInDrawerValue)
                    
                    lblDifference.text = value.currencyFormat
                }
                
            }
            return false
        }
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        
        return true
    }
}
//MARK: DetailReportViewControllerDelegate
extension EndDrawerViewController: DetailReportViewControllerDelegate {
    
    func didEndDrawerScreen(with data: JSONDictionary)  {
        
        
    }
}
