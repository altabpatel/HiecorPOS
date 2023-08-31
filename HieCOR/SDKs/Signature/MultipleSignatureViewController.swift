//
//  MultipleSignatureViewController.swift
//  HieCOR
//
//  Created by Hiecor Software on 07/11/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass
import SocketIO
import IQKeyboardManagerSwift

protocol EPSignatureDelegate {
    
    func signatureJsonArraySend(arrdata:JSONArray)
    //func epSignature(_: MultipleSignatureViewController, didSign signatureImage : UIImage, boundingRect: CGRect)
}
// for socket sudama
protocol socketForVC {
    func callForSocketVC(str: String)
}
//

class MultipleSignatureViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource, UIGestureRecognizerDelegate, MultipleSignatureCellDelegate {
    
    @IBOutlet weak var viewBaseMainHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableSignature: UITableView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var baseViewMain: UIView!
    @IBOutlet weak var lbTotalAmount: UILabel!
    @IBOutlet weak var lblTipAmountPlus: UILabel!
    // Create by Altab (14-oct-2022) for new Dot border design for Tip
    @IBOutlet weak var tipViewDotBorder: UIView!
    @IBOutlet weak var lblTipAmount: UILabel!
    
    @IBOutlet weak var constantTopAmountView: NSLayoutConstraint!
    private var dateCellExpanded: Bool = false
    private var isEditingCustom: Bool = false
    
    var index = Int()
    var indexGetCell = Int()
    var CardCount = Int()
    var orderID = String()
    var arrCardData = NSMutableArray()
    // for socket sudama
    // var arrImage = [UIImage]()
    var SaveSignatureDataModelobj = [SaveSignatureDataModel]()
    var socketDelegate : socketForVC?
    //
    var arrStringSign = [String]()
    var cardsPOS = JSONArray()
    var arrTip = [String]()
    var arrTipAmount = [String]()
    
