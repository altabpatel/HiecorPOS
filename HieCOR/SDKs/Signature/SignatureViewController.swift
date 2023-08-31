//
//  SignatureViewController.swift
//  PaymentsModule
//
//  Created by HTS on 3/22/18.
//  Copyright © 2018 HTS. All rights reserved.
//

import UIKit

protocol EPSignatureDelegateono : class {
    func epSignature(_: SignatureViewController, didSign signatureImage : UIImage, boundingRect: CGRect)
}

class SignatureViewController: BaseViewController {
    
    //MARK: IBOutlet
    @IBOutlet var signView: EPSignatureView!
    @IBOutlet weak var viewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    //MARK: Variables
    var signatureDelegateone: EPSignatureDelegate?
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewHeight()
    }
    
    //Private Functions
    private func updateViewHeight() {
        if UI_USER_INTERFACE_IDIOM() == .phone {
            if UIScreen.main.bounds.size.width < 414.0 {
                viewWidthConstraint.constant = UIScreen.main.bounds.size.width - 40
            }
        }else {
            if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
                viewWidthConstraint.constant = UIScreen.main.bounds.size.width - 200
                viewHeightConstraint.constant = UIScreen.main.bounds.size.height - 200
            }else {
                viewWidthConstraint.constant = UIScreen.main.bounds.size.width - 100
                viewHeightConstraint.constant = 450
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        updateViewHeight()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: IBAction
    @IBAction func signatureDoneTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if let signature = signView.getSignatureAsImage(Size: 400) {
            //signatureDelegateone?.epSignature(self, didSign: signature, boundingRect: signView.getSignatureBoundsInCanvas())
            dismiss(animated: true, completion: nil)
        } else {
//            showAlert(message: "Please draw your signature")
            appDelegate.showToast(message: "Please draw your signature")
        }
    }
    
    @IBAction func btn_signatureClearAction(_ sender: Any) {
        signView.clear()
    }
    
    @IBAction func signatureCancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
