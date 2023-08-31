//
//  RefundViewViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 16/04/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import Alamofire

class RefundViewViewController: BaseViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var btn_4CheckTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lbl_4CheckTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var view_LastBorderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var btn_4CheckHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view_LastBoarder: UIView!
    @IBOutlet weak var lbl_1FullRefund: UILabel!
    @IBOutlet weak var lbl_2PartialRefund: UILabel!
    @IBOutlet weak var lbl_3VoidOrder: UILabel!
    @IBOutlet weak var lbl_4Check: UILabel!
    @IBOutlet weak var lbl_4CheckHeightConsatrint: NSLayoutConstraint!
    @IBOutlet weak var txt_Notes: UITextView!
    @IBOutlet weak var tf_partialAmount: UITextField!
    @IBOutlet weak var btn_1FullRefund: UIButton!
    @IBOutlet weak var btn_4Check: UIButton!
    @IBOutlet weak var btn_3VoidOrder: UIButton!
    @IBOutlet weak var btn_2PartialRefund: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var selectTransactionTextField: UITextField!
    @IBOutlet weak var selectTransactionHeight: NSLayoutConstraint!
    @IBOutlet weak var selectTransactionLineView: UIView!
    @IBOutlet weak var fullRefundTopConstraint: NSLayoutConstraint!
    
    //MARK: Variables
    private var isAction = Bool()
    private var isSubscription = Bool()
    private var isRefundBy = Bool()
    
    private var isbtn_1FullRefundAction = Bool()
    private var isbtn_2PartialRefundAction = Bool()
    private var isbtn_3VoidOrderAction = Bool()
    private var isbtn_4CheckAction = Bool()
    
    private var isbtn_1FullRefundSubscription = Bool()
    private var isbtn_2PartialRefundSubscription = Bool()
    private var isbtn_3VoidOrderSubscription = Bool()
    private var isbtn_4CheckSubscription = Bool()
    
    private var isbtn_1FullRefundRefundBy = Bool()
    private var isbtn_2PartialRefundRefundBy = Bool()
    private var isbtn_3VoidOrderRefundBy = Bool()
    private var isbtn_4CheckRefundBy = Bool()
    
    var isSubscriptionShow = Bool()
    var selectedTransaction = String()
    var selectedTransactionId = String()
    var tracnsctionID = String()
    var orderID = String()
    var total = String()
    var transactionList = [TransactionList]()
    var transactionModel = [TransactionsModel]()
    var transactionListArray = [String]()
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeValues()
        callAPItoGetTransactionList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Set Segment
        if isSubscriptionShow {
            segmentControl.replaceSegments(segments: ["Action", "Subscriptions", "Refund By"])
        }else {
            segmentControl.replaceSegments(segments: ["Action", "Refund By"])
        }
        segmentControl.selectedSegmentIndex = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Private Functions
    private func initializeValues() {
        txt_Notes.delegate = self
        selectTransactionTextField.delegate = self
        self.tf_partialAmount.delegate = self
        self.tf_partialAmount.keyboardType = .decimalPad
        selectTransactionTextField.setDropDown()
        selectTransactionTextField.setPlaceholder()
        self.lbl_1FullRefund.text = "Full Refund"
        self.lbl_2PartialRefund.text = "Partial Refund"
        self.lbl_3VoidOrder.text = "Void Order"
        
        self.totalLabel.text = "$" + total
        isAction = true
        isSubscription = false
        isRefundBy = false
        tf_partialAmount.isHidden = true
        segmentControl.selectedSegmentIndex = 0
        btn_4CheckHeightConstraint.constant = 0.0
        lbl_4CheckHeightConsatrint.constant = 0.0
        view_LastBorderHeightConstraint.constant = 0.0
        lbl_4CheckTopConstraint.constant = 0.0
        btn_4CheckTopConstraint.constant = 0.0
        btn_4Check.isHidden = true
        
        isbtn_1FullRefundAction = true
        btn_1FullRefund.setImage( UIImage(named:"checkbox-checked"), for: .normal)
        btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
        btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
        btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
        
        isbtn_1FullRefundRefundBy = selectedTransaction.lowercased() == "credit"
        isbtn_2PartialRefundRefundBy = selectedTransaction.lowercased() == "cash"
        isbtn_3VoidOrderRefundBy = selectedTransaction.lowercased() == "external"
        isbtn_4CheckRefundBy = selectedTransaction.lowercased() == "check"
        
    }
    
    private func isValueSelected() -> (Bool, Bool , Bool) {
        var returnValue = (false, false, false)
        
        if isbtn_1FullRefundAction || isbtn_2PartialRefundAction || isbtn_3VoidOrderAction{
            returnValue.0 = true
        }
        
        if !isSubscriptionShow {
            returnValue.1 = true
        }else {
            if isbtn_1FullRefundSubscription || isbtn_2PartialRefundSubscription || isbtn_3VoidOrderSubscription {
                returnValue.1 = true
            }
        }
        
        if isbtn_1FullRefundRefundBy || isbtn_2PartialRefundRefundBy || isbtn_3VoidOrderRefundBy || isbtn_4CheckRefundBy {
            returnValue.2 = true
        }
        
        return returnValue
    }
    
    func getParameters() -> JSONDictionary {
        var action = String()
        var sub_action = String()
        var transaction_type = String()
        var partialAmount = String()
        
        partialAmount = ""
        if isbtn_1FullRefundAction == true
        {
            action = "full_refund"
        }
        else if isbtn_2PartialRefundAction == true
        {
            action = "part_refund"
            partialAmount = tf_partialAmount.text?.replacingOccurrences(of: "$", with: "") ?? "0.00"
            
        }else if isbtn_3VoidOrderAction == true
        {
            action = ""
        }
        else
        {
            action = ""
        }
        
        if (isbtn_1FullRefundSubscription == true)
        {
            sub_action = "cancel_all"
        }
        else if (isbtn_2PartialRefundSubscription == true)
        {
            sub_action = "cancel_order"
        }
        else if (isbtn_3VoidOrderSubscription == true)
        {
            sub_action = "no_change"
        }
        
        if (isbtn_1FullRefundRefundBy == true)
        {
            transaction_type = "credit"
        }
        else if (isbtn_2PartialRefundRefundBy == true)
        {
            transaction_type = "cash"
        }
        else if (isbtn_3VoidOrderRefundBy == true)
        {
            transaction_type = "external"
        }
        if (isbtn_4CheckRefundBy == true)
        {
            transaction_type = "check"
        }
        else
        {
            transaction_type = ""
        }
        
        let parameters: Parameters = [
            "order_id": orderID,
            "txn_id": selectedTransactionId,
            "action": action,
            "amount": partialAmount,
            "sub_action": sub_action,
            "note": txt_Notes.text ?? "",
            "transaction_type": transaction_type
        ]
        return parameters
    }
    
    //MARK: IBAction
    @IBAction func segmentedControlAction(_ sender: Any)
    {
        self.view.endEditing(true)
        if self.segmentControl.selectedSegmentIndex == 0
        {
            isAction = true
            isSubscription = false
            isRefundBy = false
            tf_partialAmount.isHidden = true
            btn_4Check.isHidden = true
            totalLabel.isHidden = false
            self.lbl_1FullRefund.text = "Full Refund"
            self.lbl_2PartialRefund.text = "Partial Refund"
            self.lbl_3VoidOrder.text = "Void Order"
            
            btn_4CheckHeightConstraint.constant = 0.0
            lbl_4CheckHeightConsatrint.constant = 0.0
            view_LastBorderHeightConstraint.constant = 0.0
            lbl_4CheckTopConstraint.constant = 0.0
            btn_4CheckTopConstraint.constant = 0.0
            
            selectTransactionLineView.isHidden = false
            selectTransactionTextField.isHidden = false
            fullRefundTopConstraint.constant = 30.0
            selectTransactionHeight.constant = 30.0
            
            
            if(isbtn_1FullRefundAction == true)
            {
                btn_1FullRefund.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
            else if(isbtn_2PartialRefundAction == true)
            {
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                tf_partialAmount.isHidden = false
            }
            else if(isbtn_3VoidOrderAction == true)
            {
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
            else
            {
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
            return
        }
        if isSubscriptionShow{
            if(self.segmentControl.selectedSegmentIndex == 1)
            {
                isAction = false
                isSubscription = true
                isRefundBy = false
                tf_partialAmount.isHidden = true
                btn_4Check.isHidden = true
                totalLabel.isHidden = true
                btn_4CheckHeightConstraint.constant = 0.0
                lbl_4CheckHeightConsatrint.constant = 0.0
                lbl_4CheckTopConstraint.constant = 0.0
                btn_4CheckTopConstraint.constant = 0.0
                view_LastBorderHeightConstraint.constant = 0.0
                
                selectTransactionLineView.isHidden = true
                selectTransactionTextField.isHidden = true
                fullRefundTopConstraint.constant = 0.0
                selectTransactionHeight.constant = 0.0
                
                self.lbl_1FullRefund.text = "Cancel all subscriptions associated with this user"
                self.lbl_2PartialRefund.text = "Cancel all subscriptions associated with this Order only"
                self.lbl_3VoidOrder.text = "No Change"
                
                if(isbtn_1FullRefundSubscription == true)
                {
                    btn_1FullRefund.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                    btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                }
                else if(isbtn_2PartialRefundSubscription == true)
                {
                    btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_2PartialRefund.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                    btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                }
                else if(isbtn_3VoidOrderSubscription == true)
                {
                    btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_3VoidOrder.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                    btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                }
                else
                {
                    btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                }
            }else {
                isAction = false
                isSubscription = false
                isRefundBy = true
                tf_partialAmount.isHidden = true
                btn_4Check.isHidden = false
                totalLabel.isHidden = true
                btn_4CheckHeightConstraint.constant = 22.5
                lbl_4CheckHeightConsatrint.constant = 20.5
                view_LastBorderHeightConstraint.constant = 2.0
                lbl_4CheckTopConstraint.constant = 33.0
                btn_4CheckTopConstraint.constant = 32.0
                
                selectTransactionLineView.isHidden = true
                selectTransactionTextField.isHidden = true
                fullRefundTopConstraint.constant = 0.0
                selectTransactionHeight.constant = 0.0
                
                self.lbl_1FullRefund.text = "Credit Card"
                self.lbl_2PartialRefund.text = "Cash"
                self.lbl_3VoidOrder.text = "External"
                self.lbl_4Check.text = "Check"
                
                if(isbtn_1FullRefundRefundBy == true)
                {
                    btn_1FullRefund.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                    btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                }
                else if(isbtn_2PartialRefundRefundBy == true)
                {
                    btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_2PartialRefund.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                    btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                }
                else if(isbtn_3VoidOrderRefundBy == true)
                {
                    btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_3VoidOrder.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                    btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                }
                else if(isbtn_4CheckRefundBy == true)
                {
                    btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_4Check.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                }
                else
                {
                    btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                    btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                }
            }
        } else {
            isAction = false
            isSubscription = false
            isRefundBy = true
            tf_partialAmount.isHidden = true
            btn_4Check.isHidden = false
            totalLabel.isHidden = true
            btn_4CheckHeightConstraint.constant = 22.5
            lbl_4CheckHeightConsatrint.constant = 20.5
            view_LastBorderHeightConstraint.constant = 2.0
            lbl_4CheckTopConstraint.constant = 33.0
            btn_4CheckTopConstraint.constant = 32.0
            
            selectTransactionLineView.isHidden = true
            selectTransactionTextField.isHidden = true
            fullRefundTopConstraint.constant = 0.0
            selectTransactionHeight.constant = 0.0
            
            self.lbl_1FullRefund.text = "Credit Card"
            self.lbl_2PartialRefund.text = "Cash"
            self.lbl_3VoidOrder.text = "External"
            self.lbl_4Check.text = "Check"
            
            if(isbtn_1FullRefundRefundBy == true)
            {
                btn_1FullRefund.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
            else if(isbtn_2PartialRefundRefundBy == true)
            {
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
            else if(isbtn_3VoidOrderRefundBy == true)
            {
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
            else if(isbtn_4CheckRefundBy == true)
            {
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-checked"), for: .normal)
            }
            else
            {
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
        }
    }
    
    @IBAction func btn_1FullRefundAction(_ sender: Any)
    {
        tf_partialAmount.isHidden = true
        if isAction == true
        {
            if(isbtn_1FullRefundAction == false)
            {
                isbtn_1FullRefundAction = true
                isbtn_2PartialRefundAction = false
                isbtn_3VoidOrderAction = false
                isbtn_4CheckAction = false
                
                btn_1FullRefund.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
            else
            {
                isbtn_1FullRefundAction = false
                isbtn_2PartialRefundAction = false
                isbtn_3VoidOrderAction = false
                isbtn_4CheckAction = false
                
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
        }
        else if(isSubscription == true)
        {
            if(isbtn_1FullRefundSubscription == false)
            {
                isbtn_1FullRefundSubscription = true
                isbtn_2PartialRefundSubscription = false
                isbtn_3VoidOrderSubscription = false
                isbtn_4CheckSubscription = false
                
                btn_1FullRefund.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
            else
            {
                isbtn_1FullRefundSubscription = false
                isbtn_2PartialRefundSubscription = false
                isbtn_3VoidOrderSubscription = false
                isbtn_4CheckSubscription = false
                
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
        }
        else if(isRefundBy == true)
        {
            if(isbtn_1FullRefundRefundBy == false)
            {
                isbtn_1FullRefundRefundBy = true
                isbtn_2PartialRefundRefundBy = false
                isbtn_3VoidOrderRefundBy = false
                isbtn_4CheckRefundBy = false
                
                btn_1FullRefund.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
            else
            {
                isbtn_1FullRefundRefundBy = false
                isbtn_2PartialRefundRefundBy = false
                isbtn_3VoidOrderRefundBy = false
                isbtn_4CheckRefundBy = false
                
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
        }
    }
    
    @IBAction func btn_2PartialRefund(_ sender: Any)
    {
        if isAction == true
        {
            tf_partialAmount.isHidden = false
            
            if(isbtn_2PartialRefundAction == false)
            {
                isbtn_1FullRefundAction = false
                isbtn_2PartialRefundAction = true
                isbtn_3VoidOrderAction = false
                isbtn_4CheckAction = false
                
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                tf_partialAmount.isHidden = false
            }
            else
            {
                isbtn_1FullRefundAction = false
                isbtn_2PartialRefundAction = false
                isbtn_3VoidOrderAction = false
                isbtn_4CheckAction = false
                tf_partialAmount.isHidden = true
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
        }
        else if(isSubscription == true)
        {
            if(isbtn_2PartialRefundSubscription == false)
            {
                isbtn_1FullRefundSubscription = false
                isbtn_2PartialRefundSubscription = true
                isbtn_3VoidOrderSubscription = false
                isbtn_4CheckSubscription = false
                
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
            else
            {
                isbtn_1FullRefundSubscription = false
                isbtn_2PartialRefundSubscription = false
                isbtn_3VoidOrderSubscription = false
                isbtn_4CheckSubscription = false
                
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
        }
        else if(isRefundBy == true)
        {
            if(isbtn_2PartialRefundRefundBy == false)
            {
                isbtn_1FullRefundRefundBy = false
                isbtn_2PartialRefundRefundBy = true
                isbtn_3VoidOrderRefundBy = false
                isbtn_4CheckRefundBy = false
                
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
            else
            {
                isbtn_1FullRefundRefundBy = false
                isbtn_2PartialRefundRefundBy = false
                isbtn_3VoidOrderRefundBy = false
                isbtn_4CheckRefundBy = false
                
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
        }
    }
    
    @IBAction func btn_3VoidOrder(_ sender: Any)
    {
        tf_partialAmount.isHidden = true
        if isAction == true
        {
            if(isbtn_3VoidOrderAction == false)
            {
                isbtn_1FullRefundAction = false
                isbtn_2PartialRefundAction = false
                isbtn_3VoidOrderAction = true
                isbtn_4CheckAction = false
                
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
            else
            {
                isbtn_1FullRefundAction = false
                isbtn_2PartialRefundAction = false
                isbtn_3VoidOrderAction = false
                isbtn_4CheckAction = false
                
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
        }
        else if(isSubscription == true)
        {
            if(isbtn_3VoidOrderSubscription == false)
            {
                isbtn_1FullRefundSubscription = false
                isbtn_2PartialRefundSubscription = false
                isbtn_3VoidOrderSubscription = true
                isbtn_4CheckSubscription = false
                
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
            else
            {
                isbtn_1FullRefundSubscription = false
                isbtn_2PartialRefundSubscription = false
                isbtn_3VoidOrderSubscription = false
                isbtn_4CheckSubscription = false
                
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
        }
        else if(isRefundBy == true)
        {
            if(isbtn_3VoidOrderRefundBy == false)
            {
                isbtn_1FullRefundRefundBy = false
                isbtn_2PartialRefundRefundBy = false
                isbtn_3VoidOrderRefundBy = true
                isbtn_4CheckRefundBy = false
                
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-checked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
            else
            {
                isbtn_1FullRefundRefundBy = false
                isbtn_2PartialRefundRefundBy = false
                isbtn_3VoidOrderRefundBy = false
                isbtn_4CheckRefundBy = false
                
                btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
                btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            }
        }
    }
    
    @IBAction func btn_4CheckAction(_ sender: Any)
    {
        tf_partialAmount.isHidden = true
        if(isbtn_4CheckAction == false)
        {
            isbtn_1FullRefundRefundBy = false
            isbtn_2PartialRefundRefundBy = false
            isbtn_3VoidOrderRefundBy = false
            isbtn_4CheckRefundBy = true
            
            btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            btn_4Check.setImage( UIImage(named:"checkbox-checked"), for: .normal)
        }
        else
        {
            isbtn_1FullRefundRefundBy = false
            isbtn_2PartialRefundRefundBy = false
            isbtn_3VoidOrderRefundBy = false
            isbtn_4CheckRefundBy = false
            
            btn_1FullRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            btn_2PartialRefund.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            btn_3VoidOrder.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
            btn_4Check.setImage( UIImage(named:"checkbox-unchecked"), for: .normal)
        }
    }
    
    @IBAction func btn_RefundAction(_ sender: Any)
    {
        self.view.endEditing(true)
        //Validate Data
        if transactionList.count > 0 {
            if selectTransactionTextField.text == "" {
                selectTransactionTextField.setCustomError(text: "Please select Transaction.",bottomSpace: 0)
                return
            }
        }
        
        let valueSelected = isValueSelected()
        
        if !valueSelected.0 {
            showAlert(message: "Please select an Action.")
            return
        }
        
        if isbtn_2PartialRefundAction && tf_partialAmount.text == "" {
            tf_partialAmount.setCustomError(text: "Please enter Amount.",bottomSpace: 5, isRightSide: true)
            return
        }
        
        if !valueSelected.1 {
            showAlert(message: "Please select Subscriptions.")
            return
        }
        
        if !valueSelected.2 {
            showAlert(message: "Please select Refund By.")
            return
        }
        
        if txt_Notes.text == "" {
            txt_Notes.setCustomError(text: "Please enter Note.",bottomSpace: 5)
            return
        }
        
        //Refund
        callAPItoRefund()
    }
    
    @IBAction func btn_CancelAction(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: UITextFieldDelegate
extension RefundViewViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == selectTransactionTextField {
            textField.resetCustomError(isAddAgain: false)
            textField.tintColor = UIColor.clear
            self.pickerDelegate = self
            if transactionListArray.count > 0 {
                textField.text = transactionListArray[0]
                selectedTransactionId = self.transactionModel[0].txn_id
                self.setPickerView(textField: textField, array: transactionListArray)
            }else {
                textField.resignFirstResponder()
                self.showAlert(message: "No transaction found.")
            }
        }
        if textField == tf_partialAmount {
            textField.resetCustomError(isAddAgain: false)
            if textField.text != "" {
                textField.text = textField.text?.replacingOccurrences(of: "$", with: "")
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == tf_partialAmount {
            let amount = Double(textField.text?.replacingOccurrences(of: "$", with: "") ?? "0.00") ?? 0.00
            textField.text = "$" + amount.roundToTwoDecimal
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tf_partialAmount {
            let currentText = textField.text ?? ""
            
            let newText = NSString(string: textField.text!).replacingCharacters(in: range, with: string).replacingOccurrences(of: "$", with: "")
            
            let totalTextFieldAmount = Float(newText) ?? 0
            let totalAmount = Float(total) ?? 0
            
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return replacementText.isValidDecimal(maximumFractionDigits: 2) && totalTextFieldAmount <= totalAmount
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}

//MARK: UITextViewDelegate
extension RefundViewViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.resetCustomError(isAddAgain: false)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

//MARK: HieCORPickerDelegate
extension RefundViewViewController: HieCORPickerDelegate {
    func didSelectPickerViewAtIndex(index: Int) {
        if transactionListArray.count > 0 {
            pickerTextfield.text = transactionListArray[index]
            selectedTransactionId = self.transactionModel[index].txn_id
        }
    }
    
    func didClickOnPickerViewDoneButton() {
        //...
    }
    
    func didClickOnPickerViewCancelButton() {
        pickerTextfield.text = ""
    }
    
}
//MARK: API Methods
extension RefundViewViewController {
    func callAPItoRefund() {
        let parameters = getParameters()
        OrderVM.shared.refundOrder(parameters: parameters, responseCallBack: { (success, message, error) in
            if success == 1 {
                self.showAlert(title: "Alert", message: "Refund initiated successfully.", otherButtons: nil, cancelTitle: "Okay", cancelAction: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
            }else {
                if message != nil {
                    self.showAlert(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
    
    func callAPItoGetTransactionList() {
        OrderVM.shared.getTransactionInfo(orderId: orderID, responseCallBack: { (success, message, error) in
            if success == 1 {
//                self.transactionModel = OrderVM.shared.transactionInfo
                self.transactionListArray = [String]()
                //
                for list in self.transactionModel {
                    self.transactionListArray.append("\("$" + list.amount + " - Order: " + list.order_id + " Tran: " + list.txn_id + " " + list.approval + " " + list.date_added + " PDT")")
                }
                //
                if self.transactionListArray.count > 0 {
                    if self.selectedTransactionId == "" {
                        self.selectTransactionTextField.text = self.transactionListArray[0]
                        self.selectedTransactionId = self.transactionModel[0].txn_id
                        self.total = self.transactionModel[0].amount
                        self.totalLabel.text = "$" + self.total
                    }else {
                        if let index = self.transactionModel.index(where: {$0.txn_id == self.selectedTransactionId}) {
                            self.selectTransactionTextField.text = self.transactionListArray[index]
                            self.selectedTransactionId = self.transactionModel[index].txn_id
                            self.total = self.transactionModel[index].amount
                            self.totalLabel.text = "$" + self.total
                        }
                    }
                }
                
            }else {
                if message != nil {
                    self.showAlert(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
}
