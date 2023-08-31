//
//  SignatureAndReceiptViewController.swift
//  HieCOR
//
//  Created by Hiecor on 19/02/21.
//  Copyright © 2021 HyperMacMini. All rights reserved.
//

import Foundation

class SignatureAndReceiptViewController: BaseViewController, SWRevealViewControllerDelegate {
    
    //MARK: IBOutlet
    @IBOutlet var tbl_Settings: UITableView!
    
    //MARK: Variables
    private var array_List = Array<Any>()
    private var array_iconsList = Array<Any>()
    
    //MARK: Delegate
    var signatureAndReceiptDelegate: SettingViewControllerDelegate?
    
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        array_List = ["Signature On Screen", "Signature On EMV Reader","Collect Signature On Every Order", "Receipt"]
        tbl_Settings.rowHeight = 50
        
    }
    
    @IBAction func signAndReceipBackAction(_ sender: Any) {
        signatureAndReceiptDelegate?.didMoveToNextScreen?(with: "Checkout Options")
        
    }
    
    @objc func btn_switchAction(sender: UISwitch)
    {
        if sender.tag == 0 {
            DataManager.signature = sender.isOn
        }
        if sender.tag == 1 {
            DataManager.isSingatureOnEMV = sender.isOn
        }
        if sender.tag == 2 {
            DataManager.posCollectSignatureOnEveryOrder = sender.isOn
        }
        if sender.tag == 3 {
            DataManager.receipt = sender.isOn
        }
        
    }
}
//MARK: UITableViewDataSource, UITableViewDelegate
extension SignatureAndReceiptViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_Settings.dequeueReusableCell(withIdentifier: "SettingsTableCell", for: indexPath) as! SettingsTableCell
        
        let lbl_Name = cell.contentView.viewWithTag(1) as? UILabel
        let switchBtn = cell.contentView.viewWithTag(2) as? UISwitch
        lbl_Name?.text = array_List[indexPath.row] as? String
        
        if indexPath.row == 0 {
            switchBtn?.setOn(DataManager.signature, animated: false)
        }
        if indexPath.row == 1 {
            switchBtn?.setOn(DataManager.isSingatureOnEMV, animated: false)
        }
        if indexPath.row == 2 {
            switchBtn?.setOn(DataManager.posCollectSignatureOnEveryOrder, animated: false)
        }
        if indexPath.row == 3 {
            switchBtn?.setOn(DataManager.receipt, animated: false)
        }
        switchBtn?.addTarget(self, action:#selector(btn_switchAction(sender:)), for: .touchUpInside)
        switchBtn?.tag = indexPath.row
        
        return cell
    }
    
    
}



