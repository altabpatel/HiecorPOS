//
//  StarCloudPRNTListPopupVC.swift
//  HieCOR
//
//  Created by Hiecor on 24/09/21.
//  Copyright © 2021 HyperMacMini. All rights reserved.
//

import UIKit

class StarCloudPRNTListPopupVC: BaseViewController {

    @IBOutlet weak var popupViewWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var tblView: UITableView!
    var delegate : StarCloudPRNTVCDelegate?
    var selectTextField = UITextField()
    var editPrinterNameIndex = Int()
    var editPrinterName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if UI_USER_INTERFACE_IDIOM() == .phone {
            popupViewWidthConstant.constant = 380
        } else {
            popupViewWidthConstant.constant = 480
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClose_action(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func btnPrintReceipt_action(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        delegate?.didTapOnStarCloudPrintButton()
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
//MARK: UITableViewDataSource, UITableViewDelegate
extension StarCloudPRNTListPopupVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  HomeVM.shared.starCloudPrinterModel.arrprinter_list_value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "SettingsTableCell", for: indexPath) as! SettingsTableCell
        
        cell.viewStarCloudPrnt.isHidden = false
        cell.backgroundColor = UIColor.white
        if DataManager.isGooglePrinter == true  {
            
            if HomeVM.shared.starCloudPrinterModel.arrprinter_list_value.count > 0 {
                cell.viewStarCloudPrnt.isHidden = false
                cell.txtStarPrinterName.text = HomeVM.shared.starCloudPrinterModel.arrprinter_list_value[indexPath.row].name
                cell.txtStarPrinterName.isUserInteractionEnabled = false
                // cell.txtStarPrinterName.becomeFirstResponder()
                cell.btnEdit.tag = indexPath.row
                cell.btnEdit.addTarget(self, action: #selector(btn_EditStarCloudPRNTNameAction(sender:)), for: .touchUpInside)
                cell.btnDefault.tag = indexPath.row
                cell.btnDefault.addTarget(self, action: #selector(btn_DefaultStarCloudPRNTNameAction(sender:)), for: .touchUpInside)
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    cell.lblMacAdrsMob.text = HomeVM.shared.starCloudPrinterModel.arrprinter_list_value[indexPath.row].printerMAC
                    cell.lblMacAdrs.text = ""
                }else{
                    cell.lblMacAdrs.text = HomeVM.shared.starCloudPrinterModel.arrprinter_list_value[indexPath.row].printerMAC
                    cell.lblMacAdrsMob.text = ""
                }
                if DataManager.starCloudMACaAddress == HomeVM.shared.starCloudPrinterModel.arrprinter_list_value[indexPath.row].printerMAC {
                    cell.btnDefault.backgroundColor = UIColor.init(red: 11/255, green: 118/255, blue: 201/255, alpha: 1.0)
                    cell.btnDefault.setTitleColor(.white, for: .normal)
                    cell.btnCheckMark.setImage(UIImage.init(named: "check-select"), for: .normal)
                    cell.txtStarPrinterName.textColor = UIColor.init(red: 11/255, green: 118/255, blue: 201/255, alpha: 1.0)
                }else {
                    cell.btnDefault.backgroundColor = UIColor.white
                    cell.btnDefault.setTitleColor(UIColor.init(red: 11/255, green: 118/255, blue: 201/255, alpha: 1.0), for: .normal)
                    cell.btnCheckMark.setImage(UIImage.init(named: "check-unselect"), for: .normal)
                    cell.txtStarPrinterName.textColor = UIColor.darkGray
                }
                //                if editPrinterNameIndex == indexPath.row.description {
                //                    cell.txtStarPrinterName.isUserInteractionEnabled = true
                //                   // cell.txtStarPrinterName.becomeFirstResponder()
                //                }
                return cell
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    @objc func btn_DefaultStarCloudPRNTNameAction(sender: UIButton) {
        if HomeVM.shared.starCloudPrinterModel.arrprinter_list_value.count > 0 {
            DataManager.starCloudMACaAddress =  HomeVM.shared.starCloudPrinterModel.arrprinter_list_value[sender.tag].printerMAC
            tblView.reloadData()
        }
    }
    
    @objc func btn_EditStarCloudPRNTNameAction(sender: UIButton) {

        editPrinterNameIndex = sender.tag
        let macAddress = HomeVM.shared.starCloudPrinterModel.arrprinter_list_value[editPrinterNameIndex].printerMAC
        let alert = UIAlertController(title: "Edit Printer name", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
         //   self.discountTextField = textField
          //  textField.delegate = self
            textField.keyboardType = .default
            textField.text = HomeVM.shared.starCloudPrinterModel.arrprinter_list_value[self.editPrinterNameIndex].name
            textField.placeholder =  "Please enter printer name"
            textField.tag = 3000
            textField.selectAll(nil)
        }
        alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            self.editPrinterName = textField.text ?? ""
           // self.handleDiscount(textField: textField)
            self.callAPItoUpdatePrinterName(cloudPrinterAddress: macAddress, cloudPrinterName: textField.text ?? "")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            //self.catAndProductDelegate?.hideView?(with:  "alertblurcancel")
            
        }))
       // self.catAndProductDelegate?.hideView?(with:  "alertblur")
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:- API Method
    func callAPItoUpdatePrinterName(cloudPrinterAddress: String, cloudPrinterName: String){
        HomeVM.shared.getUpdatePrinterName(cloudPrinterAddress: cloudPrinterAddress, cloudPrinterName: cloudPrinterName) { (success, message, error) in
            if success == 1 {
                DispatchQueue.main.async {
                    appDelegate.showToast(message: message ?? "")
                    HomeVM.shared.starCloudPrinterModel.arrprinter_list_value[self.editPrinterNameIndex].name = self.editPrinterName
                    print( HomeVM.shared.starCloudPrinterModel)
                    self.tblView.reloadData()
                }
               
            }else {
                if message != nil {
                    //                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    
}
