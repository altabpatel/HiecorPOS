//
//  TransactionsInfoViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 06/12/17.
//  Copyright © 2017 HyperMacMini. All rights reserved.
//

import UIKit

class TransactionsInfoViewController: BaseViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var view_NavHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view_NavHeader: UIView!
    @IBOutlet weak var lbl_StatusForIpad: UILabel!
    @IBOutlet weak var lbl_TotalAmountForIpad: UILabel!
    @IBOutlet weak var lbl_TransactionIdForIPad: UILabel!
    @IBOutlet weak var view_TransactionIdAndAmountHeightConstraintForIPad: NSLayoutConstraint!
    @IBOutlet weak var view_TransactionIdAndAmountForIpad: UIView!
    @IBOutlet weak var lbl_TransactionId: UILabel!
    @IBOutlet weak var lbl_TotalAmount: UILabel!
    @IBOutlet weak var tbl_TransactionInfo: UITableView!
    @IBOutlet var lbl_Status: UILabel!
    
    //MARK: Variables
    var transactionInfo = TransactionsDetailModel()
    var orderInfoDelegate : OrderInfoViewControllerDelegate?
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeUI()
        self.updateUI()
        self.tbl_TransactionInfo.reloadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UI_USER_INTERFACE_IDIOM() == .pad ? .default : .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    //MARK: Private Functions
    private func customizeUI() {
        
        lbl_Status.layer.borderWidth = 1.0
        lbl_Status.layer.borderColor = UIColor.init(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0).cgColor
        lbl_Status.layer.cornerRadius = 15
        lbl_Status.layer.masksToBounds = true
        
        lbl_StatusForIpad.layer.borderWidth = 1.0
        lbl_StatusForIpad.layer.borderColor = UIColor.init(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0).cgColor
        lbl_StatusForIpad.layer.cornerRadius = 15
        lbl_StatusForIpad.layer.masksToBounds = true
        
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            self.view_NavHeaderHeightConstraint.constant = 0.0
            self.view_TransactionIdAndAmountHeightConstraintForIPad.constant = 65.0
            self.view_TransactionIdAndAmountForIpad.isHidden = false
        }
        else
        {
            self.view_NavHeaderHeightConstraint.constant = 200.0
            self.view_TransactionIdAndAmountHeightConstraintForIPad.constant = 0.0
            self.view_TransactionIdAndAmountForIpad.isHidden = true
        }
        
        tbl_TransactionInfo.tableFooterView = UIView()
    }
    
    private func updateUI() {
        self.lbl_StatusForIpad.text = transactionInfo.approval
        self.lbl_TotalAmountForIpad.text = transactionInfo.amount.currencyFormat
        self.lbl_TransactionIdForIPad.text = "#\(transactionInfo.txnId)"
        
        self.lbl_Status.text = transactionInfo.approval
        self.lbl_TotalAmount.text = transactionInfo.amount.currencyFormat
        self.lbl_TransactionId.text = "#\(transactionInfo.txnId)"
        self.updateLabelColor()
        self.tbl_TransactionInfo.reloadData()
    }
    
    private func updateLabelColor() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if transactionInfo.approval == "Approved" {
                lbl_StatusForIpad?.layer.borderColor = UIColor.init(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0).cgColor
                lbl_StatusForIpad?.backgroundColor = UIColor.init(red: 206.0/255.0, green: 245.0/255.0, blue: 213.0/255.0, alpha: 1.0)
                lbl_StatusForIpad?.textColor = UIColor.init(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0)
            }else {
                lbl_StatusForIpad?.layer.borderColor = UIColor.init(red: 220.0/255.0, green: 142.0/255.0, blue: 139.0/255.0, alpha: 1.0).cgColor
                lbl_StatusForIpad?.backgroundColor = UIColor.init(red: 245.0/255.0, green: 211.0/255.0, blue: 206.0/255.0, alpha: 1.0)
                lbl_StatusForIpad?.textColor = UIColor.init(red: 220.0/255.0, green: 142.0/255.0, blue: 139.0/255.0, alpha: 1.0)
            }
        }else {
            if transactionInfo.approval == "Approved" {
                lbl_Status?.layer.borderColor = UIColor.init(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0).cgColor
                lbl_Status?.backgroundColor = UIColor.init(red: 206.0/255.0, green: 245.0/255.0, blue: 213.0/255.0, alpha: 1.0)
                lbl_Status?.textColor = UIColor.init(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0)
            }else {
                lbl_Status?.layer.borderColor = UIColor.init(red: 220.0/255.0, green: 142.0/255.0, blue: 139.0/255.0, alpha: 1.0).cgColor
                lbl_Status?.backgroundColor = UIColor.init(red: 245.0/255.0, green: 211.0/255.0, blue: 206.0/255.0, alpha: 1.0)
                lbl_Status?.textColor = UIColor.init(red: 220.0/255.0, green: 142.0/255.0, blue: 139.0/255.0, alpha: 1.0)
            }
        }
    }
    
    //MARK: IBAction
    @IBAction func btn_CancelActionForIpad(_ sender: Any)
    {
        let txnData = ["hide":true] as [String : Any]
        orderInfoDelegate?.didUpdateTransactionScreen?(with: txnData)
    }
    
    @IBAction func btn_BackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: OrderInfoViewControllerDelegate
