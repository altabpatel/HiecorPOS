//
//  AppVersionViewController.swift
//  HieCOR
//
//  Created by Hiecor Software on 02/01/20.
//  Copyright © 2020 HyperMacMini. All rights reserved.
//

import UIKit

class AppVersionViewController: UIViewController {

    @IBOutlet weak var btnNotNow: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if DataManager.isShowUpdateNow{
            btnNotNow.isHidden = false
        }else{
            btnNotNow.isHidden = true
        }
    }
    
    @IBAction func actionUpdateApp(_ sender: Any) {
        if let url = URL(string: "https://apps.apple.com/us/app/hiecor-point-of-sale-pos/id1227631152"),
            UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    @IBAction func actionNotNow(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
