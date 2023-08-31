//
//  PopViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 30/11/17.
//  Copyright © 2017 HyperMacMini. All rights reserved.
//

import UIKit

class PopViewController: BaseViewController {
    
    //MARK: Variables
    var delegate:PopOverEditDelegate? = nil
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: IBAction Method
    @IBAction func btn_EditAction(_ sender: Any) {
        delegate?.editButtonClicked(isClicked: true)
    }
    
}