extension TransactionsInfoViewController: OrderInfoViewControllerDelegate {
    func didUpdateTransactionScreen(with data: JSONDictionary) {
        if let transactionDetail = data["data"] as? TransactionsDetailModel {
            self.transactionInfo = transactionDetail
        }
        self.updateUI()
        self.tbl_TransactionInfo.reloadData()
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension TransactionsInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let img_Icon = cell.contentView.viewWithTag(1) as? UIImageView
        let lbl_Name = cell.contentView.viewWithTag(2) as? UILabel
        let lbl_Value = cell.contentView.viewWithTag(3) as? UILabel
        
        if indexPath.row == 0 {
            img_Icon?.image = UIImage(named:"order")
            lbl_Name?.text = "OrderId"
            lbl_Value?.text = "#\(transactionInfo.orderId)"
        }
        else if(indexPath.row == 1)
        {
            img_Icon?.image = UIImage(named:"status")
            lbl_Name?.text = "Status"
            lbl_Value?.text = transactionInfo.approval
        }
        else if(indexPath.row == 2)
        {
            img_Icon?.image = UIImage(named:"payment-type")
            lbl_Name?.text = "Payment Type"
            lbl_Value?.text = transactionInfo.paymentType
        }
        else if(indexPath.row == 3)
        {
            img_Icon?.image = UIImage(named:"card-type")
            lbl_Name?.text = "Card Type"
            lbl_Value?.text = transactionInfo.cardType
        }
        else if(indexPath.row == 4)
        {
            img_Icon?.image = UIImage(named:"merchant")
            lbl_Name?.text = "Merchant"
            lbl_Value?.text = transactionInfo.merchant
        }
        else if(indexPath.row == 5)
        {
            img_Icon?.image = UIImage(named:"merchant-transaction")
            lbl_Name?.text = "Merchant Transaction"
            lbl_Value?.text = transactionInfo.merchantTxnId
        }
        else if(indexPath.row == 6)
        {
            img_Icon?.image = UIImage(named:"date")
            lbl_Name?.text = "Date"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let newDate = dateFormatter.date(from: transactionInfo.dateAdded) ?? Date()
            
            lbl_Value?.text = newDate.stringFromDate(format: .newDateTime1, type: .local) // Date formate chnage (23 nov 2022)
            
        }
        else if(indexPath.row == 7)
        {
            img_Icon?.image = UIImage(named:"authorization-code")
            lbl_Name?.text = "Authorization Code"
            lbl_Value?.text = transactionInfo.authCode
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat =  (UIScreen.main.bounds.height - view_NavHeaderHeightConstraint.constant) / 8
        return height > 80 ? 80 : height
    }
}