    var signatureDelegate: EPSignatureDelegate?
    var tableData = [[String:AnyObject]]()
    
    
    //var arrTip = [String]()
    var tip = ""
    var tipAmount = Double()
    var TotalAmount = 0.0
    var totalLable = 0.0
    var EmvIndex = 1
    var valAmt = 0.0
    var paxMode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing {
            MainSocketManager.shared.connect()
        }
        tableSignature.tableFooterView = UIView()
        EmvIndex = 1
        tableSignature.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.signatureCheck(_:)), name: NSNotification.Name(rawValue: "notificationNameSignatureCheck"), object: nil)
        
        
        if arrCardData.count < 5 {
            tableSignature.isScrollEnabled = false
        } else {
            tableSignature.isScrollEnabled = true
        }
        
        if arrCardData.count == 1 {
            
        } else {
            btnContinue.backgroundColor = UIColor.lightGray
            btnContinue.isUserInteractionEnabled = false
        }
        
        if !DataManager.signature {
            self.btnContinue.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
            self.btnContinue.isUserInteractionEnabled = true
        }
        
        
        if arrCardData.count == 1 {
            for i in 0..<arrCardData.count {
                arrStringSign.append("")
                arrTip.append("")
                arrTipAmount.append("0.00")
                let data = arrCardData[0]
                //            tableData[i]["tip"] = "" as AnyObject
                //            tableData[i]["signDATA"] = "" as AnyObject
                
                
                if let amount = (data as AnyObject).value(forKey: "TotalAmount") as? String {
                    if amount == "" {
                        return
                    }
                    lbTotalAmount.text = "Total Amount " + amount.toDouble()!.currencyFormat ?? "$0.00"
                    lblTipAmountPlus.text = "\(amount.toDouble()!.currencyFormat)"
                    totalLable = amount.toDouble() ?? 0.0
                    lblTipAmountPlus.isHidden = true
                    tipViewDotBorder.isHidden = true
                    if arrCardData.count == 1 {
                        if let tipamt = (data as AnyObject).value(forKey: "tipAmount") as? String {
                            
                            //if !DataManager.isPartialAprrov {
                            lblTipAmountPlus.isHidden = false
                            tipViewDotBorder.isHidden = false
                            let indexPath = IndexPath(item: index, section: 0)
                            let cell = self.tableSignature?.cellForRow(at: indexPath) as? MultipleSignatureCell
                            //cell?.numberField.text = arrTipAmount[index].toDouble()?.currencyFormatA
                            //tableSignature.reloadData()
                            if tipamt == "0.00" || tipamt == "0.0" || tipamt == "0" {
                                
                            } else {
                                cell?.numberField.text = tipamt.toDouble()?.currencyFormatA
                                
                                cell?.noTripBtn.backgroundColor = UIColor.white
                                cell?.noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
                                
                            }
                            
                            //                                if tipamt != "0.00" {
                            //                                    cell?.numberField.text = tipamt.toDouble()?.currencyFormatA
                            //                                    
                            //                                    cell?.noTripBtn.backgroundColor = UIColor.white
                            //                                    cell?.noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
                            //                                    
                            //                                }
                            
                            let amt = amount.toDouble()!
                            
                            lblTipAmountPlus.text = "\(amt.currencyFormat) + "
                            lblTipAmount.text = " \(tipamt.toDouble()?.currencyFormat ?? "") "
                            totalLable = amt
                            arrTipAmount[i] = tipamt
                            
                            var valAmt = 0.0
                            
                            for data in arrTipAmount {
                                valAmt += data.toDouble() ?? 0.0
                            }
                            print(valAmt)
                            if valAmt > 0 {
                                lbTotalAmount.text = "Total Amount " + (amt + valAmt).currencyFormat
                                lblTipAmountPlus.text = "\(amt.currencyFormat) + "
                                lblTipAmount.text = " \(valAmt.currencyFormat ) "
                                lblTipAmountPlus.isHidden = false
                                tipViewDotBorder.isHidden = false
                            } else {
                                lbTotalAmount.text = "Total Amount " + totalLable.currencyFormat
                                lblTipAmountPlus.text = "\(totalLable.currencyFormat)"
                                lblTipAmountPlus.isHidden = true
                                tipViewDotBorder.isHidden = true
                            }
                            
                            let val = (valAmt*100)/amt
                            print("tip value \(val)")
                            switch val.rounded() {
                            case 0:
                                if val > 0 {
                                    break
                                }
                                cell?.noTripBtn.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.4666666667, blue: 0.7882352941, alpha: 1)//UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
                                cell?.noTripBtn.setTitleColor(.white, for: .normal)
                                break
                            case 15:
                                cell?.fifteenBtn.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.4666666667, blue: 0.7882352941, alpha: 1)//UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
                                cell?.fifteenBtn.setTitleColor(.white, for: .normal)
                                break
                            case 20:
                                cell?.twentyBtn.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.4666666667, blue: 0.7882352941, alpha: 1)//UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
                                cell?.twentyBtn.setTitleColor(.white, for: .normal)
                                break
                            case 25:
                                cell?.twentyFiveBtn.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.4666666667, blue: 0.7882352941, alpha: 1)//UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
                                cell?.twentyFiveBtn.setTitleColor(.white, for: .normal)
                                break
                                
                            default:
                                cell?.noTripBtn.backgroundColor = UIColor.white
                                cell?.noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
                                cell?.fifteenBtn.backgroundColor = UIColor.white
                                cell?.fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
                                cell?.twentyBtn.backgroundColor = UIColor.white
                                cell?.twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
                                cell?.twentyFiveBtn.backgroundColor = UIColor.white
                            }
                            
                            cell?.signView.loadSignatureLocal(appDelegate.localBezierPath)
                       
                        }
                    }
                }
                
                //if DataManager.isTotalTipCalculation {
                if let amount = (data as AnyObject).value(forKey: "TotalAmount") as? String {
                    TotalAmount = amount.toDouble() ?? 0.0
                }
                //                } else {
                //                    if let amount = (data as AnyObject).value(forKey: "total") as? String {
                //                        TotalAmount = amount.toDouble() ?? 0.0
                //                    }
                //                }
                
                //            if let amount = (data as AnyObject).value(forKey: "total") as? String {
                //                TotalAmount = amount.toDouble() ?? 0.0
                //            }
                
            }
        } else {
            for i in 0..<arrCardData.count {
                arrStringSign.append("")
                arrTip.append("")
                arrTipAmount.append("0.00")
                let data = arrCardData[i]
                //            tableData[i]["tip"] = "" as AnyObject
                //            tableData[i]["signDATA"] = "" as AnyObject
                
                
                if let amount = (data as AnyObject).value(forKey: "TotalAmount") as? String {
                    
                    lbTotalAmount.text = "Total Amount " + amount.toDouble()!.currencyFormat ?? "$0.00"
                    lblTipAmountPlus.text = "\(amount.toDouble()!.currencyFormat)"
                    totalLable = amount.toDouble() ?? 0.0
                    lblTipAmountPlus.isHidden = true
                    tipViewDotBorder.isHidden = true
                    // if arrCardData.count == 1 {
                    if let tipamt = (data as AnyObject).value(forKey: "tipAmount") as? String {
                        lblTipAmountPlus.isHidden = false
                        
                        
                        if tipamt != "0.00" {
                            let indexPath = IndexPath(item: i, section: 0)
                            let cell = self.tableSignature?.cellForRow(at: indexPath) as? MultipleSignatureCell
                            //cell?.numberField.text = arrTipAmount[index].toDouble()?.currencyFormatA
                            //tableSignature.reloadData()
                            cell?.numberField.text = tipamt.toDouble()?.currencyFormatA
                            
                            cell?.noTripBtn.backgroundColor = UIColor.white
                            cell?.noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
                            arrTipAmount[i] = tipamt
                        }
                    }
                    
                    // }
                }
                
                //if DataManager.isTotalTipCalculation {
                if let amount = (data as AnyObject).value(forKey: "TotalAmount") as? String {
                    TotalAmount = amount.toDouble() ?? 0.0
                }
                //                } else {
                //                    if let amount = (data as AnyObject).value(forKey: "total") as? String {
                //                        TotalAmount = amount.toDouble() ?? 0.0
                //                    }
                //                }
                
                //            if let amount = (data as AnyObject).value(forKey: "total") as? String {
                //                TotalAmount = amount.toDouble() ?? 0.0
                //            }
                
            }
            
            let amt = totalLable - HomeVM.shared.tipValue
            
            lblTipAmountPlus.text = "\(amt.currencyFormat) + \(HomeVM.shared.tipValue.currencyFormat)"
            totalLable = amt ?? 0.0
            //arrTipAmount[i] = tipamt
            
            var valAmt = 0.0
            
            for data in arrTipAmount {
                valAmt += data.toDouble() ?? 0.0
            }
            print(valAmt)
            if valAmt > 0 {
                lbTotalAmount.text = "Total Amount " + (amt + valAmt).currencyFormat
                lblTipAmountPlus.text = "\(amt.currencyFormat) + "
                lblTipAmountPlus.isHidden = false
                lblTipAmount.text = " \(valAmt.currencyFormat ) "
                tipViewDotBorder.isHidden = false
            } else {
                lbTotalAmount.text = "Total Amount " + totalLable.currencyFormat
                lblTipAmountPlus.text = "\(totalLable.currencyFormat)"
                lblTipAmountPlus.isHidden = true
                lblTipAmount.text = ""
                tipViewDotBorder.isHidden = true
            }
        }
        
        
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            useForSocket()
        }
        
        if !DataManager.collectTips {
            lblTipAmountPlus.isHidden = true
            tipViewDotBorder.isHidden = true
        }
        
        var signaturedata = ""
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = self.tableSignature?.cellForRow(at: indexPath) as? MultipleSignatureCell
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let signature = cell?.signView.getSignatureAsImage(Size: cell?.view2.frame.height ?? 400) {
                // self.arrImage[indexPath.row] = signature
                signaturedata = signature.base64(format: .png)
                self.arrStringSign[self.index] = signaturedata
                cell?.lblErrorMsg.isHidden = true
            } else {
                self.arrStringSign[self.index] = ""
                cell?.lblErrorMsg.isHidden = false
                //showAlert(message: "Please draw your signature")
            }
        }
        if !appDelegate.localBezierPath.isEmpty {
            self.btnContinue.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
            self.btnContinue.isUserInteractionEnabled = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.tableSignature.reloadData()
            // remove dotted border
            for layer in self.tipViewDotBorder!.layer.sublayers! {
                if layer.isKind(of: CAShapeLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
            self.tipViewDotBorder.addDashBorder(color: UIColor.init(red: 237/255, green: 112/255, blue: 108/255, alpha: 1.0), width: 2.0, cornerRadius: 6)
        }
        
    }
    
    func buttonTapped(cell: MultipleSignatureCell, btnTag: Int) {
        guard let indexPath = self.tableSignature.indexPath(for: cell) else {
            // Note, this shouldn't happen - how did the user tap on a button that wasn't on screen?
            return
        }
        
        //  Do whatever you need to do with the indexPath
        print("Button tapped on row \(indexPath.row)")
        print("I have pressed a button with a tag: \(btnTag)")
        isEditingCustom = false
        arrTip[indexPath.row] = String(btnTag)
        tipCalculation()
        // remove dotted border
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            for layer in self.tipViewDotBorder!.layer.sublayers! {
                if layer.isKind(of: CAShapeLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
            self.tipViewDotBorder.addDashBorder(color: UIColor.init(red: 237/255, green: 112/255, blue: 108/255, alpha: 1.0), width: 2.0, cornerRadius: 6)
        }
    }
    
    func tipCalculation(){
        for i in 0..<arrTip.count {
            if index == i {
                let tipInt  = Double(arrTip[i])
                //tipAmount = Double((TotalAmount/100)*(tipInt ?? 0))
                var tipDVal = ((TotalAmount/100)*(tipInt ?? 0))
                var strT = "\(tipDVal)"
                var strIn = ""
                if let range = strT.range(of: ".") {
                    let num = strT[range.upperBound...]
                    print(num)
                    strT = String(num)
                }
                
                strIn = strT[0 ..< 3]
                
                var newtipTotal = tipDVal.rounded(toPlaces: 3)
                let strLastDigitFive = strIn.last
                if strLastDigitFive == "5" {
                    newtipTotal = newtipTotal + 0.001
                    newtipTotal = newtipTotal.rounded(toPlaces: 2)
                    tipDVal = newtipTotal
                }
                
                arrTipAmount[i] = "\(tipDVal + 0.0000011)"
                if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                    //let tipValue = ((TotalAmount/100)*(tipInt ?? 0)).currencyFormatA
                    MainSocketManager.shared.onAddTip(tip: (tipDVal + 0.0000011).currencyFormatA)
                    
                }
            }
            
        }
        let indexPath = IndexPath(item: index, section: 0)
        let cell = self.tableSignature?.cellForRow(at: indexPath) as? MultipleSignatureCell
        cell?.numberField.text = arrTipAmount[index].toDouble()?.currencyFormatA
        //tableSignature.reloadData()
        cell?.numberField.text = "Custom"
        
        var valAmt = 0.0
        
        for data in arrTipAmount {
            valAmt += data.toDouble() ?? 0.0
        }
        
        print(valAmt)
        if valAmt > 0 {
            lbTotalAmount.text = "Total Amount " + (totalLable + valAmt).currencyFormat
            lblTipAmountPlus.text = "\(totalLable.currencyFormat) + "
            lblTipAmountPlus.isHidden = false
            tipViewDotBorder.isHidden = false
            lblTipAmount.text = " \(valAmt.currencyFormat) "
        } else {
            lbTotalAmount.text = "Total Amount " + totalLable.currencyFormat
            lblTipAmountPlus.text = "\(totalLable.currencyFormat)"
            lblTipAmountPlus.isHidden = true
            tipViewDotBorder.isHidden = true
        }
        
        
    }
    
    func useForSocket(){
        MainSocketManager.shared.connect()
        let socketConnectionStatus = MainSocketManager.shared.socket.status
        
        switch socketConnectionStatus {
        case SocketIOStatus.connected:
            print("socket connected")
            MainSocketManager.shared.emitSignature { (signatureDataModelForSocket) in
                if DataManager.sessionID == signatureDataModelForSocket.sessionID{
                    
                    
                    let indexPath = IndexPath(item: signatureDataModelForSocket.signIndex, section: 0)
                    let cell = self.tableSignature?.cellForRow(at: indexPath) as? MultipleSignatureCell
                    
                    self.arrStringSign[indexPath.row] = signatureDataModelForSocket.signData.replacingOccurrences(of: "data:image/png;base64,", with: "")
                    if self.arrStringSign[indexPath.row] != "" {
                        cell?.signatureImageForSocket.isHidden = false
                    }else{
                        cell?.lblErrorMsg.isHidden = false
                    }
                    let signatureSocketImage = self.convertBase64StringToImage(imageBase64String: self.arrStringSign[indexPath.row])
                    cell?.signatureImageForSocket.image = signatureSocketImage
                    
                    cell?.numberField.text = signatureDataModelForSocket.tip
                    
                    cell?.numberField.resignFirstResponder()
                    cell?.noTripBtn.backgroundColor = UIColor.white
                    cell?.noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
                    cell?.fifteenBtn.backgroundColor = UIColor.white
                    cell?.fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
                    cell?.twentyBtn.backgroundColor = UIColor.white
                    cell?.twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
                    cell?.twentyFiveBtn.backgroundColor = UIColor.white
                    cell?.twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
                    if signatureDataModelForSocket.tipPercent == 15 {
                        cell?.fifteenBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
                        cell?.fifteenBtn.setTitleColor(.white, for: .normal)
                    } else if signatureDataModelForSocket.tipPercent == 20 {
                        cell?.twentyBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
                        cell?.twentyBtn.setTitleColor(.white, for: .normal)
                    } else if signatureDataModelForSocket.tipPercent == 25 {
                        cell?.twentyFiveBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
                        cell?.twentyFiveBtn.setTitleColor(.white, for: .normal)
                    } else if signatureDataModelForSocket.tipPercent == 0 {
                        cell?.noTripBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
                        cell?.noTripBtn.setTitleColor(.white, for: .normal)
                    }
                    self.valAmt = signatureDataModelForSocket.tip.toDouble() ?? 0.0
                    if self.valAmt > 0 {
                        self.lbTotalAmount.text = "Total Amount " + (self.totalLable + self.valAmt).currencyFormat
                        self.lblTipAmountPlus.text = "\(self.totalLable.currencyFormat) + \(self.valAmt.currencyFormat)"
                        self.lblTipAmountPlus.isHidden = false
                    } else {
                        self.lbTotalAmount.text = "Total Amount " + self.totalLable.currencyFormat
                        self.lblTipAmountPlus.text = "\(self.totalLable.currencyFormat)"
                        self.lblTipAmountPlus.isHidden = true
                    }
                    
                    cell?.lblErrorMsg.isHidden = true
                    self.index = indexPath.row + 1
                    self.tableSignature.isScrollEnabled = false
                    //self.EmvIndex = 1
                    self.tableSignature.reloadData()
                }
                
            }
            
            MainSocketManager.shared.emitSignatureContinue { (saveSignatureDataModel, sid) in
                if DataManager.sessionID == sid {
                    MainSocketManager.shared.socket.off("saveSignature")
                    self.SaveSignatureDataModelobj = saveSignatureDataModel
                    //  let parameters = self.getParametersForSocket()
                    //  self.callAPItoSignature(parameters: parameters)
                    print("testing socket api hit by socket")
                    self.getParametersForSocket()
                    self.signatureDelegate?.signatureJsonArraySend(arrdata: self.cardsPOS)
                    self.dismiss(animated: true, completion: nil)
                    //  socket.on("saveSignature")
                    
                    if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                        MainSocketManager.shared.onCloseSignature()
                        //  socketDelegate?.callForSocketVC(str: "callback")
                    }
                }
            }
            
        case SocketIOStatus.connecting:
            print("socket connecting")
        case SocketIOStatus.disconnected:
            print("socket disconnected")
        case SocketIOStatus.notConnected:
            print("socket not connected")
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        baseViewMain.layer.cornerRadius = 3
        // border
        baseViewMain.layer.borderWidth = 1.0
        baseViewMain.layer.borderColor = UIColor.gray.cgColor
        
        if UIScreen.main.bounds.height - 100 <= tableSignature.contentSize.height {
            tableSignature.isScrollEnabled = false
            tableSignature.alwaysBounceVertical = false
            //viewBaseMainHeightConstraint.constant = UIScreen.main.bounds.height - 100
        } else {
            // self.tableHeightConstraint.constant = tableSignature.contentSize.height
            //viewBaseMainHeightConstraint.constant =  tableSignature.contentSize.height + 110
        }
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.view.endEditing(true)
//        setView(view: view_KeyboardAddNotes, hidden: true)
//        customView.isHidden = true
//        txt_AddNote.text = ""
//        btn_AddNoteDone.setImage(UIImage(named: "tick-inactive"), for: .normal)
//        customView = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.size.width, height: self.view.frame.size.height-158))
//        updateUI()
//        updateViewWidth()
        // Create by Altab (14-oct-2022) for new Dot border design for Tip
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.tableSignature.reloadData()
            // remove dotted border
            for layer in self.tipViewDotBorder!.layer.sublayers! {
                if layer.isKind(of: CAShapeLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
            self.tipViewDotBorder.addDashBorder(color: UIColor.init(red: 237/255, green: 112/255, blue: 108/255, alpha: 1.0), width: 2.0, cornerRadius: 6)
        }
    }
    @IBAction func btnCross_Action(_ sender: Any) {
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            MainSocketManager.shared.socket.off("saveSignature")
            MainSocketManager.shared.onCloseSignature()
            socketDelegate?.callForSocketVC(str: "callback")
        }
        DispatchQueue.main.async {
            SwipeAndSearchVC.shared.isEnable = true
            SwipeAndSearchVC.shared.enableTextField()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnContinue_Action(_ sender: UIButton) {
        //let parameters = getParameters()
        //self.callAPItoSignature(parameters: parameters)
        
        //        if let signature = signView.getSignatureAsImage() {
        //            signatureDelegateone?.epSignature(self, didSign: signature, boundingRect: signView.getSignatureBoundsInCanvas())
        //            dismiss(animated: true, completion: nil)
        //        } else {
        //            showAlert(message: "Please draw your signature")
        //
        if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
            if arrCardData.count > 0 {
                let data = arrCardData[0]
                if let card = (data as AnyObject).value(forKey: "card_number") as? String {
                    if card == "Ingenico" {
                        appDelegate.showToast(message: "Only Manual Payment Products is available in offline mode.")
                        self.dismiss(animated: true, completion: nil)
                        return
                    }
                }
            }
        }
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            MainSocketManager.shared.socket.off("saveSignature")
        }
        sender.backgroundColor =  #colorLiteral(red: 0.01960784314, green: 0.8196078431, blue: 0.1882352941, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            sender.backgroundColor =  #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
        }
        AppDelegate.isLoaderNotHide = true              //ssk
        print("testing socket api hit by click ")
        getParameters()
        DataManager.arrTempListing = cardsPOS
        signatureDelegate?.signatureJsonArraySend(arrdata: cardsPOS)
        self.dismiss(animated: true, completion: nil)
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
            MainSocketManager.shared.onCloseSignature()
            self.socketDelegate?.callForSocketVC(str: "callback")
        }
        
    }
    
    
    @objc func signatureCheck(_ notification: NSNotification) {
        //tableSignature.isScrollEnabled = true
        var signaturedata = ""
        let indexPath = IndexPath(item: index, section: 0)
        let cell = self.tableSignature?.cellForRow(at: indexPath) as? MultipleSignatureCell
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let signature = cell?.signView.getSignatureAsImage(Size: cell?.view2.frame.height ?? 400) {
                // self.arrImage[indexPath.row] = signature
                signaturedata = signature.base64(format: .png)
                self.arrStringSign[self.index] = signaturedata
                cell?.lblErrorMsg.isHidden = true
            } else {
                self.arrStringSign[self.index] = ""
                cell?.lblErrorMsg.isHidden = false
                //showAlert(message: "Please draw your signature")
            }
        }
        
        //        for i in 0..<arrCardData.count {
        //
        //            let indexPath = IndexPath(item: i, section: 0)
        //            let cell = self.tableSignature?.cellForRow(at: indexPath) as? MultipleSignatureCell
        //            //let ob = cell?.signView.getSignatureAsImage()
        //
        //            let data = arrCardData[i]
        //            //var cardnumber = ""
        //            var signaturedata = ""
        //            var txnID = ""
        //
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        //                if let signature = cell?.signView.getSignatureAsImage() {
        //                    self.arrImage[indexPath.row] = signature
        //                    signaturedata = signature.base64(format: .png)
        //                    self.arrStringSign.append(signaturedata)
        //                    cell?.lblErrorMsg.isHidden = true
        //                } else {
        //                    self.arrStringSign.append("")
        //                    cell?.lblErrorMsg.isHidden = false
        //                    //showAlert(message: "Please draw your signature")
        //                }
        //            }
        //        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.EmvIndex = 1
            self.tableSignature.reloadData()
        }
    }
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UISwipeGestureRecognizer) {
        print("Hello World")
        tableSignature.isScrollEnabled = false
    }
    
    @objc func handleTapTwo(_ sender: UIPanGestureRecognizer) {
        print("Hello Worldtwoooooooooo")
        //tableSignature.isScrollEnabled = false
    }
    
    @objc func handleTapSingle(_ sender: UITapGestureRecognizer) {
        print("Hello Worldtwoooooooooo")
        tableSignature.isScrollEnabled = false
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        tableSignature.isScrollEnabled = false
        return true
    }
    
    
    
    @objc func actionClearSignature(_ sender: UIButton) {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        let cell = self.tableSignature?.cellForRow(at: indexPath) as? MultipleSignatureCell
        arrStringSign[indexPath.row] = ""
        cell?.signView.clear()
        cell?.signatureImageForSocket.isHidden = true
        EmvIndex = 1
        tableSignature.reloadData()
    }
    
    
    @objc func actionNextSignature(_ sender: UIButton) {
        
        //if arrCardData.count < index {
        let indexPath = IndexPath(item: sender.tag, section: 0)
        let cell = self.tableSignature?.cellForRow(at: indexPath) as? MultipleSignatureCell
        
        if let signature = cell?.signView.getSignatureAsImage(Size: cell?.view2.frame.height ?? 400) {
            //signaturedata = signature.base64(format: .png)
            //  var dataImg = cell?.signView.getSignatureAsImage()
            //arrImage.append(signature)
            arrStringSign[indexPath.row] = signature.base64(format: .png)
            // arrImage[indexPath.row] = signature
            cell?.lblErrorMsg.isHidden = true
            index = indexPath.row + 1
            tableSignature.isScrollEnabled = false
            
            //cell?.signView.clear()
            EmvIndex = 1
            tableSignature.reloadData()
        } else {
            cell?.lblErrorMsg.isHidden = false
            //showAlert(message: "Please draw your signature")
        }
        
    }
    // for socket sudama
    private func getParametersForSocket() -> JSONDictionary {
        cardsPOS.removeAll()
        var cards = JSONArray()
        for i in 0..<SaveSignatureDataModelobj.count {
            
            var dict = JSONDictionary()
            dict["txn_id"] = SaveSignatureDataModelobj[i].txn_id
            dict["signature"] = SaveSignatureDataModelobj[i].dataUrl
            dict["tip"] = SaveSignatureDataModelobj[i].tip
            dict["card_number"] = SaveSignatureDataModelobj[i].cardNumber
            dict["paxNumber"] = SaveSignatureDataModelobj[i].paxNumber
            dict["TotalAmount"] = SaveSignatureDataModelobj[i].totalAmount//lbTotalAmount.text?.replacingOccurrences(of: "Total Amount $", with: "")
            
            cardsPOS.append(dict)
            
        }
        
        let parameters: JSONDictionary = [
            "order_id": self.orderID,
            "digital_signature": cardsPOS
        ]
        return parameters
    }
    
    private func getParameters() -> JSONDictionary {
        
        cardsPOS.removeAll()
        var isComplete = true
        
        for i in 0..<arrCardData.count {
            
            let indexPath = IndexPath(item: i, section: 0)
            let cell = self.tableSignature?.cellForRow(at: indexPath) as? MultipleSignatureCell
            //let ob = cell?.signView.getSignatureAsImage()
            
            let data = arrCardData[i]
            //var cardnumber = ""
            var signaturedata = ""
            var txnID = ""
            var CardNumber = ""
            var total = ""
            var paxNumber = ""
            
            
            
            signaturedata = arrStringSign[i]
            tip = arrTipAmount[i]
            
            if let txnId = (data as AnyObject).value(forKey: "txn_id") as? String {
                txnID = txnId
            }
            if let paxNum = (data as AnyObject).value(forKey: "paxNumber") as? String {
                paxNumber = paxNum
            }
            if let card = (data as AnyObject).value(forKey: "card_number") as? String {
                CardNumber = card
            }
            
            var dict = JSONDictionary()
            dict["txn_id"] = txnID
            dict["signature"] = signaturedata
            dict["tip"] = tip // testing for single card
            dict["card_number"] = CardNumber
            dict["paxNumber"] = paxNumber
            dict["TotalAmount"] = lbTotalAmount.text?.replacingOccurrences(of: "Total Amount $", with: "")
            
            cardsPOS.append(dict)
            
        }
        
        //        if !isComplete {
        //            let parameters: JSONDictionary = [:]
        //            return parameters
        //        }
        
        let parameters: JSONDictionary = [
            "order_id": self.orderID,
            "digital_signature": cardsPOS
        ]
        //order_id: 102887, digital_signature:
        return parameters
    }
    // for socket sudama
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }
    //
    func callAPItoSignature(parameters: JSONDictionary) {
        
        OrderVM.shared.saveSignatureOrder(parameters: parameters, responseCallBack: { (success, message, error) in
            if success == 1 {
                self.arrCardData.removeAllObjects()
                if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                    MainSocketManager.shared.onCloseSignature()
                    self.socketDelegate?.callForSocketVC(str: "callback")
                }
                // self.showAlert(title: "Alert", message: "Refunded successfully.", otherButtons: nil, cancelTitle: kOkay, cancelAction: { (action) in
                self.dismiss(animated: true, completion: nil)
                appDelegate.showToast(message: "Refunded successfully.")
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let indexPath = IndexPath(item: index, section: 0)
        let cell = self.tableSignature?.cellForRow(at: indexPath) as? MultipleSignatureCell
        let indexPoint :CGPoint = textField.convert(.zero, to: tableSignature)
        let indexPathValue:IndexPath = tableSignature.indexPathForRow(at: indexPoint)!
        print("the index of current cell \(indexPathValue.row)")
        arrTipAmount[indexPath.row]  = (cell?.numberField.text as AnyObject) as! String
        
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        EmvIndex = 1
        return arrCardData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MultipleSignatureCell", for: indexPath) as! MultipleSignatureCell
        
        let data = arrCardData[indexPath.row]
        var tipViewHideFlag = false
        if let card = (data as AnyObject).value(forKey: "card_number") as? String {
            if card == "****" {
                cell.lblCardNumber.text = "EMV #\(EmvIndex)"
                EmvIndex += 1
            } else if card == "Ingenico" {
                cell.lblCardNumber.text = card//"Ingenico"
            } else if card == "Cash" || card == "Check" || card == "Internal Gift Card" || card == "External" || card == "External Gift Card" || card == "Gift Card" || card == "Ach Check"{
                cell.lblCardNumber.text = card
                tipViewHideFlag = true
            } else {
                cell.lblCardNumber.text = "*** *** **** \(card)"
            }
        }
        
        //cell.numberField.setBorder(color: UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0))
        
        for val in arrStringSign {
            if val != "" {
                self.btnContinue.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                self.btnContinue.isUserInteractionEnabled = true
            } else {
                self.btnContinue.backgroundColor = UIColor.lightGray
                self.btnContinue.isUserInteractionEnabled = false
                
            }
        }
        
        // cell.signView.loadSignature(arrStringSign[indexPath.row])
        
        cell.delegate = self
        cell.noTripBtn.tag = 00
        cell.fifteenBtn.tag = 15
        cell.twentyBtn.tag = 20
        cell.twentyFiveBtn.tag = 25
        cell.numberField.delegate = self
        cell.numberField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // remove dotted border
        for layer in cell.customTipViewDotBorder!.layer.sublayers! {
            if layer.isKind(of: CAShapeLayer.self) {
                layer.removeFromSuperlayer()
            }
        }
        cell.customTipViewDotBorder.addDashBorder(color: UIColor.init(red: 237/255, green: 112/255, blue: 108/255, alpha: 1.0), width: 2.0, cornerRadius: 6)
       
        cell.btnClear.tag = indexPath.row
        cell.btnClear.addTarget(self, action: #selector(self.actionClearSignature), for: .touchUpInside)
        
        cell.btnNext.tag = indexPath.row
        cell.btnNext.addTarget(self, action: #selector(self.actionNextSignature), for: .touchUpInside)
        
        
        if index == indexPath.row{
            cell.btnCellOpenClose.setTitle("-", for: .normal)
            cell.view2.isHidden = true
            cell.tipView.isHidden = true
            
            if DataManager.collectTips {
                cell.tipView.isHidden = false
                if appDelegate.strPaxMode == "GIFT"{
                    cell.tipView.isHidden = true
                }
            }
            
            if DataManager.signature {
                cell.view2.isHidden = false
            }
            if tipViewHideFlag {
                cell.tipView.isHidden = true
            }
            
            
            if DataManager.isSingatureOnEMV && DataManager.signature {
                //constantTopAmountView.constant = 100
                if let card = (data as AnyObject).value(forKey: "card_number") as? String {
                    if card == "****" {
                        cell.view2.isHidden = true
                    }  else {
                        cell.view2.isHidden = false
                    }
                }
                
            }
            
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if arrCardData.count < 5 {
                    tableSignature.isScrollEnabled = false
                } else {
                    let tap = UISwipeGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                    cell.signView.addGestureRecognizer(tap)
                    
                    let tapone = UITapGestureRecognizer(target: self, action: #selector(self.handleTapSingle(_:)))
                    cell.signView.addGestureRecognizer(tapone)
                }
            } else {
                if arrCardData.count < 2 {
                    tableSignature.isScrollEnabled = false
                } else {
                    let tap = UISwipeGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                    cell.signView.addGestureRecognizer(tap)
                    
                    let tapone = UITapGestureRecognizer(target: self, action: #selector(self.handleTapSingle(_:)))
                    cell.signView.addGestureRecognizer(tapone)
                }
            }
            
            
            
            //let taptwo = UIPanGestureRecognizer(target: self, action: #selector(self.handleTapTwo(_:)))
            //cell.signView.addGestureRecognizer(taptwo)
            
        }else{
            cell.btnCellOpenClose.setTitle("+", for: .normal)
            cell.view2.isHidden = true
            cell.tipView.isHidden = true
        }
        
        if arrCardData.count - 1 == indexPath.row {
            cell.btnNext.isHidden = true
        } else {
            cell.btnNext.isHidden = false
        }
        
        if !DataManager.signature {
            self.btnContinue.backgroundColor =  #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
            self.btnContinue.isUserInteractionEnabled = true
        }
        
        if arrCardData.count == 1 {
            cell.lblErrorMsg.isHidden = true
            if !DataManager.signature {
                self.btnContinue.backgroundColor =  #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                self.btnContinue.isUserInteractionEnabled = true
            } else {
                for val in arrStringSign {
                    if val != "" {
                        self.btnContinue.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                        self.btnContinue.isUserInteractionEnabled = true
                    } else {
                        self.btnContinue.backgroundColor = UIColor.lightGray
                        self.btnContinue.isUserInteractionEnabled = false
                        
                    }
                }
            }
            //self.btnContinue.isUserInteractionEnabled = true
            cell.btnCellOpenClose.isHidden = true
            if let card = (data as AnyObject).value(forKey: "card_number") as? String {
                if card == "****" {
                    cell.lblCardNumber.text = "EMV"
                    if DataManager.signature && DataManager.isSingatureOnEMV {
                        self.btnContinue.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                        self.btnContinue.isUserInteractionEnabled = true
                    }
                } else if card == "Ingenico" {
                    cell.lblCardNumber.text = "Ingenico"
                    if DataManager.signature && DataManager.isSingatureOnEMV {
                        self.btnContinue.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                        self.btnContinue.isUserInteractionEnabled = true
                    }
                } else {
                    if DataManager.signature {
                        for val in arrStringSign {
                            if val != "" {
                                self.btnContinue.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
                                self.btnContinue.isUserInteractionEnabled = true
                            } else {
                                self.btnContinue.backgroundColor = UIColor.lightGray
                                self.btnContinue.isUserInteractionEnabled = false
                                
                            }
                        }
                    }
                }
            }
        }
        if !appDelegate.localBezierPath.isEmpty {
            self.btnContinue.backgroundColor = #colorLiteral(red: 0.007843137255, green: 0.6196078431, blue: 0.137254902, alpha: 1)
            self.btnContinue.isUserInteractionEnabled = true
        }
        //        if HomeVM.shared.DueShared > 0 {
        //            cell.tipView.isHidden = true
        //        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        EmvIndex = 1
        let indexPath = IndexPath(item: self.index, section: 0)
        let cell = self.tableSignature?.cellForRow(at: indexPath) as? MultipleSignatureCell
        if dateCellExpanded {
            dateCellExpanded = false
        } else {
            dateCellExpanded = true
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if arrCardData.count < 5 {
                tableSignature.isScrollEnabled = false
            } else {
                tableSignature.isScrollEnabled = true
            }
        } else {
            if arrCardData.count < 2 {
                tableSignature.isScrollEnabled = false
            } else {
                tableSignature.isScrollEnabled = true
            }
        }
        
        cell?.signView.loadSignature(arrStringSign[indexPath.row])
        
        tableSignature.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if index == indexPath.row {
                if DataManager.isSingatureOnEMV && DataManager.signature {
                    let data = arrCardData[indexPath.row]
                    if let card = (data as AnyObject).value(forKey: "card_number") as? String {
                        if card == "****" {
                            return 120
                        } else {
                            if arrCardData.count == 1 {
                                return UIScreen.main.bounds.height - 200
                            } else {
                                return 400
                            }
                        }
                    }
                }
                if !DataManager.signature {
                    return 120
                } else {
                    if arrCardData.count == 1 {
                        return UIScreen.main.bounds.height - 200
                    } else {
                        return 400
                    }
                }
                
            } else {
                return 60
            }
        }else{
            if index == indexPath.row {
                if DataManager.isSingatureOnEMV && DataManager.signature {
                    let data = arrCardData[indexPath.row]
                    if let card = (data as AnyObject).value(forKey: "card_number") as? String {
                        if card == "****"  {
                            return 120
                        } else {
                            if arrCardData.count == 1 {
                                return UIScreen.main.bounds.height - 270
                            } else {
                                return 300
                            }
                        }
                    }
                }
                if !DataManager.signature {
                    return 120
                } else {
                    if arrCardData.count == 1 {
                        return UIScreen.main.bounds.height - 200
                    } else {
                        return 300
                    }
                }
                
            } else {
                return 60
            }
        }
    }
    
}

//MARK:- Textfield Delegate Methods
extension MultipleSignatureViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.hideAssistantBar()
        let indexPath = IndexPath(item: index, section: 0)
        let cell = self.tableSignature?.cellForRow(at: indexPath) as? MultipleSignatureCell
        let indexPoint :CGPoint = textField.convert(.zero, to: tableSignature)
        let indexPathValue:IndexPath = tableSignature.indexPathForRow(at: indexPoint)!
        print("the index of current cell \(indexPathValue.row)")
        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
        
        if textField == cell?.numberField {
            isEditingCustom = true
            if cell?.numberField.text == "Custom" {
                cell?.numberField.text = "0.00"
                arrTipAmount[indexPath.row]  = (cell?.numberField.text as AnyObject) as! String
                cell?.numberField.selectAll(nil)
            } else {
                arrTipAmount[indexPath.row]  = (cell?.numberField.text as AnyObject) as! String
                cell?.numberField.selectAll(nil)
            }
            
        }
        
        
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
        let indexPath = IndexPath(item: index, section: 0)
        let cell = self.tableSignature?.cellForRow(at: indexPath) as? MultipleSignatureCell
        
        if textField == cell?.numberField {
            let currentText = textField.text ?? ""
            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
            return replacementText.isValidDecimal(maximumFractionDigits: 2)
        }
        return true
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let indexPoint :CGPoint = textField.convert(.zero, to: tableSignature)
        let indexPathValue:IndexPath = tableSignature.indexPathForRow(at: indexPoint)!
        print("the index of current cell \(indexPathValue.row)")
        
        let indexPath = IndexPath(item: index, section: 0)
        
        let cell = self.tableSignature?.cellForRow(at: indexPath) as? MultipleSignatureCell
        cell?.numberField.resignFirstResponder()
        cell?.fifteenBtn.backgroundColor = UIColor.white
        cell?.fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        cell?.twentyBtn.backgroundColor = UIColor.white
        cell?.twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        cell?.twentyFiveBtn.backgroundColor = UIColor.white
        cell?.twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        if textField.text == "0.0" || textField.text == "" || textField.text == "0.00" || textField.text == "0" {
            cell?.noTripBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
            cell?.noTripBtn.setTitleColor(.white, for: .normal)
            cell?.numberField.text = "Custom"
            
        } else {
            cell?.noTripBtn.backgroundColor = UIColor.white
            cell?.noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
        }
        if textField == cell?.numberField {
            arrTipAmount[indexPath.row] = (cell?.numberField.text as AnyObject) as! String
            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                if indexPath.row == 0 {
                    if arrTipAmount[0] == "Custom" {
                        arrTipAmount[0] = "0"
                    }
                    MainSocketManager.shared.onAddTip(tip: arrTipAmount[0])
                }
            }
        }
        if isEditingCustom {
            var valAmt = 0.0
            
            for data in arrTipAmount {
                valAmt += data.toDouble() ?? 0.0
            }
            print(valAmt)
            if valAmt > 0 {
                lbTotalAmount.text = "Total Amount " + (totalLable + valAmt).currencyFormat
                lblTipAmountPlus.text = " \(totalLable.currencyFormat) + "
                lblTipAmountPlus.isHidden = false
                tipViewDotBorder.isHidden = false
                lblTipAmount.text = " \(valAmt.currencyFormat) "
            } else {
                lbTotalAmount.text = "Total Amount " + totalLable.currencyFormat
                lblTipAmountPlus.text = "\(totalLable.currencyFormat)"
                lblTipAmountPlus.isHidden = true
                tipViewDotBorder.isHidden = true
            }
            // remove dotted border
            // Create by Altab (14-oct-2022) for new Dot border design for Tip
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                for layer in self.tipViewDotBorder!.layer.sublayers! {
                    if layer.isKind(of: CAShapeLayer.self) {
                        layer.removeFromSuperlayer()
                    }
                }
                self.tipViewDotBorder.addDashBorder(color: UIColor.init(red: 237/255, green: 112/255, blue: 108/255, alpha: 1.0), width: 2.0, cornerRadius: 6)
            }
            
        }
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            textField.resignFirstResponder()
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        // disableValidateToChangeColor()
        textField.resignFirstResponder()
        return false
    }
}

