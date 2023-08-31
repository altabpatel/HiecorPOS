//
//  CustomerPickupVC.swift
//  HieCOR
//
//  Created by Hiecor on 27/01/22.
//  Copyright © 2022 HyperMacMini. All rights reserved.
//

import UIKit

class CustomerPickupVC: BaseViewController {

    //MARK: - Outlet
    @IBOutlet weak var btnCompletePickup: UIButton!
    @IBOutlet weak var signView: EPSignatureView!
    @IBOutlet weak var txtNotes: UITextField!
    
    var signaturedata = ""
    var orderInfoModelObj = OrderInfoModel()
    var delegate: OrderInfoViewControllerDelegate?
    var customerPickupDelegete: CustomerPickupDelegete?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnCompletePickup.backgroundColor = UIColor.lightGray
        btnCompletePickup.isUserInteractionEnabled =  false
        txtNotes.delegate = self
        appDelegate.localBezierPath.removeAllPoints()
        NotificationCenter.default.addObserver(self, selector: #selector(self.signatureCheck(_:)), name: NSNotification.Name(rawValue: "notificationNameSignatureCheck"), object: nil)

        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        appDelegate.localBezierPath.removeAllPoints()
    }
    
    //MARK: - IBAction 
    @IBAction func btnClose_action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnClear_action(_ sender: Any) {
        self.btnCompletePickup.backgroundColor = UIColor.lightGray
        self.btnCompletePickup.isUserInteractionEnabled =  false
        self.signaturedata = ""
        signView.clear()
    }
    
    @IBAction func btnCompletePickUp_action(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sender.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
        }
        let param = ["order_id":orderInfoModelObj.orderID,
                     "custID":orderInfoModelObj.userID,
                     "notes":txtNotes.text ?? "",
                     "signature":signaturedata]
        
        self.saveCustomerPickupOrder(parm: param)
    }
    
    @objc func signatureCheck(_ notification: NSNotification) {
        var signaturedata = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let signature = self.signView.getSignatureAsImage(Size: self.signView.frame.height ) {
                // self.arrImage[indexPath.row] = signature
                signaturedata = signature.base64(format: .png)
                self.signaturedata = "data:image/png;base64,\(signaturedata)"
                if self.txtNotes.text == "" || signaturedata == "" {
                    self.btnCompletePickup.backgroundColor = UIColor.lightGray
                    self.btnCompletePickup.isUserInteractionEnabled =  false
                }else {
                    self.btnCompletePickup.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                    self.btnCompletePickup.isUserInteractionEnabled =  true
                }
            }
        }
        
    }
    
    
    //MARK:- API Method
    func saveCustomerPickupOrder(parm:JSONDictionary) {
        OrderVM.shared.saveCustomerPickupOrder(parameters: parm) { (success, message, error) in
            if success == 1 {
                if UI_USER_INTERFACE_IDIOM() == .phone {
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                  //  if UI_USER_INTERFACE_IDIOM() == .pad {
                        self.delegate?.didGetOrderInformation?(with: self.orderInfoModelObj.orderID, defualtView: false)
                    self.customerPickupDelegete?.didMoveToOrderInfoForCustomerPickup?()
                    self.dismiss(animated: false, completion: nil)
                   // }
                })
            }else {
                
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                }
                
                if message != nil {
                    appDelegate.showToast(message: message!)
                } else {
                    self.showErrorMessage(error: error)
                }
                
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CustomerPickupVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtNotes
        {
            if let text = txtNotes.text,
                let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange,with: string)
                print(updatedText)
                if updatedText == "" || signaturedata == "" {
                    btnCompletePickup.backgroundColor = UIColor.lightGray
                    btnCompletePickup.isUserInteractionEnabled =  false
                    return true
                }else {
                    btnCompletePickup.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                    btnCompletePickup.isUserInteractionEnabled =  true
                }
                
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
        
    }
}
