//
//  PaymentModeMenuViewController.swift
//  PaymentsModule
//
//  Created by HTS on 3/22/18.
//  Copyright © 2018 HTS. All rights reserved.
//

import UIKit

class PaymentModeMenuViewController: BaseViewController
{
    //MARK: IBOutlet
    @IBOutlet weak var creditCardButton: UIButton!
    @IBOutlet var cashButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var externalButton: UIButton!
    @IBOutlet weak var externalGiftcardButton: UIButton!
    @IBOutlet weak var internalGiftcardButton: UIButton!
    @IBOutlet weak var giftCardButton: UIButton!
    @IBOutlet weak var achCheckButton: UIButton!
    @IBOutlet weak var paxButton: UIButton!
    @IBOutlet var paymentTypeRightConstrian: NSLayoutConstraint!
    
    //MARK: Variables
    var delegate: PaymentModeMenuDelegate?
    static var hiddenButtonstags = [Int]()
    var isCashOn = true
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PaymentModeMenuViewController.dismissMenuboard))
        view.addGestureRecognizer(tap)
        //Hide All Buttons
        hideAllButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customizeUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.didDismiss()
    }
    
    //Private Functions
    private func customizeUI() {
        paymentTypeRightConstrian.constant = UI_USER_INTERFACE_IDIOM() == .pad ? 380 : 15
        if let sectionArray = DataManager.selectedPayment {
            creditCardButton.isHidden = !sectionArray.contains("CREDIT")
            if isCashOn {
                cashButton.isHidden = !sectionArray.contains("CASH")
            }
            checkButton.isHidden = !sectionArray.contains("CHECK")
            externalButton.isHidden = !sectionArray.contains("EXTERNAL")
            externalGiftcardButton.isHidden = !sectionArray.contains("EXTERNAL GIFT CARD")
            internalGiftcardButton.isHidden = !sectionArray.contains("INTERNAL GIFT CARD")
            giftCardButton.isHidden = !sectionArray.contains("GIFT CARD")
            achCheckButton.isHidden = !sectionArray.contains("ACH CHECK")
            paxButton.isHidden = !sectionArray.contains("PAX PAY")
        }
    }
    
    private func hideAllButtons() {
        creditCardButton.isHidden = true
        cashButton.isHidden = true
        checkButton.isHidden = true
        externalButton.isHidden = true
        externalGiftcardButton.isHidden = true
        internalGiftcardButton.isHidden = true
        giftCardButton.isHidden = true
        achCheckButton.isHidden = true
        paxButton.isHidden = true
    }
    
    //MARK: IBAction Method
    @IBAction func paymentModeTapped(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
        delegate?.paymentModeMenu(sender: sender, selctedIndex: sender.tag)
    }
    
    @objc func dismissMenuboard()
    {
        dismiss(animated: true, completion: nil)
        delegate?.didDismiss()
    }
    
}

//MARK: MultiCardContainerViewControllerDelegate
extension PaymentModeMenuViewController: MultiCardContainerViewControllerDelegate {
    func didHideButton(with tag: Int, isHidden: Bool) {
        PaymentModeMenuViewController.hiddenButtonstags.append(tag)
    }
}
