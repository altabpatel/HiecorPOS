//
//  RefundViewController.swift
//  HieCOR
//
//  Created by Deftsoft on 10/12/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class RefundViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var cancelAllUserSubscriptionButton: UIButton!
    @IBOutlet weak var cancelAllOrderSubscriptionButton: UIButton!
    @IBOutlet weak var noChangeButton: UIButton!
    @IBOutlet weak var cancelAllUserSubscriptionLabel: UILabel!
    @IBOutlet weak var cancelAllOrderSubscriptionLabel: UILabel!
    @IBOutlet weak var noChangeLabel: UILabel!
    @IBOutlet weak var subscriptionView: UIView!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet var stackViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var buttonWidth: NSLayoutConstraint!
    @IBOutlet weak var tableFooterView: UIView!
    @IBOutlet weak var btnProcess: UIButton!
    
    //MARK: Variables
    var orderInfoDelegate: OrderInfoViewControllerDelegate?
    var orderInfoModelObj = OrderInfoModel()
    var refundOrderByDataModelObj = RefundOrderDataModel()
    var returnToStockButton: UIButton?
    var isLandscape = false
    var array = [AnyObject]()
    var arrayPax = [AnyObject]()//[String]()
    var transMethodObj = TransactionsDetailModel()
    var showPayment  = [String]()
    var showPax  = [String]()
    var showPaymentCell  = [String]()
    var showPaxCell  = [String]()
    var textViewPlaceholder = String()
    var selectedIndexOther = Int()
    var indexPathOther = NSIndexPath()
    var selectedIndexing:[String] = []
    private var array_ItemList = Array<Any>()
    var showItems = [String]()
    var isChangeRefundType = false
    
    
    var indexPayment = Int()
    var indexPax = Int()
    var indexItem = Int()
    var indexCell = 0
    var indexCellItem = 0
    var indexCellPax = 0
    var ischeckPax = false
    var indexPathAll = NSIndexPath()
    var indexPathItem = NSIndexPath()
    var isCheckItem = false
    
    var indexQuantity = Int()
    var indexPathQuantity = NSIndexPath()
    
    var strProductQty = [String]()
    var strStatusItem : NSMutableArray = []
    var strOtherItem : NSMutableArray = []
    var arrReturnStock : NSMutableArray = []
    
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set Delegate To Self
        notesTextView.delegate = self
        //
        if UI_USER_INTERFACE_IDIOM() == .pad {
            tabelView.tableFooterView = UIView()
        }
        updateRefundScreen()
        array_ItemList = ["New/UnOpened", "New/Open Box", "Used", "Damaged","Other"]
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.view.endEditing(true)
        self.updateUI()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.tabelView.reloadData()
        }
    }
    
    //MARK: Private Functions
    private func updateUI() {
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
                stackViewTrailingConstraint.isActive = false
                buttonWidth.isActive = true
                buttonWidth.constant = 200
            }else {
                stackViewTrailingConstraint.isActive = true
                buttonWidth.isActive = false
            }
            self.updateTableUI()
            self.tabelView.reloadData()
        }
    }
    
    private func updateRefundScreen() {
        print(strStatusItem)
        indexCellItem = 0
        notesTextView.text = textViewPlaceholder
        notesTextView.textColor = #colorLiteral(red: 0.6430795789, green: 0.6431742311, blue: 0.6430588365, alpha: 1)
        if orderInfoModelObj.isSubscription == false && UI_USER_INTERFACE_IDIOM() == .phone {
            tabelView.tableFooterView?.frame.size = CGSize(width: tabelView.frame.width, height: CGFloat(117.5))
            // tabelView.tableFooterView?.frame.size = CGSize(width: tabelView.frame.width, height: CGFloat(300))
        }
        cancelAllUserSubscriptionButton.isSelected = false
        cancelAllOrderSubscriptionButton.isSelected = false
        noChangeButton.isSelected = true
        returnToStockButton = nil
        // priya
        //self.array = self.orderInfoModelObj.refundPaymentTypeArray
        self.array = self.orderInfoModelObj.transactionArray
        if self.arrayPax != nil{
            self.arrayPax = self.orderInfoModelObj.paxDeviceListRefund
        }
        print("array Transaction ", self.array)
        print("array Pax ", self.arrayPax)
        self.subscriptionView.isHidden = !self.orderInfoModelObj.isSubscription
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            if orderInfoModelObj.productsArray.count > 0 {
                showItems.removeAll()
                strStatusItem.removeAllObjects()
                strOtherItem.removeAllObjects()
                arrReturnStock.removeAllObjects()
                for i in orderInfoModelObj.productsArray {
                    strStatusItem.add("Unopened")
                    strOtherItem.add("")
                    arrReturnStock.add(true)
                }
            }
        }
        
        self.tabelView.reloadData()
    }
    
    
    private func updateTableUI() {
        self.tabelView.alpha = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.tabelView.alpha = 1.0
        })
    }
    
    private func getParameters() -> JSONDictionary {
        
        var transactionsArray = JSONArray()
        var itemsArray = JSONArray()
        var paxDeviceArray = JSONArray()
        
        strProductQty.removeAll()
        
        for i in 0..<orderInfoModelObj.productsArray.count {
            
            let indexPath = IndexPath(item: i, section: 2)
            let cell = self.tabelView?.cellForRow(at: indexPath) as? ItemsValueCell
            strProductQty.append(cell?.txfProductqauntity.text ?? "0")
            strOtherItem.replaceObject(at: i, with: cell?.tfOther.text ?? "")
        }
        print(strProductQty)
        
        for transaction in orderInfoModelObj.transactionArray {
            var dict = JSONDictionary()
            dict["txn_id"] = transaction.txnId
            dict["card_type"] = transaction.cardType
            dict["amount"] = transaction.isVoidSelected ? "" : transaction.isFullRefundSelected ? transaction.availableRefundAmount.roundToTwoDecimal : transaction.partialAmount.replacingOccurrences(of: "$", with: "")
            dict["type"] =  transaction.isFullRefundSelected ? "full_refund" : transaction.isVoidSelected ? "void" : "part_refund"
            if isChangeRefundType {
                dict["refund_by"] = pickerTextfield.text
            }else{
                dict["refund_by"] = transaction.manualPaymentType == "" ? transaction.type == "" ? showPayment.contains("Credit") ? "Credit" : showPayment.first : transaction.type  : transaction.manualPaymentType.capitalized
            }
            
           // orderInfoModelObj.transactionArray[indexPayment].selectPaymentIndex
            var dictOne = JSONDictionary()
            
            if orderInfoModelObj.paxDeviceListRefund.count > 0 {
                let hh = orderInfoModelObj.paxDeviceListRefund[indexPayment]
                
                dictOne["pax_terminal_device_name"] = hh.pax_terminal_device_name
                dictOne["pax_terminal_port"] = hh.pax_terminal_port
                dictOne["pax_terminal_url"] = hh.pax_terminal_url
                let obj:[String] = ["EMV"]
                print(obj)
                
                let objIndex:[String] = [showPaymentCell[indexCell]]
                
                if objIndex == obj{
                    paxDeviceArray.append(dictOne)
                }
                transactionsArray.append(contentsOf: paxDeviceArray)
            }
            transactionsArray.append(dict)
        }
        
        for i in 0..<orderInfoModelObj.productsArray.count {
            var dict = JSONDictionary()
            dict["id"] = orderInfoModelObj.productsArray[i].productID
            dict["title"] = orderInfoModelObj.productsArray[i].title
            dict["qty"] = strProductQty[i]
            dict["actual_qty"] = orderInfoModelObj.productsArray[i].qty
            dict["price"] =  orderInfoModelObj.productsArray[i].price
            dict["product_amount"] = orderInfoModelObj.productsArray[i].mainPrice
            dict["salesId"] = orderInfoModelObj.productsArray[i].salesID
            dict["man_price"] = orderInfoModelObj.productsArray[i].mainPrice
            dict["attr_id"] = orderInfoModelObj.productsArray[i].attribute
            dict["man_desc"] = orderInfoModelObj.productsArray[i].mainDesc
            dict["ship_condition"] = strStatusItem[i]
            dict["ship_other_condition"] = strOtherItem[i]
            dict["backToStock"] = arrReturnStock[i]
            
            itemsArray.append(dict)
        }
        
        
        var subAction = "no_change"
        
        if cancelAllUserSubscriptionButton.isSelected {
            subAction = "cancel_all"
        }
        
        if cancelAllOrderSubscriptionButton.isSelected {
            subAction = "cancel_order"
        }
        
        if !orderInfoModelObj.isSubscription {
            subAction = ""
        }
        
        let parameters: JSONDictionary = [
            "custID": orderInfoModelObj.userID,
            "orderId": orderInfoModelObj.orderID,
            "action": subAction,
            //"backToStock": returnToStockButton?.isSelected ?? true,
            "note": notesTextView.text ?? "",
            "transaction": transactionsArray,
            "product": itemsArray
        ]
        
        return parameters
    }
    
    //MARK: IBActions
    @IBAction func clearButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        notesTextView.text = ""
        notesTextView.resetCustomError(isAddAgain: false)
        returnToStockButton = nil
        
        cancelAllUserSubscriptionButton.isSelected = false
        cancelAllOrderSubscriptionButton.isSelected = false
        noChangeButton.isSelected = true
        
        self.tabelView.reloadData()
        self.view.endEditing(true)
        if UI_USER_INTERFACE_IDIOM() == .pad {
            orderInfoDelegate?.didHideRefundView?(isRefresh: false)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func processButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        
        if notesTextView.text == "" ||  notesTextView.text == "Type note here..." {
            notesTextView.setCustomError(text: "Please enter Note.",bottomSpace: 2)
            return
        }
        callAPItoRefund()
    }
    
    @IBAction func crossButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        
        indexCellItem = 0
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            orderInfoDelegate?.didHideRefundView?(isRefresh: false)
        } else {
            // self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelAllUserSubscriptionButtonAction(_ sender: Any) {
        cancelAllUserSubscriptionButton.isSelected = true
        cancelAllOrderSubscriptionButton.isSelected = false
        noChangeButton.isSelected = false
    }
    
    @IBAction func cancelAllOrderSubscriptionButtonAction(_ sender: Any) {
        cancelAllUserSubscriptionButton.isSelected = false
        cancelAllOrderSubscriptionButton.isSelected = true
        noChangeButton.isSelected = false
    }
    
    @IBAction func noChangeButtonAction(_ sender: Any) {
        cancelAllUserSubscriptionButton.isSelected = false
        cancelAllOrderSubscriptionButton.isSelected = false
        noChangeButton.isSelected = true
    }
    
    @objc func handleReturnBacktoStock(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            arrReturnStock.replaceObject(at: sender.tag, with: false)
        } else {
            arrReturnStock.replaceObject(at: sender.tag, with: true)
        }
        
        let indexPosition = IndexPath(row: sender.tag, section: 2)
        tabelView.reloadRows(at: [indexPosition], with: .none)
        
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension RefundViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return orderInfoModelObj.transactionArray.count
        case 1: return 1
        default: return orderInfoModelObj.productsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsCell", for: indexPath) as! TransactionTableCell
            cell.paymentNameLabel.text = orderInfoModelObj.transactionArray[indexPath.row].cardType == "" ? "      " : orderInfoModelObj.transactionArray[indexPath.row].cardType
            cell.paymentTypeLabel.text = orderInfoModelObj.transactionArray[indexPath.row].isFullRefundSelected ? "Full Refund" : orderInfoModelObj.transactionArray[indexPath.row].isVoidSelected ? "Void" : "Partial Refund"
            cell.amountLabel.text = orderInfoModelObj.transactionArray[indexPath.row].isVoidSelected ? orderInfoModelObj.transactionArray[indexPath.row].availableRefundAmount.currencyFormat : orderInfoModelObj.transactionArray[indexPath.row].isFullRefundSelected ? orderInfoModelObj.transactionArray[indexPath.row].availableRefundAmount.currencyFormat : (Double(orderInfoModelObj.transactionArray[indexPath.row].partialAmount) ?? 0.0).currencyFormat
            
            cell.textfield2.tag = indexPath.row
            cell.textfield2.setDropDown()
            
            cell.tfPaxDevice2.tag = indexPath.row
            cell.tfPaxDevice2.setDropDown()
            let arrval = self.orderInfoModelObj.transactionArray[indexPath.row].Payment_Method_arr
            showPaymentCell.removeAll()
            
            let dataPaymet = self.orderInfoModelObj.transactionArray[indexPath.row].type
            
            print(dataPaymet)
            
            for ob in arrval{
                let aa = ob.label
                showPaymentCell.append(aa)
            }
            
            let arrval2 = self.orderInfoModelObj.paxDeviceListRefund
            showPaxCell.removeAll()
            for ob in arrval2{
                let aa2 = ob.pax_terminal_device_name
                showPaxCell.append(aa2)
            }
            showPax.removeAll()
            if self.arrayPax != nil && showPaxCell != nil && showPaxCell.count != 0{
                let strVal = "\(DataManager.selectedPaxRefund?[0])"
                if showPaxCell.contains(strVal) {
                    cell.tfPaxDevice2.text = strVal
                } else {
                    if DataManager.selectedPaxDeviceName != "" {
                        if ischeckPax {
                            cell.tfPaxDevice2.text = showPaxCell[indexCellPax].lowercased()
                        }else{
                            cell.tfPaxDevice2.text = DataManager.selectedPaxDeviceName
                        }
                    }else{
                        cell.tfPaxDevice2.text = showPaxCell[indexCellPax].lowercased()
                    }
                    
                }
            }
            showPayment.removeAll()
            
            //cell.textfield2.text = showPaymentCell[self.orderInfoModelObj.transactionArray[indexPath.row].selectPaymentIndex]
            
            
            cell.textfield2.addTarget(self, action: #selector(handlePaymentTypeTextField(sender:)), for: .editingDidBegin)
            if self.arrayPax != nil && showPaxCell != nil{
                cell.tfPaxDevice2.addTarget(self, action: #selector(handlePaxTextField(sender:)), for: .editingDidBegin)
            }
            
            if UI_USER_INTERFACE_IDIOM() == .pad {
                cell.textfield1.tag = indexPath.row
                cell.textfield1.setDropDown()
                
                let arrval = self.orderInfoModelObj.transactionArray[indexPath.row].Payment_Method_arr
                showPaymentCell.removeAll()
                for ob in arrval{
                    let aa = ob.label
                    showPaymentCell.append(aa)
                }
                if self.arrayPax != nil && showPaxCell != nil {
                    let arrval2 = self.orderInfoModelObj.paxDeviceListRefund
                    showPaxCell.removeAll()
                    for ob in arrval2{
                        let aa2 = ob.pax_terminal_device_name
                        showPaxCell.append(aa2)
                    }
                }
                
                cell.textfield1.text = showPaymentCell[self.orderInfoModelObj.transactionArray[indexPath.row].selectPaymentIndex]
                
                
                if self.arrayPax != nil && showPaxCell != nil && showPaxCell.count != 0{
                    let strVal = "\(DataManager.selectedPaxRefund?[0])"
                    if showPaxCell.contains(strVal) {
                        cell.tfPaxDevice1.text = strVal
                    } else {
                        if DataManager.selectedPaxDeviceName != "" {
                            if ischeckPax {
                                cell.tfPaxDevice1.text = showPaxCell[indexCellPax].lowercased()
                            }else{
                                cell.tfPaxDevice1.text = DataManager.selectedPaxDeviceName
                            }
                            
                        }else{
                            cell.tfPaxDevice1.text = showPaxCell[indexCellPax].lowercased()
                        }
                        
                    }
                    
                    cell.tfPaxDevice1.tag = indexPath.row
                    cell.tfPaxDevice1.setDropDown()
                    cell.tfPaxDevice1.addTarget(self, action: #selector(handlePaxTextField(sender:)), for: .editingDidBegin)
                    
                }
                cell.textfield1.addTarget(self, action: #selector(handlePaymentTypeTextField(sender:)), for: .editingDidBegin)
                cell.textfield1.tag = indexPath.row
                let obj:[String] = ["EMV"]
                print(obj)
                let objPax:[String] = ["PAX"]
                print(objPax)
                let objIndex:[String] = [showPaymentCell[self.orderInfoModelObj.transactionArray[indexPath.row].selectPaymentIndex]]
                
                if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
                    print("Landscape")
                    cell.textfield1.isHidden = false
                    cell.textfield2.isHidden = true
                    cell.paymentTypeLabel.textAlignment = .left
                    if self.arrayPax != nil{
                        if objIndex == obj {
                            cell.tfPaxDevice1.isHidden = false
                            cell.tfPaxDevice2.isHidden = true
                        }else{
                            cell.tfpaxDevice1WidthCons.constant = 0
                            cell.tfpaxDevice2heightCons.constant = 0
                            cell.tfPaxDevice1.isHidden = true
                            cell.tfPaxDevice2.isHidden = true
                            cell.contentView.setNeedsLayout()
                            cell.contentView.setNeedsDisplay()
                        }
                    }
                }else {
                    print("Portarit")
                    cell.textfield1.isHidden = true
                    cell.textfield2.isHidden = false
                    cell.paymentTypeLabel.textAlignment = .right
                    if self.arrayPax != nil{
                        if objIndex == obj{
                            cell.tfPaxDevice2.isHidden = false
                            cell.tfPaxDevice1.isHidden = true
                            cell.tfpaxDevice2heightCons.constant = 35
                            cell.contentView.setNeedsLayout()
                            cell.contentView.setNeedsDisplay()
                            
                        }else{
                            cell.tfpaxDevice1WidthCons.constant = 0
                            cell.tfpaxDevice2heightCons.constant = 0
                            cell.tfPaxDevice1.isHidden = true
                            cell.tfPaxDevice2.isHidden = true
                            cell.contentView.setNeedsLayout()
                            cell.contentView.setNeedsDisplay()
                        }
                    }
                }
            } else {
                cell.textfield2.setPadding()
                cell.tfPaxDevice2.setPadding()
                cell.tfPaxDevice2.setDropDown()
                let obj:[String] = ["EMV"]
                print(obj)
                let objPax:[String] = ["PAX"]
                print(objPax)
                let objIndex:[String] = [showPaymentCell[self.orderInfoModelObj.transactionArray[indexPath.row].selectPaymentIndex]]
                
                if self.arrayPax != nil{
                    if objIndex == obj{
                        cell.tfPaxDevice2.isHidden = false
                        cell.tfpaxDevice2heightCons.constant = 26
                        cell.contentView.layoutIfNeeded()
                        cell.contentView.setNeedsLayout()
                        cell.contentView.setNeedsDisplay()
                        
                    }else{
                        cell.tfPaxDevice2.isHidden = true
                        cell.tfpaxDevice2heightCons.constant = 0
                        cell.contentView.layoutIfNeeded()
                        cell.contentView.setNeedsLayout()
                        cell.contentView.setNeedsDisplay()
                    }
                }
            }
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReturnToStock", for: indexPath)
            //            let returnToStock = cell.contentView.viewWithTag(101) as? UIButton
            //            returnToStock?.isSelected = returnToStockButton?.isSelected ?? true
            //            if UI_USER_INTERFACE_IDIOM() == .phone {
            //                returnToStock?.backgroundColor = returnToStock?.isSelected == true ? UIColor.init(red: 11/255, green: 118/255, blue: 201/255, alpha: 1.0) : UIColor.white
            //                returnToStock?.setTitleColor(returnToStock?.isSelected == true ? UIColor.white : UIColor.init(red: 11/255, green: 118/255, blue: 201/255, alpha: 1.0), for: .normal)
            //            }
            //            returnToStock?.addTarget(self, action: #selector(handleReturnToStockAction(sender:)), for: .touchUpInside)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsValueCell", for: indexPath) as! ItemsValueCell
            let obj = orderInfoModelObj.productsArray[indexPath.row].qty
            
            let qtyObj = Double(Int(orderInfoModelObj.productsArray[indexPath.row].qty))
            
            if obj > qtyObj {
                cell.txfProductqauntity.text = String(obj)
            } else {
                cell.txfProductqauntity.text = String(Int(orderInfoModelObj.productsArray[indexPath.row].qty))
            }
            cell.tfOther.delegate = self
            cell.lblProductName?.text = orderInfoModelObj.productsArray[indexPath.row].title
            cell.lblQuantity.text = ""
            
            cell.tfItems.tag = indexPath.row
            cell.tfItems.setPaddingleft()
            cell.tfItems.setDropDown()
            cell.tfItems.addTarget(self, action: #selector(handleItemsTextField(sender:)), for: .editingDidBegin)
            
            cell.btnReturnBacktoStock.tag = indexPath.row
            cell.btnReturnBacktoStock.addTarget(self, action: #selector(handleReturnBacktoStock(sender:)), for: .touchUpInside)
            
            cell.txfProductqauntity.addTarget(self, action: #selector(handleQuantityTypeTextField(sender:)), for: .editingDidBegin)
            cell.txfProductqauntity.tag = indexPath.row
            
            cell.tfOther.addTarget(self, action: #selector(handleTfOther(sender:)), for: .editingDidBegin)
            cell.tfOther.tag = indexPath.row
            cell.tfOther.isHidden = true
            if UI_USER_INTERFACE_IDIOM() == .phone {
                cell.tfOther.isHidden = true
                cell.tfItemHeightCons.constant = 0
                cell.contentView.layoutIfNeeded()
                cell.contentView.setNeedsLayout()
                cell.contentView.setNeedsDisplay()
            }
            
            let ob = strStatusItem[indexPath.row] as? String
            
            if  ob  == "Unopened"  {
                cell.tfItems.text = array_ItemList[0] as? String
                cell.tfOther.isHidden = true
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    cell.tfOther.isHidden = true
                    cell.tfItemHeightCons.constant = 0
                    cell.contentView.layoutIfNeeded()
                    cell.contentView.setNeedsLayout()
                    cell.contentView.setNeedsDisplay()
                }
            }else if ob  == "openbox"  {
                cell.tfItems.text = array_ItemList[1] as? String
                cell.tfOther.isHidden = true
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    cell.tfOther.isHidden = true
                    cell.tfItemHeightCons.constant = 0
                    cell.contentView.layoutIfNeeded()
                    cell.contentView.setNeedsLayout()
                    cell.contentView.setNeedsDisplay()
                }
            }else if ob  == "used"  {
                cell.tfItems.text = array_ItemList[2] as? String
                cell.tfOther.isHidden = true
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    cell.tfOther.isHidden = true
                    cell.tfItemHeightCons.constant = 0
                    cell.contentView.layoutIfNeeded()
                    cell.contentView.setNeedsLayout()
                    cell.contentView.setNeedsDisplay()
                }
            }else if ob  == "damaged"  {
                cell.tfItems.text = array_ItemList[3] as? String
                cell.tfOther.isHidden = true
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    cell.tfOther.isHidden = true
                    cell.tfItemHeightCons.constant = 0
                    cell.contentView.layoutIfNeeded()
                    cell.contentView.setNeedsLayout()
                    cell.contentView.setNeedsDisplay()
                }
            }else if ob  == "other"  {
                cell.tfItems.text = array_ItemList[4] as? String
                cell.tfOther.isHidden = false
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    cell.tfOther.isHidden = false
                    cell.tfItemHeightCons.constant = 32
                    cell.contentView.layoutIfNeeded()
                    cell.contentView.setNeedsLayout()
                    cell.contentView.setNeedsDisplay()
                }
            }
            
            let stock : Bool = arrReturnStock[indexPath.row] as! Bool
            
            if stock {
                cell.btnReturnBacktoStock?.isSelected = false
                cell.btnReturnBacktoStock.backgroundColor = #colorLiteral(red: 0, green: 0.6662763357, blue: 0.1810612977, alpha: 1)
                cell.btnReturnBacktoStock.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.btnReturnBacktoStock.cornerRadius = 4
                cell.btnReturnBacktoStock.borderWidth = 1
                cell.btnReturnBacktoStock.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for:UIControlState.normal)
                cell.btnReturnBacktoStock.titleEdgeInsets = UIEdgeInsets(top: 0, left: -7, bottom: 0, right: 0)
                cell.btnReturnBacktoStock.imageEdgeInsets = UIEdgeInsets(top: 0, left: 128, bottom: 0, right: 0)
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    cell.btnReturnBacktoStock.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
                    cell.btnReturnBacktoStock.imageEdgeInsets = UIEdgeInsets(top: 0, left: 115, bottom: 0, right: 0)
                }
                
            } else {
                cell.btnReturnBacktoStock?.isSelected = true
                //cell.btnReturnBacktoStock.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
                cell.btnReturnBacktoStock.borderColor = #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
                cell.btnReturnBacktoStock.cornerRadius = 4
                cell.btnReturnBacktoStock.borderWidth = 1
                cell.btnReturnBacktoStock.titleLabel?.textAlignment = NSTextAlignment.center
                cell.btnReturnBacktoStock.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.btnReturnBacktoStock.setTitleColor(#colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), for:UIControlState.normal)
                cell.btnReturnBacktoStock.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                cell.btnReturnBacktoStock.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                
                
                
                
                
            }
            
            let objOther : String = strOtherItem[indexPath.row] as! String
            cell.tfOther.text = objOther
            
            //            if UI_USER_INTERFACE_IDIOM() == .pad {
            //                if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            //                    print("Landscape")
            //                    cell.tfItems.frame.size.width = 150
            //                    cell.itemStackView.distribution = .fillProportionally
            //
            //                }else {
            //                    print("Portarit")
            //                    cell.itemStackView.distribution = .fillEqually
            //                }
            //            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return indexPath.section == 1 ? orderInfoModelObj.productsArray.count ==  0 ? 0 : 40 : UITableViewAutomaticDimension
        } else {
            return indexPath.section == 1 ? orderInfoModelObj.productsArray.count ==  0 ? 0 : UITableViewAutomaticDimension : UITableViewAutomaticDimension
            // return UITableViewAutomaticDimension
            
            
            
            //            switch indexPath.section {
            //            case 0:
            //
            //                if indexPath.row == 0{
            //                    return 90
            //                }else if indexPath.row == 1{
            //                    return 42
            //                }else if indexPath.row == 2{
            //                    return 80
            //                }
            //
            //            //case 1: return 1
            //            //default: return 40
            //            default:
            //                return 110 //UITableViewAutomaticDimension
            //            }
            
            //return UITableViewAutomaticDimension
        }
    }
    
    @objc func handlePaymentTypeTextField(sender: UITextField) {
        ischeckPax = false
        self.pickerDelegate = self
        indexPayment = sender.tag
        indexPathAll = NSIndexPath(row: indexPayment, section: 0)
        self.array = self.orderInfoModelObj.transactionArray[indexPayment].Payment_Method_arr
        showPayment.removeAll()
        for ob in self.array{
            let aa = ob as! PaymentMethodModel
            showPayment.append(aa.label)
        }
        self.setPickerView(textField: sender, array: showPayment)
    }
    
    @objc func handleQuantityTypeTextField(sender: UITextField) {
        indexQuantity = sender.tag
        indexPathQuantity = NSIndexPath(row: indexQuantity, section: 2)
    }
    
    @objc func handleTfOther(sender: UITextField) {
        selectedIndexOther = sender.tag
        indexPathOther = NSIndexPath(row: selectedIndexOther, section: 2)
    }
    
    @objc func handlePaxTextField(sender: UITextField) {
        ischeckPax = true
        self.pickerDelegate = self
        indexPax = sender.tag
        indexPathAll = NSIndexPath(row: indexPax, section: 0)
        //self.arrayPax = self.orderInfoModelObj.paxDeviceListRefund
        showPax.removeAll()
        for ob in self.arrayPax{
            let aa = ob as! PaxDevicesList
            showPax.append(aa.pax_terminal_device_name)
        }
        self.setPickerView(textField: sender, array: showPax)
    }
    
    
    
    @objc func handleItemsTextField(sender: UITextField) {
        ischeckPax = false
        isCheckItem = true
        self.pickerDelegate = self
        indexItem = sender.tag
        indexPathItem = NSIndexPath(row: indexItem, section: 2)
        showItems.removeAll()
        self.setPickerView(textField: sender, array: array_ItemList as! [String])
    }
    
    //    @objc func handleReturnToStockAction(sender: UIButton) {
    //        sender.isSelected = !sender.isSelected
    //        if UI_USER_INTERFACE_IDIOM() == .phone {
    //            sender.backgroundColor = returnToStockButton?.isSelected == true ? UIColor.init(red: 11/255, green: 118/255, blue: 201/255, alpha: 1.0) : UIColor.white
    //            sender.setTitleColor(returnToStockButton?.isSelected == true ? UIColor.white : UIColor.init(red: 11/255, green: 118/255, blue: 201/255, alpha: 1.0), for: .normal)
    //        }
    //        returnToStockButton = sender
    //        self.tabelView.reloadData()
    //    }
}

