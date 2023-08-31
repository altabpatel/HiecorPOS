//
//  NotesContainerViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 21/03/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class NotesContainerViewController: BaseViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var txt_Notes: UITextView!
    
    //MARK: Variables
    var delegate: PaymentTypeContainerViewControllerDelegate?
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTextView()
        //
        if UI_USER_INTERFACE_IDIOM() == .phone {
            MultiCardContainerViewController.isClassLoaded = false
        }
        //Update Previous Data If Available
        if let key = PaymentsViewController.paymentDetailDict["key"] as? String, key.lowercased() == "notes" {
            if let data = PaymentsViewController.paymentDetailDict["data"] as? JSONDictionary {
                txt_Notes.text = data["notes"] as? String ?? ""
                txt_Notes.textColor = UIColor.black
            }
        }
    }
    
    //MARK: Private Functions
    private func setupTextView() {
        txt_Notes.delegate = self
        txt_Notes.text = "Enter note here..."
        txt_Notes.textColor =  UIColor.lightGray
    }
    
}

//MARK: UITextFieldDelegate
extension NotesContainerViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Enter note here..."
            textView.textColor = UIColor.lightGray
        }
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            textView.resignFirstResponder()
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

//MARK: PaymentTypeDelegate
extension NotesContainerViewController: PaymentTypeDelegate {
    
    func saveData() {
        self.view.endEditing(true)
        PaymentsViewController.paymentDetailDict["data"] = ["notes":txt_Notes.text ?? ""]
    }
    
    
    func sendNotesData(isIPad: Bool) {
        let Obj = ["notes":txt_Notes.text ?? ""]
        delegate?.getPaymentData?(with: Obj)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.delegate?.placeOrderForIpad?(with: 1 as AnyObject) //1 for pass dummy value// not for use
        }
    }
    
    func reset() {
        txt_Notes.text = "Enter note here..."
        txt_Notes.textColor = UIColor.lightGray
    }
    
}
