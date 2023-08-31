//
//  PrinterFunctions.swift
//  Swift SDK
//
//  Created by Yuji on 2015/**/**.
//  Copyright © 2015年 Star Micronics. All rights reserved.
//

import Foundation

class PrinterFunctions {
    static func createTextReceiptData(_ emulation: StarIoExtEmulation, localizeReceipts: ILocalizeReceipts, utf8: Bool) -> Data {
        let builder: ISCBBuilder = StarIoExt.createCommandBuilder(emulation)
        
        builder.beginDocument()
        
        localizeReceipts.appendTextReceiptData(builder, utf8: utf8)
        
        builder.appendCutPaper(SCBCutPaperAction.partialCutWithFeed)
        
        builder.endDocument()
        
        return builder.commands.copy() as! Data
    }
    
    static func createTextReceiptApiData(_ emulation: StarIoExtEmulation, utf8: Bool, issplit:Bool, transId:Int) -> Data {
        let builder: ISCBBuilder = StarIoExt.createCommandBuilder(emulation)
        
        builder.beginDocument()
        
        append2inchTextReceiptApiData(builder, utf8: utf8, issplit: issplit, transId: transId)
        
        builder.appendCutPaper(SCBCutPaperAction.partialCutWithFeed)
        
        builder.endDocument()
        
        return builder.commands.copy() as! Data
    }
    
    static    func append2inchTextReceiptApiData(_ builder: ISCBBuilder, utf8: Bool, issplit:Bool, transId:Int) {
        
        let str_footerText =  HomeVM.shared.receiptModel.card_agreement_text + "<br>" +  HomeVM.shared.receiptModel.refund_policy_text + "<br>" +  HomeVM.shared.receiptModel.footer_text
        
        var add = ""
        if  HomeVM.shared.receiptModel.city == "" &&  HomeVM.shared.receiptModel.region == "" &&  HomeVM.shared.receiptModel.postal_code == "" {
            add = ""
        } else if  HomeVM.shared.receiptModel.city != "" && ( HomeVM.shared.receiptModel.region != "" ||  HomeVM.shared.receiptModel.postal_code != "") {
            add = ","
        } else if  HomeVM.shared.receiptModel.city == "" && ( HomeVM.shared.receiptModel.region != "" ||  HomeVM.shared.receiptModel.postal_code != ""){
            add = ""
        }
        
        var orderAddress = ""
        
        if  HomeVM.shared.receiptModel.address_line1 != "" {
            orderAddress =  HomeVM.shared.receiptModel.address_line1
        }
        
        if  HomeVM.shared.receiptModel.address1 != "" {
            if orderAddress == "" {
                orderAddress =   HomeVM.shared.receiptModel.address1
            } else {
                orderAddress =  orderAddress +  "\n" + HomeVM.shared.receiptModel.address1
            }
            
        }
        
        if  HomeVM.shared.receiptModel.address2 != "" {
            if orderAddress == "" {
                orderAddress =   HomeVM.shared.receiptModel.address2
            } else {
                orderAddress =  orderAddress +  "\n" +  HomeVM.shared.receiptModel.address2
            }
        }
        
        
        let order: JSONDictionary = ["title" : HomeVM.shared.receiptModel.packing_slip_title ,
                                     "address" : "\(orderAddress)"  ,
                                     "addressDetail" : "\(HomeVM.shared.receiptModel.city)\(add)\(HomeVM.shared.receiptModel.region) \( HomeVM.shared.receiptModel.postal_code)",
                                     "date" : HomeVM.shared.receiptModel.date_added ,
                                     "orderid": HomeVM.shared.receiptModel.order_id ,
                                     "products" : HomeVM.shared.receiptModel.array_ReceiptContent ,
                                     "total" : HomeVM.shared.receiptModel.total ,
                                     "tip" : HomeVM.shared.receiptModel.tip ,
                                     "subtotal" : HomeVM.shared.receiptModel.sub_total ,
                                     "discount" : HomeVM.shared.receiptModel.discount ,
                                     "shipping" : HomeVM.shared.receiptModel.shipping ,
                                     "tax" : HomeVM.shared.receiptModel.tax ,
                                     "footertext" : str_footerText ,
                                     "card_agreement_text" : HomeVM.shared.receiptModel.card_agreement_text,
                                     "refund_policy_text" : HomeVM.shared.receiptModel.refund_policy_text,
                                     "footer_text" : HomeVM.shared.receiptModel.footer_text,
                                     "transactiontype" : HomeVM.shared.receiptModel.transaction_type,
                                     "paymentmode" : HomeVM.shared.receiptModel.payment_type,
                                     "order_time" : HomeVM.shared.receiptModel.order_time,
                                     "sale_location" : HomeVM.shared.receiptModel.sale_location,
                                     "bar_code" :  HomeVM.shared.receiptModel.bar_code,
                                     "card_details" :  HomeVM.shared.receiptModel.array_ReceiptCardContent,
                                     "entry_method" :  HomeVM.shared.receiptModel.entry_method,
                                     "card_number" :  HomeVM.shared.receiptModel.card_number,
                                     "approval_code" :  HomeVM.shared.receiptModel.approval_code,
                                     "coupon_code" :  HomeVM.shared.receiptModel.coupon_code,
                                     "change_due" :  HomeVM.shared.receiptModel.change_due,
                                     "signature" :  HomeVM.shared.receiptModel.signature,
                                     "card_holder_name" :  HomeVM.shared.receiptModel.card_holder_name,
                                     "card_holder_label" :  HomeVM.shared.receiptModel.card_holder_label,
                                     "company_name" :  HomeVM.shared.receiptModel.company_name,
                                     "city" :  HomeVM.shared.receiptModel.city,
                                     "region" : HomeVM.shared.receiptModel.region,
                                     "customer_service_phone" : HomeVM.shared.receiptModel.customer_service_phone,
                                     "customer_service_email" : HomeVM.shared.receiptModel.customer_service_email,
                                     "postal_code" : HomeVM.shared.receiptModel.postal_code,
                                     "header_text" : HomeVM.shared.receiptModel.header_text,
                                     "balance_due" : HomeVM.shared.receiptModel.balance_Due,
                                     "payment_status" : HomeVM.shared.receiptModel.payment_status,
                                     "source" : HomeVM.shared.receiptModel.source,
                                     "show_company_address" :  HomeVM.shared.receiptModel.show_company_address,
                                     "show_all_final_transactions" : HomeVM.shared.receiptModel.show_all_final_transactions,
                                     "print_all_transactions" : HomeVM.shared.receiptModel.print_all_transactions,
                                     "extra_merchant_copy" : HomeVM.shared.receiptModel.extra_merchant_copy,
                                     "showtipline_status" :  HomeVM.shared.receiptModel.showtipline_status,
                                     "total_refund_amount" :  HomeVM.shared.receiptModel.total_refund_amount,
                                     "notes" :  HomeVM.shared.receiptModel.notes,
                                     "isNotes" :  HomeVM.shared.receiptModel.isNotes,
                                     "lowvaluesig_status" :  HomeVM.shared.receiptModel.lowvaluesig_status,
                                     "ACCT" : HomeVM.shared.receiptModel.ACCT,
                                     "AID" : HomeVM.shared.receiptModel.AID,
                                     "TC" : HomeVM.shared.receiptModel.TC,
                                     "AppName" : HomeVM.shared.receiptModel.Appname,
                                     "lowvaluesig_status_setting_flag" : HomeVM.shared.receiptModel.lowvaluesig_status_setting_flag,
                                     "is_signature_placeholder":HomeVM.shared.receiptModel.is_signature_placeholder,
                                     "qr_code":HomeVM.shared.receiptModel.qr_code,
                                     "qr_code_data":HomeVM.shared.receiptModel.qr_code_data,
                                     "hide_qr_code":HomeVM.shared.receiptModel.hide_qr_code
        ]
        
        if issplit {
            dataPrintSplitePayment(dict: order, builder, utf8: utf8, issplit: issplit, transId: transId)
        } else {
            dataPrint(dict: order, builder, utf8: utf8, issplit: issplit, transId: transId)
        }
        
    }
    
