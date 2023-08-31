//
//  CancelErrorViewcontroller.swift
//  HieCOR
//
//  Created by Hiecor on 22/09/21.
//  Copyright © 2021 HyperMacMini. All rights reserved.
//

import Foundation

import UIKit

class CancelErrorViewcontroller: UIViewController {

    
    @IBOutlet weak var viewErrorShow: UIView!
    @IBOutlet weak var viewCancelShow: UIView!
    @IBOutlet weak var lblNameDevice: UILabel!
    
    var isErrorShow = false
    var strName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNameDevice.text = "Reader:" + strName
        if isErrorShow == true {
            viewErrorShow.isHidden = false
            viewCancelShow.isHidden = true
        } else {
            viewErrorShow.isHidden = true
            viewCancelShow.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func OK_Action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
