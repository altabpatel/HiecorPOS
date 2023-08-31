//
//  LedPairingViewController.swift
//  EMVSDKSwiftTestApp
//
//  Created by Abhiram Dinesh on 11/20/19.
//  Copyright © 2019 Ingenico. All rights reserved.
//

import UIKit

class LedPairingViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIImageView!
    
    var confirmationCallback: RUALedPairingConfirmationCallback?
    var ledSequence:[Any] = []
    var ledPairingView : RUALedPairingView?
    var delegateCallvalue : ingenicoCancelViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ledArrayWidth = containerView.frame.size.width/3
        ledPairingView = RUALedPairingView(frame: CGRect(x: ledArrayWidth, y: ledArrayWidth/3, width: ledArrayWidth, height: ledArrayWidth/4))
        containerView.addSubview(ledPairingView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ledPairingView?.showSequences(ledSequence)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        if UI_USER_INTERFACE_IDIOM() == .phone {
            Indicator.sharedInstance.showIndicatorforMoby()
        }
        Indicator.sharedInstance.hideIndicator()
        confirmationCallback?.cancel()
        self.dismiss(animated: true, completion: nil)
        
        delegateCallvalue?.didTapOnCancelButton()
        
        //let vc = CancelErrorViewcontroller()
//        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        //self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func restart(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        self.dismiss(animated: true) {
            if UI_USER_INTERFACE_IDIOM() == .phone {
                Indicator.sharedInstance.showIndicatorforMoby()
            }
            self.confirmationCallback?.restartLedPairingSequence()
        }
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        confirmationCallback?.confirm()
        if UI_USER_INTERFACE_IDIOM() == .phone {
            Indicator.sharedInstance.showIndicatorforMoby()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