    static func dataPrint(dict: JSONDictionary,_ builder: ISCBBuilder, utf8: Bool, issplit:Bool, transId:Int) {
        let size = Int(round(Double(DataManager.paperSize) * 6.62))
        let sizetwo = Int(round(Double(DataManager.paperSize) * 7))
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
        
        let showAllFinal_transactions = dict["show_all_final_transactions"] as? String ?? "false"
        let printAllTransactions = dict["print_all_transactions"] as? String ?? "false"
        let extraMerchantCopy = dict["extra_merchant_copy"] as? String ?? "false"
        
        let Acct  = dict["ACCT"] as? String ?? ""
        let Aid  = dict["AID"] as? String ?? ""
        let Tc  = dict["TC"] as? String ?? ""
        let Appname  = dict["AppName"] as? String ?? ""
        let is_signature_placeholder = dict["is_signature_placeholder"] as? Bool ?? false
        let qr_code = dict["qr_code"] as? String ?? ""
        let qr_code_data = dict["qr_code_data"] as? String ?? ""
        let hide_qr_code = dict["hide_qr_code"] as? Bool ?? false
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
        let charactersCount =  Int((size / font)/2) - 2
        
        //Products
        var blocks = [[Block]]()
        var block = [Block]()
        
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
        //
        
        let encoding: String.Encoding
        
        if utf8 == true {
            encoding = String.Encoding.utf8
            
            builder.append(SCBCodePageType.UTF8)
        }
        else {
            encoding = String.Encoding.ascii
            
            builder.append(SCBCodePageType.CP998)
        }
        
        builder.append(SCBInternationalType.USA)
        
        builder.appendCharacterSpace(0)
        
        builder.appendAlignment(SCBAlignmentPosition.center)
        
        builder.appendAlignment(SCBAlignmentPosition.left)
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
            
            if Double(productCode.count) > (Double(num)*0.4) {
                productCode = "\(productCode.prefix(18))" // two Dot append
            }
            //    block.append("\n".data(using: encoding)!)
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
                block.append("\n".data(using: encoding)!)
                if productCode != "" {
                    block.append("".bc.kv(printDensity: size, fontDensity: font, k: productCode , v: "\(qty.roundToTwoDecimal + " x " + priceInDouble)", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                } else {
                    block.append("\(qty.roundToTwoDecimal + " x " + priceInDouble)".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
                }
                block.append("-".bc.dividing(printDensity: size, fontDensity: font))
                block.append("\n".data(using: encoding)!)
                
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
                    block.append("".bc.kv(printDensity: size, fontDensity: font, k: productCode , v: "\(qty.roundToTwoDecimal) x \(priceInDouble)", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                } else {
                    block.append("\(qty.roundToTwoDecimal) x \(priceInDouble)".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.right)]))
                }
                
                if productNote != "" {
                    block.append("\n".data(using: encoding)!)
                    block.append(productNote.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.normalSize, TextBlock.PredefinedAttribute.alignment(.left)]))
                }
                if itemFields != "" {
                    block.append("\n".data(using: encoding)!)
                    block.append(itemFields.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.normalSize, TextBlock.PredefinedAttribute.alignment(.left)]))
                }
                if attriute != "" {
                    block.append("\n".data(using: encoding)!)
                    block.append(attriute.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.normalSize, TextBlock.PredefinedAttribute.alignment(.left)]))
                }
                block.append("-".bc.dividing(printDensity: size, fontDensity: font))
                
            }
            block.append("\n".data(using: encoding)!)
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
            let amount = Double(cardDetail.amount)
            let cardNo = (cardDetail.card_no).replacingOccurrences(of: "*", with: "")
            var cardNoObj = cardDetail.card_no
            let aiType = cardDetail.ai_Type
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
                    block1.append("".bc.kv(printDensity: size, fontDensity: font,k: cardTypeObj, v: "$\((amount ?? 0.0).roundToTwoDecimal)".count > charactersCount ? "\(String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".prefix(charactersCount)) + String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".dropFirst(charactersCount)))" : "$\((amount ?? 0.0).roundToTwoDecimal)" , attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                } else if PaymentSatus == "INVOICE" && aiType != "" {
                    block1.append("".bc.kv(printDensity: size, fontDensity: font,k: cardTypeObj, v: "$\((amount ?? 0.0).roundToTwoDecimal)".count > charactersCount ? "\(String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".prefix(charactersCount)) + String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".dropFirst(charactersCount)))" : "$\((amount ?? 0.0).roundToTwoDecimal)" , attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                }
                else if PaymentSatus == "Approved" {
                    block1.append("".bc.kv(printDensity: size, fontDensity: font,k: cardTypeObj, v: "$\((amount ?? 0.0).roundToTwoDecimal)".count > charactersCount ? "\(String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".prefix(charactersCount)) + String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".dropFirst(charactersCount)))" : "$\((amount ?? 0.0).roundToTwoDecimal)" , attributes: [TextBlock.PredefinedAttribute.alignment(.center)]))
                }
                
            }
            blocks1.append(block1)
            block1 = [Block]()
        }
        
        var receipt = [Receipt]()
        
        var headerReceipt = Receipt()
        builder.appendAlignment(SCBAlignmentPosition.center)
        
        if title != "" {
            
            builder.append(title.bc.customSize(printDensity: size, fontDensity: font, isBold:false, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        
        if showCompanyAddress {
            if address != "\n" {
                builder.append(address.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]).data)
                
            }
            if addressDetail != "," {
                builder.append(addressDetail.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]).data)
                
            }
        }
        
        
        
        if customerServiceEmail != "" {
            builder.append(customerServiceEmail.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if customerServicePhone != "" {
            builder.append(customerServicePhone.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if headerText != "" {
            builder.append("\(headerText) \n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        builder.appendAlignment(SCBAlignmentPosition.left)
        builder.append(" \n".bc.customSize(printDensity: size, fontDensity: font, isBold:false, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.left)]).data)
        
        if addedDate != "" || orderTime != "" {
            builder.append("".bc.kv(printDensity: size, fontDensity: font, k: addedDate , v: "\(orderTime)", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if orderid != "" {
            
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "Order" , v: "#\(orderid)\n", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if transactiontype != "" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "Transaction Type  " , v: "\(transactiontype)", attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
            
        }
        
        if cardHolderName != "" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: cardHolderLabel + "  " , v: cardHolderName, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if Acct != "" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "ACCT  " , v: Acct, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
        }
        
        if companyName != "" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "Company Name  " , v: companyName, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if cardNumber != "************" && cardDetails.count == 1 {
            if cardNumber != "" && cardDetails.count == 1 {
                builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "Card#  " , v: cardNumber, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
                
            }
        }
        
        if source != "" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "Sale Location  " , v: source, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if Aid != "" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "AID  " , v: Aid, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
        }
        
        if Tc != "" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "TC  " , v: Tc, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
        }
        
        if approvalCode != "" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "Approval Code  " , v: approvalCode, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if entryMethod != "" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "Entry Method  " , v: entryMethod, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if PaymentSatus != "" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "Payment Status  " , v: PaymentSatus, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        builder.append("\n".data(using: encoding))
        
        if blocks.count > 0 {
            builder.append( "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
            
        }
        
        builder.append("\n".data(using: encoding))
        // PRINT Card Type
        for block in blocks {
            for data in  block {
                //       builder.appendAlignment(SCBAlignmentPosition.left)
                builder.append(data.data)
            }
        }
        
        var footerReceipt =  Receipt()
        
        if subtotalInString != "$0.00" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Subtotal ".count > charactersCount ? String(describing: "Subtotal ".prefix(charactersCount) + ".. ") : "Subtotal ", v: subtotalInString.count > charactersCount ? "\(String(describing: subtotalInString.prefix(charactersCount)) + String(describing: subtotalInString.dropFirst(charactersCount)))" : subtotalInString , attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        } else {
            if PaymentSatus == "REFUND" {
                builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Subtotal ".count > charactersCount ? String(describing: "Subtotal ".prefix(charactersCount) + ".. ") : "Subtotal ", v: subtotalInString.count > charactersCount ? "\(String(describing: subtotalInString.prefix(charactersCount)) + String(describing: subtotalInString.dropFirst(charactersCount)))" : subtotalInString , attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            }
        }
        
        if discountInString != "$0.00" {
            if couponCode != "" {
                builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: ("Discount-" + couponCode + " ") , v: discountInString.count > charactersCount ? "\(String(describing: discountInString.prefix(charactersCount)) + String(describing: discountInString.dropFirst(charactersCount)))" : discountInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
                
            } else {
                builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Discount ", v:  discountInString.count > charactersCount ? "\(String(describing: discountInString.prefix(charactersCount)) + String(describing: discountInString.dropFirst(charactersCount)))" : discountInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
                
            }
        }
        
        if shippingInString != "$0.00" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Shipping ".count > charactersCount ? String(describing: "Shipping ".prefix(charactersCount) + ".. ") : "Shipping ", v: shippingInString.count > charactersCount ? "\(String(describing: shippingInString.prefix(charactersCount)) + String(describing: shippingInString.dropFirst(charactersCount)))" : shippingInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if taxInString != "$0.00" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Tax ", v:  taxInString.count > charactersCount ? "\(String(describing: taxInString.prefix(charactersCount)) + String(describing: taxInString.dropFirst(charactersCount)))" : taxInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        builder.appendAlignment(SCBAlignmentPosition.left)
        if tipInString == "$0.00" {
            if showtiplinestatus {
                builder.append(" \n".data(using: encoding))
                builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
                //                builder.append(" \n".data(using: encoding))
                
                builder.append( "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
                builder.append(" \n".data(using: encoding))
                
                builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "Tip" , v: "------", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
                builder.append(" \n".data(using: encoding))
                
                builder.append( "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
                
                builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  "------", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
                builder.append(" \n".data(using: encoding))
                
            }
        } else {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Tip ", v:  tipInString.count > charactersCount ? "\(String(describing: tipInString.prefix(charactersCount)) + String(describing: tipInString.dropFirst(charactersCount)))" : tipInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if tipInString != "$0.00" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            builder.append("\n".data(using: encoding))
            
        } else {
            if !showtiplinestatus {
                builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
                builder.append("\n".data(using: encoding))
            }
        }
        
        if showAllFinal_transactions == "true" {
            
            builder.appendAlignment(SCBAlignmentPosition.left)
            for block1 in blocks1 {
                for data in  block1 {
                    builder.appendAlignment(SCBAlignmentPosition.left)
                    // headerReceipt.add(block: data)
                    builder.append(data.data)
                }
            }
        }
        
        if totalRefundAmount != "$0.00" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Total Refunded Amt", v:  totalRefundAmount.count > charactersCount ? "\(String(describing: totalRefundAmount.prefix(charactersCount)) + String(describing: totalRefundAmount.dropFirst(charactersCount)))" : totalRefundAmount, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            builder.append("".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold,TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if balanceDueInString != "$0.00"{
            builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Balance Due ", v:  balanceDueInString.count > charactersCount ? "\(String(describing: balanceDueInString.prefix(charactersCount)) + String(describing: balanceDueInString.dropFirst(charactersCount)))" : balanceDueInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
            builder.append("".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold,TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if changeInString != "$0.00" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Change ", v:  changeInString.count > charactersCount ? "\(String(describing: changeInString.prefix(charactersCount)) + String(describing: changeInString.dropFirst(charactersCount)))" : changeInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
            builder.append("".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold,TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if isNotes {
            builder.append( "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
            
            if notes.count > (size/font) - 6 {
                builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Notes ", v: "\n\(notes)" /*notes.count > charactersCount ? "\(String(describing: notes.prefix(charactersCount)) + String(describing: notes.dropFirst(charactersCount)))" : notes*/, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
                
            }else{
                builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Notes ", v: "\n\(notes)" /*notes.count > charactersCount ? "\(String(describing: notes.prefix(charactersCount)) + String(describing: notes.dropFirst(charactersCount)))" : notes*/, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
                
            }
        }
        
        builder.append("\n".data(using: encoding))
        if lowvaluesig_status {
            builder.append( "-".bc.dividing(printDensity: size, fontDensity: font).data)
            /// signature
            builder.append( "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
            
        }
        
        if (cardDetails[transId].txn_type != "" && cardDetails[transId].txn_type == "visa") || cardDetails[transId].txn_type == "credit" || cardDetails[transId].txn_type == "credit_card" || cardDetails[transId].txn_type == "credit card" || cardDetails[transId].txn_type == "mast" || cardDetails[transId].txn_type == "amex" || cardDetails[transId].txn_type == "amx" || cardDetails[transId].txn_type == "discover" || cardDetails[transId].txn_type == "EMV" || cardDetails[transId].txn_type == "EMV-DEBIT_CARD" || cardDetails[transId].txn_type == "EMV-GIFT_CARD"  {
            if lowvaluesig_status_setting_flag && signatureImage == nil {
                builder.append(" \n".data(using: encoding))
                builder.append(" x \n".data(using: encoding))
                builder.append( "-".bc.dividing(printDensity: size, fontDensity: font).data)
                /// signature
                builder.append( "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
                
            }
        }
        
        let footerTextArray = footertext.components(separatedBy: "-")
        receipt.append(headerReceipt)
        
        //  ************** Image or Bar code And footer Text **************************
        
        builder.appendAlignment(SCBAlignmentPosition.center)
        
//        var barCodeImage: UIImage?
//        let results = barcode.matches(for: "data:image\\/([a-zA-Z]*);base64,([^\\\"]*)")
//
//        for imageString in results {
//            autoreleasepool {
//                barCodeImage = imageString.base64ToImage()
//            }
//        }
//
        builder.append(" \n".data(using: encoding))
        if is_signature_placeholder == false {
            if let img = signatureImage {
                let image = img
                let targetSize = CGSize(width: 400, height: 150)
                
                //        let scaledImage = image.scalePreservingAspectRatio(
                //            image: img, targetSize: targetSize
                //        )
                let img1 = resizeImage(image: image, targetSize: targetSize)
                // builder.appendBitmap(scaledImage, diffusion: false)
                builder.appendBitmap(withAlignment: img1, diffusion: false, position: SCBAlignmentPosition.center)
                builder.append("-".bc.dividing(printDensity: size, fontDensity: font).data)
                // builder.appendBitmap(signatureImagePrint, diffusion: false)
                builder.append("\n".data(using: encoding))
            }
        }
        
        footerReceiptDataShow(builder, footerArr: footerTextArray, orderId: orderid, discountInStringObj: discountInString)
        builder.append("\n".data(using: encoding))
        
//        barCodeImage = resizeImage(image: barCodeImage!, targetSize: CGSize(width: 360, height: 210))
        if barcode != "" {
            builder.appendBarcodeData("{B\(orderid)".data(using: String.Encoding.ascii), symbology: SCBBarcodeSymbology.code128, width: SCBBarcodeWidth.mode3, height: 80, hri: true)
        }else{
//            builder.appendQrCodeData(withAlignment: qr_code.data(using: String.Encoding.utf8), model: SCBQrCodeModel.no1, level: SCBQrCodeLevel.H, cell: 5, position: .center)
            if !hide_qr_code {
                builder.appendQrCodeData(withAlignment: qr_code.data(using: String.Encoding.utf8), model: SCBQrCodeModel.no2, level: SCBQrCodeLevel.H, cell: 4, position: SCBAlignmentPosition.center)

            }
        }
        builder.append("\n".data(using: encoding))
    }
    
    static func dataPrintSplitePayment(dict: JSONDictionary,_ builder: ISCBBuilder, utf8: Bool, issplit:Bool, transId:Int) {
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
        
        let showAllFinal_transactions = dict["show_all_final_transactions"] as? String ?? "false"
        let printAllTransactions = dict["print_all_transactions"] as? String ?? "false"
        let extraMerchantCopy = dict["extra_merchant_copy"] as? String ?? "false"
        let is_signature_placeholder = dict["is_signature_placeholder"] as? Bool ?? false
        let qr_code = dict["qr_code"] as? String ?? ""
        let qr_code_data = dict["qr_code_data"] as? String ?? ""
        let hide_qr_code = dict["hide_qr_code"] as? Bool ?? false
        
        
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
        let charactersCount =  Int((size / font)/2) - 2
        
        //Products
        var blocks = [[Block]]()
        var block = [Block]()
        
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
        //
        
        let encoding: String.Encoding
        
        if utf8 == true {
            encoding = String.Encoding.utf8
            
            builder.append(SCBCodePageType.UTF8)
        }
        else {
            encoding = String.Encoding.ascii
            
            builder.append(SCBCodePageType.CP998)
        }
        
        builder.append(SCBInternationalType.USA)
        
        builder.appendCharacterSpace(0)
        
        builder.appendAlignment(SCBAlignmentPosition.center)
        
        builder.append("\n".data(using: encoding))
        if block.count > 0 {
            blocks.append(block)
            block = [Block]()
        }
        
        // Card Type
        var blocks1 = [[Block]]()
        var block1 = [Block]()
        
        // for i in 0..<cardDetails.count {
        let cardDetail = cardDetails[transId]
        let cardType = cardDetail.card_type.capitalized
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
                block1.append("".bc.kv(printDensity: size, fontDensity: font,k: (cardType + "-" + cardNo), v: "$\((amount ?? 0.0).roundToTwoDecimal)".count > charactersCount ? "\(String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".prefix(charactersCount)) + String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".dropFirst(charactersCount)))" : "$\((amount ?? 0.0).roundToTwoDecimal)" , attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
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
            
            block1.append("".bc.kv(printDensity: size, fontDensity: font,k: cardTypeObj, v: "$\((amount ?? 0.0).roundToTwoDecimal)".count > charactersCount ? "\(String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".prefix(charactersCount)) + String(describing: "$\((amount ?? 0.0).roundToTwoDecimal)".dropFirst(charactersCount)))" : "$\((amount ?? 0.0).roundToTwoDecimal)" , attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
        }
        blocks1.append(block1)
        block1 = [Block]()
        //}
        
        var receipt = [Receipt]()
        
        var headerReceipt = Receipt()
        builder.appendAlignment(SCBAlignmentPosition.center)
        
        if title != "" {
            
            builder.append(title.bc.customSize(printDensity: size, fontDensity: font, isBold:false, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
            builder.append("".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold,TextBlock.PredefinedAttribute.alignment(.left)]).data)
        }
        
        
        if showCompanyAddress {
            if address != "\n" {
                builder.append(address.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]).data)
                
            }
            if addressDetail != "," {
                builder.append(addressDetail.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]).data)
                
            }
        }
        
        if customerServiceEmail != "" {
            builder.append(customerServiceEmail.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if customerServicePhone != "" {
            builder.append(customerServicePhone.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
            builder.append("".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
        }
        
        if headerText != "" {
            builder.append("\(headerText) \n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        builder.appendAlignment(SCBAlignmentPosition.left)
        builder.append(" \n".bc.customSize(printDensity: size, fontDensity: font, isBold:false, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.left)]).data)
        
        builder.append("\n".bc.customSize(printDensity: size, fontDensity: font, isBold:false, attributes: [TextBlock.PredefinedAttribute.boldFont, TextBlock.PredefinedAttribute.alignment(.left)]).data)
        
        
        if addedDate != "" || orderTime != "" {
            builder.append("".bc.kv(printDensity: size, fontDensity: font, k: addedDate , v: "\(orderTime)\n", attributes: [TextBlock.PredefinedAttribute.boldFont, TextBlock.PredefinedAttribute.alignment(.left)]).data)
            
            
        }
        
        if orderid != "" {
            
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "Order  " , v: "#\(orderid)\n", attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
            
        }
        
        if transactiontype != "" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "Transaction Type  " , v: "\(transactiontype)\n", attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
            
        }
        
        if cardHolderName != "" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: cardHolderLabel + "  " , v: cardHolderName, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if companyName != "" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "Company Name  " , v: companyName, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if cardNumber != "************" && cardDetails.count == 1 {
            if cardNumber != "" && cardDetails.count == 1 {
                builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "Card#  " , v: cardNumber, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
                
            }
        }
        
        if source != "" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "Sale Location  " , v: source, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if approvalCode != "" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "Approval Code  " , v: approvalCode, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if entryMethod != "" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "Entry Method  " , v: entryMethod, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if PaymentSatus != "" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "Payment Status  " , v: PaymentSatus, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        builder.append("\n".data(using: encoding))
        
        if blocks.count > 0 {
            builder.append( "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
            
        }
        
        builder.append("\n".data(using: encoding))
        //
        
        for block in blocks {
            for data in  block {
                // var newReceipt = Receipt()
                // headerReceipt.add(block: data)
                builder.append(data.data)
                //receipt.append(newReceipt)
                
            }
            
        }
        
        var footerReceipt =  Receipt()
        builder.append( "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
        
        
        if discountInString != "$0.00" {
            if couponCode != "" {
                builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: ("Discount-" + couponCode + " ") , v: discountInString.count > charactersCount ? "\(String(describing: discountInString.prefix(charactersCount)) + String(describing: discountInString.dropFirst(charactersCount)))" : discountInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
                
            } else {
                builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Discount ", v:  discountInString.count > charactersCount ? "\(String(describing: discountInString.prefix(charactersCount)) + String(describing: discountInString.dropFirst(charactersCount)))" : discountInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
                
            }
        }
        
        builder.appendAlignment(SCBAlignmentPosition.left)
        if tipInString == "$0.00" {
            if showtiplinestatus {
                builder.append(" \n".data(using: encoding))
                builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
                //                builder.append(" \n".data(using: encoding))
                
                builder.append( "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
                builder.append(" \n".data(using: encoding))
                
                builder.append( "".bc.kv(printDensity: size, fontDensity: font, k: "Tip" , v: "------", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
                builder.append(" \n".data(using: encoding))
                
                builder.append( "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
                builder.append(" \n".data(using: encoding))
                
                builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  "------", attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
                builder.append(" \n".data(using: encoding))
                
                
            }
        } else {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Tip ", v:  tipInString.count > charactersCount ? "\(String(describing: tipInString.prefix(charactersCount)) + String(describing: tipInString.dropFirst(charactersCount)))" : tipInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        
        if tipInString != "$0.00" {
            builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            builder.append(" \n".data(using: encoding))
            
        } else {
            if !showtiplinestatus {
                builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Total ", v:  totalInString.count > charactersCount ? "\(String(describing: totalInString.prefix(charactersCount)) + String(describing: totalInString.dropFirst(charactersCount)))" : totalInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
                builder.append(" \n".data(using: encoding))
            }
        }
        
        if showAllFinal_transactions == "true" {
            builder.append( "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
            
            builder.appendAlignment(SCBAlignmentPosition.left)
            for block1 in blocks1 {
                for data in  block1 {
                    // headerReceipt.add(block: data)
                    builder.append(data.data)
                }
            }
        }
        
        if totalRefundAmount != "$0.00" {
            builder.append(" \n".data(using: encoding))
            builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Total Refunded Amt", v:  totalRefundAmount.count > charactersCount ? "\(String(describing: totalRefundAmount.prefix(charactersCount)) + String(describing: totalRefundAmount.dropFirst(charactersCount)))" : totalRefundAmount, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if balanceDueInString != "$0.00"{
            builder.append(" \n".data(using: encoding))
            builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Balance Due ", v:  balanceDueInString.count > charactersCount ? "\(String(describing: balanceDueInString.prefix(charactersCount)) + String(describing: balanceDueInString.dropFirst(charactersCount)))" : balanceDueInString, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        
        if changeInString != "$0.00" {
            builder.append("\n".data(using: encoding))
            builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Change ", v:  changeInString.count > charactersCount ? "\(String(describing: changeInString.prefix(charactersCount)) + String(describing: changeInString.dropFirst(charactersCount)))" : changeInString, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
            
        }
        
        if isNotes {
            builder.append(" \n".data(using: encoding))
            //headerReceipt.add(block: "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]))
            builder.append( "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
            
            if notes.count > (size/font) - 6 {
                builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Notes ", v: "\n\(notes)" /*notes.count > charactersCount ? "\(String(describing: notes.prefix(charactersCount)) + String(describing: notes.dropFirst(charactersCount)))" : notes*/, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
                
            }else{
                builder.append( "".bc.kv(printDensity: size, fontDensity: font,k: "Notes ", v: "\n\(notes)" /*notes.count > charactersCount ? "\(String(describing: notes.prefix(charactersCount)) + String(describing: notes.dropFirst(charactersCount)))" : notes*/, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
                
            }
        }
        
        
        if lowvaluesig_status {
            builder.append( "-".bc.dividing(printDensity: size, fontDensity: font).data)
            /// signature
            builder.append( "".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
            
        }
        
        
        let footerTextArray = footertext.components(separatedBy: "-")
        receipt.append(headerReceipt)
        
        
        //  ************** Image or Bar code And footer Text **************************
        
        builder.appendAlignment(SCBAlignmentPosition.center)
        
        builder.append(" \n".data(using: encoding))
//        var barCodeImage: UIImage?
//        let results = barcode.matches(for: "data:image\\/([a-zA-Z]*);base64,([^\\\"]*)")
//
//        for imageString in results {
//            autoreleasepool {
//                barCodeImage = imageString.base64ToImage()
//            }
//        }
        
        let imgsize = Int(round(Double(DataManager.paperSize) * 5))
        //builder.appendBitmap(signatureImage, diffusion: false)
        var signatureImagePrint: UIImage?
        builder.append("\n\n".data(using: encoding))
        builder.append(" \n".data(using: encoding))
        
        if (cardDetails[transId].txn_type != "" && cardDetails[transId].txn_type == "visa") || cardDetails[transId].txn_type == "credit" || cardDetails[transId].txn_type == "credit_card" || cardDetails[transId].txn_type == "credit card" || cardDetails[transId].txn_type == "mast" || cardDetails[transId].txn_type == "amex" || cardDetails[transId].txn_type == "amx" || cardDetails[transId].txn_type == "discover" || cardDetails[transId].txn_type == "EMV" || cardDetails[transId].txn_type == "EMV-DEBIT_CARD" || cardDetails[transId].txn_type == "EMV-GIFT_CARD"  {
            if let img = signatureImage {
                //signatureImagePrint = resizeImage(image: img, targetSize: CGSize(width: 360, height: imgsize))
                builder.appendBitmap(img, diffusion: false, width: imgsize, bothScale: false)
                builder.append("-".bc.dividing(printDensity: size, fontDensity: font).data)
                // builder.appendBitmap(signatureImagePrint, diffusion: false)
            }
            builder.append("\n".data(using: encoding))
        }
        
        footerReceiptDataShow(builder, footerArr: footerTextArray, orderId: orderid, discountInStringObj: discountInString)
        builder.append("\n".data(using: encoding))
//        barCodeImage = resizeImage(image: barCodeImage!, targetSize: CGSize(width: 360, height: 210))
        if barcode != "" {
            builder.appendBarcodeData("{B\(orderid)".data(using: String.Encoding.ascii), symbology: SCBBarcodeSymbology.code128, width: SCBBarcodeWidth.mode3, height: 80, hri: true)
        }else{
            if !hide_qr_code {
                builder.appendQrCodeData(withAlignment: qr_code.data(using: String.Encoding.ascii), model: SCBQrCodeModel.no1, level: SCBQrCodeLevel.H, cell: 5, position: .center)
            }
        }
        
        builder.append("\n".data(using: encoding))
        
    }
    
    static func footerReceiptDataShow(_ builder: ISCBBuilder,footerArr: [String], orderId: String, discountInStringObj: String) {
        let size = Int(round(Double(DataManager.paperSize) * 5))
        let size2 = Int(round(Double(DataManager.paperSize) * 7))
        let font = 9
        var stringFinal = ""
        builder.appendAlignment(SCBAlignmentPosition.center)
        builder.append(SCBFontStyleType.B)
        if discountInStringObj != "$0.00" {
            builder.append("\n".data(using: String.Encoding.utf8))
            builder.append("".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
            builder.append("\n".data(using: String.Encoding.utf8))
            builder.append("You Saved \(discountInStringObj)".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]).data)
            builder.append("\n".data(using: String.Encoding.utf8))
            builder.append("".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
        }
        
        for text in footerArr {
            if text != "" {
                stringFinal = printerStr(str: text)
                print("str:------\(stringFinal)")
                builder.append(stringFinal.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.smallFont, TextBlock.PredefinedAttribute.alignment(.center)]).data)
                builder.append("\n".data(using: String.Encoding.utf8))
            }
        }
        builder.append("".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.smallFont, TextBlock.PredefinedAttribute.alignment(.center)]).data)

        // receipt.append(headerReceipt)
    }
    
    static func printerStr(str: String) -> String {
        var   NORMAL_SIZE_LINE_LENGTH_SECOND = 0
        var   NORMAL_SPACE_POSITION = 0
        var  NORMAL_SIZE_LINE_LENGTH = 0
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
    
    static func replace(myString: String, index: Int, newChar: Character) -> String {
        
        var chars = Array(myString)     // gets an array of characters
        chars[index] = newChar
        let modifiedString = String(chars)
        //  print(modifiedString)
        return modifiedString
    }
    
    static func barCodeImagePrint(barcode:String) ->UIImage{
        
        var barCodeImage: UIImage?
        let results = barcode.matches(for: "data:image\\/([a-zA-Z]*);base64,([^\\\"]*)")
        
        for imageString in results {
            autoreleasepool {
                barCodeImage = imageString.base64ToImage()
            }
        }
        return barCodeImage!
        
    }
    
    static func getImage(image: UIImage, backgroundColor: UIColor)->UIImage?{
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
    
    static  func imageWith(Text: String?,font:Int,size:Int,hieght:CGFloat) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: size, height: Int(hieght))
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = .zero
        nameLabel.textColor = .black
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(font))
        nameLabel.text = Text
        UIGraphicsBeginImageContext(nameLabel.frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        //       let size = image.size
        let width1 = Int(round(Double(DataManager.paperSize) * 8.62))
        //       let widthRatio  = targetSize.width  / size.width
        //       let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        //if(widthRatio > heightRatio) {
        newSize = CGSize(width: width1, height: 200)
        //          // newSize = CGSizeMake(size.width  heightRatio, size.height  heightRatio)
        //       } else {
        //           newSize = CGSize(width: 360, height: 90)
        //           //newSize = CGSizeMake(size.width  widthRatio,  size.height  widthRatio)
        //       }
        
        // This is the rect that we've calculated out and this is what is actually used below
        //let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    static func createRasterReceiptData(_ emulation: StarIoExtEmulation, localizeReceipts: ILocalizeReceipts) -> Data {
        let image: UIImage = localizeReceipts.createRasterReceiptImage()!
        
        let builder: ISCBBuilder = StarIoExt.createCommandBuilder(emulation)
        
        builder.beginDocument()
        
        builder.appendBitmap(image, diffusion: false)
        
        builder.appendCutPaper(SCBCutPaperAction.partialCutWithFeed)
        
        builder.endDocument()
        
        return builder.commands.copy() as! Data
    }
    
    static func createScaleRasterReceiptData(_ emulation: StarIoExtEmulation, localizeReceipts: ILocalizeReceipts, width: Int, bothScale: Bool) -> Data {
        let image: UIImage = localizeReceipts.createScaleRasterReceiptImage()!
        
        let builder: ISCBBuilder = StarIoExt.createCommandBuilder(emulation)
        
        builder.beginDocument()
        
        builder.appendBitmap(image, diffusion: false, width: width, bothScale: bothScale)
        
        builder.appendCutPaper(SCBCutPaperAction.partialCutWithFeed)
        
        builder.endDocument()
        
        return builder.commands.copy() as! Data
    }
    
    static func createCouponData(_ emulation: StarIoExtEmulation, localizeReceipts: ILocalizeReceipts, width: Int, rotation: SCBBitmapConverterRotation) -> Data {
        let image: UIImage = localizeReceipts.createCouponImage()!
        
        let builder: ISCBBuilder = StarIoExt.createCommandBuilder(emulation)
        
        builder.beginDocument()
        
        builder.appendBitmap(image, diffusion: false, width: width, bothScale: true, rotation: rotation)
        
        builder.appendCutPaper(SCBCutPaperAction.partialCutWithFeed)
        
        builder.endDocument()
        
        return builder.commands.copy() as! Data
    }
    
    static func createTextBlackMarkData(_ emulation: StarIoExtEmulation, localizeReceipts: ILocalizeReceipts, type: SCBBlackMarkType, utf8: Bool) -> Data {
        let builder: ISCBBuilder = StarIoExt.createCommandBuilder(emulation)
        
        builder.beginDocument()
        
        builder.append(type)
        
        localizeReceipts.appendTextLabelData(builder, utf8: utf8)
        
        builder.appendCutPaper(SCBCutPaperAction.partialCutWithFeed)
        
        //      builder.append(SCBBlackMarkType.invalid)
        
        builder.endDocument()
        
        return builder.commands.copy() as! Data
    }
    
    static func createPasteTextBlackMarkData(_ emulation: StarIoExtEmulation, localizeReceipts: ILocalizeReceipts, pasteText: String, doubleHeight: Bool, type: SCBBlackMarkType, utf8: Bool) -> Data {
        let builder: ISCBBuilder = StarIoExt.createCommandBuilder(emulation)
        
        builder.beginDocument()
        
        builder.append(type)
        
        if doubleHeight == true {
            builder.appendMultipleHeight(2)
            
            localizeReceipts.appendPasteTextLabelData(builder, pasteText: pasteText, utf8: utf8)
            
            builder.appendMultipleHeight(1)
        }
        else {
            localizeReceipts.appendPasteTextLabelData(builder, pasteText: pasteText, utf8: utf8)
        }
        
        builder.appendCutPaper(SCBCutPaperAction.partialCutWithFeed)
        
        //      builder.append(SCBBlackMarkType.invalid)
        
        builder.endDocument()
        
        return builder.commands.copy() as! Data
    }
    
    static func createTextPageModeData(_ emulation: StarIoExtEmulation, localizeReceipts: ILocalizeReceipts, rect: CGRect, rotation: SCBBitmapConverterRotation, utf8: Bool) -> Data {
        let builder: ISCBBuilder = StarIoExt.createCommandBuilder(emulation)
        
        builder.beginDocument()
        
        builder.beginPageMode(rect, rotation:rotation)
        
        localizeReceipts.appendTextLabelData(builder, utf8: utf8)
        
        builder.endPageMode()
        
        builder.appendCutPaper(SCBCutPaperAction.partialCutWithFeed)
        
        builder.endDocument()
        
        return builder.commands.copy() as! Data
    }
    
    static func createHoldPrintData(_ emulation: StarIoExtEmulation, isHoldArray: [Bool]) -> [Data] {
        var commandArray : [Data] = [];
        
        for i in 0..<isHoldArray.count {
            let builder: ISCBBuilder = StarIoExt.createCommandBuilder(emulation)
            
            builder.beginDocument()
            
            // Disable hold print controlled by printer firmware.
            builder.append(SCBHoldPrintType.invalid)
            
            if isHoldArray[i] {
                // Enable paper present status if wait paper removal before next printing.
                builder.append(SCBPaperPresentStatusType.valid)
            } else {
                // Disable paper present status if do not wait paper removal before next printing.
                builder.append(SCBPaperPresentStatusType.invalid)
            }
            
            // Create commands for printing.
            builder.appendAlignment(SCBAlignmentPosition.center)
            
            builder.append(("\n------------------------------------\n\n\n\n\n\n").data(using: String.Encoding.ascii))
            
            builder.appendMultiple(3, height: 3)
            
            builder.append(("Page ").data(using: String.Encoding.ascii))
            builder.append((String(i + 1)).data(using: String.Encoding.ascii))
            
            builder.appendMultiple(1, height: 1)
            
            builder.append(("\n\n\n\n\n----------------------------------\n").data(using: String.Encoding.ascii))
            
            builder.appendCutPaper(SCBCutPaperAction.partialCutWithFeed)
            
            builder.endDocument()
            
            commandArray.append(builder.commands.copy() as! Data)
        }
        
        return commandArray;
    }
    
    static func createTextReceiptEndDrawerApiData(_ emulation: StarIoExtEmulation, utf8: Bool,dict: JSONDictionary) -> Data {
        let builder: ISCBBuilder = StarIoExt.createCommandBuilder(emulation)
        
        builder.beginDocument()
        
        append3inchEndDrawerTextReceiptApiData(builder, utf8: utf8, dict: dict)
        //       let img = barCodeImagePrint(barcode: HomeVM.shared.receiptModel.bar_code)
        //        builder.
        
        builder.appendCutPaper(SCBCutPaperAction.partialCutWithFeed)
        
        builder.endDocument()
        
        return builder.commands.copy() as! Data
    }
    
    static func append3inchEndDrawerTextReceiptApiData(_ builder: ISCBBuilder, utf8: Bool,dict: JSONDictionary) {
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
        let is_signature_placeholder = dict["is_signature_placeholder"] as? Bool ?? false
        let qr_code = dict["qr_code"] as? String ?? ""
        let qr_code_data = dict["qr_code_data"] as? String ?? ""
        let charactersCount =  Int((size / font)/2) - 2
        //Products
        var blocks = [[Block]]()
        var block = [Block]()
        
        if block.count > 0 {
            blocks.append(block)
            block = [Block]()
        }
        
        // Card Type
        var blocks1 = [[Block]]()
        var block1 = [Block]()
        
        
        var receipt = [Receipt]()
        
        var headerReceipt = Receipt()
        let encoding: String.Encoding
        
        if utf8 == true {
            encoding = String.Encoding.utf8
            
            builder.append(SCBCodePageType.UTF8)
        }
        else {
            encoding = String.Encoding.ascii
            
            builder.append(SCBCodePageType.CP998)
        }
        
        builder.append(SCBInternationalType.USA)
        
        builder.appendCharacterSpace(0)
        
        builder.appendAlignment(SCBAlignmentPosition.center)
        
        if title != "" {
            builder.append(title.bc.customSize(printDensity: size, fontDensity: font, isBold:false, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        
        if address != "," {
            builder.append(address.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if addressDetail != "," {
            builder.append(addressDetail.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if customer_service_email != "" {
            // headerReceipt.add(block: customer_service_email.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]))
            builder.append(customer_service_email.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if customer_service_phone != "" {
            builder.append(customer_service_phone.bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.bold, TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        builder.append("\n".data(using: encoding))
        
        if user_name != "" {
            builder.append("".bc.kv(printDensity: size, fontDensity: font, k: "User  " , v: user_name, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if source != "" {
            builder.append("".bc.kv(printDensity: size, fontDensity: font, k: "Sale Location " , v: source, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        if started != "" {
            builder.append("".bc.kv(printDensity: size, fontDensity: font, k: "Started  " , v: started, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        if end_time != "" {
            builder.append("".bc.kv(printDensity: size, fontDensity: font, k: "Ended  " , v: end_time, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        if pay_in != "" {
            builder.append("".bc.kv(printDensity: size, fontDensity: font, k: "Paid In  " , v: pay_in, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        if pay_out != "" {
            builder.append("".bc.kv(printDensity: size, fontDensity: font, k: "Paid Out  " , v: pay_out, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        if cash_sales != "" {
            builder.append("".bc.kv(printDensity: size, fontDensity: font, k: "Cash Sales " , v: cash_sales, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        if cash_refunds != "" {
            builder.append("".bc.kv(printDensity: size, fontDensity: font, k: "Cash Refunded " , v: cash_refunds, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        if expected_in_drawer != "" {
            builder.append("".bc.kv(printDensity: size, fontDensity: font, k: "Expected in Drawer " , v: expected_in_drawer, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        if starting_cash != "" {
            builder.append("".bc.kv(printDensity: size, fontDensity: font, k: "Starting Cash " , v: starting_cash, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        if actualin_drawer != "" {
            builder.append("".bc.kv(printDensity: size, fontDensity: font, k: "Actual in Drawer " , v: actualin_drawer, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        if drawer_difference != "" {
            builder.append("".bc.kv(printDensity: size, fontDensity: font, k: "Difference " , v: drawer_difference, attributes: [TextBlock.PredefinedAttribute.alignment(.center)]).data)
            
        }
        
        
        builder.append("\n".data(using: encoding))
        
        for block in blocks {
            for data in  block {
                var newReceipt = Receipt()
                newReceipt.add(block: data)
                receipt.append(newReceipt)
            }
        }
        
        var footerReceipt = Receipt()
        builder.append("\n".data(using: encoding))
        
        builder.append("\n".data(using: encoding))
        builder.append("\n".bc.customSize(printDensity: size, fontDensity: font, attributes: [TextBlock.PredefinedAttribute.alignment(.left)]).data)
        
        for block1 in blocks1 {
            for data in  block1 {
                footerReceipt.add(block: data)
            }
        }
        
    }
}


extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
}

extension UIImage {
    func scalePreservingAspectRatio(image: UIImage, targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let size = image.size
        
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
    
}

