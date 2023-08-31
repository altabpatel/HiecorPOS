//
//  ChangeDeviceNamePopupVC.swift
//  HieCOR
//
//  Created by hiecor on 26/04/21.
//  Copyright © 2021 HyperMacMini. All rights reserved.
//

import UIKit

class ChangeDeviceNamePopupVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtDeviceName: UITextField!
    var delegate: ChangeDeviceNamePopupVCDelegate?
    var arrFilert = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let name = DataManager.deviceNameText {
            txtDeviceName.text = name
        }else {
            let nameDevice = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
            txtDeviceName.text = nameDevice//UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
        }
        txtDeviceName.delegate = self
        txtDeviceName.becomeFirstResponder()
        txtDeviceName.addDoneOnKeyboardWithTarget(self, action: #selector(doneButtonClicked))
    }
    
    @IBAction func btnCancel_action(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.6745098039, green: 0.1607843137, blue: 0.1450980392, alpha: 0.8)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sender.backgroundColor = #colorLiteral(red: 0.6745098039, green: 0.1607843137, blue: 0.1450980392, alpha: 1)
        }
        delegate?.deviceNamePopHide?()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnDoneAction(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sender.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
        }
        self.delegate?.deviceNameUpdatePopup?(with: txtDeviceName.text!)
        
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
         self.delegate?.deviceNameUpdatePopup?(with: txtDeviceName.text!)
    }
    
}
extension ChangeDeviceNamePopupVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFilert.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = (arrFilert[indexPath.row]).condenseWhitespace()
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        txtDeviceName.text = (arrFilert[indexPath.row]).condenseWhitespace()
        //arrFilert.removeAllObjects()
        arrFilert.removeAll()
        delegate?.deviceNamePopHieght?(with: Float(121))
        tblView.reloadData()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
}
extension ChangeDeviceNamePopupVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField == txtDeviceName
        {
            if let text = txtDeviceName.text,
                let textRange = Range(range, in: text) {
                var updatedText = text.replacingCharacters(in: textRange,with: string)
                print(updatedText)
                if updatedText == "" {
                    arrFilert.removeAll()
                    delegate?.deviceNamePopHieght?(with: Float(121 + 45*arrFilert.count))
                    tblView.reloadData()
                    return true
                }
       
                // search code by Sudama -------Start------
                updatedText = updatedText.trimmingCharacters(in: .whitespaces).condenseWhitespace()
                arrFilert.removeAll()
                var isSpaceInVal = true
                let spaceCount = updatedText.filter{$0 == " "}.count
                if spaceCount > 0 {
                    isSpaceInVal = false
                }
                for i in 0..<HomeVM.shared.sourcesList.count {
                    let strVal = HomeVM.shared.sourcesList[i]
                    let strArry = strVal.split(separator: " ")
                    if strArry.count > 0 && isSpaceInVal {
                        
                        for ar in strArry {
                            if (ar.lowercased)().hasPrefix(updatedText.lowercased()) {
                                arrFilert.append(HomeVM.shared.sourcesList[i])
                                break
                            }
                        }
                    }else{
                        if (HomeVM.shared.sourcesList[i].lowercased()).hasPrefix(updatedText.lowercased()) {
                            arrFilert.append(HomeVM.shared.sourcesList[i])
                        }
                    }
                    
                }
                
                // search code by sudama -------End------
                
                delegate?.deviceNamePopHieght?(with: Float(121 + 45*arrFilert.count))
                tblView.reloadData()
     
                
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
        
    }
}
extension String {
    func caseInsensitiveHasPrefix(_ prefix: String) -> Bool {
        return range(of: prefix, options: [.diacriticInsensitive, .caseInsensitive,.anchored]) != nil
    }
}