//MARK: HieCORPickerDelegate
extension RefundViewController: HieCORPickerDelegate {
    func didSelectPickerViewAtIndex(index: Int) {
        if ischeckPax {
            DataManager.selectedPaxRefund = nil
            indexCellPax = index
            if showPax.count > 0 {
                isChangeRefundType = false
                let ob:[String] = [showPax[index].capitalized]
                DataManager.selectedPaxRefund = ob
                pickerTextfield.text = "\(DataManager.selectedPaxRefund![0])"
            }
        }else{
            indexCell = index
            if self.showPayment.count != 0{
                isChangeRefundType = true
                pickerTextfield.text = self.showPayment[index].capitalized
                orderInfoModelObj.transactionArray[indexPayment].selectPaymentIndex = index
            }
        }
        if isCheckItem {
            if indexCellItem == 0 {
                indexCellItem = index
            }else if indexCellItem == 1 {
                indexCellItem = index
            }else if indexCellItem == 2 {
                indexCellItem = index
            }else if  indexCellItem == 3 {
                indexCellItem = index
            }else if  indexCellItem == 4 {
                indexCellItem = index
            }
        }
        
    }
    
    override func pickerViewDoneAction() {
        self.view.endEditing(true)
        pickerTextfield.resignFirstResponder()
        
        if isCheckItem {
            
            var obj = ""
            
            if indexCellItem == 0 {
                obj = "Unopened"
                showItems.append(obj)
            }else if indexCellItem == 1 {
                obj = "openbox"
                showItems.append(obj)
            }else if indexCellItem == 2 {
                obj = "used"
                showItems.append(obj)
            }else if  indexCellItem == 3 {
                obj = "damaged"
                showItems.append(obj)
            }else if  indexCellItem == 4  {
                obj = "other"
                showItems.append(obj)
            }
            
            strStatusItem.replaceObject(at: indexItem, with: obj)
            
            self.tabelView.beginUpdates()
            self.tabelView.reloadRows(at: [indexPathItem as IndexPath], with: .fade)
            self.tabelView.endUpdates()
            //pickerTextfield.text = (self.array_ItemList[index] as AnyObject).capitalized
        }else{
            self.tabelView.beginUpdates()
            self.tabelView.reloadRows(at: [indexPathAll as IndexPath], with: .fade)
            self.tabelView.endUpdates()
        }
        
    }
    
