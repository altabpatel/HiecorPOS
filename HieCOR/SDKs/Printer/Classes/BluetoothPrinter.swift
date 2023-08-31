//
//  BluetoothPrinter.swift
//  HieCOR
//
//  Created by HTS on 4/24/18.
//  Copyright © 2018 HTS. All rights reserved.
//

import Foundation

class BluetoothPrinter: NSObject {
    
    static let sharedInstance = BluetoothPrinter()
    private var index = 0
    private var NORMAL_SIZE_LINE_LENGTH_SECOND = 0
    private var NORMAL_SPACE_POSITION = 0
    private var NORMAL_SIZE_LINE_LENGTH = 0

    
    private override init() {}
    
    private func getImage(image: UIImage, backgroundColor: UIColor)->UIImage?{
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        backgroundColor.setFill()
        UIRectFill(CGRect(origin: .zero, size: image.size))
        let rect = CGRect(origin: .zero, size: image.size)
        let path = UIBezierPath(arcCenter: CGPoint(x:rect.midX, y:rect.midY), radius: rect.midX, startAngle: 0, endAngle: 6.28319, clockwise: true)
        path.fill()
        image.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    //Class Functions
    func isConnected() -> Bool {
        return (PrintersViewController.printerManager == nil) ? false : PrintersViewController.printerManager!.canPrint
    }
    
    
    func printContent(dict: JSONDictionary){
        let cardDetails = dict["card_details"] as? [arrayReceiptCardContentModel] ?? [arrayReceiptCardContentModel]()
        let PaymentSatus = dict["payment_status"] as? String ?? ""
        let printAllTransactions = dict["print_all_transactions"] as? String ?? "false"
        let extraMerchantCopy = dict["extra_merchant_copy"] as? String ?? "false"
        if PrintersViewController.printerManager!.canPrint {
            
            if PaymentSatus.uppercased() != "REFUND_PARTIAL" && PaymentSatus.uppercased() != "REFUND" {
                if cardDetails.count > 1 && printAllTransactions == "true" {
                    //Prepare Receipt
                    let Thread1 = DispatchQueue(label: "Thread1")
                    let Thread2 = DispatchQueue(label: "Thread2")
                  //  let Thread3 = DispatchQueue(label: "Thread3")
                    Thread2.sync {
                        
                        for i in 0..<cardDetails.count {
                            let cardDetail = cardDetails[i]
                            let cardType = cardDetail.card_type

                            Thread1.sync {
                                index = 0
                                if extraMerchantCopy == "true" {
                                    
                                    if (cardType != "" && cardType == "visa") || cardType == "credit" || cardType == "credit_card" || cardType == "credit card" || cardType == "mast" || cardType == "amex" || cardType == "amx" || cardType == "discover"  {
                                        
                                        for _ in 0..<2 {
                                            printSingleTransactionReceiptForSplitPayment(dict: dict, trans_i: i)
                                            sleep(1)
                                        }
                                    }else {
                                       printSingleTransactionReceiptForSplitPayment(dict: dict, trans_i: i)
                                           sleep(1)
                                    }
                                }else{
                                    printSingleTransactionReceiptForSplitPayment(dict: dict, trans_i: i)
                                       sleep(1)
                                }
                            }
                            
                        }
                     printMainContent(dict: dict)
                        sleep(1)
                    }
                    
                }else{
                    if extraMerchantCopy == "true" {
                      if (cardDetails[0].txn_type != "" && cardDetails[0].txn_type == "visa") || cardDetails[0].txn_type == "credit" || cardDetails[0].txn_type == "credit_card" || cardDetails[0].txn_type == "credit card" || cardDetails[0].txn_type == "mast" || cardDetails[0].txn_type == "amex" || cardDetails[0].txn_type == "amx" || cardDetails[0].txn_type == "discover" || cardDetails[0].txn_type == "EMV" || cardDetails[0].txn_type == "EMV-DEBIT_CARD" || cardDetails[0].txn_type == "EMV-GIFT_CARD"  {
                        
                        for h in 0..<2 {
                            printMainContent(dict: dict)
                            print("tets second\(h)")
                            sleep(2)
                        }
                        }else {
                              printMainContent(dict: dict)
                          
                        }
                        
                    }else{
                            printMainContent(dict: dict)
                    }
                }
            }else{
                  printMainContent(dict: dict)
                 
            }
        } else if DataManager.isStarPrinterConnected {
            
            if PaymentSatus.uppercased() != "REFUND_PARTIAL" && PaymentSatus.uppercased() != "REFUND" {
                if cardDetails.count > 1 && printAllTransactions == "true" {
                    //Prepare Receipt
                    let Thread1 = DispatchQueue(label: "Thread1")
                    let Thread2 = DispatchQueue(label: "Thread2")
                  //  let Thread3 = DispatchQueue(label: "Thread3")
                    Thread2.sync {
                        
                        for i in 0..<cardDetails.count {
                            let cardDetail = cardDetails[i]
                            let cardType = cardDetail.card_type

                            Thread1.sync {
                                index = 0
                                if extraMerchantCopy == "true" {
                                    
                                    if (cardType != "" && cardType == "visa") || cardType == "credit" || cardType == "credit_card" || cardType == "credit card" || cardType == "mast" || cardType == "amex" || cardType == "amx" || cardType == "discover"  {
                                        
                                        for _ in 0..<2 {
//                                            printSingleTransactionReceiptForSplitPayment(dict: dict, trans_i: i)
                                            callStarPrinterMethod(issplit: true, transId: i)
                                            sleep(1)
                                        }
                                    }else {
                                       //printSingleTransactionReceiptForSplitPayment(dict: dict, trans_i: i)
                                        callStarPrinterMethod(issplit: true, transId: i)
                                        sleep(1)
                                    }
                                }else{
                                    //printSingleTransactionReceiptForSplitPayment(dict: dict, trans_i: i)
                                    callStarPrinterMethod(issplit: true, transId: i)
                                       sleep(1)
                                }
                            }
                            
                        }
                     callStarPrinterMethod(issplit: false, transId: 0)
                        sleep(1)
                    }
                    
                }else{
                    if extraMerchantCopy == "true" {
                      if (cardDetails[0].txn_type != "" && cardDetails[0].txn_type == "visa") || cardDetails[0].txn_type == "credit" || cardDetails[0].txn_type == "credit_card" || cardDetails[0].txn_type == "credit card" || cardDetails[0].txn_type == "mast" || cardDetails[0].txn_type == "amex" || cardDetails[0].txn_type == "amx" || cardDetails[0].txn_type == "discover" || cardDetails[0].txn_type == "EMV" || cardDetails[0].txn_type == "EMV-DEBIT_CARD" || cardDetails[0].txn_type == "EMV-GIFT_CARD"  {
                        
                        for h in 0..<2 {
                            callStarPrinterMethod(issplit: false, transId: 0)
                            print("tets second\(h)")
                            sleep(2)
                        }
                        }else {
                              callStarPrinterMethod(issplit: false, transId: 0)
                          
                        }
                        
                    }else{
                            callStarPrinterMethod(issplit: false, transId: 0)
                    }
                }
            }else{
                  callStarPrinterMethod(issplit: false, transId: 0)
                 
            }
        }
    }
    
    func callStarPrinterMethod(issplit:Bool, transId:Int) {
        let commands: Data
        
        let emulation: StarIoExtEmulation = LoadStarPrinter.getEmulation()
        print(emulation)
        
        let width: Int = LoadStarPrinter.getSelectedPaperSize().rawValue
        
        let paperSize: PaperSizeIndex = LoadStarPrinter.getSelectedPaperSize()
        let language: LanguageIndex = LanguageIndex.english//LoadStarPrinter.getSelectedLanguage()
        let localizeReceipts: ILocalizeReceipts = LocalizeReceipts.createLocalizeReceipts(language,
                                                                                          paperSizeIndex: paperSize)
        commands = PrinterFunctions.createTextReceiptApiData(emulation,utf8: true,issplit: issplit,transId: transId)
        
        //self.blind = true
        
        //  if #available(iOS 13.0, *) {
        Communication.sendCommandsForPrintReDirection(commands,
                                                      timeout: 10000) { (communicationResultArray) in
                                                        // self.blind = false
                                                        
                                                        var message: String = ""
                                                        
                                                        for i in 0..<communicationResultArray.count {
                                                            if i == 0 {
                                                                message += "[Destination]\n"
                                                            }
                                                            else {
                                                                message += "[Backup]\n"
                                                            }
                                                            
                                                            message += "Port Name: " + communicationResultArray[i].0 + "\n"
                                                            
                                                            switch communicationResultArray[i].1.result {
                                                            case .success:
                                                                message += "----> Success!\n\n";
                                                                message = ""
                                                            case .errorOpenPort:
                                                                message += "----> Fail to openPort\n\n";
                                                            case .errorBeginCheckedBlock:
                                                                message += "----> Printer is offline (beginCheckedBlock)\n\n";
                                                            case .errorEndCheckedBlock:
                                                                message += "----> Printer is offline (endCheckedBlock)\n\n";
                                                            case .errorReadPort:
                                                                message += "----> Read port error (readPort)\n\n";
                                                            case .errorWritePort:
                                                                message += "----> Write port error (writePort)\n\n";
                                                            default:
                                                                message += "----> Unknown error\n\n";
                                                            }
                                                        }
                                                        
                                                        
                                                        
                                                        //                                                                    self.showSimpleAlert(title: "Communication Result",
                                                        //                                                                                         message: message,
                                                        //                                                                                         buttonTitle: "OK",
                                                        //                                                                                         buttonStyle: .cancel)
                                                        if message != "" {
                                                            appDelegate.showToast(message: message)
                                                        }
        }
    }
    

    func printSingleTransactionReceiptForSplitPayment(dict: JSONDictionary, trans_i: Int){
        
        let size = Int(round(Double(DataManager.paperSize) * 6.62))
        let font = 12
        let title = dict["title"] as? String ?? ""
        let address = (dict["address"] as? String ?? "").replacingOccurrences(of: " • ", with: ".")
        let orderid = dict["orderid"] as? String ?? ""
        let addedDate = dict["date"] as? String ?? ""
        let orderTime = dict["order_time"] as? String ?? ""
        let cardDetails = dict["card_details"] as? [arrayReceiptCardContentModel] ?? [arrayReceiptCardContentModel]()
        let footertext = (dict["footertext"] as? String ?? "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "<br>", with: "-")
        let cardAgreementText = (dict["card_agreement_text"] as? String ?? "").replacingOccurrences(of: "<br>", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
        let refundPolicyText = (dict["refund_policy_text"] as? String ?? "").replacingOccurrences(of: "<br>", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
        let footerTextP = (dict["footer_text"] as? String ?? "").replacingOccurrences(of: "<br>", with: "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "")
        let cardHolderName = dict["card_holder_name"] as? String ?? ""
        let cardHolderLabel = dict["card_holder_label"] as? String ?? ""
        let companyName = dict["company_name"] as? String ?? ""
        let customerServiceEmail = dict["customer_service_email"] as? String ?? ""
        let customerServicePhone = dict["customer_service_phone"] as? String ?? ""
        let addressDetail = dict["addressDetail"] as? String ?? ""
        let source = dict["source"] as? String ?? ""
        let showCompanyAddress = dict["show_company_address"] as? Bool ?? false
        let showtiplinestatus = dict["showtipline_status"] as? Bool ?? false
        let headerText = dict["header_text"] as? String ?? ""
        
        let barcode = dict["bar_code"] as? String ?? ""
        let signature = dict["signature"] as? String ?? ""
        let is_signature_placeholder = dict["is_signature_placeholder"] as? Bool ?? false
        let qr_code = dict["qr_code"] as? String ?? ""
        let qr_code_data = dict["qr_code_data"] as? String ?? ""
        let hide_qr_code = dict["hide_qr_code"] as? Bool ?? false
        let cardDetail = cardDetails[trans_i]
        let cardType = cardDetail.card_type
        let amount = Double(cardDetail.amount)
        let cardNo = (cardDetail.card_no)
        let cardNowithoutStar = (cardDetail.card_no).replacingOccurrences(of: "*", with: "")
        // by sudama Start
        let totalAmount = Double(cardDetail.total_amount) ?? 0.0
        let approvalCode = cardDetail.approval_code
        let signatureUrl = cardDetail.signature_url
        let entryMethod = cardDetail.entry_method
        let paymentStatus = cardDetail.payment_status
        let transactionType = cardDetail.transaction_type
        let tipValue = Double(cardDetail.tip) ?? 0.0
        let totalInString = "$" + totalAmount.roundToTwoDecimal
        let tipInString = "$" + tipValue.roundToTwoDecimal
        var signatureImage: UIImage?
        
        if let url = URL(string: signature) {
            do {
                let data = try Data(contentsOf: url)
                if signature != "" {
                    signatureImage = getImage(image: UIImage(data: data)!, backgroundColor: .white)!
                }
            }
            catch let error {
                print("Error in downloading signature image: \(error)")
            }
        }
        
        var receipt = [Receipt]()
        
        var headerReceipt = Receipt()
        
        let charactersCount =  Int((size / font)/2) - 2
        if title != "" {
            headerReceipt.add(block: title.bc.customSize(printDensity: size, fontDensity: font, isBold:true, attributes: [TextBlock.PredefinedAttribute.boldFont, TextBlock.PredefinedAttribute.alignment(.center)]))
        }
        
        if showCompanyAddress {
            if address != "\n" {
                headerReceipt.add(block: address.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.normalBoldFont, TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            if addressDetail != "," {
                headerReceipt.add(block: addressDetail.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.normalBoldFont, TextBlock.PredefinedAttribute.alignment(.center)]))
            }
        }
        if customerServiceEmail != "" {
            headerReceipt.add(block: customerServiceEmail.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.normalBoldFont, TextBlock.PredefinedAttribute.alignment(.center)]))
        }
        
        if customerServicePhone != "" {
            headerReceipt.add(block: customerServicePhone.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.normalBoldFont, TextBlock.PredefinedAttribute.alignment(.center)]))
        }
        
        if headerText != "" {
            headerReceipt.add(block: headerText.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.normalBoldFont, TextBlock.PredefinedAttribute.alignment(.center)]))
        }
        
        headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
        
        if addedDate != "" || orderTime != "" {
            headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: addedDate , v: orderTime, attributes: [TextBlock.PredefinedAttribute.normalSize, TextBlock.PredefinedAttribute.alignment(.center)]))
        }
        
        if orderid != "" {
            //headerReceipt.add(block: "Order #\(orderid)".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.normalSize, TextBlock.PredefinedAttribute.alignment(.left)]))
            headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Order  " , v: "#\(orderid)", attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))

        }
        
        if transactionType != "" {
            headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Transaction Type  " , v: transactionType, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
        }
        
        if cardHolderName != "" {
            headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: cardHolderLabel + "  " , v: cardHolderName, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
        }
        
        if companyName != "" {
            headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Company Name  " , v: companyName, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
        }
        
        if cardNo != "************" && cardDetails.count > 1 {
            if cardNo != "" && cardDetails.count > 1 {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Card#  " , v: cardNo, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
        }
        
        if source != "" {
            headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Sale Location  " , v: source, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
        }
        
        if approvalCode != "" {
            headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Approval Code  " , v: approvalCode, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
        }
        
        if entryMethod != "" {
            headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Entry Method  " , v: entryMethod, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
        }
        
        if paymentStatus != "" {
            headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Payment Status  " , v: paymentStatus, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
        }
        
        
        if tipInString == "$0.00" {
            if showtiplinestatus {
                headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Tip" , v: "------", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  "------", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
        } else {
            //if showtiplinestatus {
            headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Tip ", v:  tipInString.count > charactersCount ? "\(String(describing: tipInString.prefix(charactersCount)) + String(describing: tipInString.dropFirst(charactersCount)))" : tipInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //}
        }
        
        
        if tipInString != "$0.00" {
            headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
        } else {
            if !showtiplinestatus {
                headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
        }
        headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
        if cardNowithoutStar != "" {
            if cardNowithoutStar != "************" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font,k: (cardType + "-" + cardNowithoutStar), v: "$\((amount ?? 0.0).roundToTwoDecimal)".count > charactersCount ? "\(String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".prefix(charactersCount)) + String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".dropFirst(charactersCount)))" : "$\((amount ?? 0.0).roundToTwoDecimal)" , attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
        } else {
            headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font,k: cardType, v: "$\((amount ?? 0.0).roundToTwoDecimal)".count > charactersCount ? "\(String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".prefix(charactersCount)) + String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".dropFirst(charactersCount)))" : "$\((amount ?? 0.0).roundToTwoDecimal)" , attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
        }
        
      //  headerReceipt.add(block: "\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
        
//        // footer
//        if cardAgreementText != "" {
//            headerReceipt.add(block: cardAgreementText.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.light, TextBlock.PredefinedAttribute.alignment(.center)]))
//        }
//        if refundPolicyText != "" {
//            headerReceipt.add(block: refundPolicyText.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.light, TextBlock.PredefinedAttribute.alignment(.center)]))
//        }
//        if footerTextP != "" {
//            headerReceipt.add(block: footerTextP.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.light, TextBlock.PredefinedAttribute.alignment(.center)]))
//        }
//
//        headerReceipt.add(block: "\n\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
//        headerReceipt.add(block: "-".bc.dividing(printDensity: size, fontDensity: font))
//
//        receipt.append(headerReceipt)
        
        
        //----
        
        let footerTextArray = footertext.components(separatedBy: "-")
        // var footerDescriptionReceipt = Receipt()
        
//        for text in footerTextArray {
//            if text != "" {
//                headerReceipt.add(block: text.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
//            }
//        }
//
//        headerReceipt.add(block: "\n\n\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
      //  headerReceipt.add(block: "-".bc.dividing(printDensity: size, fontDensity: font))
        receipt.append(headerReceipt)
        
//       // ---
//        let footerTextArray = footertext.components(separatedBy: "-")
//        var footerDescriptionReceipt = Receipt()
//
//        for text in footerTextArray {
//            if text != "" {
//                footerDescriptionReceipt.add(block: text.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
//            }
//        }
        
      //  footerDescriptionReceipt.add(block: "\n\n\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
     //   receipt.append(footerDescriptionReceipt)
        //
        //Print
        index = 0
        self.callPrint(receipt: receipt,orderId: orderid, signatureImage: signatureImage, footertext: "", size: size, font: font)
        if (cardDetails[trans_i].txn_type != "" && cardDetails[trans_i].txn_type == "visa") || cardDetails[trans_i].txn_type == "credit" || cardDetails[trans_i].txn_type == "credit_card" || cardDetails[trans_i].txn_type == "credit card" || cardDetails[trans_i].txn_type == "mast" || cardDetails[trans_i].txn_type == "amex" || cardDetails[trans_i].txn_type == "amx" || cardDetails[trans_i].txn_type == "discover" || cardDetails[trans_i].txn_type == "EMV" || cardDetails[trans_i].txn_type == "EMV-DEBIT_CARD" || cardDetails[trans_i].txn_type == "EMV-GIFT_CARD"  {
            forImagePrint(signatureImage: signatureImage)
        }
        footerReceiptDataShow(footerArr: footerTextArray, orderId: orderid, signaData: signatureImage, discountInStringObj: "")
        if barcode != "" {// for bar or QR code print By Altab (23Dec2022)
            barCodeImagePrint(barcodeString: barcode)
        }else {
            if !hide_qr_code {
                qrCodeImagePrint(qrcodeString: qr_code_data)
            }
        }
    }
    
    
    
   /*   // func by sudama
    func printReceiptForDifferentPaymentType(dict: JSONDictionary) {
        let size = Int(round(Double(DataManager.paperSize) * 6.62))
               let font = 12
               let title = dict["title"] as? String ?? ""
               let address = (dict["address"] as? String ?? "").replacingOccurrences(of: " • ", with: ".")
               let orderid = dict["orderid"] as? String ?? ""
               let addedDate = dict["date"] as? String ?? ""
               let orderTime = dict["order_time"] as? String ?? ""
               let saleLocation = dict["sale_location"] as? String ?? ""
               let products = dict["products"] as? [arrayReceiptContentModel] ?? [arrayReceiptContentModel]()
               let cardDetails = dict["card_details"] as? [arrayReceiptCardContentModel] ?? [arrayReceiptCardContentModel]()
               let barcode = dict["bar_code"] as? String ?? ""
               let signature = dict["signature"] as? String ?? ""
               let footertext = (dict["footertext"] as? String ?? "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "<br>", with: "-")
               let transactiontype = dict["transactiontype"] as? String ?? ""
               let entryMethod = dict["entry_method"] as? String ?? ""
               var cardNumber = String()
               let approvalCode = dict["approval_code"] as? String ?? ""
               let couponCode = dict["coupon_code"] as? String ?? ""
               let cardHolderName = dict["card_holder_name"] as? String ?? ""
               let cardHolderLabel = dict["card_holder_label"] as? String ?? ""
               let companyName = dict["company_name"] as? String ?? ""
               let city = dict["city"] as? String ?? ""
               let region = dict["region"] as? String ?? ""
               let customerServiceEmail = dict["customer_service_email"] as? String ?? ""
               let customerServicePhone = dict["customer_service_phone"] as? String ?? ""
               let addressDetail = dict["addressDetail"] as? String ?? ""
               let source = dict["source"] as? String ?? ""
               let showCompanyAddress = dict["show_company_address"] as? Bool ?? false
               //let balanceDue = dict["balance_due"] as? String ?? ""
               let PaymentSatus = dict["payment_status"] as? String ?? ""
               let showtiplinestatus = dict["showtipline_status"] as? Bool ?? false
               let balanceDue = (Double((dict["balance_due"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
               
               let postalCode = dict["postal_code"] as? String ?? ""
               let headerText = dict["header_text"] as? String ?? ""
               let total = (Double((dict["total"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
               let subtotal = (Double((dict["subtotal"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
               let shipping = (Double((dict["shipping"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
               let discount = (Double((dict["discount"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
               let tax = (Double((dict["tax"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
               let tip = (Double((dict["tip"] as? String ?? "0.  00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
               let changeDue = (Double((dict["change_due"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
               let totalRefund = (Double((dict["total_refund_amount"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
               let showAllFinal_transactions = dict["show_all_final_transactions"] as? String ?? "false"
               let printAllTransactions = dict["print_all_transactions"] as? String ?? "false"
               let extraMerchantCopy = dict["extra_merchant_copy"] as? String ?? "false"
               
//               let totalInString = "$" + total.roundToTwoDecimal
//               let subtotalInString = "$" + subtotal.roundToTwoDecimal
//               let shippingInString = "$" + shipping.roundToTwoDecimal
//               let discountInString = "$" + discount.roundToTwoDecimal
//               let taxInString = "$" + tax.roundToTwoDecimal
//               let tipInString = "$" + tip.roundToTwoDecimal
//               let changeInString = "$" + changeDue.roundToTwoDecimal
//               let balanceDueInString = "$" + balanceDue.roundToTwoDecimal
//               let totalRefundAmount = "$" + totalRefund.roundToTwoDecimal
               var signatureImage: UIImage?
//
     
        if let url = URL(string: signature) {
            do {
                let data = try Data(contentsOf: url)
                if signature != "" {
                    signatureImage = getImage(image: UIImage(data: data)!, backgroundColor: .white)!
                }
            }
            catch let error {
                print("Error in downloading signature image: \(error)")
            }
        }
        
        
        let charactersCount =  Int((size / font)/2) - 2
        
//        //Products
//        var blocks = [[Block]]()
//        var block = [Block]()
        
//        for i in 0..<products.count {
//            let product = products[i]
//            var productTitle = product.title
//            let productNote = product.note
//            let attriute = product.attributes
//
//            if Double(productTitle.count) > Double(size / font) {
//                productTitle = productTitle.prefix((size / font) - 2) + ".."
//            }
//
//            let qty = Double(product.qty)
//
//            let num = size / font
//
//            var productCode = product.code
//
//            if Double(productCode.count) > (Double(num)*0.4) {
//                productCode = productCode.prefix(16) + ".."
//            }
//
//            if product.id == "coupon" {
//                var price = String()
//
//                if product.price.stringValue.first == "-" {
//                    price = product.price.stringValue.replacingOccurrences(of: "-", with: "")
//                    price = "-$" + price
//                }else {
//                    price =  "$" + product.price.stringValue
//                }
//
//                let priceInDouble = Double(price) ?? 0
//
//                block.append(productTitle.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
//                if productCode != "" {
//                    block.append("".bc.kv(printDensity: size, fontDensity: font, k: productCode , v: "\(qty.roundToTwoDecimal + " x " + priceInDouble.roundToTwoDecimal)", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
//                } else {
//                    block.append("\(qty.roundToTwoDecimal + " x " + priceInDouble.roundToTwoDecimal)".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
//                }
//                block.append("-".bc.dividing(printDensity: size, fontDensity: font))
//
//            }else {
//
//                block.append(productTitle.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
//                block.append(productNote.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
//                if productCode != "" {
//                    block.append("".bc.kv(printDensity: size, fontDensity: font, k: productCode , v: "\(qty.roundToTwoDecimal) x $\(product.price.doubleValue.roundToTwoDecimal)", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
//                } else {
//                    block.append("\(qty.roundToTwoDecimal) x $\(product.price.doubleValue.roundToTwoDecimal)".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.right)]))
//                }
//
//                block.append(attriute.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
//
//                block.append("-".bc.dividing(printDensity: size, fontDensity: font))
//            }
//
//            if block.count == 10 {
//                blocks.append(block)
//                block = [Block]()
//            }
//        }
//        if block.count > 0 {
//            blocks.append(block)
//            block = [Block]()
//        }
//
//        // Card Type
//        var blocks1 = [[Block]]()
//        var block1 = [Block]()
        

        if PrintersViewController.printerManager!.canPrint {
            if PaymentSatus.uppercased() != "REFUND_PARTIAL" && PaymentSatus.uppercased() != "REFUND" {
                if cardDetails.count > 1 && printAllTransactions == "false" {
                    //Prepare Receipt
                    for i in 0..<cardDetails.count {
                        let cardDetail = cardDetails[i]
                        let cardType = cardDetail.card_type
                        let amount = Double(cardDetail.amount)
                        let cardNo = (cardDetail.card_no)
                        let cardNowithoutStar = (cardDetail.card_no).replacingOccurrences(of: "*", with: "")
                        // by sudama Start
                        let txnId = cardDetail.txn_id
                        let totalAmount = Double(cardDetail.total_amount) ?? 0.0
                        let approvalCode = cardDetail.approval_code
                        let entryMethod = cardDetail.entry_method
                        let paymentStatus = cardDetail.payment_status
                        let transactionType = cardDetail.transaction_type
                        let signatureUrl = cardDetail.signature_url
                        let isSignatureBool = cardDetail.isSignature
                        let signatureImageBase64 = cardDetail.signature_image_base_64
                        let tipValue = Double(cardDetail.tip) ?? 0.0
                        
                        let totalInString = "$" + totalAmount.roundToTwoDecimal
                        let subtotalInString = "$" + subtotal.roundToTwoDecimal
                        let shippingInString = "$" + shipping.roundToTwoDecimal
                        let discountInString = "$" + discount.roundToTwoDecimal
                        let taxInString = "$" + tax.roundToTwoDecimal
                        let tipInString = "$" + tipValue.roundToTwoDecimal
                        let changeInString = "$" + changeDue.roundToTwoDecimal
                        let balanceDueInString = "$" + balanceDue.roundToTwoDecimal
                        let totalRefundAmount = "$" + totalRefund.roundToTwoDecimal
                        var signatureImage: UIImage?
        
                        var receipt = [Receipt]()
                        
                        var headerReceipt = Receipt()
                        
                        if title != "" {
                            headerReceipt.add(block: title.bc.customSize(printDensity: size, fontDensity: font, isBold:true, attributes: [TextBlock.PredefinedAttribute.bold,TextBlock.PredefinedAttribute.scale(.l1), TextBlock.PredefinedAttribute.alignment(.center)]))
                        }
                        
                        if showCompanyAddress {
                            if address != "\n" {
                                headerReceipt.add(block: address.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
                            }
                            if addressDetail != "," {
                                headerReceipt.add(block: addressDetail.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
                            }
                        }
                        if customerServiceEmail != "" {
                            headerReceipt.add(block: customerServiceEmail.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
                        }
                        
                        if customerServicePhone != "" {
                            headerReceipt.add(block: customerServicePhone.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
                        }
                        
                        if headerText != "" {
                            headerReceipt.add(block: headerText.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
                        }
                        
                        headerReceipt.add(block: "\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                        
                        if addedDate != "" || orderTime != "" {
                            headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: addedDate , v: orderTime, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                        }
                        
                        if orderid != "" {
                            headerReceipt.add(block: "Order #\(orderid)".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                        }
                        
                        if transactiontype != "" {
                            headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Transaction Type  " , v: transactiontype, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                        }
                        
                        if cardHolderName != "" {
                            headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: cardHolderLabel + "  " , v: cardHolderName, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                        }
                        
                        if companyName != "" {
                            headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Company Name  " , v: companyName, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                        }
                        
                        if cardNo != "************" && cardDetails.count > 1 {
                            if cardNo != "" && cardDetails.count > 1 {
                                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Card#  " , v: cardNo, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                            }
                        }
                        
                        if source != "" {
                            headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Sale Location  " , v: source, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                        }
                        
                        if approvalCode != "" {
                            headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Approval Code  " , v: approvalCode, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                        }
                        
                        if entryMethod != "" {
                            headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Entry Method  " , v: entryMethod, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                        }
                        
                        if PaymentSatus != "" {
                            headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Payment Status  " , v: PaymentSatus, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                        }
                        
                        
                        
                        if tipInString == "$0.00" {
                            if showtiplinestatus {
                                headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Tip" , v: "------", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                                headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  "------", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                            }
                        } else {
                            //if showtiplinestatus {
                            headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Tip ", v:  tipInString.count > charactersCount ? "\(String(describing: tipInString.prefix(charactersCount)) + String(describing: tipInString.dropFirst(charactersCount)))" : tipInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                            //}
                        }
                        
                        
                        if tipInString != "$0.00" {
                            headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                        } else {
                            if !showtiplinestatus {
                                headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                            }
                        }
                        headerReceipt.add(block: "\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                        if cardNowithoutStar != "" {
                            if cardNowithoutStar != "************" {
                               headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font,k: (cardType + "-" + cardNowithoutStar), v: "$\((amount ?? 0.0).roundToTwoDecimal)".count > charactersCount ? "\(String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".prefix(charactersCount)) + String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".dropFirst(charactersCount)))" : "$\((amount ?? 0.0).roundToTwoDecimal)" , attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                            }
                        } else {
                           headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font,k: cardType, v: "$\((amount ?? 0.0).roundToTwoDecimal)".count > charactersCount ? "\(String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".prefix(charactersCount)) + String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".dropFirst(charactersCount)))" : "$\((amount ?? 0.0).roundToTwoDecimal)" , attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                        }
//                        blocks1.append(block1)
//                        //
                        headerReceipt.add(block: "\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                  
                        //receipt.append(headerReceipt)
                        let footerTextArray = footertext.components(separatedBy: "-")
                        // var footerDescriptionReceipt = Receipt()
                        
                        for text in footerTextArray {
                            if text != "" {
                                headerReceipt.add(block: text.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
                            }
                        }
                        
                        headerReceipt.add(block: "\n\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
                        headerReceipt.add(block: "-".bc.dividing(printDensity: size, fontDensity: font))
                        receipt.append(headerReceipt)
                        
                        //Print
                        index = 0
                        self.callPrint(receipt: receipt,orderId: orderid, signatureImage: signatureImage, footertext: footertext, size: size, font: font)
                    }
                }
            }
        }
        
    }*/
    // Final print  Receipt
  func printMainContent(dict: JSONDictionary) {
        let size = Int(round(Double(DataManager.paperSize) * 6.62))
        let font = 12
        
        let title = dict["title"] as? String ?? ""
        let address = (dict["address"] as? String ?? "").replacingOccurrences(of: " • ", with: ".")
        let orderid = dict["orderid"] as? String ?? ""
        let addedDate = dict["date"] as? String ?? ""
        let orderTime = dict["order_time"] as? String ?? ""
        let saleLocation = dict["sale_location"] as? String ?? ""
        let products = dict["products"] as? [arrayReceiptContentModel] ?? [arrayReceiptContentModel]()
        let cardDetails = dict["card_details"] as? [arrayReceiptCardContentModel] ?? [arrayReceiptCardContentModel]()
        let barcode = dict["bar_code"] as? String ?? ""
        let signature = dict["signature"] as? String ?? ""
        let footertext = (dict["footertext"] as? String ?? "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "<br>", with: "-")
        let transactiontype = dict["transactiontype"] as? String ?? ""
        let entryMethod = dict["entry_method"] as? String ?? ""
        var cardNumber = String()
        let approvalCode = dict["approval_code"] as? String ?? ""
        let couponCode = dict["coupon_code"] as? String ?? ""
        let cardHolderName = dict["card_holder_name"] as? String ?? ""
        let cardHolderLabel = dict["card_holder_label"] as? String ?? ""
        let companyName = dict["company_name"] as? String ?? ""
        let city = dict["city"] as? String ?? ""
        let region = dict["region"] as? String ?? ""
        let customerServiceEmail = dict["customer_service_email"] as? String ?? ""
        let customerServicePhone = dict["customer_service_phone"] as? String ?? ""
        let addressDetail = dict["addressDetail"] as? String ?? ""
        let source = dict["source"] as? String ?? ""
        let showCompanyAddress = dict["show_company_address"] as? Bool ?? false
        //let balanceDue = dict["balance_due"] as? String ?? ""
        let PaymentSatus = dict["payment_status"] as? String ?? ""
        let showtiplinestatus = dict["showtipline_status"] as? Bool ?? false
        let balanceDue = (Double((dict["balance_due"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
        
        let postalCode = dict["postal_code"] as? String ?? ""
        let headerText = dict["header_text"] as? String ?? ""
        let total = (Double((dict["total"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
        let subtotal = (Double((dict["subtotal"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
        let shipping = (Double((dict["shipping"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
        let discount = (Double((dict["discount"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
        let tax = (Double((dict["tax"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
        let tip = (Double((dict["tip"] as? String ?? "0.  00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
        let changeDue = (Double((dict["change_due"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
        
        let totalRefund = (Double((dict["total_refund_amount"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
        let notes = dict["notes"] as? String ?? ""
        let isNotes = dict["isNotes"] as? Bool ?? false
        let lowvaluesig_status = dict["lowvaluesig_status"] as? Bool ?? false
        let lowvaluesig_status_setting_flag = dict["lowvaluesig_status_setting_flag"] as? Bool ?? false
      let is_signature_placeholder = dict["is_signature_placeholder"] as? Bool ?? false
      let qr_code = dict["qr_code"] as? String ?? ""
      let qr_code_data = dict["qr_code_data"] as? String ?? ""
        
    let Acct  = dict["ACCT"] as? String ?? ""
     let Aid  = dict["AID"] as? String ?? ""
     let Tc  = dict["TC"] as? String ?? ""
     let Appname  = dict["AppName"] as? String ?? ""
    
        let showAllFinal_transactions = dict["show_all_final_transactions"] as? String ?? "false"
        let printAllTransactions = dict["print_all_transactions"] as? String ?? "false"
        let extraMerchantCopy = dict["extra_merchant_copy"] as? String ?? "false"
        
        let totalInString = "$" + total.roundToTwoDecimal
        let subtotalInString = "$" + subtotal.roundToTwoDecimal
        let shippingInString = "$" + shipping.roundToTwoDecimal
        let discountInString = "$" + discount.roundToTwoDecimal
        let taxInString = "$" + tax.roundToTwoDecimal
        let tipInString = "$" + tip.roundToTwoDecimal
        let changeInString = "$" + changeDue.roundToTwoDecimal
        let balanceDueInString = "$" + balanceDue.roundToTwoDecimal
        let totalRefundAmount = "$" + totalRefund.roundToTwoDecimal
        var signatureImage: UIImage?
      let hide_qr_code = dict["hide_qr_code"] as? Bool ?? false
      if is_signature_placeholder == false { // for black signature not print By Altab (23Dec2022)
          if let url = URL(string: signature) {
              do {
                  let data = try Data(contentsOf: url)
                  if signature != "" {
                      signatureImage = getImage(image: UIImage(data: data)!, backgroundColor: .white)!
                  }
              }
              catch let error {
                  print("Error in downloading signature image: \(error)")
              }
          }
      }
        
        
        
        let charactersCount =  Int((size / font)/2) - 2
        
        //Products
        var blocks = [[Block]]()
        var block = [Block]()
        
        for i in 0..<products.count {
            let product = products[i]
            var productTitle = product.title
            let productNote = product.note.trimmingCharacters(in: .whitespaces)
         //   let attriute = product.attributes
            var attriute = product.attributes
            var itemFields = product.itemFields
            if (attriute != "" && attriute.contains("|")) {
                attriute = attriute.replacingOccurrences(of: "| ", with: "\n").trimmingCharacters(in: .whitespaces)
            }
            if (itemFields != "" && itemFields.contains("|")) {
                itemFields = itemFields.replacingOccurrences(of: "| ", with: "\n").trimmingCharacters(in: .whitespaces)
            }
            if Double(productTitle.count) > Double(size / font) {
                productTitle = productTitle.prefix((size / font) - 2) + ".."
            }
            
            let qty = Double(product.qty)
            
            let num = size / font
            
            var productCode = product.code
            var isCodeLineChange = false
            
            if Double(productCode.count) > (Double(num)*0.4) {
               // productCode = "\(productCode.prefix(18))" // two Dot append
                isCodeLineChange = true
            }
            
            if product.id == "coupon" {
                var price = String()
                
                if product.price.stringValue.first == "-" {
                    price = product.price.stringValue.replacingOccurrences(of: "-", with: "")
                    price = "-$\(price.toDouble()?.roundToTwoDecimal ?? "0.00")"
                }else {
                    price =  "$\(product.price.stringValue.toDouble()?.roundToTwoDecimal ?? "0.00")"
                }
                
                let priceInDouble = price
                
                block.append(productTitle.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                 if productCode != "" {
                                   if isCodeLineChange {
                                       block.append(productCode.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                                       block.append("\(qty.roundToTwoDecimal + " x " + priceInDouble)".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                                   } else {
                                       block.append("".bc.kv(printDensity: size, fontDensity: font, k: productCode , v: "\(qty.roundToTwoDecimal + " x " + priceInDouble)", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                                   }
                               } else {
                                   block.append("\(qty.roundToTwoDecimal + " x " + priceInDouble)".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                               }
                block.append("-".bc.dividing(printDensity: size, fontDensity: font))
                
            }else {
                
                var price = String()
                
                if product.price.stringValue.first == "-" {
                    price = product.price.stringValue.replacingOccurrences(of: "-", with: "")
                    price = "-$\(price.toDouble()?.roundToTwoDecimal ?? "0.00")"
                }else {
                    price =  "$\(product.price.stringValue.toDouble()?.roundToTwoDecimal ?? "0.00")"
                }
                
                let priceInDouble = price
                
                block.append(productTitle.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                if productCode != "" {
                    if isCodeLineChange {
                        block.append(productCode.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                        block.append("\(qty.roundToTwoDecimal) x \(priceInDouble)".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.right)]))
                    } else {
                        block.append("".bc.kv(printDensity: size, fontDensity: font, k: productCode , v: "\(qty.roundToTwoDecimal) x \(priceInDouble)", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))

                    }
                   // block.append("".bc.kv(printDensity: size, fontDensity: font, k: productCode , v: "\(qty.roundToTwoDecimal) x $\(product.price.doubleValue.roundToTwoDecimal)", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                } else {
                    block.append("\(qty.roundToTwoDecimal) x \(priceInDouble)".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.right)]))
                }
                if productNote != "" {
                    block.append(productNote.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.normalSize, TextBlock.PredefinedAttribute.alignment(.left)]))
                }
                if itemFields != "" {
                    block.append(itemFields.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.normalSize, TextBlock.PredefinedAttribute.alignment(.left)]))
                }
                if attriute != "" {
                    block.append(attriute.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.normalSize, TextBlock.PredefinedAttribute.alignment(.left)]))
                }
                block.append("-".bc.dividing(printDensity: size, fontDensity: font))
            }
            
//            if block.count == 10 {
//                blocks.append(block)
//                block = [Block]()
//            }
        }
        if block.count > 0 {
            blocks.append(block)
            block = [Block]()
        }
        
        // Card Type
        var blocks1 = [[Block]]()
        var block1 = [Block]()
        
        for i in 0..<cardDetails.count {
            let cardDetail = cardDetails[i]
            let cardType = cardDetail.card_type.capitalized
            let aiType = cardDetail.ai_Type
            let amount = Double(cardDetail.amount)
            let cardNo = (cardDetail.card_no).replacingOccurrences(of: "*", with: "")
            var cardNoObj = cardDetail.card_no
            var cardTypeObj = cardDetail.card_type.capitalized
            if cardNo != "************" && cardDetails.count == 1 {
                if cardNo != "" && cardDetails.count == 1 {
                    cardNumber = cardDetail.card_no
                }
            }
            if cardNo != "" {
                if cardNo != "************" {
                    block1.append("".bc.kv(printDensity: size, fontDensity: font,k: (cardType + "-" + cardNo), v: "$\((amount ?? 0.0).roundToTwoDecimal)".count > charactersCount ? "\(String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".prefix(charactersCount)) + String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".dropFirst(charactersCount)))" : "$\((amount ?? 0.0).roundToTwoDecimal)" , attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                }
            } else {
                if cardDetail.card_no != "" {
                    cardNoObj = (cardDetail.card_no).replacingOccurrences(of: "*", with: "")
                    if cardNoObj != "" {
                        cardTypeObj = cardTypeObj + "-" + cardNumber
                    } else {
                        cardTypeObj = cardTypeObj + "-****"
                    }
                }
                if PaymentSatus == "PAID" || PaymentSatus == "REFUND" || PaymentSatus == "REFUND_PARTIAL" || PaymentSatus == "VOID" {
                        block1.append("".bc.kv(printDensity: size, fontDensity: font,k: cardTypeObj, v: "$\((amount ?? 0.0).roundToTwoDecimal)".count > charactersCount ? "\(String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".prefix(charactersCount)) + String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".dropFirst(charactersCount)))" : "$\((amount ?? 0.0).roundToTwoDecimal)" , attributes: [TextBlock.PredefinedAttribute.alignment(.right)]))
                } else if PaymentSatus == "INVOICE" && aiType != "" {
                    block1.append("".bc.kv(printDensity: size, fontDensity: font,k: cardTypeObj, v: "$\((amount ?? 0.0).roundToTwoDecimal)".count > charactersCount ? "\(String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".prefix(charactersCount)) + String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".dropFirst(charactersCount)))" : "$\((amount ?? 0.0).roundToTwoDecimal)" , attributes: [TextBlock.PredefinedAttribute.alignment(.right)]))
                }else if PaymentSatus == "Approved" {
                    block1.append("".bc.kv(printDensity: size, fontDensity: font,k: cardTypeObj, v: "$\((amount ?? 0.0).roundToTwoDecimal)".count > charactersCount ? "\(String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".prefix(charactersCount)) + String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".dropFirst(charactersCount)))" : "$\((amount ?? 0.0).roundToTwoDecimal)" , attributes: [TextBlock.PredefinedAttribute.alignment(.right)]))
                }
            }
            blocks1.append(block1)
            block1 = [Block]()
        }
        
        //Prepare Receipt
        if PrintersViewController.printerManager!.canPrint {
            
            var receipt = [Receipt]()
            
            var headerReceipt = Receipt()
            //            if saleLocation != "" {
            //                headerReceipt.add(block: saleLocation.bc.customSize(printDensity: size, fontDensity: font, isBold:true, attributes: [TextBlock.PredefinedAttribute.bold,TextBlock.PredefinedAttribute.scale(.l1), TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            
            if title != "" {
                headerReceipt.add(block: title.bc.customSize(printDensity: size, fontDensity: font, isBold:true, attributes: [TextBlock.PredefinedAttribute.boldFont, TextBlock.PredefinedAttribute.alignment(.center)]))
                headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            }
            
            
            //            if title != "" {
            //                headerReceipt.add(block: title.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            //                headerReceipt.add(block: "\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            //            }
            
            if showCompanyAddress {
                if address != "\n" {
                    headerReceipt.add(block: address.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.normalBoldFont, TextBlock.PredefinedAttribute.alignment(.center)]))
                }
                if addressDetail != "," {
                    headerReceipt.add(block: addressDetail.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.normalBoldFont, TextBlock.PredefinedAttribute.alignment(.center)]))
                }
            }
            
            
            //            if city != "" {
            //                headerReceipt.add(block: city.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            //
            //            if region != "" {
            //                headerReceipt.add(block: region.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            //
            //            if postalCode != "" {
            //                headerReceipt.add(block: postalCode.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            
            if customerServiceEmail != "" {
                headerReceipt.add(block: customerServiceEmail.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.normalBoldFont, TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
            if customerServicePhone != "" {
                headerReceipt.add(block: customerServicePhone.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.normalBoldFont, TextBlock.PredefinedAttribute.alignment(.center)]))
                headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            }
            
            if headerText != "" {
                headerReceipt.add(block: headerText.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.normalBoldFont, TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
            headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            
            if addedDate != "" || orderTime != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: addedDate , v: orderTime, attributes: [TextBlock.PredefinedAttribute.normalSize, TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
            if orderid != "" {
                //headerReceipt.add(block: "Order #\(orderid)".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.normalSize,TextBlock.PredefinedAttribute.alignment(.left)]))
                
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Order  " , v: "#\(orderid)", attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))

            }
            
            if transactiontype != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Transaction Type  " , v: transactiontype, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            }
            
            if cardHolderName != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: cardHolderLabel + "  " , v: cardHolderName, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
            if Acct != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "ACCT  " , v: Acct, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            }

            
            if companyName != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Company Name  " , v: companyName, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
            if cardNumber != "************" && cardDetails.count == 1 {
                if cardNumber != "" && cardDetails.count == 1 {
                    headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Card#  " , v: cardNumber, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                }
            }
            
            if source != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Sale Location  " , v: source, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
            if Aid != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "AID  " , v: Aid, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            }
            
            if Tc != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "TC  " , v: Tc, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            }

            if approvalCode != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Approval Code  " , v: approvalCode, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
            if entryMethod != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Entry Method  " , v: entryMethod, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
            if PaymentSatus != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Payment Status  " , v: PaymentSatus, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }

            if blocks.count > 0 {
                headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            }
      
            for block in blocks {
                for data in  block {
                   // var newReceipt = Receipt()
                    headerReceipt.add(block: data)
                    //receipt.append(newReceipt)
                      
                }
              
            }
          //  receipt.append(headerReceipt)
        var footerReceipt =  Receipt()
            //headerReceipt.add(block: "\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            if subtotalInString != "$0.00" {
                headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Subtotal ".count > charactersCount ? String(describing: "Subtotal ".prefix(charactersCount) + ".. ") : "Subtotal ", v: subtotalInString.count > charactersCount ? "\(String(describing: subtotalInString.prefix(charactersCount)) + String(describing: subtotalInString.dropFirst(charactersCount)))" : subtotalInString , attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            } else {
                if PaymentSatus == "REFUND" {
                    headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Subtotal ".count > charactersCount ? String(describing: "Subtotal ".prefix(charactersCount) + ".. ") : "Subtotal ", v: subtotalInString.count > charactersCount ? "\(String(describing: subtotalInString.prefix(charactersCount)) + String(describing: subtotalInString.dropFirst(charactersCount)))" : subtotalInString , attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                }
            }
            
            if discountInString != "$0.00" {
                if couponCode != "" {
                    headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font, k: ("Discount-" + couponCode + " ") , v: discountInString.count > charactersCount ? "\(String(describing: discountInString.prefix(charactersCount)) + String(describing: discountInString.dropFirst(charactersCount)))" : discountInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                } else {
                    headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Discount ", v:  discountInString.count > charactersCount ? "\(String(describing: discountInString.prefix(charactersCount)) + String(describing: discountInString.dropFirst(charactersCount)))" : discountInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                }
            }
            
            if shippingInString != "$0.00" {
                headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Shipping ".count > charactersCount ? String(describing: "Shipping ".prefix(charactersCount) + ".. ") : "Shipping ", v: shippingInString.count > charactersCount ? "\(String(describing: shippingInString.prefix(charactersCount)) + String(describing: shippingInString.dropFirst(charactersCount)))" : shippingInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
            if taxInString != "$0.00" {
                headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Tax ", v:  taxInString.count > charactersCount ? "\(String(describing: taxInString.prefix(charactersCount)) + String(describing: taxInString.dropFirst(charactersCount)))" : taxInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
            if tipInString == "$0.00" {
                if showtiplinestatus {
                    headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                    headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                    headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Tip" , v: "------", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                    headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                    headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  "------", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                }
            } else {
                //if showtiplinestatus {
                    headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Tip ", v:  tipInString.count > charactersCount ? "\(String(describing: tipInString.prefix(charactersCount)) + String(describing: tipInString.dropFirst(charactersCount)))" : tipInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                //}
            }
            
            
            if tipInString != "$0.00" {
                headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            } else {
                if !showtiplinestatus {
                    headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                }
            }
            
            if showAllFinal_transactions == "true" {
                headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                
                for block1 in blocks1 {
                    for data in  block1 {
                        headerReceipt.add(block: data)
                    }
                }
            }
            
            if totalRefundAmount != "$0.00" {
                headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Total Refunded Amt", v:  totalRefundAmount.count > charactersCount ? "\(String(describing: totalRefundAmount.prefix(charactersCount)) + String(describing: totalRefundAmount.dropFirst(charactersCount)))" : totalRefundAmount, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }

            if balanceDueInString != "$0.00"{
                headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Balance Due ", v:  balanceDueInString.count > charactersCount ? "\(String(describing: balanceDueInString.prefix(charactersCount)) + String(describing: balanceDueInString.dropFirst(charactersCount)))" : balanceDueInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
            //            if tipInString != "$0.00" {
            //                footerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Tip ", v:  tipInString.count > charactersCount ? "\(String(describing: tipInString.prefix(charactersCount)) + String(describing: tipInString.dropFirst(charactersCount)))" : tipInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            //   footerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            
            
            if changeInString != "$0.00" {
                headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Change ", v:  changeInString.count > charactersCount ? "\(String(describing: changeInString.prefix(charactersCount)) + String(describing: changeInString.dropFirst(charactersCount)))" : changeInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
            if isNotes {
                headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                if notes.count > (size/font) - 6 {
                    headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Notes ", v: "\n\(notes)" /*notes.count > charactersCount ? "\(String(describing: notes.prefix(charactersCount)) + String(describing: notes.dropFirst(charactersCount)))" : notes*/, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                    
                }else{
                    headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Notes ", v:  notes.count > charactersCount ? "\(String(describing: notes.prefix(charactersCount)) + String(describing: notes.dropFirst(charactersCount)))" : notes, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                    
                }
               // headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Notes ", v:  notes.count > charactersCount ? "\(String(describing: notes.prefix(charactersCount)) + String(describing: notes.dropFirst(charactersCount)))" : notes, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
           // headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            
            if (cardDetails[0].txn_type != "" && cardDetails[0].txn_type == "visa") || cardDetails[0].txn_type == "credit" || cardDetails[0].txn_type == "credit_card" || cardDetails[0].txn_type == "credit card" || cardDetails[0].txn_type == "mast" || cardDetails[0].txn_type == "amex" || cardDetails[0].txn_type == "amx" || cardDetails[0].txn_type == "discover" || cardDetails[0].txn_type == "EMV" || cardDetails[0].txn_type == "EMV-DEBIT_CARD" || cardDetails[0].txn_type == "EMV-GIFT_CARD"  {
                if lowvaluesig_status {
                    headerReceipt.add(block: "-".bc.dividing(printDensity: size, fontDensity: font))  /// signature
                    headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                }
                
                if  signatureImage == nil && lowvaluesig_status_setting_flag {
                    headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))

                    headerReceipt.add(block: "x ".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))

                    headerReceipt.add(block: "-".bc.dividing(printDensity: size, fontDensity: font))  /// signature
                    headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                }
            }
            
//            if discountInString != "$0.00" {
//               // headerReceipt.add(block: "\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
//                headerReceipt.add(block: "You've Saved \(discountInString)".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
//                headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
//                //footerReceipt.add(block: "\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
//            }
            // MARK Hide for V5
            //            if DataManager.signatureOnReceipt{
            //                footerReceipt.add(block: "\n\n\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            //                //footerReceipt.add(block: )
            //                //footerReceipt.a
            //                //footerReceipt.add(block: signature.bc.cu)
            //                block.append(signatureImage as! Block)
            //                block.append("-".bc.dividing(printDensity: size, fontDensity: font))
            //
            //                for block in block {
            //                    footerReceipt.add(block: block)
            //                }
            //            }
            
           // receipt.append(footerReceipt)
            
            let footerTextArray = footertext.components(separatedBy: "-")
           // var footerDescriptionReceipt = Receipt()
            
//            for text in footerTextArray {
//                if text != "" {
//                    headerReceipt.add(block: text.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
//                }
//            }
           
           // headerReceipt.add(block: "\n\n\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            if is_signature_placeholder {  // for black signature not print By Altab (23Dec2022)
                headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "", v: "\n", attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                headerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "", v: "\n", attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                headerReceipt.add(block: "-".bc.dividing(printDensity: size, fontDensity: font))  /// signature
            }
            receipt.append(headerReceipt)
            
            //Print
            index = 0
            self.callPrint(receipt: receipt,orderId: orderid, signatureImage: signatureImage, footertext: "", size: size, font: font)
            
            if signatureImage != nil {
                forImagePrint(signatureImage: signatureImage)
            } else {
                
            }
          //  forImagePrint(signatureImage: signatureImage)
            footerReceiptDataShow(footerArr: footerTextArray, orderId: orderid, signaData: signatureImage, discountInStringObj: discountInString)
            if barcode != "" {  // for bar or QR code print By Altab (23Dec2022)
                barCodeImagePrint(barcodeString: barcode)
            }else{
                if !hide_qr_code {
                    qrCodeImagePrint(qrcodeString: qr_code_data)
                }
                
            }
        
            
          //  self.callPrint(receipt: receipt,orderId: orderid, signatureImage: signatureImage, footertext: "", size: size, font: font)
        }
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {

        // Figure out what our orientation is, and use that to form the rectangle
        let newSize = CGSize(width: 360, height: 90)
        // This is the rect that we've calculated out and this is what is actually used below
        //let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    func resizeQRCodeImage(image: UIImage) -> UIImage {
        
        let paperSize = DataManager.paperSize == 58 ? 75 : 100
        let newSize = CGSize(width: 240, height: 240)
        // This is the rect that we've calculated out and this is what is actually used below
        //let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        let rect = CGRect(x: CGFloat(paperSize), y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 360, height: 240), false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func forImagePrint(signatureImage: UIImage?){
        if signatureImage != nil {
            var signatureImagePrint: UIImage?
            signatureImagePrint = resizeImage(image: signatureImage!, targetSize: CGSize(width: 360, height: 90))
            
            var ticket = Ticket(
                .image(signatureImagePrint!, attributes: .alignment(.center)),
                .dividing
                
            )
            ticket.feedLinesOnHead = 1
            ticket.feedLinesOnTail = 1
            
            
            if PrintersViewController.printerManager!.canPrint {
                PrintersViewController.printerManager?.printForImage(ticket)
            }
        }
    }
    
    func barCodeImagePrint(barcodeString: String){
        if barcodeString != "" {
            
            var barCodeImage: UIImage?
            let results = barcodeString.matches(for: "data:image\\/([a-zA-Z]*);base64,([^\\\"]*)")
            
            for imageString in results {
                autoreleasepool {
                    barCodeImage = imageString.base64ToImage()
                }
            }
            
            barCodeImage = resizeImage(image: barCodeImage!, targetSize: CGSize(width: 360, height: 90))

            var ticket = Ticket(
                .image(barCodeImage!, attributes: .alignment(.center)),
                .blank,
                .blank
                
            )
            ticket.feedLinesOnHead = 1
            ticket.feedLinesOnTail = 1
            
            
            if PrintersViewController.printerManager!.canPrint {
                PrintersViewController.printerManager?.printForImage(ticket)
            }
        }
   
    }
    func qrCodeImagePrint(qrcodeString: String){  // for QR code print By Altab (23Dec2022)
        if qrcodeString != "" {
            
            var barCodeImage: UIImage?
            let results = qrcodeString.matches(for: "data:image\\/([a-zA-Z]*);base64,([^\\\"]*)")
            
            for imageString in results {
                autoreleasepool {
                    barCodeImage = imageString.base64ToImage()
                }
            }
            
            barCodeImage = resizeQRCodeImage(image: barCodeImage!)

            var ticket = Ticket(
                .blank,
                .image(barCodeImage!, attributes: .alignment(.center)),
                .blank,
                .blank
            )
            ticket.feedLinesOnHead = 1
            ticket.feedLinesOnTail = 1
            
            if PrintersViewController.printerManager!.canPrint {
                PrintersViewController.printerManager?.printForImage(ticket)
            }
        }
   
    }
    func footerReceiptDataShow(footerArr: [String], orderId: String, signaData: UIImage?, discountInStringObj: String) {
        var headerReceipt = Receipt()
        var receipt = [Receipt]()
        let size = Int(round(Double(DataManager.paperSize) * 6.62))
        let font = 9
        var stringFinal = ""
       
        if discountInStringObj != "$0.00" {
            headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            headerReceipt.add(block: "You Saved \(discountInStringObj)".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            //footerReceipt.add(block: "\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
        }
        
        // headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
        for text in footerArr {
            if text != "" {
                stringFinal = printerStr(str: text)
                print("str:------\(stringFinal)")
                headerReceipt.add(block: stringFinal.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.smallFont, TextBlock.PredefinedAttribute.alignment(.center)]))
            }
        }
        headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.smallFont, TextBlock.PredefinedAttribute.alignment(.center)]))
        headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))

        receipt.append(headerReceipt)
        self.callPrint(receipt: receipt,orderId: orderId, signatureImage: signaData, footertext: "", size: size, font: font)
    }

    private func printerStr(str: String) -> String {
        NORMAL_SIZE_LINE_LENGTH_SECOND = 0
        NORMAL_SPACE_POSITION = 0
        NORMAL_SIZE_LINE_LENGTH = 0
        var strArr = str
        
        let value = Int(round(Double(DataManager.paperSize) * 6.62))
        
        NORMAL_SIZE_LINE_LENGTH = value / 10
        NORMAL_SIZE_LINE_LENGTH_SECOND = NORMAL_SIZE_LINE_LENGTH
        
        for i in 0..<strArr.count {
            if strArr[i] == " " {
                if i < NORMAL_SIZE_LINE_LENGTH_SECOND {
                    NORMAL_SPACE_POSITION = i
                }else{
                    // stringFinal = stringFinal.append(str[i] + "\n")
                    strArr = replace(myString: strArr, index: NORMAL_SPACE_POSITION, newChar: "\n")
                    //stringFinal = addCharToString(str: str, c: "\n", pos: NORMAL_SPACE_POSITION)
                    
                    NORMAL_SIZE_LINE_LENGTH_SECOND = NORMAL_SIZE_LINE_LENGTH_SECOND + NORMAL_SIZE_LINE_LENGTH
                }
            }
        }
        return strArr
    }
    
    

    func replace(myString: String, index: Int, newChar: Character) -> String {

        var chars = Array(myString)     // gets an array of characters
        chars[index] = newChar
        let modifiedString = String(chars)
      //  print(modifiedString)
        return modifiedString
    }
    func callPrint(receipt:[Receipt]! , orderId:String!, signatureImage: UIImage?,footertext: String, size: Int, font: Int) {
           if index < receipt.count {
               PrintersViewController.printerManager?.print(receipt[index], completeBlock: { (_) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                       self.index += 1
                       self.callPrint(receipt: receipt,orderId: orderId, signatureImage: signatureImage,footertext: footertext, size: size, font: font)
                   }
               })
           }
       }
    // Open cash drawer with normal Bluetooth printer
    func openCashDraer(){
        if PrintersViewController.printerManager!.canPrint {
            PrintersViewController.printerManager?.openCashDrawer( completeBlock: { (_) in
            
            })
        }
    }
    
    
    func callStarPrinterEndDrawerMethod(dict:JSONDictionary) {
        let commands: Data
        
        let emulation: StarIoExtEmulation = LoadStarPrinter.getEmulation()
        print(emulation)
        
        let width: Int = LoadStarPrinter.getSelectedPaperSize().rawValue
        
        let paperSize: PaperSizeIndex = LoadStarPrinter.getSelectedPaperSize()
        let language: LanguageIndex = LanguageIndex.english//LoadStarPrinter.getSelectedLanguage()
        let localizeReceipts: ILocalizeReceipts = LocalizeReceipts.createLocalizeReceipts(language,
                                                                                          paperSizeIndex: paperSize)
        commands = PrinterFunctions.createTextReceiptEndDrawerApiData(emulation,utf8: true, dict: dict)
        
        //self.blind = true
        
        //  if #available(iOS 13.0, *) {
        Communication.sendCommandsForPrintReDirection(commands,
                                                      timeout: 10000) { (communicationResultArray) in
                                                        // self.blind = false
                                                        
                                                        var message: String = ""
                                                        
                                                        for i in 0..<communicationResultArray.count {
                                                            if i == 0 {
                                                                message += "[Destination]\n"
                                                            }
                                                            else {
                                                                message += "[Backup]\n"
                                                            }
                                                            
                                                            message += "Port Name: " + communicationResultArray[i].0 + "\n"
                                                            
                                                            switch communicationResultArray[i].1.result {
                                                            case .success:
                                                                message += "----> Success!\n\n";
                                                                message = ""
                                                            case .errorOpenPort:
                                                                message += "----> Fail to openPort\n\n";
                                                            case .errorBeginCheckedBlock:
                                                                message += "----> Printer is offline (beginCheckedBlock)\n\n";
                                                            case .errorEndCheckedBlock:
                                                                message += "----> Printer is offline (endCheckedBlock)\n\n";
                                                            case .errorReadPort:
                                                                message += "----> Read port error (readPort)\n\n";
                                                            case .errorWritePort:
                                                                message += "----> Write port error (writePort)\n\n";
                                                            default:
                                                                message += "----> Unknown error\n\n";
                                                            }
                                                        }
                                                        
                                                        
                                                        
                                                        //                                                                    self.showSimpleAlert(title: "Communication Result",
                                                        //                                                                                         message: message,
                                                        //                                                                                         buttonTitle: "OK",
                                                        //                                                                                         buttonStyle: .cancel)
                                                        if message != "" {
                                                            appDelegate.showToast(message: message)
                                                        }
                                                        
        }
    }
    
    func printEndDrawer(dict: JSONDictionary) {
        let size = Int(round(Double(DataManager.paperSize) * 6.62))
        let font = 12
        
        let title = dict["title"] as? String ?? ""
        let address = (dict["address"] as? String ?? "").replacingOccurrences(of: " • ", with: ".")
        
        let addressDetail = dict["addressDetail"] as? String ?? ""
        let show_site_name = dict["show_site_name"] as? String ?? ""
        let siteName = dict["siteName"] as? String ?? ""
        let company_address = dict["company_address"] as? String ?? ""
        let address_line1 = dict["address_line1"] as? String ?? ""
        let address_line2 = dict["address_line2"] as? String ?? ""
        let city = dict["city"] as? String ?? ""
        let region = dict["region"] as? String ?? ""
        let postal_code = dict["postal_code"] as? String ?? ""
        let packing_slip_title = dict["packing_slip_title"] as? String ?? ""
        let customer_service_email = dict["customer_service_email"] as? String ?? ""
        let customer_service_phone = dict["customer_service_phone"] as? String ?? ""
        let cashdrawerID = dict["cashdrawerID"] as? String ?? ""
        let cash_refunds = dict["cash_refunds"] as? String ?? ""
        let cash_sales = dict["cash_sales"] as? String ?? ""
        let pay_in = dict["pay_in"] as? String ?? ""
        let pay_out = dict["pay_out"] as? String ?? ""
        let started = dict["started"] as? String ?? ""
        let end_time = dict["end_time"] as? String ?? ""
        let actualin_drawer = dict["actualin_drawer"] as? String ?? ""
        let starting_cash = dict["starting_cash"] as? String ?? ""
        let drawer_desc = dict["drawer_desc"] as? String ?? ""
        let expected_in_drawer = dict["expected_in_drawer"] as? String ?? ""
        let drawer_difference = dict["drawer_difference"] as? String ?? ""
        let source = dict["source"] as? String ?? ""
        let user_name = dict["user_name"] as? String ?? ""
        
        
        //        let orderid = dict["orderid"] as? String ?? ""
        //        let addedDate = dict["date"] as? String ?? ""
        //        let orderTime = dict["order_time"] as? String ?? ""
        //        let saleLocation = dict["sale_location"] as? String ?? ""
        //        let products = dict["products"] as? [arrayReceiptContentModel] ?? [arrayReceiptContentModel]()
        //        let cardDetails = dict["card_details"] as? [arrayReceiptCardContentModel] ?? [arrayReceiptCardContentModel]()
        //        let barcode = dict["bar_code"] as? String ?? ""
        //        let signature = dict["signature"] as? String ?? ""
        //        let footertext = (dict["footertext"] as? String ?? "").replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "<br>", with: "-")
        //        let transactiontype = dict["transactiontype"] as? String ?? ""
        //        let entryMethod = dict["entry_method"] as? String ?? ""
        //        var cardNumber = String()
        //        let approvalCode = dict["approval_code"] as? String ?? ""
        //        let couponCode = dict["coupon_code"] as? String ?? ""
        //        let cardHolderName = dict["card_holder_name"] as? String ?? ""
        //        let cardHolderLabel = dict["card_holder_label"] as? String ?? ""
        //        let companyName = dict["company_name"] as? String ?? ""
        //        let city = dict["city"] as? String ?? ""
        //        let region = dict["region"] as? String ?? ""
        //        let customerServiceEmail = dict["customer_service_email"] as? String ?? ""
        //        let customerServicePhone = dict["customer_service_phone"] as? String ?? ""
        //        let addressDetail = dict["addressDetail"] as? String ?? ""
        //        let showCompanyAddress = dict["show_company_address"] as? Bool ?? false
        //
        //        let postalCode = dict["postal_code"] as? String ?? ""
        //        let headerText = dict["header_text"] as? String ?? ""
        //        let total = (Double((dict["total"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
        //        let subtotal = (Double((dict["subtotal"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
        //        let shipping = (Double((dict["shipping"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
        //        let discount = (Double((dict["discount"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
        //        let tax = (Double((dict["tax"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
        //        let tip = (Double((dict["tip"] as? String ?? "0.  00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
        //        let changeDue = (Double((dict["change_due"] as? String ?? "0.00").replacingOccurrences(of: ",", with: "")) ?? 0.00)
        //
        //        let totalInString = "$" + total.roundToTwoDecimal
        //        let subtotalInString = "$" + subtotal.roundToTwoDecimal
        //        let shippingInString = "$" + shipping.roundToTwoDecimal
        //        let discountInString = "$" + discount.roundToTwoDecimal
        //        let taxInString = "$" + tax.roundToTwoDecimal
        //        let tipInString = "$" + tip.roundToTwoDecimal
        //        let changeInString = "$" + changeDue.roundToTwoDecimal
        //        var signatureImage: UIImage?
        //
        //        if let url = URL(string: signature) {
        //            do {
        //                let data = try Data(contentsOf: url)
        //                if signature != "" {
        //                    signatureImage = getImage(image: UIImage(data: data)!, backgroundColor: .white)!
        //                }
        //            }
        //            catch let error {
        //                print("Error in downloading signature image: \(error)")
        //            }
        //        }
        
        
        let charactersCount =  Int((size / font)/2) - 2
        
        //Products
        var blocks = [[Block]]()
        var block = [Block]()
        
        //        for i in 0..<products.count {
        //            let product = products[i]
        //            var productTitle = product.title
        //            let productNote = product.note
        //
        //            if Double(productTitle.count) > Double(size / font) {
        //                productTitle = productTitle.prefix((size / font) - 2) + ".."
        //            }
        //
        //            let qty = Double(product.qty)
        //
        //            let num = size / font
        //
        //            var productCode = product.code
        //
        //            if Double(productCode.count) > (Double(num)*0.4) {
        //                productCode = productCode.prefix(16) + ".."
        //            }
        //
        //            if product.id == "coupon" {
        //                var price = String()
        //
        //                if product.price.stringValue.first == "-" {
        //                    price = product.price.stringValue.replacingOccurrences(of: "-", with: "")
        //                    price = "-$" + price
        //                }else {
        //                    price =  "$" + product.price.stringValue
        //                }
        //
        //                let priceInDouble = Double(price) ?? 0
        //
        //                block.append(productTitle.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
        //                if productCode != "" {
        //                    block.append("".bc.kv(printDensity: size, fontDensity: font, k: productCode , v: "\(qty.roundToTwoDecimal + " x " + priceInDouble.roundToTwoDecimal)", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
        //                } else {
        //                    block.append("\(qty.roundToTwoDecimal + " x " + priceInDouble.roundToTwoDecimal)".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
        //                }
        //                block.append("-".bc.dividing(printDensity: size, fontDensity: font))
        //
        //            }else {
        //
        //                block.append(productTitle.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
        //                block.append(productNote.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
        //
        //                if productCode != "" {
        //                    block.append("".bc.kv(printDensity: size, fontDensity: font, k: productCode , v: "\(qty.roundToTwoDecimal) x $\(product.price.doubleValue.roundToTwoDecimal)", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
        //                } else {
        //                    block.append("\(qty.roundToTwoDecimal) x $\(product.price.doubleValue.roundToTwoDecimal)".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.right)]))
        //                }
        //                block.append("-".bc.dividing(printDensity: size, fontDensity: font))
        //            }
        //
        //            if block.count == 10 {
        //                blocks.append(block)
        //                block = [Block]()
        //            }
        //        }
        if block.count > 0 {
            blocks.append(block)
            block = [Block]()
        }
        
        // Card Type
        var blocks1 = [[Block]]()
        var block1 = [Block]()
        
        //        for i in 0..<cardDetails.count {
        //            let cardDetail = cardDetails[i]
        //            let cardType = cardDetail.card_type
        //            let amount = Double(cardDetail.amount)
        //            let cardNo = (cardDetail.card_no).replacingOccurrences(of: "*", with: "")
        //
        //            if cardNo != "************" && cardDetails.count == 1 {
        //                if cardNo != "" && cardDetails.count == 1 {
        //                    cardNumber = cardDetail.card_no
        //                }
        //            }
        //            if cardNo != "" {
        //                if cardNo != "************" {
        //                    block1.append("".bc.kv(printDensity: size, fontDensity: font,k: (cardType + "-" + cardNo), v: "$\((amount ?? 0.0).roundToTwoDecimal)".count > charactersCount ? "\(String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".prefix(charactersCount)) + String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".dropFirst(charactersCount)))" : "$\((amount ?? 0.0).roundToTwoDecimal)" , attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
        //                }
        //            } else {
        //                block1.append("".bc.kv(printDensity: size, fontDensity: font,k: cardType, v: "$\((amount ?? 0.0).roundToTwoDecimal)".count > charactersCount ? "\(String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".prefix(charactersCount)) + String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".dropFirst(charactersCount)))" : "$\((amount ?? 0.0).roundToTwoDecimal)" , attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
        //            }
        //            blocks1.append(block1)
        //            block1 = [Block]()
        //        }
        
        //Prepare Receipt
        if PrintersViewController.printerManager!.canPrint {
            
            var receipt = [Receipt]()
            
            var headerReceipt = Receipt()
            //            if saleLocation != "" {
            //                headerReceipt.add(block: saleLocation.bc.customSize(printDensity: size, fontDensity: font, isBold:true, attributes: [TextBlock.PredefinedAttribute.bold,TextBlock.PredefinedAttribute.scale(.l1), TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            
//            if title != "" {
//                headerReceipt.add(block: title.bc.customSize(printDensity: size, fontDensity: font, isBold:true, attributes: [TextBlock.PredefinedAttribute.bold,TextBlock.PredefinedAttribute.scale(.l1), TextBlock.PredefinedAttribute.alignment(.center)]))
//            }
            
            
            if title != "" {
                headerReceipt.add(block: title.bc.customSize(printDensity: size, fontDensity: font, isBold:true, attributes: [TextBlock.PredefinedAttribute.boldFont, TextBlock.PredefinedAttribute.alignment(.center)]))
                //headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            }
            
            //            if title != "" {
            //                headerReceipt.add(block: title.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            //                headerReceipt.add(block: "\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            //            }
            
            //            if showCompanyAddress {
            //                if address != "\n" {
            //                    headerReceipt.add(block: address.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            //                }
            //                if addressDetail != "," {
            //                    headerReceipt.add(block: addressDetail.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            //                }
            //            }
            
            if address != "," {
                headerReceipt.add(block: address.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
            if addressDetail != "," {
                headerReceipt.add(block: addressDetail.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            //
            //                        if city != "" {
            //                            headerReceipt.add(block: city.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            //                        }
            //
            //                        if region != "" {
            //                            headerReceipt.add(block: region.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            //                        }
            //
            //                        if postal_code != "" {
            //                            headerReceipt.add(block: postal_code.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            //                        }
            
            if customer_service_email != "" {
                headerReceipt.add(block: customer_service_email.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
            if customer_service_phone != "" {
                headerReceipt.add(block: customer_service_phone.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
            //            if headerText != "" {
            //                headerReceipt.add(block: headerText.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            
            headerReceipt.add(block: "\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            
            if user_name != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "User  " , v: user_name, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
            if source != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Sale Location " , v: source, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
            if started != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Started  " , v: started, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            if end_time != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Ended  " , v: end_time, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            if pay_in != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Paid In  " , v: pay_in, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            if pay_out != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Paid Out  " , v: pay_out, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            if cash_sales != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Cash Sales " , v: cash_sales, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            if cash_refunds != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Cash Refunded " , v: cash_refunds, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            if expected_in_drawer != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Expected in Drawer " , v: expected_in_drawer, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            if starting_cash != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Starting Cash " , v: starting_cash, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            if actualin_drawer != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Actual in Drawer " , v: actualin_drawer, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            if drawer_difference != "" {
                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Difference " , v: drawer_difference, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            }
            
            //            if started != "" {
            //                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: started , v: started, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            //
            //            if cashdrawerID != "" {
            //                headerReceipt.add(block: "CashDrawerId #\(cashdrawerID)".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            //            }
            
            //            if transactiontype != "" {
            //                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Transaction Type  " , v: transactiontype, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            //            }
            //
            //            if cardNumber != "************" && cardDetails.count == 1 {
            //                if cardNumber != "" && cardDetails.count == 1 {
            //                    headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Card#  " , v: cardNumber, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //                }
            //            }
            //
            //            if cardHolderName != "" {
            //                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: cardHolderLabel + "  " , v: cardHolderName, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            //
            //            if companyName != "" {
            //                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Company Name  " , v: companyName, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            //
            //            if saleLocation != "" {
            //                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Sale Location  " , v: saleLocation, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            //
            //            if approvalCode != "" {
            //                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Approval Code  " , v: approvalCode, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            //
            //            if entryMethod != "" {
            //                headerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Entry Method  " , v: entryMethod, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            headerReceipt.add(block: "\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            receipt.append(headerReceipt)
            
            for block in blocks {
                for data in  block {
                    var newReceipt = Receipt()
                    newReceipt.add(block: data)
                    receipt.append(newReceipt)
                }
            }
            
            var footerReceipt = Receipt()
            footerReceipt.add(block: "\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            
            //            if subtotalInString != "$0.00" {
            //                footerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Subtotal ".count > charactersCount ? String(describing: "Subtotal ".prefix(charactersCount) + ".. ") : "Subtotal ", v: subtotalInString.count > charactersCount ? "\(String(describing: subtotalInString.prefix(charactersCount)) + String(describing: subtotalInString.dropFirst(charactersCount)))" : subtotalInString , attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            
            //            if discountInString != "$0.00" {
            //                if couponCode != "" {
            //                    footerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font, k: ("Discount-" + couponCode + " ") , v: discountInString.count > charactersCount ? "\(String(describing: discountInString.prefix(charactersCount)) + String(describing: discountInString.dropFirst(charactersCount)))" : discountInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //                } else {
            //                    footerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Discount ", v:  discountInString.count > charactersCount ? "\(String(describing: discountInString.prefix(charactersCount)) + String(describing: discountInString.dropFirst(charactersCount)))" : discountInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //                }
            //            }
            
            //            if shippingInString != "$0.00" {
            //                footerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Shipping ".count > charactersCount ? String(describing: "Shipping ".prefix(charactersCount) + ".. ") : "Shipping ", v: shippingInString.count > charactersCount ? "\(String(describing: shippingInString.prefix(charactersCount)) + String(describing: shippingInString.dropFirst(charactersCount)))" : shippingInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            //
            //            if taxInString != "$0.00" {
            //                footerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Tax ", v:  taxInString.count > charactersCount ? "\(String(describing: taxInString.prefix(charactersCount)) + String(describing: taxInString.dropFirst(charactersCount)))" : taxInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            
            footerReceipt.add(block: "\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            
            for block1 in blocks1 {
                for data in  block1 {
                    footerReceipt.add(block: data)
                }
            }
            
            //            if DataManager.collectTips{
            //                if tipInString != "$0.00" {
            //
            //                    footerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Tip ", v:  tipInString.count > charactersCount ? "\(String(describing: tipInString.prefix(charactersCount)) + String(describing: tipInString.dropFirst(charactersCount)))" : tipInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //                    footerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //
            //                }else{
            //                    if tipInString == "$0.00"{
            //                        footerReceipt.add(block: "".bc.kv(printDensity: size, fontDensity: font, k: "Tip" , v: "------", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //                        footerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  "------", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //
            //                    }
            //                }
            //            }else{
            //                footerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            
            //            if tipInString != "$0.00" {
            //                footerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Tip ", v:  tipInString.count > charactersCount ? "\(String(describing: tipInString.prefix(charactersCount)) + String(describing: tipInString.dropFirst(charactersCount)))" : tipInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            //   footerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            
            
            //            if changeInString != "$0.00" {
            //                footerReceipt.add(block:  "".bc.kv(printDensity: size, fontDensity: font,k: "Change ", v:  changeInString.count > charactersCount ? "\(String(describing: changeInString.prefix(charactersCount)) + String(describing: changeInString.dropFirst(charactersCount)))" : changeInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
            //            }
            //
            //            if discountInString != "$0.00" {
            //                footerReceipt.add(block: "\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            //                footerReceipt.add(block: "You've Saved \(discountInString)".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            //                footerReceipt.add(block: "\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            //            }
            
            // MARK Hide for V5
            /*  if DataManager.signatureOnReceipt{
             footerReceipt.add(block: "\n\n\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
             block.append("-".bc.dividing(printDensity: size, fontDensity: font))
             
             for block in block {
             footerReceipt.add(block: block)
             }
             }
             */
            receipt.append(footerReceipt)
            
            //            let footerTextArray = footertext.components(separatedBy: "-")
            //            var footerDescriptionReceipt = Receipt()
            //
            //            for text in footerTextArray {
            //                if text != "" {
            //                    footerDescriptionReceipt.add(block: text.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            //                }
            //            }
            //            footerDescriptionReceipt.add(block: "\n\n\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            //            receipt.append(footerDescriptionReceipt)
            
            //Print
            index = 0
            self.callPrintEndDrawer(receipt: receipt,cashDrawerId: cashdrawerID, size: size, font: font)
        }
    }
    
    func callPrintEndDrawer(receipt:[Receipt]! , cashDrawerId:String!, size: Int, font: Int) {
        if index < receipt.count {
            PrintersViewController.printerManager?.print(receipt[index], completeBlock: { (_) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.index += 1
                    self.callPrintEndDrawer(receipt: receipt,cashDrawerId: cashDrawerId, size: size, font: font)
                }
            })
        }
    }
}
extension String {
    func base64ToImage() -> UIImage? {
        if let url = URL(string: self),let data = try? Data(contentsOf: url),let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range:  NSRange(self.startIndex..., in: self))
            return results.map {
                //self.substring(with: Range($0.range, in: self)!)
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