    override func pickerViewCancelAction() {
        self.view.endEditing(true)
        pickerTextfield.resignFirstResponder()
        if isCheckItem {
            self.tabelView.beginUpdates()
            self.tabelView.reloadRows(at: [indexPathItem as IndexPath], with: .fade)
            self.tabelView.endUpdates()
        } else {
            self.tabelView.beginUpdates()
            tabelView.reloadRows(at: [indexPathAll as IndexPath], with: .fade)
            self.tabelView.endUpdates()
        }
    }
}

//MARK: UITextViewDelegate
extension RefundViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.resetCustomError(isAddAgain: false)
        if textView.text == textViewPlaceholder || textView.text == "" {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        if range.location == 0 && text == " " {
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != ""{
            btnProcess.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
        }else{
            btnProcess.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            IQKeyboardManager.shared.enableAutoToolbar = true
        }
        if textView.text == textViewPlaceholder || textView.text == "" || (textView.text)!.trimmingCharacters(in: .whitespaces).isEmpty {
            textView.text = textViewPlaceholder
            textView.textColor = #colorLiteral(red: 0.6430795789, green: 0.6431742311, blue: 0.6430588365, alpha: 1)
        }
        
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
            IQKeyboardManager.shared.enable = false
        }
    }
}

//MARK: UITextFieldDelegate
extension RefundViewController : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.hideAssistantBar()
        
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
        
        let indexPoint :CGPoint = textField.convert(.zero, to: tabelView)
        guard let indexPathValue:IndexPath = tabelView.indexPathForRow(at: indexPoint) else {
            return
        }
        print("the index of current cell \(indexPathValue.row)")
        
        if notesTextView.text == "" {
            notesTextView.text = textViewPlaceholder
            notesTextView.textColor = UIColor.darkGray
        }
        
        let indexPath = IndexPath(item: selectedIndexOther, section: 2)
        let cell = self.tabelView?.cellForRow(at: indexPath) as? ItemsValueCell
        let ob = cell?.tfOther.text
        strOtherItem.replaceObject(at: selectedIndexOther, with: ob ?? "")
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let indexPoint :CGPoint = textField.convert(.zero, to: tabelView)
        let indexPathValue:IndexPath = tabelView.indexPathForRow(at: indexPoint)!
        print("the index of current cell \(indexPathValue.row)")
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let indexPoint :CGPoint = textField.convert(.zero, to: tabelView)
        guard let indexPathValue:IndexPath = tabelView.indexPathForRow(at: indexPoint) else {return}
        print("the index of current cell \(indexPathValue.row)")
        
        DispatchQueue.main.async {
            textField.resignFirstResponder()
        }
        
        if strProductQty.count > 0 {
            if textField.text == "" {
//                self.showAlert(message: "Please enter Quantity value")
                appDelegate.showToast(message: "Please enter Quantity value")
                strProductQty[indexPathValue.row] = "0"
            }
            else {
                strProductQty[indexPathValue.row] = textField.text!
            }
        }
        
        
        if textField.text == "" {
//            self.showAlert(message: "Please enter Other item value")
            appDelegate.showToast(message: "Please enter Other item value")
            strOtherItem[indexPathValue.row] = ""
        }
        else {
            strOtherItem[indexPathValue.row] = textField.text!
        }
        
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Handle Swipe Reader Data
        
        print(indexPathQuantity)
        print(indexQuantity)
        
        let obj = orderInfoModelObj.productsArray[indexQuantity].qty
        
        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
        var replacementText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        if range.location == 0 && string == " " {
            return false
        }
        
        if string == "\t" {
            return false
        }
        
        print(string)
        print(textField.text)
        
        if string == " " {
            return false
        }
        
        let indexPath = IndexPath(item: selectedIndexOther, section: 2)
        let cell = self.tabelView?.cellForRow(at: indexPath) as? ItemsValueCell
        
        if textField == cell?.tfOther{
            
        }else{
            replacementText = replacementText.replacingOccurrences(of: "$", with: "")
            let dat = Int(replacementText)
            
            if dat == nil {
                return replacementText.isValidDecimal(maximumFractionDigits: 0) && charactersCount <= 8
            } else {
                
                if replacementText.isValidDecimal(maximumFractionDigits: 0) && charactersCount <= 8 && dat! <= Int(obj) {
                    return replacementText.isValidDecimal(maximumFractionDigits: 0) && charactersCount <= 8 && dat! <= Int(obj)
                } else {
//                    self.showAlert(message: "Quantity must be less or equal to available quantity: \(obj)")
                    appDelegate.showToast(message: "Quantity must be less or equal to available quantity: \(obj)")
                    return false
                }
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: API Methods
extension RefundViewController {
    func callAPItoRefund() {
        let parameters = getParameters()
        
        for data in strProductQty {
            if data == "0" || data == "" || data == " "{
//                self.showAlert(message: "Please enter correct quantity")
                appDelegate.showToast(message: "Please enter correct quantity")
                return
            }
        }
        
        OrderVM.shared.refundOrder(parameters: parameters, responseCallBack: { (success, message, error) in
            if success == 1 {
                // self.showAlert(title: "Alert", message: "Refunded successfully.", otherButtons: nil, cancelTitle: kOkay, cancelAction: { (action) in
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    self.refundOrderByDataModelObj = OrderVM.shared.refundData
                    //self.orderInfoDelegate?.didHideRefundView?(isRefresh: true)
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
                    vc.refundOrderDataModelObj = OrderVM.shared.refundData
                    vc.refundOrderDataModelObj.checkRefund = true
                    vc.strGooglePrint = self.orderInfoModelObj.googleReceipturl
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "OrderViewController") as! OrderViewController
                    vc.refundOrderDataModelObj = OrderVM.shared.refundData
                    vc.refundOrderDataModelObj.checkRefund = true
                    vc.strGooglePrint = self.orderInfoModelObj.googleReceipturl
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                // })
            }else {
                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
}

//MARK: OrderInfoViewControllerDelegate
extension RefundViewController: OrderInfoViewControllerDelegate {
    func didUpdateRefundScreen(with data: JSONDictionary) {
        self.textViewPlaceholder = "Type note here..."
        self.notesTextView.text = ""
         btnProcess.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.7882352941, alpha: 1)
        indexCellItem = 0
        
        if notesTextView.text == "" {
            notesTextView.text = textViewPlaceholder
            notesTextView.textColor = UIColor.darkGray
        }
        cancelAllUserSubscriptionButton.isSelected = false
        cancelAllOrderSubscriptionButton.isSelected = false
        noChangeButton.isSelected = true
        returnToStockButton = nil
        
        self.orderInfoModelObj = data["data"] as? OrderInfoModel ?? OrderInfoModel()
        //self.array = self.orderInfoModelObj.refundPaymentTypeArray
        //priya
        self.array = self.orderInfoModelObj.transactionArray
        self.arrayPax = self.orderInfoModelObj.paxDeviceListRefund
        print(self.orderInfoModelObj.paxDeviceListRefund.count)
        print(arrayPax.count)
        
        if orderInfoModelObj.productsArray.count > 0 {
            showItems.removeAll()
            strStatusItem.removeAllObjects()
            strOtherItem.removeAllObjects()
            arrReturnStock.removeAllObjects()
            for i in orderInfoModelObj.productsArray {
                strStatusItem.add("Unopened")
                strOtherItem.add("")
                arrReturnStock.add(true)
            }
        }
        self.subscriptionView.isHidden = !self.orderInfoModelObj.isSubscription
        self.tabelView.reloadData()
    }
}
