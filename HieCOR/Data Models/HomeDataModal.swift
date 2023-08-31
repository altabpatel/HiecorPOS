//
//  HomeDataModal.swift
//  HieCOR
//
//  Created by Deftsoft on 23/07/18.
//  Copyright 2018 HyperMacMini. All rights reserved.
//

import Foundation
import CoreData

struct CoupanDetail {
    var id: String!
    var code: String!
    var amount: String!
    var type: String!
    var freeShipping: String!
    var productList: [String]!
    var totalAmount: String!
}

struct CartCalculationDetail {
    var tax: Double!
    var shipping: Double!
    var total: Double!
    var subTotal: Double!
    var couponDiscount: Double!
    var discount: Double!
    var couponType: String!
    var couponName: String!
    var isValidCoupon: Bool!
    var amount_available_for_refund: Double!
}

class CategoriesModel
{
    var str_CategoryName = String()
}

class IngenicoModel: NSObject
{
    var row_id = Double()
    var str_username = String()
    var str_password = String()
    var str_apikey = String()
    var str_url = String()
    var tokenization_fee_cents = String()
    var tokenization_enabled = Bool()
    var merchant_id = String()
}

class ProductsModel: NSObject
{
    var row_id = Double()
    var str_title = String()
    var str_product_id = String()
    var str_product_categoryName = String()
    var str_external_prod_id = String()
    var str_product_code = String()
    var str_stock = String()
    var str_price = String()
    var str_price_wholesale = String()
    var str_short_description = String()
    var str_long_description = String()
    var str_product_image = String()
    var productImageData: Data?
    var str_limit_qty = String()
    var str_keywords = String()
    var str_fileID = String()
    var is_taxable = String()
    var unlimited_stock = String()
    var shippingPrice = String()
    var mainPrice = String()
    var EditPrice = String()
    var isAllowDecimal = Bool()
    var isEditPrice = Bool()
    var isEditQty = Bool()
    var isShowEditModel = Bool()
    var isOutOfStock = Int()
    var taxDetails = JSONDictionary()
    var variations = JSONDictionary()
    var attributesData = JSONArray()
    var variationsData = JSONArray()
    var itemMetaData = JSONArray()
    var surchagevariationsData = JSONArray()
    var surchargeVariations = JSONDictionary()
    var selectedAttributesData = JSONArray()
    var automatic_upsell = [String]()
    var item_notes_title = String()
    //    var productSetting: ProductSetting?
    var width = Double()
    var height = Double()
    var length = Double()
    var weight = Double()
    
    var allow_credit_product = Bool()
    var allow_purchase_product = Bool()
    
    //by sudama add sub
    var frequencySub = String()
    var daymnth = String()
    var numberOfOcc = String()
    var unlimitedCheck = Bool()
    var addSubscription = Bool()
    //
    var str_fulfillment_action = String()
    var str_brand = String()
    var str_supplier = String()
    var str_website_Link = String()
    var on_order = String()
    var v_product_attributes_name = String()
    var v_product_attributes_values = [String]()
    var customFieldsArr = [CustomFieldsModel]()
    var v_product_stock = String()
    var Wholesale_use_parent_price = Bool()
    var serialNumberSearch = ""
    var is_additional_product = Bool() // For subcharge product By Altab (20Dec2022)
}

struct ProductSetting {
    var str_pos_logo = String()
    var ios_version = String()
    var show_update_now = Bool()
    var str_pos_no_inventory_purchase = String()
    var str_pos_tax_on_shipping_handling_functionality = String()
    var str_pos_show_images_functionality = String()
    var str_show_ship_order_in_pos = String()
    var str_pos_shipping_calculator_functionality = String()
    var str_manual_product_tax_data = String()
    var loyalty_program_settings : [ProductSettingLoyalty]
    var settings_Terms : [ProductSettingTerms]
    var str_invoice_po_number = String()
    var str_invoice_rep = String()
    var str_invoice_date = String()
    var str_invoice_terms = String()
    var str_invoice_title = String()
    var str_invoice_Country = String()
    
}

struct ProductSettingLoyalty {
    var max_save_order = String()
    var percent_savings = String()
}

struct ProductSettingTerms {
    var text = String()
    var id = String()
}
struct CustomFieldsModel {
    var label = String()
    var value = String()
}
class CustomerListModel: NSObject
{
    var isDataAdded = Bool()
    var str_company = String()
    var str_address = String()
    var str_address2 = String()
    var str_bpid = String()
    var str_city = String()
    var str_email = String()
    var str_display_name = String()
    var emv_card_Count = Double()
    var ingenico_card_count = Double()
    var company = String()
    var str_first_name = String()
    var str_last_name = String()
    var str_billing_first_name = String()
    var str_billing_last_name = String()
    var str_shipping_first_name = String()
    var str_shipping_last_name = String()
    var str_order_id = String()
    var str_phone = String()
    var str_postal_code = String()
    var str_region = String()
    var str_userID = String()
    var str_Billingphone = String()
    var str_Billingaddress = String()
    var str_Billingaddress2 = String()
    var str_Billingcity = String()
    var str_Billingregion = String()
    var str_Billingpostal_code = String()
    var str_Billingemail = String()
    var str_Shippingemail = String()
    var str_Shippingphone = String()
    var str_Shippingaddress = String()
    var str_Shippingaddress2 = String()
    var str_Shippingcity = String()
    var str_Shippingregion = String()
    var str_Shippingpostal_code = String()
    var cardDetail: CardDataModel?
    var userCustomTax = String()
    var userCoupan = String()
    var country = String()
    var shippingCountry = String()
    var billingCountry = String()
    var isUserCustSelected : Bool = false
    var str_balanceDue = Double()
    var cardCount = Int()
    var userPaxToken = String()
    var shippingaddressCount : Int!
    var str_CustomText1 = String()
    var str_CustomText2 = String()
    var str_loyalty_balance = String()
    var doubleloyalty_balance = Double()
    var user_ingenico_token = Dictionary<String,AnyObject>()
    var user_has_open_invoice = String()
    var str_customer_status = String()
    //Mark: start anand
    var str_contact_source = String()
    var str_office_phone = String()
    var str_customerTags = String()
    //end anand
}

class RegionsListModel
{
    var str_regionName = String()
    var str_regionAbv = String()
}

struct CountryDetail {
    var name: String!
    var abbreviation: String!
}

struct PAXDeviceList {
    var name: String!
    var url: String!
    var port: String!
}

struct SettingListData {
    var settingKey: String!
    var settingValue: String!
    var settingOption: String!
}
// by sudama offline
struct MultipleOrderData {
    var orderID : String!
    var message : String!
    var status : Bool!
    
}

class CouponsListModel
{
    var str_coupon_id = String()
    var str_coupon_code = String()
    var str_discount_type = String()
    var str_discount_amount = String()
    var str_coupon_name = String()
    
}
class MailingListModel
{
    var str_listid = String()
    var str_list_name = String()
}

class TaxListModel
{
    var tax_rowsData = Array<Any>()
    var tax_settings = Dictionary<String,AnyObject>()
    var tax_amount = String()
    var tax_title = String()
    var tax_type = String()
}

struct CardDataModel {
    var cardNumber: String!
    var month: String!
    var year: String!
    var type: String!
    var bpId: String!
}

class ReceiptEndDrawerURL {
    var receipt_url = String()
}

class ReceiptContentModel
{
    var packing_slip_title = String()
    var address1 = String()
    var address_line1 = String()
    var address2 = String()
    var city = String()
    var region = String()
    var customer_service_email = String()
    var customer_service_phone = String()
    var postal_code = String()
    var header_text = String()
    var sub_total = String()
    var transaction_type = String()
    var payment_type = String()
    var date_added = String()
    var order_time = String()
    var entry_method = String()
    var card_number = String()
    var approval_code = String()
    var coupon_code = String()
    var source = String()
    var sale_location = String()
    var change_due = String()
    var tax = String()
    var total = String()
    var discount = String()
    var tip = String()
    var shipping = String()
    var order_id = String()
    var card_agreement_text = String()
    var refund_policy_text = String()
    var footer_text = String()
    var bar_code = String()
    var signature = String()
    var card_holder_name = String()
    var card_holder_label = String()
    var company_name = String()
    var balance_Due = String()
    var payment_status = String()
    var show_company_address = Bool()
    var showtipline_status = Bool()
    var lowvaluesig_status_setting_flag = Bool()
    var show_all_final_transactions = String()
    var print_all_transactions = String()
    var extra_merchant_copy = String()
    var total_refund_amount = String()
    var notes = String()
    var isNotes = Bool()
    var lowvaluesig_status = Bool()
    var AID = String()
    var TC = String()
    var Appname = String()
    var ACCT = String()
    var array_ReceiptContent = [arrayReceiptContentModel]()
    var array_ReceiptCardContent = [arrayReceiptCardContentModel]()
    var qr_code = String() //  By Altab (23Dec2022)
    var is_signature_placeholder = Bool()
    var qr_code_data = String()
    var hide_qr_code = Bool()
}

class ReceiptEndDrawerDetailsModel
{
    var show_site_name = Bool()
    var siteName = String()
    var company_address = Bool()
    var address_line1 = String()
    var address_line2 = String()
    var city = String()
    var region = String()
    var postal_code = String()
    var packing_slip_title = String()
    var customer_service_email = String()
    var customer_service_phone = String()
    var cashdrawerID = String()
    var cash_refunds = String()
    var cash_sales = String()
    var pay_in = String()
    var pay_out = String()
    var starting_cash = String()
    var started = String()
    var end_time = String()
    var actualin_drawer = String()
    var drawer_desc = String()
    var expected_in_drawer = String()
    var drawer_difference = String()
    var source = String()
    var user_name = String()
}


class arrayReceiptContentModel
{
    var id = String()
    var title = String()
    var qty = Double()
    var price = NSNumber()
    var code = String()
    var note = String()
    var attributes = String()
    var itemFields = String()
}

class arrayReceiptCardContentModel
{
    var card_type = String()
    var amount = String()
    var card_no = String()
    var txn_type = String()
    // by sudama Start
    var txn_id = String()
    var total_amount = String()
    var approval_code = String()
    var entry_method = String()
    var payment_status = String()
    var transaction_type = String()
    var signature_url = String()
    var ai_Type = String()
    var isSignature = Bool()
    var signature_image_base_64 = String()
    var tip = String()
    
    // by sudama End
}
class DrawerHistoryModel
{
    var cashdrawerID = String()
    var end_time = String()
    var drawer_id = String()
    var starting_cash = String()
    var cash_sales = String()
    var cash_refunds = String()
    var paid_in_out = String()
    var paid_in = String()
    var paid_out = String()
    var started = String()
    var closed = String()
    var actualin_drawer = String()
    var drawer_desc = String()
    var expected_in_drawer = String()
    var drawer_difference = String()
    var paid_time = String()
    var paid_amount = String()
    var paid_outTime = String()
    var paid_outAmount = String()
    var source = String()
    var user_name = String()
    var last_action = String()
    var total_amount = String()
    var username_login = String()
    var array_PaidInOutContent = [arrayPaidInOutModel]()
}
class GetBalanceModel {
    var str_balance = String()
}

class SavedCardList {
    
    var cardfname = String()
    var cardlname = String()
    var bpid = String()
    var cardexpmo = String()
    var cardtype = String()
    var cardexpyr = String()
    var last4 = String()
    var cchealthcaretype = String()
    var track2data = String()
    var tip = String()
    var cardpaymenttype = String()
    var first6 = String()
    var cardvalid = Bool()
    var cardimg = String()
    var last_4 = String()
    var emv_card_token = String()
    var ingenico_card_token = String()
    var systemtokenRefId = String()
}

class UserShippingAddress {
    var bpid = String()
    var firstname = String()
    var lastname = String()
    var addressline1 = String()
    var addressline2 = String()
    var city = String()
    var region = String()
    var country = String()
    var postalcode = String()
    var displayname = String()
}
 // for socket sudama
class CustomerFacingDeviceList {
    var room_name = String()
    var room_id = String()
    var session_id = String()

} //

class arrayPaidInOutModel
{
    var amount = String()
    var time = String()
}

class ShippingCarrierDataModel
{
    var carrier_id = String()
    var carrier_name = String()
    var fullfillment_id = String()
    var carrier_display_name = String()
}
class ShippingServiceDataModel
{
    var desc = String()
    var service = String()
    var service_id = String()
    var rate = String()
}
class GetPrinterDataModel
{
    var is_multiple_printer = Bool()
    var arrprinter_list_value = [PrinterListValueDataModel]()
    
}
class PrinterListValueDataModel
{
    var printerMAC = String()
    var name = String()
    
}
class SerialNumberDataModel { // By Altab 18 Aug 2022
    var location_name = String()
    var serial_number = String()
}
class InvoiceTemplateDataModel { // By Altab 18 Aug 2022
    var defaultID = String()
    var defaultOnly = Bool()
    var aryTemplatesSettings = [InvoiceTemplatesSettingsDataModel]()
}
class InvoiceTemplatesSettingsDataModel { // By Altab 18 Aug 2022
    var id = String()
    var is_default = String()
    var template_name = String()
    var settings = TemplatesSettingsDataModel()
}
class TemplatesSettingsDataModel { // By Altab 18 Aug 2022
    var show_invoice_title_setting = String()
    var show_representative_setting = String()
    var show_frequency_setting = String()
    var show_po_number_setting = String()
    
    var show_payment_terms_setting = String()
    var show_invoice_date_setting = String()
    var show_shipping_address_setting = String()
    var show_country_setting = String()
    
    var show_bcc_email_setting = String()
    var show_user_comments_setting = String()
    var show_invoice_status_setting = String()
    var show_invoice_smartlist = String()
    
    var show_invoice_custom_text1 = String()
    var show_invoice_custom_text2 = String()
    var show_line_item_tax_setting = String()
    var show_detailed_description_setting = String()
    
    var show_item_discount_setting = String()
    var show_enable_split_rows_for_products = String()
    var show_invoice_discounting_setting = String()
    var show_shipping_setting = String()
    
    var show_free_shipping_threshold_setting = String()
    var show_custom_amount_setting = String()
    var show_custom_tax_setting = String()
    var show_inventory_options_setting = String()
    
    var free_shipping_threshold_value = String()
    var payment_terms_values = [ProductSettingTerms]()
}
extension HomeVM {
    
    func parseCategoryData(responseDict: JSONDictionary) {
        if let data = responseDict[APIKeys.kData] as? Array<Any> {
            self.isMoreCategoryFound = (data.count == 0) ? false : true
            for category in data {
                let categoryName = ((category as? NSDictionary) != nil) ? ((category as AnyObject).value(forKey: "title")) as? String ?? kEmptyString
                    :  category as? String ?? kEmptyString //?? kEmptyString
                let categoriesModel = CategoriesModel()
                categoriesModel.str_CategoryName = categoryName
                self.categoriesArray.append(categoriesModel)
            }
        }
    }
    
    func parseProductData(responseDict: JSONDictionary) {
        if let data = responseDict[APIKeys.kData] as? Array<Any> {
            self.isMoreProductFound = (data.count == 0) ? false : true
            
            var SettingLoyalty = [ProductSettingLoyalty]()
            var productListTerms = jsonArray
            var productListTermsValue = [ProductSettingTerms]()
            
            productListTerms.removeAll()
            
            if let dictSetting = responseDict["settings"] as? JSONDictionary  {
                let pos_logo = dictSetting["pos_logo"] as? String ?? ""
                let ios_version = dictSetting["ios_version"] as? String ?? ""
                let show_update_now = dictSetting["show_not_now_in_app"] as? Bool ?? false
                let pos_no_inventory_purchase = dictSetting["pos_no_inventory_purchase"] as? String ?? ""
                let show_pax_heartland_giftcards_method = dictSetting["show_pax_heartland_giftcards_method"] as? String ?? ""
                let show_heartland_giftcards_method = dictSetting["show_heartland_giftcards_method"] as? String ?? ""
                let pos_tax_on_shipping_handling_functionality = dictSetting["pos_tax_on_shipping_handling_functionality"] as? String ?? ""
                let pos_show_images_functionality = dictSetting["pos_show_images_functionality"] as? String ?? ""
                let pos_show_price_functionality = dictSetting["pos_show_price_functionality"] as? String ?? ""
                let pos_expose_pro_code_functionality = dictSetting["pos_expose_pro_code_functionality"] as? String ?? ""
                let pos_auto_print_credit_card_functionality = dictSetting["pos_auto_print_credit_card_functionality"] as? String ?? ""
                let pos_disable_discount_feature = dictSetting["pos_disable_discount_feature"] as? String ?? ""
                let pos_product_view_information = dictSetting["pos_product_view_information"] as? String ?? ""
                let show_ship_order_in_pos = dictSetting["show_ship_order_in_pos"] as? String ?? ""
                let pos_shipping_calculator_functionality = dictSetting["pos_shipping_calculator_functionality"] as? String ?? ""
                // by priya for invoice
                let pos_invoice_po_number = dictSetting["show_po_number_setting"] as? String ?? "true"
                let pos_invoice_rep = dictSetting["show_representative_setting"] as? String ?? "true"
                let pos_invoice_Date = dictSetting["show_invoice_date_setting"] as? String ?? "true"
                let pos_invoice_terms = dictSetting["show_payment_terms_setting"] as? String ?? "true"
                let pos_invoice_title = dictSetting["show_invoice_title_setting"] as? String ?? "true"
                let pos_invoice_Country = dictSetting["show_country_setting"] as? String ?? "true"
                let pos_hide_out_of_stock_functionality = dictSetting["pos_hide_out_of_stock_functionality"] as? String ?? "true"
                let show_product_in_stock_checkbox = dictSetting["show_product_in_stock_checkbox"] as? String ?? "false"
                let show_product_new_scan = dictSetting["show_product_new_scan"] as? String ?? "false"
                // end priya
                if let termsObj = dictSetting["payment_terms_values"] as? NSArray{
                    for temp in termsObj {
                        if let dict = temp as? NSDictionary{
                            let textob = dict.value(forKey: "text") as? String ?? ""
                            let textid = dict.value(forKey: "id") as? String ?? ""
                            productListTermsValue.append(ProductSettingTerms(text: textob, id: textid))
                            
                            let objData: JSONDictionary = [
                                "text": textob,
                                "id": textid
                            ]
                            
                            productListTerms.append(objData)
                        }
                    }
                }
                DataManager.productTermsData = productListTerms
                
                // Start ..... by priya loyalty change
                if let loyaltyOb = dictSetting["loyalty_program_settings"] as? JSONDictionary {
                    let max_save_order = loyaltyOb["max_save_order"] as? String ?? ""
                    let percent_savings = loyaltyOb["percent_savings"] as? String ?? ""
                    SettingLoyalty.append(ProductSettingLoyalty(max_save_order: max_save_order, percent_savings: percent_savings))
                    DataManager.loyaltyMaxSaveOrder = max_save_order
                    DataManager.loyaltyPercentSaving = percent_savings
                }
                
                let tip_calc_by_total = dictSetting["tip_calc_by_total"] as? Bool ?? false

                //end......priya
                let manual_product_tax_data = dictSetting["manual_product_tax_data"] as? String ?? ""
                let custom_field_show = dictSetting["custom_field_show"] as? Bool ?? false
                let custom_text1_type = dictSetting["custom_text1_type"] as? String ?? ""
                let custom_text2_type = dictSetting["custom_text2_type"] as? String ?? ""
                let custom_text1Label = dictSetting["custom_text1"] as? String ?? ""
                let custom_text2Label = dictSetting["custom_text2"] as? String ?? ""
                 // by sudama offline
                let offline_cc_process = dictSetting["offline_cc_process"] as? Bool ?? false
                let show_queued_offline_orders = dictSetting["show_queued_offline_orders"] as? Bool ?? false
                let show_subscription = dictSetting["show_subscription"] as? Bool ?? false
                let pax_tokenization_enable =  dictSetting["pax_tokenization_enable"] as? String ?? ""
                let allow_zero_dollar_txn = dictSetting["allow_zero_dollar_txn"] as? String ?? "false"
                let allow_user_price_change = dictSetting["allow_user_price_change"] as? String ?? "true"
                let allow_ingenico_payment_method = dictSetting["ingenico_payment_method"] as? String ?? "true"
                let show_subscription_check_box = dictSetting["show_subscription_check_box"] as? String ?? "false"
                let ingenico_payment_method_cancel_and_message = dictSetting["ingenico_payment_method_cancel_and_message"] as? String ?? "false"
                if ingenico_payment_method_cancel_and_message == "true" {
                     DataManager.isIngenicPaymentMethodCancelAndMessage = true
                }else{
                      DataManager.isIngenicPaymentMethodCancelAndMessage = false
                }
                
                let prompt_add_customer = dictSetting["prompt_add_customer"] as? String ?? ""
                if prompt_add_customer == "true" {
                     DataManager.isPromptAddCustomer = true
                }else{
                      DataManager.isPromptAddCustomer = false
                }
                
                let allow_edit_product = dictSetting["allow_edit_product"] as? String ?? ""
                if allow_edit_product == "true" {
                     DataManager.isProductEdit = true
                }else{
                      DataManager.isProductEdit = false
                }
                
                // screen saver code
                let is_screen_saver_on = dictSetting["is_screen_saver_on"] as? Bool ?? false
                let screensaver_time_in_second = dictSetting["screensaver_time_in_second"] as? Int ?? 1800
                
                DataManager.isScreenSaverOn = is_screen_saver_on
                DataManager.screenSaverTimeInSec = screensaver_time_in_second
                
                let app = UIApplication.shared as? TimerApplication
                app?.resetIdleTimer()
                
                //
                //pos_single_result_auto_add_to_cart
                let pos_single_result_auto_add_to_cart = dictSetting["pos_single_result_auto_add_to_cart"] as? String ?? ""
                if pos_single_result_auto_add_to_cart == "false" {
                    DataManager.isPosSingleResultAutoAddToCart = true
                }else{
                    DataManager.isPosSingleResultAutoAddToCart = false
                }
                let zreport_is_lowercase = dictSetting["zreport_is_lowercase"] as? String ?? ""
                DataManager.isZreportLowerCase = zreport_is_lowercase == "true"
//                if zreport_is_lowercase == "true" {
//                     DataManager.isZreportLowerCase = true
//                }else{
//                      DataManager.isZreportLowerCase = false
//                }
                
                let tax_ten_decimal = dictSetting["tax_ten_decimal"] as? String ?? ""
                //if tax_ten_decimal == "true" {
                     DataManager.isTaxTenDecimal = tax_ten_decimal == "true"
//                }else{
//                      DataManager.isTaxTenDecimal = false
//                }
                
                let open_pay_now_in_app = dictSetting["open_pay_now_in_app"] as? String ?? ""
                DataManager.isOpenPayNowInApp = open_pay_now_in_app == "true"

                let show_full_reciept_option_for_print = dictSetting["show_full_reciept_option_for_print"] as? String ?? ""
                DataManager.showFullRecieptOptionForPrint = show_full_reciept_option_for_print
                
                let show_multiple_shipping_popup = dictSetting["show_multiple_shipping_popup"] as? String ?? ""
                DataManager.showMultipleShippingPopup = show_multiple_shipping_popup
                
                DataManager.allowIngenicoPaymentMethod = allow_ingenico_payment_method
                DataManager.allowUserPriceChange = allow_user_price_change
                DataManager.allowZeroDollarTxn = allow_zero_dollar_txn
                DataManager.offlineccProcess = offline_cc_process
                DataManager.showQueuedOfflineOrders = show_queued_offline_orders
                DataManager.showCustomerFacing = dictSetting["customer_facing_support"] as? Bool ?? false
                DataManager.showCustomerFacingForMobile = dictSetting["customer_facing_support_mob"] as? Bool ?? false

                DataManager.showSubscription = show_subscription_check_box == "true" ? true : false // show_subscription
                DataManager.paxTokenizationEnable = pax_tokenization_enable
                DataManager.isTotalTipCalculation = tip_calc_by_total
               let show_terminal_intregation_settings = dictSetting["show_terminal_intregation_settings"] as? String ?? "true"
                DataManager.showTerminalIntregationSettings = show_terminal_intregation_settings 
                productSetting = [ProductSetting(str_pos_logo:pos_logo,ios_version:ios_version,show_update_now:show_update_now,str_pos_no_inventory_purchase:pos_no_inventory_purchase,str_pos_tax_on_shipping_handling_functionality:pos_tax_on_shipping_handling_functionality,str_pos_show_images_functionality:pos_show_images_functionality,str_show_ship_order_in_pos:show_ship_order_in_pos, str_pos_shipping_calculator_functionality: pos_shipping_calculator_functionality, str_manual_product_tax_data: manual_product_tax_data, loyalty_program_settings:SettingLoyalty, settings_Terms: productListTermsValue, str_invoice_po_number: pos_invoice_po_number, str_invoice_rep: pos_invoice_rep, str_invoice_date: pos_invoice_Date, str_invoice_terms: pos_invoice_terms, str_invoice_title: pos_invoice_title, str_invoice_Country:pos_invoice_Country )]
                DataManager.noInventoryPurchase = pos_no_inventory_purchase
                DataManager.showImagesFunctionality = pos_show_images_functionality
                DataManager.showProductCodeFunctionality = pos_expose_pro_code_functionality
                DataManager.showPriceFunctionality = pos_show_price_functionality
                DataManager.posAutoPrintCreditCardFunctionality = pos_auto_print_credit_card_functionality
                DataManager.posDisableDiscountFeature = pos_disable_discount_feature
                DataManager.showShipOrderInPos = show_ship_order_in_pos
                DataManager.showShippingCalculatiosInPos = pos_shipping_calculator_functionality
                DataManager.isPaxTokenEnable = "true"
                DataManager.isPosProductViewInfo = pos_product_view_information
                DataManager.manual_product_tax_data = manual_product_tax_data
                DataManager.posTaxOnShippingHandlingFunctionality = pos_tax_on_shipping_handling_functionality
                DataManager.posiOSVersion = ios_version
                DataManager.isShowUpdateNow = show_update_now
                
                DataManager.posInvoicePoNumber = pos_invoice_po_number
                DataManager.posInvoiceRep = pos_invoice_rep
                DataManager.posInvoiceDate = pos_invoice_Date
                DataManager.posInvoiceTerms = pos_invoice_terms
                DataManager.posInvoiceTitle = pos_invoice_title
                DataManager.posInvoiceCountry = pos_invoice_Country
                
                print("ios_version", ios_version)
                print("DataManager.posiOSVersion", DataManager.posiOSVersion)
                
                
                DataManager.customFieldShow = custom_field_show
                DataManager.customText1Type = custom_text1_type
                DataManager.customText2Type = custom_text2_type
                DataManager.customText1Label = custom_text1Label
                DataManager.customText2Label = custom_text2Label
                
                DataManager.ShowPaxHeartlandGiftcardsMethod = show_pax_heartland_giftcards_method
                DataManager.ShowHeartlandGiftcardsMethod = show_heartland_giftcards_method
                DataManager.logoImageUrl = pos_logo
                DataManager.loadGiftCardOnlyOnPurchase = dictSetting["load_gift_card_only_on_purchase"] as? String ?? "" //For Load Balance
                DataManager.posDropdownDefaultRegionState = dictSetting["pos_dropdown_default_region"] as? String ?? ""
                DataManager.posHideOutofStockFunctionality = pos_hide_out_of_stock_functionality == "true"
                DataManager.showProductInStockCheckbox =  show_product_in_stock_checkbox
                DataManager.showProductNewScan = show_product_new_scan
            }
            
            if data.count > 0 {
                var tempProducts = [ProductsModel]()
                for i in (0...data.count-1) {
                    let productsData = (data as AnyObject).object(at: i)
                    let ProductsModelObj = ProductsModel()
                    ProductsModelObj.str_title = ((productsData as AnyObject).value(forKey: "title")) as? String ?? ""
                    ProductsModelObj.str_external_prod_id = ((productsData as AnyObject).value(forKey: "external_prod_id")) as? String ?? ""
                    ProductsModelObj.shippingPrice = (((productsData as AnyObject).value(forKey: "shipping_prices")) as? String ?? "0").replacingOccurrences(of: ",", with: "")
                    ProductsModelObj.str_price = (((productsData as AnyObject).value(forKey: "price")) as? String ?? "").replacingOccurrences(of: ",", with: "")
                    ProductsModelObj.mainPrice = (((productsData as AnyObject).value(forKey: "price")) as? String ?? "").replacingOccurrences(of: ",", with: "")
                    ProductsModelObj.str_stock = ((productsData as AnyObject).value(forKey: "stock")) as? String ?? ""
                    ProductsModelObj.str_product_id = ((productsData as AnyObject).value(forKey: "product_id")) as? String ?? ""
                    ProductsModelObj.str_product_code = ((productsData as AnyObject).value(forKey: "product_code")) as? String ?? ""
                    ProductsModelObj.str_price_wholesale = ((productsData as AnyObject).value(forKey: "price_wholesale")) as? String ?? ""
                    //by anand
                    ProductsModelObj.str_fulfillment_action = ((productsData as AnyObject).value(forKey: "fulfillment_action")) as? String ?? ""
                    ProductsModelObj.str_supplier = ((productsData as AnyObject).value(forKey: "supplier")) as? String ?? ""
                    ProductsModelObj.str_brand = ((productsData as AnyObject).value(forKey: "brand")) as? String ?? ""
                    ProductsModelObj.str_website_Link = ((productsData as AnyObject).value(forKey: "website_link")) as? String ?? ""
                    ProductsModelObj.on_order = ((productsData as AnyObject).value(forKey: "on_order")) as? String ?? ""
                    //end anand

                    ProductsModelObj.str_long_description = ((productsData as AnyObject).value(forKey: "long_description")) as? String ?? ""
                    ProductsModelObj.str_short_description = ((productsData as AnyObject).value(forKey: "short_description_html_entity")) as? String ?? ""
                    ProductsModelObj.str_product_image = ((productsData as AnyObject).value(forKey: "product_image")) as? String ?? ""
                    ProductsModelObj.str_limit_qty = ((productsData as AnyObject).value(forKey: "limit_qty")) as? String ?? ""
                    ProductsModelObj.is_taxable = ((productsData as AnyObject).value(forKey: "is_taxable")) as? String ?? ""
                    ProductsModelObj.unlimited_stock = ((productsData as AnyObject).value(forKey: "unlimited_stock")) as? String ?? ""
                    ProductsModelObj.str_keywords = ((productsData as AnyObject).value(forKey: "keywords")) as? String ?? ""
                    ProductsModelObj.str_fileID = ((productsData as AnyObject).value(forKey: "fileID")) as? String ?? ""
                    ProductsModelObj.isAllowDecimal = ((productsData as AnyObject).value(forKey: "qty_allow_decimal") as? String ?? "0") == "1"
                    ProductsModelObj.isEditPrice = ((productsData as AnyObject).value(forKey: "prompt_for_price") as? String ?? "0") == "1"
                    ProductsModelObj.isShowEditModel = (productsData as AnyObject).value(forKey: "showEditModel") as? Bool ?? false
                    ProductsModelObj.isEditQty = ((productsData as AnyObject).value(forKey: "prompt_for_quantity") as? String ?? "0") == "1"
                    ProductsModelObj.variations = (productsData as AnyObject).value(forKey: "variation_display") as? JSONDictionary ?? JSONDictionary()
                    ProductsModelObj.taxDetails = (productsData as AnyObject).value(forKey: "tax_detail") as? JSONDictionary ?? JSONDictionary()
                    ProductsModelObj.surchargeVariations = (productsData as AnyObject).value(forKey: "surcharge_variations_display") as? JSONDictionary ?? JSONDictionary()
                    ProductsModelObj.attributesData = (productsData as AnyObject).value(forKey: "attributes") as? JSONArray ?? JSONArray()      //DD
                    ProductsModelObj.variationsData = (productsData as AnyObject).value(forKey: "variations") as? JSONArray ?? JSONArray()      //DD
                    ProductsModelObj.itemMetaData = (productsData as AnyObject).value(forKey: "item_meta_fields") as? JSONArray ?? JSONArray() // SD
                    ProductsModelObj.surchagevariationsData = (productsData as AnyObject).value(forKey: "surcharge_variations") as? JSONArray ?? JSONArray()    //DD
                    ProductsModelObj.width = ((productsData as AnyObject).value(forKey: "width")) as? Double ?? 0.0
                    ProductsModelObj.height = ((productsData as AnyObject).value(forKey: "height")) as? Double ?? 0.0
                    ProductsModelObj.length = ((productsData as AnyObject).value(forKey: "length")) as? Double ?? 0.0
                    ProductsModelObj.weight = ((productsData as AnyObject).value(forKey: "weight")) as? Double ?? 0.0
                    ProductsModelObj.EditPrice = ""
                    ProductsModelObj.isOutOfStock = ((productsData as AnyObject).value(forKey: "is_out_of_stock")) as? Int ?? 0
                    ProductsModelObj.allow_credit_product = ((productsData as AnyObject).value(forKey: "allow_credit_product")) as? Bool ?? false
                    ProductsModelObj.allow_purchase_product = ((productsData as AnyObject).value(forKey: "allow_purchase_product")) as? Bool ?? false
                    ProductsModelObj.automatic_upsell = (productsData as AnyObject).value(forKey: "automatic_upsell") as? [String] ?? [String]()      //DD
                    if DataManager.automatic_upsellData.count == 0 {
                        DataManager.automatic_upsellData = ProductsModelObj.automatic_upsell
                    }

                    //v_product_stock
                    ProductsModelObj.v_product_stock = (productsData as AnyObject).value(forKey: "v_product_stock") as? String ?? "0"      //DD
                   // for custom_fields
                    ProductsModelObj.customFieldsArr.removeAll()
                    if let termsObj = (productsData as AnyObject).value(forKey: "custom_fields") as? NSArray{
                        for temp in termsObj {
                            if let dict = temp as? NSDictionary{
                                var customFields = CustomFieldsModel()
                                customFields.label = dict.value(forKey: "label") as? String ?? ""
                                customFields.value = dict.value(forKey: "value") as? String ?? ""
                                ProductsModelObj.customFieldsArr.append(customFields)
                            }
                        }
                    }
                    
                    ProductsModelObj.v_product_attributes_name = ((productsData as AnyObject).value(forKey: "v_product_attributes_name")) as? String ?? ""
                    ProductsModelObj.v_product_attributes_values = (productsData as AnyObject).value(forKey: "v_product_attributes_values") as? [String] ?? [String]()
                    ProductsModelObj.Wholesale_use_parent_price = (productsData as AnyObject).value(forKey: "use_parent_price") as? Bool ?? false

                    ProductsModelObj.is_additional_product = (productsData as AnyObject).value(forKey: "is_additional_product") as? Bool ?? false
                    ProductsModelObj.item_notes_title = ((productsData as AnyObject).value(forKey: "item_notes_title")) as? String ?? ""
                    tempProducts.append(ProductsModelObj)
                }
                self.productsArray.append(contentsOf: tempProducts)
            }
        }
        
        
    }
    
    func parseSearchProductData(responseDict: JSONDictionary) {
        
        if let arrayData:NSDictionary = responseDict[APIKeys.kData] as? NSDictionary {
            
            var tempProducts = [ProductsModel]()
            
            let ProductsModelObj = ProductsModel()
            ProductsModelObj.str_title = ((arrayData as AnyObject).value(forKey: "title")) as? String ?? ""
            ProductsModelObj.str_external_prod_id = ((arrayData as AnyObject).value(forKey: "external_prod_id")) as? String ?? ""
            ProductsModelObj.str_price = (((arrayData as AnyObject).value(forKey: "price")) as? String ?? "").replacingOccurrences(of: ",", with: "")
            ProductsModelObj.mainPrice = (((arrayData as AnyObject).value(forKey: "price")) as? String ?? "").replacingOccurrences(of: ",", with: "")
            ProductsModelObj.shippingPrice = (((arrayData as AnyObject).value(forKey: "shipping_prices")) as? String ?? "0").replacingOccurrences(of: ",", with: "")
            ProductsModelObj.str_stock = ((arrayData as AnyObject).value(forKey: "stock")) as? String ?? ""
            ProductsModelObj.str_product_id = ((arrayData as AnyObject).value(forKey: "product_id")) as? String ?? ""
            ProductsModelObj.str_product_code = ((arrayData as AnyObject).value(forKey: "product_code")) as? String ?? ""
            ProductsModelObj.str_price_wholesale = ((arrayData as AnyObject).value(forKey: "price_wholesale")) as? String ?? ""
            //by anand
            ProductsModelObj.str_fulfillment_action = ((arrayData as AnyObject).value(forKey: "fulfillment_action")) as? String ?? ""
            ProductsModelObj.str_supplier = ((arrayData as AnyObject).value(forKey: "supplier")) as? String ?? ""
            ProductsModelObj.str_brand = ((arrayData as AnyObject).value(forKey: "brand")) as? String ?? ""
            ProductsModelObj.str_website_Link = ((arrayData as AnyObject).value(forKey: "website_link")) as? String ?? ""
            ProductsModelObj.on_order = (arrayData as AnyObject).value(forKey: "on_order") as? String ?? ""
            //end anand
            
            ProductsModelObj.str_long_description = ((arrayData as AnyObject).value(forKey: "long_description")) as? String ?? ""
            ProductsModelObj.str_short_description = ((arrayData as AnyObject).value(forKey: "short_description_html_entity")) as? String ?? ""
            ProductsModelObj.str_product_image = ((arrayData as AnyObject).value(forKey: "product_image")) as? String ?? ""
            ProductsModelObj.str_limit_qty = ((arrayData as AnyObject).value(forKey: "limit_qty")) as? String ?? ""
            ProductsModelObj.is_taxable = ((arrayData as AnyObject).value(forKey: "is_taxable")) as? String ?? ""
            ProductsModelObj.unlimited_stock = ((arrayData as AnyObject).value(forKey: "unlimited_stock")) as? String ?? ""
            ProductsModelObj.str_keywords = ((arrayData as AnyObject).value(forKey: "keywords")) as? String ?? ""
            ProductsModelObj.str_fileID = ((arrayData as AnyObject).value(forKey: "fileID")) as? String ?? ""
            ProductsModelObj.isAllowDecimal = ((arrayData as AnyObject).value(forKey: "qty_allow_decimal") as? String ?? "0") == "1"
            ProductsModelObj.isEditPrice = ((arrayData as AnyObject).value(forKey: "prompt_for_price") as? String ?? "0") == "1"
            ProductsModelObj.isShowEditModel = (arrayData as AnyObject).value(forKey: "showEditModel") as? Bool ?? false
            ProductsModelObj.isEditQty = ((arrayData as AnyObject).value(forKey: "prompt_for_quantity") as? String ?? "0") == "1"
            ProductsModelObj.variations = (arrayData as AnyObject).value(forKey: "variation_display") as? JSONDictionary ?? JSONDictionary()
            ProductsModelObj.taxDetails = (arrayData as AnyObject).value(forKey: "tax_detail") as? JSONDictionary ?? JSONDictionary()
            ProductsModelObj.surchargeVariations = (arrayData as AnyObject).value(forKey: "surcharge_variations_display") as? JSONDictionary ?? JSONDictionary()
            ProductsModelObj.attributesData = (arrayData as AnyObject).value(forKey: "attributes") as? JSONArray ?? JSONArray()      //DD
            ProductsModelObj.variationsData = (arrayData as AnyObject).value(forKey: "variations") as? JSONArray ?? JSONArray()      //DD
            ProductsModelObj.itemMetaData = (arrayData as AnyObject).value(forKey: "item_meta_fields") as? JSONArray ?? JSONArray() // SD
            ProductsModelObj.surchagevariationsData = (arrayData as AnyObject).value(forKey: "surcharge_variations") as? JSONArray ?? JSONArray()    //DD
            ProductsModelObj.width = ((arrayData as AnyObject).value(forKey: "width")) as? Double ?? 0.0
            ProductsModelObj.height = ((arrayData as AnyObject).value(forKey: "height")) as? Double ?? 0.0
            ProductsModelObj.length = ((arrayData as AnyObject).value(forKey: "length")) as? Double ?? 0.0
            ProductsModelObj.weight = ((arrayData as AnyObject).value(forKey: "weight")) as? Double ?? 0.0
            ProductsModelObj.EditPrice = ""
            ProductsModelObj.isOutOfStock = ((arrayData as AnyObject).value(forKey: "is_out_of_stock")) as? Int ?? 0
            
            ProductsModelObj.allow_credit_product = ((arrayData as AnyObject).value(forKey: "allow_credit_product")) as? Bool ?? false
            ProductsModelObj.allow_purchase_product = ((arrayData as AnyObject).value(forKey: "allow_purchase_product")) as? Bool ?? false
            ProductsModelObj.automatic_upsell = (arrayData as AnyObject).value(forKey: "automatic_upsell") as? [String] ?? [String]()      //DD
            if DataManager.automatic_upsellData.count == 0 {
                DataManager.automatic_upsellData = ProductsModelObj.automatic_upsell
            }
            
            ProductsModelObj.item_notes_title = ((arrayData as AnyObject).value(forKey: "item_notes_title")) as? String ?? ""
            ProductsModelObj.is_additional_product = (arrayData as AnyObject).value(forKey: "is_additional_product") as? Bool ?? false
            tempProducts.append(ProductsModelObj)
            self.searchProductsArray.append(contentsOf: tempProducts)
            
        }
        
        if let arrayData:Array = responseDict[APIKeys.kData] as? Array<AnyObject>
        {
            self.isMoreProductFound = (arrayData.count == 0) ? false : true
            if arrayData.count>0
            {
                var tempProducts = [ProductsModel]()
                
                for i in (0...arrayData.count-1)
                {
                    let productsData = (arrayData as AnyObject).object(at: i)
                    let ProductsModelObj = ProductsModel()
                    ProductsModelObj.str_title = ((productsData as AnyObject).value(forKey: "title")) as? String ?? ""
                    ProductsModelObj.str_external_prod_id = ((productsData as AnyObject).value(forKey: "external_prod_id")) as? String ?? ""
                    ProductsModelObj.str_price = (((productsData as AnyObject).value(forKey: "price")) as? String ?? "").replacingOccurrences(of: ",", with: "")
                    ProductsModelObj.mainPrice = (((productsData as AnyObject).value(forKey: "price")) as? String ?? "").replacingOccurrences(of: ",", with: "")
                    ProductsModelObj.shippingPrice = (((productsData as AnyObject).value(forKey: "shipping_prices")) as? String ?? "0").replacingOccurrences(of: ",", with: "")
                    ProductsModelObj.str_stock = ((productsData as AnyObject).value(forKey: "stock")) as? String ?? ""
                    ProductsModelObj.str_product_id = ((productsData as AnyObject).value(forKey: "product_id")) as? String ?? ""
                    ProductsModelObj.str_product_code = ((productsData as AnyObject).value(forKey: "product_code")) as? String ?? ""
                    ProductsModelObj.str_price_wholesale = ((productsData as AnyObject).value(forKey: "price_wholesale")) as? String ?? ""
                    //by anand
                    ProductsModelObj.str_fulfillment_action = ((productsData as AnyObject).value(forKey: "fulfillment_action")) as? String ?? ""
                    ProductsModelObj.str_supplier = ((productsData as AnyObject).value(forKey: "supplier")) as? String ?? ""
                    ProductsModelObj.str_brand = ((productsData as AnyObject).value(forKey: "brand")) as? String ?? ""
                    ProductsModelObj.str_website_Link = ((productsData as AnyObject).value(forKey: "website_link")) as? String ?? ""
                    ProductsModelObj.on_order = (productsData as AnyObject).value(forKey: "on_order") as? String ?? ""
                    //end anand
                    
                    ProductsModelObj.str_long_description = ((productsData as AnyObject).value(forKey: "long_description")) as? String ?? ""
                    ProductsModelObj.str_short_description = ((productsData as AnyObject).value(forKey: "short_description_html_entity")) as? String ?? ""
                    ProductsModelObj.str_product_image = ((productsData as AnyObject).value(forKey: "product_image")) as? String ?? ""
                    ProductsModelObj.str_limit_qty = ((productsData as AnyObject).value(forKey: "limit_qty")) as? String ?? ""
                    ProductsModelObj.is_taxable = ((productsData as AnyObject).value(forKey: "is_taxable")) as? String ?? ""
                    ProductsModelObj.unlimited_stock = ((productsData as AnyObject).value(forKey: "unlimited_stock")) as? String ?? ""
                    ProductsModelObj.str_keywords = ((productsData as AnyObject).value(forKey: "keywords")) as? String ?? ""
                    ProductsModelObj.str_fileID = ((productsData as AnyObject).value(forKey: "fileID")) as? String ?? ""
                    ProductsModelObj.isAllowDecimal = ((productsData as AnyObject).value(forKey: "qty_allow_decimal") as? String ?? "0") == "1"
                    ProductsModelObj.isEditPrice = ((productsData as AnyObject).value(forKey: "prompt_for_price") as? String ?? "0") == "1"
                    ProductsModelObj.isShowEditModel = (productsData as AnyObject).value(forKey: "showEditModel") as? Bool ?? false
                    ProductsModelObj.isEditQty = ((productsData as AnyObject).value(forKey: "prompt_for_quantity") as? String ?? "0") == "1"
                    ProductsModelObj.variations = (productsData as AnyObject).value(forKey: "variation_display") as? JSONDictionary ?? JSONDictionary()
                    ProductsModelObj.taxDetails = (productsData as AnyObject).value(forKey: "tax_detail") as? JSONDictionary ?? JSONDictionary()
                    ProductsModelObj.surchargeVariations = (productsData as AnyObject).value(forKey: "surcharge_variations_display") as? JSONDictionary ?? JSONDictionary()
                    ProductsModelObj.attributesData = (productsData as AnyObject).value(forKey: "attributes") as? JSONArray ?? JSONArray()      //DD
                    ProductsModelObj.variationsData = (productsData as AnyObject).value(forKey: "variations") as? JSONArray ?? JSONArray()      //DD
                    ProductsModelObj.itemMetaData = (productsData as AnyObject).value(forKey: "item_meta_fields") as? JSONArray ?? JSONArray() // SD
                    ProductsModelObj.surchagevariationsData = (productsData as AnyObject).value(forKey: "surcharge_variations") as? JSONArray ?? JSONArray()    //DD
                    ProductsModelObj.width = ((productsData as AnyObject).value(forKey: "width")) as? Double ?? 0.0
                    ProductsModelObj.height = ((productsData as AnyObject).value(forKey: "height")) as? Double ?? 0.0
                    ProductsModelObj.length = ((productsData as AnyObject).value(forKey: "length")) as? Double ?? 0.0
                    ProductsModelObj.weight = ((productsData as AnyObject).value(forKey: "weight")) as? Double ?? 0.0
                    ProductsModelObj.EditPrice = ""
                    ProductsModelObj.isOutOfStock = ((productsData as AnyObject).value(forKey: "is_out_of_stock")) as? Int ?? 0
                    
                    ProductsModelObj.allow_credit_product = ((productsData as AnyObject).value(forKey: "allow_credit_product")) as? Bool ?? false
                    ProductsModelObj.allow_purchase_product = ((productsData as AnyObject).value(forKey: "allow_purchase_product")) as? Bool ?? false
                    ProductsModelObj.automatic_upsell = (productsData as AnyObject).value(forKey: "automatic_upsell") as? [String] ?? [String]()      //DD
                    if DataManager.automatic_upsellData.count == 0 {
                        DataManager.automatic_upsellData = ProductsModelObj.automatic_upsell
                    }

                    ProductsModelObj.item_notes_title = ((productsData as AnyObject).value(forKey: "item_notes_title")) as? String ?? ""
                    //v_product_stock
                    ProductsModelObj.v_product_stock = (productsData as AnyObject).value(forKey: "v_product_stock") as? String ?? "0"      //DD
                   // for custom_fields
                    ProductsModelObj.customFieldsArr.removeAll()
                    if let termsObj = (productsData as AnyObject).value(forKey: "custom_fields") as? NSArray{
                        for temp in termsObj {
                            if let dict = temp as? NSDictionary{
                                var customFields = CustomFieldsModel()
                                customFields.label = dict.value(forKey: "label") as? String ?? ""
                                customFields.value = dict.value(forKey: "value") as? String ?? ""
                                ProductsModelObj.customFieldsArr.append(customFields)
                            }
                        }
                    }
                    
                    ProductsModelObj.v_product_attributes_name = ((productsData as AnyObject).value(forKey: "v_product_attributes_name")) as? String ?? ""
                    ProductsModelObj.v_product_attributes_values = (productsData as AnyObject).value(forKey: "v_product_attributes_values") as? [String] ?? [String]()
                    ProductsModelObj.Wholesale_use_parent_price = (productsData as AnyObject).value(forKey: "use_parent_price") as? Bool ?? false
                    ProductsModelObj.is_additional_product = (productsData as AnyObject).value(forKey: "is_additional_product") as? Bool ?? false
                    tempProducts.append(ProductsModelObj)
                }
                self.searchProductsArray.append(contentsOf: tempProducts)
            }
        }
    }
    
    func parseUpdatedProductData(responseDict: JSONDictionary) {
        updatedProduct = ProductsModel()
        if let data = responseDict[APIKeys.kData] as? Array<Any> {
            if data.count > 0 {
                let productsData = (data as AnyObject).object(at: 0)
                let ProductsModelObj = ProductsModel()
                ProductsModelObj.str_title = ((productsData as AnyObject).value(forKey: "title")) as? String ?? ""
                ProductsModelObj.str_external_prod_id = ((productsData as AnyObject).value(forKey: "external_prod_id")) as? String ?? ""
                ProductsModelObj.shippingPrice = (((productsData as AnyObject).value(forKey: "shipping_prices")) as? String ?? "0").replacingOccurrences(of: ",", with: "")
                ProductsModelObj.str_price = (((productsData as AnyObject).value(forKey: "price")) as? String ?? "").replacingOccurrences(of: ",", with: "")
                ProductsModelObj.mainPrice = (((productsData as AnyObject).value(forKey: "price")) as? String ?? "").replacingOccurrences(of: ",", with: "")
                ProductsModelObj.str_stock = ((productsData as AnyObject).value(forKey: "stock")) as? String ?? ""
                ProductsModelObj.str_product_id = ((productsData as AnyObject).value(forKey: "product_id")) as? String ?? ""
                ProductsModelObj.str_product_code = ((productsData as AnyObject).value(forKey: "product_code")) as? String ?? ""
                ProductsModelObj.str_price_wholesale = ((productsData as AnyObject).value(forKey: "price_wholesale")) as? String ?? ""
                //by anand
                ProductsModelObj.str_fulfillment_action = ((productsData as AnyObject).value(forKey: "fulfillment_action")) as? String ?? ""
                ProductsModelObj.str_supplier = ((productsData as AnyObject).value(forKey: "supplier")) as? String ?? ""
                ProductsModelObj.str_brand = ((productsData as AnyObject).value(forKey: "brand")) as? String ?? ""
                ProductsModelObj.str_website_Link = ((productsData as AnyObject).value(forKey: "website_link")) as? String ?? ""
                ProductsModelObj.on_order = (productsData as AnyObject).value(forKey: "on_order") as? String ?? ""
                //end anand
                
                ProductsModelObj.str_long_description = ((productsData as AnyObject).value(forKey: "long_description")) as? String ?? ""
                ProductsModelObj.str_short_description = ((productsData as AnyObject).value(forKey: "short_description_html_entity")) as? String ?? ""
                ProductsModelObj.str_product_image = ((productsData as AnyObject).value(forKey: "product_image")) as? String ?? ""
                ProductsModelObj.str_limit_qty = ((productsData as AnyObject).value(forKey: "limit_qty")) as? String ?? ""
                ProductsModelObj.is_taxable = ((productsData as AnyObject).value(forKey: "is_taxable")) as? String ?? ""
                ProductsModelObj.unlimited_stock = ((productsData as AnyObject).value(forKey: "unlimited_stock")) as? String ?? ""
                ProductsModelObj.str_keywords = ((productsData as AnyObject).value(forKey: "keywords")) as? String ?? ""
                ProductsModelObj.str_fileID = ((productsData as AnyObject).value(forKey: "fileID")) as? String ?? ""
                ProductsModelObj.isAllowDecimal = ((productsData as AnyObject).value(forKey: "qty_allow_decimal") as? String ?? "0") == "1"
                ProductsModelObj.isEditPrice = ((productsData as AnyObject).value(forKey: "prompt_for_price") as? String ?? "0") == "1"
                ProductsModelObj.isShowEditModel = (productsData as AnyObject).value(forKey: "showEditModel") as? Bool ?? false
                ProductsModelObj.isEditQty = ((productsData as AnyObject).value(forKey: "prompt_for_quantity") as? String ?? "0") == "1"
                ProductsModelObj.variations = (productsData as AnyObject).value(forKey: "variation_display") as? JSONDictionary ?? JSONDictionary()
                ProductsModelObj.taxDetails = (productsData as AnyObject).value(forKey: "tax_detail") as? JSONDictionary ?? JSONDictionary()
                ProductsModelObj.surchargeVariations = (productsData as AnyObject).value(forKey: "surcharge_variations_display") as? JSONDictionary ?? JSONDictionary()
                
                ProductsModelObj.attributesData = (productsData as AnyObject).value(forKey: "attributes") as? JSONArray ?? JSONArray()  //DD
                ProductsModelObj.variationsData = (productsData as AnyObject).value(forKey: "variations") as? JSONArray ?? JSONArray()  //DD
                ProductsModelObj.itemMetaData = (productsData as AnyObject).value(forKey: "item_meta_fields") as? JSONArray ?? JSONArray() // SD
                ProductsModelObj.surchagevariationsData = (productsData as AnyObject).value(forKey: "surcharge_variations") as? JSONArray ?? JSONArray()    //DD
                ProductsModelObj.width = ((productsData as AnyObject).value(forKey: "width")) as? Double ?? 0.0
                ProductsModelObj.height = ((productsData as AnyObject).value(forKey: "height")) as? Double ?? 0.0
                ProductsModelObj.length = ((productsData as AnyObject).value(forKey: "length")) as? Double ?? 0.0
                ProductsModelObj.weight = ((productsData as AnyObject).value(forKey: "weight")) as? Double ?? 0.0
                ProductsModelObj.EditPrice = ""
                ProductsModelObj.isOutOfStock = ((productsData as AnyObject).value(forKey: "is_out_of_stock")) as? Int ?? 0
                ProductsModelObj.allow_credit_product = ((productsData as AnyObject).value(forKey: "allow_credit_product")) as? Bool ?? false
                ProductsModelObj.allow_purchase_product = ((productsData as AnyObject).value(forKey: "allow_purchase_product")) as? Bool ?? false
                ProductsModelObj.automatic_upsell = (productsData as AnyObject).value(forKey: "automatic_upsell") as? [String] ?? [String]()      //DD
                if DataManager.automatic_upsellData.count == 0 {
                    DataManager.automatic_upsellData = ProductsModelObj.automatic_upsell
                }

                ProductsModelObj.item_notes_title = ((productsData as AnyObject).value(forKey: "item_notes_title")) as? String ?? ""
                ProductsModelObj.is_additional_product = (productsData as AnyObject).value(forKey: "is_additional_product") as? Bool ?? false
                self.updatedProduct = ProductsModelObj
            }
        }
    }
    
    func parseSearchCategoryData(responseDict: JSONDictionary) {
        self.searchCategoriesArray.removeAll()
        
        if let data = responseDict[APIKeys.kData] as? Array<Any> {
            for category in data {
                let categoryName = ((category as? NSDictionary) != nil) ? ((category as AnyObject).value(forKey: "title")) as? String ?? kEmptyString
                    :  category as? String ?? kEmptyString
                let categoriesModel = CategoriesModel()
                categoriesModel.str_CategoryName = categoryName
                self.searchCategoriesArray.append(categoriesModel)
            }
        }
    }
    
    func parseTaxData(responseDict: JSONDictionary) {
        taxList.removeAll()
        
        if let data = responseDict[APIKeys.kData] as? [String: AnyObject] {
            if let arrayTaxData = data["tax_rows"] as? Array<Dictionary<String,AnyObject>>
            {
                if arrayTaxData.count > 0
                {
                    for i in (0...arrayTaxData.count-1)
                    {
                        let taxData = (arrayTaxData as AnyObject).object(at: i)
                        let  taxModelObj = TaxListModel()
                        taxModelObj.tax_title = (taxData as AnyObject).value(forKey: "title") as? String ?? ""
                        taxModelObj.tax_type = (taxData as AnyObject).value(forKey: "type") as? String ?? ""
                        taxModelObj.tax_amount = ((taxData as AnyObject).value(forKey: "amount") as? String ?? "").replacingOccurrences(of: ",", with: "")
                        self.taxList.append(taxModelObj)
                    }
                }
            }
            DataManager.posTaxListData = data
            self.taxSetting = data
        }
    }
    
    func parseCoupanData(responseDict: JSONDictionary) {
        coupanList.removeAll()
        
        if let arrayData: Array = responseDict[APIKeys.kData] as? Array<AnyObject>
        {
            if arrayData.count>0
            {
                for i in (0...arrayData.count-1)
                {
                    let couponsData = (arrayData as AnyObject).object(at: i)
                    let couponsModelObj = CouponsListModel()
                    couponsModelObj.str_coupon_code = (couponsData as AnyObject).value(forKey: "coupon_code") as? String ?? ""
                    couponsModelObj.str_coupon_id = (couponsData as AnyObject).value(forKey: "coupon_id") as? String ?? ""
                    couponsModelObj.str_discount_type = (couponsData as AnyObject).value(forKey: "discount_type") as? String ?? ""
                    couponsModelObj.str_coupon_name = (couponsData as AnyObject).value(forKey: "coupon_name") as? String ?? ""
                    couponsModelObj.str_discount_amount = ((couponsData as AnyObject).value(forKey: "discount_amount") as? String ?? "").replacingOccurrences(of: ",", with: "")
                    self.coupanList.append(couponsModelObj)
                }
            }
        }
    }
    
    func parseIngenicoData(responseDict: JSONDictionary) {
        //coupanList.removeAll()
        
        let success = responseDict["success"] as? Bool ?? false
        
        if success {
            self.ingenicoData.removeAll()
            let IngenicoModelObj = IngenicoModel()
            if let arrayData: AnyObject = responseDict[APIKeys.kData] as? AnyObject
            {
                //IngenicoModelObj.str_username = arrayData.value(forKey: "username") as! String
                //IngenicoModelObj.str_apikey = arrayData.value(forKey: "apikey") as! String
                //IngenicoModelObj.str_url = arrayData.value(forKey: "url") as! String
                //IngenicoModelObj.str_password = arrayData.value(forKey: "password") as! String
                IngenicoModelObj.merchant_id = arrayData.value(forKey: "merchant_id") as? String ?? ""
                IngenicoModelObj.str_username = arrayData.value(forKey: "username") as! String
                IngenicoModelObj.str_apikey = arrayData.value(forKey: "apikey") as! String
                IngenicoModelObj.str_url = arrayData.value(forKey: "url") as! String
                IngenicoModelObj.str_password = arrayData.value(forKey: "password") as! String
                IngenicoModelObj.tokenization_fee_cents = arrayData.value(forKey: "tokenization_fee_cents") as? String ?? "0"
                IngenicoModelObj.tokenization_enabled = arrayData.value(forKey: "tokenization_enabled") as? Bool ?? false
                self.ingenicoData.append(IngenicoModelObj)
            }
        }
    }
    
    func parseMailingData(responseDict: JSONDictionary) {
        
        self.MailingList.removeAll()
        
        if let arrayData: Array = responseDict[APIKeys.kData] as? Array<AnyObject>
        {
            if arrayData.count>0
            {
                for i in (0...arrayData.count-1)
                {
                    let MailingData = (arrayData as AnyObject).object(at: i)
                    let MailingModelObj = MailingListModel()
                    MailingModelObj.str_listid = (MailingData as AnyObject).value(forKey: "listid") as? String ?? ""
                    MailingModelObj.str_list_name = (MailingData as AnyObject).value(forKey: "list_name") as? String ?? ""
                    self.MailingList.append(MailingModelObj)
                }
            }
        }
    }
    
    func parseCustomerData(responseDict: JSONDictionary) {
        
        if let arrayData: Array = responseDict[APIKeys.kData] as? Array<AnyObject>
        {
            self.isMoreCustomerFound = (arrayData.count == 0) ? false : true
            
            for data in arrayData {
                if let customersdata = data as? JSONDictionary {
                    self.customerList.append(self.parseCustomerData(customersData: customersdata))
                }
            }
        }
    }
    
    func parseSearchCustomerData(responseDict: JSONDictionary) {
        
        if let arrayData: Array = responseDict[APIKeys.kData] as? Array<AnyObject>
        {
            self.isMoreSearchCustomerFound = (arrayData.count == 0) ? false : true
            for data in arrayData {
                if let customersdata = data as? JSONDictionary {
                    searchCustomerList.append(self.parseCustomerData(customersData: customersdata))
                }
            }
        }
    }
    
    func parseCustomerDetailData(responseDict: JSONDictionary) {
        customerDetail = CustomerListModel()
        if let data = responseDict["data"] as? JSONDictionary {
            customerDetail = self.parseCustomerData(customersData: data as [String : AnyObject])
        }
    }
    
    func parseRegionData(responseDict: JSONDictionary) {
        regionsList.removeAll()
        
        if let arrayData: Array = responseDict[APIKeys.kData] as? Array<AnyObject>
        {
            if arrayData.count>0 {
                for i in (0...arrayData.count-1) {
                    let RegionsData = (arrayData as AnyObject).object(at: i)
                    let regionsModelObj = RegionsListModel()
                    regionsModelObj.str_regionAbv = (RegionsData as AnyObject).value(forKey: "regionAbv") as? String ?? ""
                    regionsModelObj.str_regionName = (RegionsData as AnyObject).value(forKey: "regionName") as? String ?? ""
                    self.regionsList.append(regionsModelObj)
                }
            }
        }
    }
    
    func parseGetBalanceData(responseDict: JSONDictionary) {
        
        if let balanceData = responseDict["data"] as? [String:AnyObject]
        {
            let GiftBalanceObj = GetBalanceModel()
            
            if let val = balanceData["balance"] as? String {
                GiftBalanceObj.str_balance = "\(val)"
                self.giftBalance.append(GiftBalanceObj)
            }
        }
    }
    
    func parseGetCreditSavedData(responseDict: JSONDictionary) {
        savedCardList.removeAll()
        if let data = responseDict[APIKeys.kData] as? NSArray {
            for savedCardData in data {
                let savedCardDataModelObj = SavedCardList()
                
                savedCardDataModelObj.cardfname = ((savedCardData as AnyObject).value(forKey: "card_fname")) as? String ?? ""
                savedCardDataModelObj.cardlname = ((savedCardData as AnyObject).value(forKey: "card_lname")) as? String ?? ""
                savedCardDataModelObj.bpid = ((savedCardData as AnyObject).value(forKey: "bp_id")) as? String ?? ""
                savedCardDataModelObj.cardexpmo = ((savedCardData as AnyObject).value(forKey: "card_exp_mo")) as? String ?? ""
                savedCardDataModelObj.cardtype = ((savedCardData as AnyObject).value(forKey: "card_type")) as? String ?? ""
                savedCardDataModelObj.cardexpyr = ((savedCardData as AnyObject).value(forKey: "card_exp_yr")) as? String ?? ""
                savedCardDataModelObj.last4 = ((savedCardData as AnyObject).value(forKey: "last4")) as? String ?? ""
                savedCardDataModelObj.cchealthcaretype = ((savedCardData as AnyObject).value(forKey: "cc_healthcare_type")) as? String ?? ""
                savedCardDataModelObj.track2data = ((savedCardData as AnyObject).value(forKey: "track2data")) as? String ?? ""
                savedCardDataModelObj.last_4 = ((savedCardData as AnyObject).value(forKey: "last_4")) as? String ?? ""
                savedCardDataModelObj.first6 = ((savedCardData as AnyObject).value(forKey: "first_6")) as? String ?? ""
                savedCardDataModelObj.cardvalid = ((savedCardData as AnyObject).value(forKey: "card_valid")) as? Bool ?? false
                savedCardDataModelObj.cardimg = ((savedCardData as AnyObject).value(forKey: "card_img")) as? String ?? ""
                savedCardDataModelObj.emv_card_token = ((savedCardData as AnyObject).value(forKey: "emv_card_token")) as? String ?? ""
                savedCardDataModelObj.ingenico_card_token = ((savedCardData as AnyObject).value(forKey: "ingenico_card_token")) as? String ?? ""
                savedCardDataModelObj.systemtokenRefId = ((savedCardData as AnyObject).value(forKey: "systemtokenRefId")) as? String ?? ""

                self.savedCardList.append(savedCardDataModelObj)
            }
        }
    }
    
    func parseGetUserShippingAddress(responseDict: JSONDictionary) {
        ShippingUserAddress.removeAll()
        if let data = responseDict[APIKeys.kData] as? NSArray {
            for UserShippingData in data {
                let UserShippingDataModelObj = UserShippingAddress()
                
                UserShippingDataModelObj.bpid = ((UserShippingData as AnyObject).value(forKey: "bp_id")) as? String ?? ""
                UserShippingDataModelObj.firstname = ((UserShippingData as AnyObject).value(forKey: "first_name")) as? String ?? ""
                UserShippingDataModelObj.lastname = ((UserShippingData as AnyObject).value(forKey: "last_name")) as? String ?? ""
                UserShippingDataModelObj.addressline1 = ((UserShippingData as AnyObject).value(forKey: "address_line_1")) as? String ?? ""
                UserShippingDataModelObj.addressline2 = ((UserShippingData as AnyObject).value(forKey: "address_line_2")) as? String ?? ""
                UserShippingDataModelObj.city = ((UserShippingData as AnyObject).value(forKey: "city")) as? String ?? ""
                UserShippingDataModelObj.region = ((UserShippingData as AnyObject).value(forKey: "region")) as? String ?? ""
                UserShippingDataModelObj.country = ((UserShippingData as AnyObject).value(forKey: "country")) as? String ?? ""
                UserShippingDataModelObj.postalcode = ((UserShippingData as AnyObject).value(forKey: "postal_code")) as? String ?? ""
                UserShippingDataModelObj.displayname = ((UserShippingData as AnyObject).value(forKey: "display_name")) as? String ?? ""
                self.ShippingUserAddress.append(UserShippingDataModelObj)
            }
        }
    }
    //for socket sudama
    func parseCustomerFacingDeviceList(responseDict: JSONDictionary) {
           customerFacingDeviceList.removeAll()
           if let data = responseDict[APIKeys.kData] as? NSArray {
               for UserShippingData in data {
                   let customerFacingDeviceListObj = CustomerFacingDeviceList()
                   customerFacingDeviceListObj.room_name = ((UserShippingData as AnyObject).value(forKey: "room_name")) as? String ?? ""
                   customerFacingDeviceListObj.room_id = ((UserShippingData as AnyObject).value(forKey: "room_id")) as? String ?? ""
                   customerFacingDeviceListObj.session_id = ((UserShippingData as AnyObject).value(forKey: "session_id")) as? String ?? ""
                   self.customerFacingDeviceList.append(customerFacingDeviceListObj)
               }
           }
       }
    //
    func parsePAXData(responseDict: JSONDictionary) {
        paxDeviceList.removeAll()
        if let data = responseDict[APIKeys.kData] as? NSDictionary {
            if let devicesArray = data.value(forKey: "pax_devices") as? NSArray {
                for tempdict in devicesArray {
                    if let dict = tempdict as? NSDictionary {
                        let name = dict.value(forKey: "pax_terminal_device_name") as? String ?? ""
                        let url = dict.value(forKey: "pax_terminal_url") as? String ?? ""
                        let port = dict.value(forKey: "pax_terminal_port") as? String ?? ""
                        
                        paxDeviceList.append(PAXDeviceList(name: name, url: url,port: port))
                    }
                }
            }
        }
    }
    
    func parseShippinCarrierData(responseDict: JSONDictionary) {
        shippingCarrierList.removeAll()
        if let data = responseDict[APIKeys.kData] as? NSArray {
            for i in (0...data.count-1) {
                let shippingCarrierData = (data as AnyObject).object(at: i)
                let shippingCarrierModelObj = ShippingCarrierDataModel()
                shippingCarrierModelObj.carrier_id = ((shippingCarrierData as AnyObject).value(forKey: "carrier_id")) as? String ?? ""
                shippingCarrierModelObj.carrier_name = ((shippingCarrierData as AnyObject).value(forKey: "carrier_name")) as? String ?? ""
                shippingCarrierModelObj.fullfillment_id = ((shippingCarrierData as AnyObject).value(forKey: "fulfillment_id")) as? String ?? ""
                shippingCarrierModelObj.carrier_display_name = ((shippingCarrierData as AnyObject).value(forKey: "carrier_display_name")) as? String ?? ""
                self.shippingCarrierList.append(shippingCarrierModelObj)
            }
        }
    }
    func parseShippinServiceData(responseDict: JSONDictionary) {
        shippingServiceList.removeAll()
        if let data = responseDict[APIKeys.kData] as? NSArray {
            for i in (0...data.count-1) {
                let shippingServiceData = (data as AnyObject).object(at: i)
                let shippingServiceModelObj = ShippingServiceDataModel()
                shippingServiceModelObj.desc = ((shippingServiceData as AnyObject).value(forKey: "desc")) as? String ?? ""
                shippingServiceModelObj.service = ((shippingServiceData as AnyObject).value(forKey: "service")) as? String ?? ""
                shippingServiceModelObj.service_id = ((shippingServiceData as AnyObject).value(forKey: "service_id")) as? String ?? ""
                shippingServiceModelObj.rate = ((shippingServiceData as AnyObject).value(forKey: "rate")) as? String ?? ""
                self.shippingServiceList.append(shippingServiceModelObj)
            }
        }
    }
    
    func parseSettingData(responseDict: JSONDictionary) {
        settingList.removeAll()
        
        if let arrayData: Array = responseDict[APIKeys.kData] as? Array<AnyObject>
        {
            if arrayData.count>0 {
                for i in (0...arrayData.count-1) {
                    let RegionsData = (arrayData as AnyObject).object(at: i)
                    var regionsModelObj = SettingListData()
                    regionsModelObj.settingKey = (RegionsData as AnyObject).value(forKey: "key") as? String ?? ""
                    regionsModelObj.settingValue = (RegionsData as AnyObject).value(forKey: "value") as? String ?? ""
                    regionsModelObj.settingOption = (RegionsData as AnyObject).value(forKey: "options") as? String ?? ""
//                    if regionsModelObj.settingKey == "pos_cloud_receipt_mode" {
//                                            print(regionsModelObj.settingKey)
//                                             print(regionsModelObj.settingValue)
//                                           // if regionsModelObj.settingValue == "true" {
//                                                DataManager.isGooglePrinter = regionsModelObj.settingValue == "true" ? true : false
//                        //DataManager.isGooglePrinter = false
//                                                DataManager.isBluetoothPrinter = false
//                    //                        }else {
//                    //                            DataManager.isCloudReceiptPrinter = false
//                    //                            DataManager.isBluetoothPrinter = true
//                    //                        }
//                                        }
                    self.settingList.append(regionsModelObj)
                }
            }
            print("value data === \(settingList)")
        }
    }
    
    func parseCustomerData(customersData:JSONDictionary)-> CustomerListModel
    {
        let customerModelObj = CustomerListModel()
        var cardDetail: CardDataModel? = nil
        
        if let dict = customersData["cc"] as? JSONDictionary  {
            let month = dict["card_exp_mo"] as? String ?? ""
            let year = dict["card_exp_yr"] as? String ?? ""
            let cardType = dict["card_type"] as? String ?? ""
            let cardnumber = dict["last4"] as? String ?? ""
            let BPid = dict["bpID"] as? String ?? ""
            cardDetail = CardDataModel(cardNumber: cardnumber, month: month, year: year, type: cardType, bpId: BPid)
        }
        
        customerModelObj.cardDetail = cardDetail
        
        customerModelObj.str_first_name = (customersData["first_name"]) as? String ?? ""
        customerModelObj.str_last_name = customersData ["last_name"] as? String ?? ""
        customerModelObj.str_email = (customersData["email"]) as? String ?? ""
        customerModelObj.str_phone = customersData["phone"] as? String ?? ""
        customerModelObj.str_company = customersData["company"] as? String ?? ""
        customerModelObj.str_address = customersData["address"] as? String ?? ""
        customerModelObj.str_address2 = customersData["address2"] as? String ?? ""
        customerModelObj.str_city = (customersData["city"]) as? String ?? ""
        customerModelObj.str_region = (customersData["region"]) as? String ?? ""
        customerModelObj.str_postal_code = (customersData["postal_code"]) as? String ?? ""
        customerModelObj.str_bpid = customersData["bpid"] as? String ?? ""
        customerModelObj.str_userID = customersData["userID"] as? String ?? ""
        customerModelObj.str_order_id = customersData["order_id"] as? String ?? ""
        customerModelObj.str_display_name = customersData["display_name"] as? String ?? ""
        customerModelObj.userCoupan = customersData["user_coupon"] as? String ?? ""
        customerModelObj.userCustomTax = customersData["user_custom_tax"] as? String ?? ""
        customerModelObj.country = customersData["country"] as? String ?? ""
        customerModelObj.cardCount = customersData["card_count"] as? Int ?? 0
        customerModelObj.shippingaddressCount = customersData["shippingaddress_count"] as? Int ?? 0
        customerModelObj.userPaxToken = customersData["user_pax_token"] as? String ?? ""
        customerModelObj.str_CustomText1 = customersData["custom_text_1"] as? String ?? ""
        customerModelObj.str_CustomText2 = customersData["custom_text_2"] as? String ?? ""
        
        customerModelObj.user_ingenico_token = customersData["user_ingenico_token"] as? [String : AnyObject] ?? [:]
        
        customerModelObj.str_loyalty_balance = customersData["loyalty_balance"] as? String ?? ""
        customerModelObj.doubleloyalty_balance = customersData["loyalty_balance"] as? Double ?? 0.0
        customerModelObj.emv_card_Count = customersData["emv_card_count"] as? Double ?? 0.0
        customerModelObj.ingenico_card_count = customersData["ingenico_card_count"] as? Double ?? 0.0
        if customerModelObj.str_loyalty_balance != "" {
            customerModelObj.doubleloyalty_balance = Double(customerModelObj.str_loyalty_balance)!
        }
        customerModelObj.str_customer_status = customersData["customer_status"] as? String ?? ""
        customerModelObj.user_has_open_invoice = customersData["user_has_open_invoice"] as? String ?? ""
        // Mark: start anand
        customerModelObj.str_customerTags = customersData["custome_tags"] as? String ?? ""
        customerModelObj.str_contact_source = (customersData["contact_source"]) as? String ?? ""
        customerModelObj.str_office_phone = (customersData["office_phone"]) as? String ?? ""
        //end anand
        
        if let dict = customersData["billing_addr"] as? NSDictionary {
            customerModelObj.str_Billingaddress = dict.value(forKey: "address_line_1") as? String ?? ""
            customerModelObj.str_Billingaddress2 = dict.value(forKey: "address_line_2") as? String ?? ""
            customerModelObj.str_Billingcity = dict.value(forKey: "city") as? String ?? ""
            customerModelObj.str_Billingregion = dict.value(forKey: "region") as? String ?? ""
            customerModelObj.str_Billingpostal_code = dict.value(forKey: "postal_code") as? String ?? ""
            customerModelObj.str_Billingphone = dict.value(forKey: "phone") as? String ?? ""
            customerModelObj.str_Billingemail = dict.value(forKey: "email") as? String ?? ""
            customerModelObj.str_billing_first_name = dict.value(forKey: "first_name") as? String ?? ""
            customerModelObj.str_billing_last_name = dict.value(forKey: "last_name") as? String ?? ""
            customerModelObj.billingCountry = dict.value(forKey: "country") as? String ?? ""
        }
        
        
        if let dict = customersData["shipping_addr"] as? NSDictionary {
            customerModelObj.str_Shippingaddress = dict.value(forKey: "address_line_1") as? String ?? ""
            customerModelObj.str_Shippingaddress2 = dict.value(forKey: "address_line_2") as? String ?? ""
            customerModelObj.str_Shippingcity = dict.value(forKey: "city") as? String ?? ""
            customerModelObj.str_Shippingregion = dict.value(forKey: "region") as? String ?? ""
            customerModelObj.str_Shippingpostal_code = dict.value(forKey: "postal_code") as? String ?? ""
            customerModelObj.str_Shippingphone = dict.value(forKey: "phone") as? String ?? ""
            customerModelObj.str_Shippingemail = dict.value(forKey: "email") as? String ?? ""
            customerModelObj.str_shipping_first_name = dict.value(forKey: "first_name") as? String ?? ""
            customerModelObj.str_shipping_last_name = dict.value(forKey: "last_name") as? String ?? ""
            customerModelObj.shippingCountry = dict.value(forKey: "country") as? String ?? ""
        }
        
        return customerModelObj
    }
    
    
    func parseCreateOrderData(responseDict: JSONDictionary) {
        userData = [String:AnyObject]()
        if let data = responseDict[APIKeys.kData] as? [String: AnyObject] {
            self.userData = data
        }
    }
    // by sudama offline
    func parsePushMultipleOrderData(responseDict: JSONDictionary){
        muttipleOrderList.removeAll()
        
        if let arrayData: Array = responseDict[APIKeys.kData] as? Array<AnyObject>
        {
            if arrayData.count>0 {
                for i in (0...arrayData.count-1) {
                    let RegionsData = (arrayData as AnyObject).object(at: i)
                    var regionsModelObj = MultipleOrderData()
                    regionsModelObj.orderID = (RegionsData as AnyObject).value(forKey: "orderID") as? String ?? ""
                    regionsModelObj.message = (RegionsData as AnyObject).value(forKey: "message") as? String ?? ""
                    regionsModelObj.status = (RegionsData as AnyObject).value(forKey: "status") as? Bool ?? false
                    self.muttipleOrderList.append(regionsModelObj)
                }
            }
            print("value data === \(muttipleOrderList)")
        }
    }
    
    
    func parseRepresentativesData(responseDict: JSONDictionary) {
        self.representativesList.removeAll()
        
        if let arrayRepresentatives:Array = responseDict[APIKeys.kData] as?  Array<Dictionary<String, AnyObject>>
        {
            for data in arrayRepresentatives {
                let representativesObj = RepresentativesListForInvoiceModel()
                representativesObj.id = (data as AnyObject).value(forKey: "id") as? String ?? ""
                representativesObj.display_name = (data as AnyObject).value(forKey: "display_name") as? String ?? ""
                self.representativesList.append(representativesObj)
            }
        }
    }
    
    func parseReceiptEndDrawerDetailsData(responseDict: JSONDictionary) {
        self.receiptDetailsModel = ReceiptEndDrawerDetailsModel()
        
        if let data = responseDict[APIKeys.kData] as? Dictionary<String, AnyObject>
        {
            self.receiptDetailsModel.show_site_name = data["show_site_name"] as? Bool ?? false
            self.receiptDetailsModel.siteName = data["siteName"] as? String ?? ""
            self.receiptDetailsModel.company_address = data["company_address"] as? Bool ?? false
            self.receiptDetailsModel.address_line1 = data["address_line1"] as? String ?? ""
            self.receiptDetailsModel.address_line2 = data["address_line2"] as? String ?? ""
            self.receiptDetailsModel.city = data["city"] as? String ?? ""
            self.receiptDetailsModel.region = data["region"] as? String ?? ""
            self.receiptDetailsModel.postal_code = data["postal_code"] as? String ?? ""
            self.receiptDetailsModel.packing_slip_title = data["packing_slip_title"] as? String ?? ""
            self.receiptDetailsModel.customer_service_email = data["customer_service_email"] as? String ?? ""
            self.receiptDetailsModel.customer_service_phone = data["customer_service_phone"] as? String ?? ""
            self.receiptDetailsModel.cashdrawerID = data["cashdrawerID"] as? String ?? ""
            self.receiptDetailsModel.cash_refunds = data["cash_refunds"] as? String ?? ""
            self.receiptDetailsModel.cash_sales = data["cash_sales"] as? String ?? ""
            self.receiptDetailsModel.pay_in = data["pay_in"] as? String ?? ""
            self.receiptDetailsModel.pay_out = data["pay_out"] as? String ?? ""
            self.receiptDetailsModel.starting_cash = data["starting_cash"] as? String ?? ""
            self.receiptDetailsModel.started = data["started"] as? String ?? ""
            self.receiptDetailsModel.end_time = data["end_time"] as? String ?? ""
            self.receiptDetailsModel.actualin_drawer = data["actualin_drawer"] as? String ?? ""
            self.receiptDetailsModel.drawer_desc = data["drawer_desc"] as? String ?? ""
            self.receiptDetailsModel.expected_in_drawer = data["expected_in_drawer"] as? String ?? ""
            self.receiptDetailsModel.drawer_difference = data["drawer_difference"] as? String ?? ""
            self.receiptDetailsModel.source = data["source"] as? String ?? ""
            self.receiptDetailsModel.user_name = data["user_name"] as? String ?? ""
        }
    }
    
    func parseReceiptEndDrawerURLData(responseDict: JSONDictionary) {
        self.receiptEndDrawerURL = ReceiptEndDrawerURL()
        
        if let data = responseDict[APIKeys.kData] as? Dictionary<String, AnyObject>
        {
            self.receiptEndDrawerURL.receipt_url = data["receipt_url"] as? String ?? ""
        }
    }
    
    
    func parseReceiptData(responseDict: JSONDictionary) {
        self.receiptModel = ReceiptContentModel()
        
        if let data = responseDict[APIKeys.kData] as? Dictionary<String, AnyObject>
        {
            self.receiptModel.show_company_address = data["show_company_address"] as? Bool ?? false
            self.receiptModel.packing_slip_title = data["packing_slip_title"] as? String ?? ""
            self.receiptModel.address1 = data["address1"] as? String ?? ""
            self.receiptModel.address_line1 = data["address_line1"] as? String ?? ""
            self.receiptModel.showtipline_status = data["showtipline_status"] as? Bool ?? false
            self.receiptModel.lowvaluesig_status_setting_flag = data["lowvaluesig_status_setting_flag"] as? Bool ?? false
            self.receiptModel.address2 = data["address2"] as? String ?? ""
            self.receiptModel.city = data["city"] as? String ?? ""
            self.receiptModel.region = data["region"] as? String ?? ""
            self.receiptModel.customer_service_email = data["customer_service_email"] as? String ?? ""
            self.receiptModel.customer_service_phone = data["customer_service_phone"] as? String ?? ""
            self.receiptModel.postal_code = data["postal_code"] as? String ?? ""
            self.receiptModel.header_text = data["header_text"] as? String ?? ""
            self.receiptModel.sub_total = data["sub_total"] as? String ?? ""
            self.receiptModel.shipping = data["shipping"] as? String ?? ""
            self.receiptModel.discount = data["discount"] as? String ?? ""
            self.receiptModel.transaction_type = data["transaction_type"] as? String ?? ""
            self.receiptModel.footer_text = data["footer_text"] as? String ?? ""
            self.receiptModel.payment_type = data["payment_type"] as? String ?? ""
            self.receiptModel.date_added = data["date_added"] as? String ?? ""
            self.receiptModel.tax = data["tax"] as? String ?? ""
            self.receiptModel.total = data["total"] as? String ?? ""
            self.receiptModel.tip = data["tip"] as? String ?? ""
            self.receiptModel.order_id = data["order_id"] as? String ?? ""
            self.receiptModel.order_time = data["order_time"] as? String ?? ""
            self.receiptModel.source = data["source"] as? String ?? ""
            self.receiptModel.bar_code = data["bar_code"] as? String ?? ""
            self.receiptModel.entry_method = data["entry_method"] as? String ?? ""
            self.receiptModel.card_number = data["card_number"] as? String ?? ""
            self.receiptModel.approval_code = data["approval_code"] as? String ?? ""
            self.receiptModel.coupon_code = data["coupon_code"] as? String ?? ""
            self.receiptModel.change_due = data["change_due"] as? String ?? ""
            self.receiptModel.signature = data["signature"] as? String ?? ""
            self.receiptModel.card_holder_label = data["card_holder_label"] as? String ?? ""
            self.receiptModel.card_holder_name = data["card_holder_name"] as? String ?? ""
            self.receiptModel.company_name = data["company"] as? String ?? ""
            self.receiptModel.sale_location = data["sale_location"] as? String ?? ""
            self.receiptModel.card_agreement_text = data["card_agreement_text"] as? String ?? ""
            self.receiptModel.refund_policy_text = data["refund_policy_text"] as? String ?? ""
            self.receiptModel.balance_Due = data["balance_due"] as? String ?? ""
            self.receiptModel.payment_status = data["payment_status"] as? String ?? ""
            self.receiptModel.show_all_final_transactions = data["show_all_final_transactions"] as? String ?? ""
            self.receiptModel.print_all_transactions = data["print_all_transactions"] as? String ?? ""
            self.receiptModel.extra_merchant_copy = data["extra_merchant_copy"] as? String ?? ""
            self.receiptModel.total_refund_amount = data["total_refund_amount"] as? String ?? ""
            self.receiptModel.notes = data["notes"] as? String ?? ""
            self.receiptModel.isNotes = data["isNotes"] as? Bool ?? false
            self.receiptModel.lowvaluesig_status = data["lowvaluesig_status"] as? Bool ?? false
            self.receiptModel.is_signature_placeholder = data["is_signature_placeholder"] as? Bool ?? false // By Altab (23Dec2022)
            self.receiptModel.qr_code = data["qr_code"] as? String ?? ""
            self.receiptModel.qr_code_data = data["qr_code_data"] as? String ?? ""
            self.receiptModel.hide_qr_code = data["hide_qr_code"] as? Bool ?? true
            if let dict = data["aid"] as? NSDictionary {
                                  self.receiptModel.AID = dict.value(forKey: "AID") as? String ?? ""
                       }
                       if let dict = data["app_name"] as? NSDictionary {
                                  self.receiptModel.Appname = dict.value(forKey: "APP NAME") as? String ?? ""
                       }
                       if let dict = data["tc"] as? NSDictionary {
                                  self.receiptModel.TC = dict.value(forKey: "TC") as? String ?? ""
                       }
                       if let dict = data["acct"] as? NSDictionary {
                                  self.receiptModel.ACCT = dict.value(forKey: "ACCT") as? String ?? ""
                       }
            self.receiptModel.array_ReceiptContent = [arrayReceiptContentModel]()
            if let arrayData = data["contents"] as? Array<Dictionary<String, AnyObject>>
            {
                if arrayData.count>0
                {
                    for i in (0...arrayData.count-1)
                    {
                        let receiptData = (arrayData as AnyObject).object(at: i)
                        let array_receiptModel = arrayReceiptContentModel()
                        
                        array_receiptModel.id = ((receiptData as AnyObject).value(forKey: "id")) as? String ?? ""
                        array_receiptModel.title = ((receiptData as AnyObject).value(forKey: "title")) as? String ?? ""
                        array_receiptModel.qty = ((receiptData as AnyObject).value(forKey: "qty")) as? Double ?? 0
                        array_receiptModel.price = ((receiptData as AnyObject).value(forKey: "price")) as? NSNumber ?? 0
                        array_receiptModel.code = ((receiptData as AnyObject).value(forKey: "code")) as? String ?? ""
                        array_receiptModel.note = ((receiptData as AnyObject).value(forKey: "man_desc")) as? String ?? ""
                        array_receiptModel.attributes = ((receiptData as AnyObject).value(forKey: "attributes")) as? String ?? ""
                        array_receiptModel.itemFields = ((receiptData as AnyObject).value(forKey: "itemFields")) as? String ?? ""
                        self.receiptModel.array_ReceiptContent.append(array_receiptModel)
                        
                    }
                }
            }
            
            self.receiptModel.array_ReceiptCardContent = [arrayReceiptCardContentModel]()
            if let arrayData = data["transactions"] as? Array<Dictionary<String, AnyObject>>
            {
                if arrayData.count>0
                {
                    for i in (0...arrayData.count-1)
                    {
                        let receiptCardData = (arrayData as AnyObject).object(at: i)
                        let array_receiptCardModel = arrayReceiptCardContentModel()
                        array_receiptCardModel.ai_Type = ((receiptCardData as AnyObject).value(forKey: "ai_type")) as? String ?? ""

                        array_receiptCardModel.card_type = ((receiptCardData as AnyObject).value(forKey: "card_type")) as? String ?? ""
                        array_receiptCardModel.amount = ((receiptCardData as AnyObject).value(forKey: "amount")) as? String ?? ""
                        array_receiptCardModel.card_no = ((receiptCardData as AnyObject).value(forKey: "card_number")) as? String ?? ""
                        array_receiptCardModel.txn_type = ((receiptCardData as AnyObject).value(forKey: "txn_type")) as? String ?? ""
                        // by sudama Start
                        array_receiptCardModel.txn_id = ((receiptCardData as AnyObject).value(forKey: "txn_id")) as? String ?? ""
                        array_receiptCardModel.total_amount = ((receiptCardData as AnyObject).value(forKey: "total_amount")) as? String ?? ""
                        array_receiptCardModel.approval_code = ((receiptCardData as AnyObject).value(forKey: "approval_code")) as? String ?? ""
                        array_receiptCardModel.entry_method = ((receiptCardData as AnyObject).value(forKey: "entry_method")) as? String ?? ""
                        array_receiptCardModel.payment_status = ((receiptCardData as AnyObject).value(forKey: "payment_status")) as? String ?? ""
                        array_receiptCardModel.transaction_type = ((receiptCardData as AnyObject).value(forKey: "transaction_type")) as? String ?? ""
                        array_receiptCardModel.signature_url = ((receiptCardData as AnyObject).value(forKey: "signature_url")) as? String ?? ""
                        array_receiptCardModel.isSignature = ((receiptCardData as AnyObject).value(forKey: "isSignature")) as? Bool ?? false
                        array_receiptCardModel.signature_image_base_64 = ((receiptCardData as AnyObject).value(forKey: "signature_image_base_64")) as? String ?? ""
                        array_receiptCardModel.tip = ((receiptCardData as AnyObject).value(forKey: "tip")) as? String ?? ""
                        // by sudama End
                        
                        self.receiptModel.array_ReceiptCardContent.append(array_receiptCardModel)
                    }
                }
            }
            
        }
    }
    
    func parseCoupanProductIDListData(responseDict: JSONDictionary) {
        coupanDetail = CoupanDetail()
        if let data = responseDict[APIKeys.kData] as? NSArray {
            if let dict = data.firstObject as? NSDictionary {
                let id = dict.value(forKey: "coupon_id") as? String ?? ""
                let code = dict.value(forKey: "coupon_code") as? String ?? ""
                let amount = (dict.value(forKey: "discount_amount") as? String ?? "").replacingOccurrences(of: ",", with: "")
                let type = dict.value(forKey: "discount_type") as? String ?? ""
                let freeShipping = dict.value(forKey: "free_shipping") as? String ?? ""
                let totalAmount = dict.value(forKey: "total_amount") as? String ?? ""
                
                var productList = [String]()
                if let array = dict.value(forKey: "productList") as? [String] {
                    for value in array {
                        productList.append(value)
                    }
                }
                self.coupanDetail = CoupanDetail(id: id, code: code, amount: amount,type: type, freeShipping: freeShipping, productList: productList, totalAmount: totalAmount)
            }
        }
    }
    
    func parseCountryListData(responseDict: JSONDictionary) {
        countryDetail.removeAll()
        
        if let data = responseDict[APIKeys.kData] as? NSArray {
            for tempDict in data {
                if let dict = tempDict as? NSDictionary {
                    let country = dict.value(forKey: "country") as? String ?? ""
                    let abbreviation = dict.value(forKey: "abbreviation") as? String ?? ""
                    self.countryDetail.append(CountryDetail(name: country, abbreviation: abbreviation))
                }
            }
        }
    }
    
    func parseStartDrawerData(responseDict: JSONDictionary)  {
        self.currentDrawerDetail = [DrawerHistoryModel]()
        
        if let drawerData = responseDict["data"] as? [String:AnyObject]
        {
            let currentDrawerObj = DrawerHistoryModel()
            currentDrawerObj.drawer_id = drawerData["cashdrawerID"] as? String ?? ""
            currentDrawerObj.starting_cash = drawerData["starting_cash"] as? String ?? ""
            currentDrawerObj.started = drawerData["started"] as? String ?? ""
            currentDrawerObj.cash_sales = drawerData["cash_sales"] as? String ?? ""
            currentDrawerObj.cash_refunds = drawerData["cash_refunds"] as? String ?? ""
            currentDrawerObj.actualin_drawer = drawerData["actualin_drawer"] as? String ?? ""
            currentDrawerObj.expected_in_drawer = drawerData["expected_in_drawer"] as?String ?? ""
            currentDrawerObj.drawer_difference = drawerData["drawer_difference"] as? String ?? ""
            currentDrawerObj.paid_in = drawerData["pay_in"] as? String ?? ""
            currentDrawerObj.paid_out = drawerData["pay_out"] as? String ?? ""
            currentDrawerObj.drawer_desc = drawerData["drawer_desc"] as? String ?? ""
            currentDrawerObj.source = drawerData["source"] as? String ?? ""
            currentDrawerObj.user_name = drawerData["user_name"] as? String ?? ""
            currentDrawerObj.username_login = drawerData["username_login"] as? String ?? ""
            self.currentDrawerDetail.append(currentDrawerObj)
        }
        
        //        if let data = responseDict[APIKeys.kData] as? NSArray {
        //            if let dict = data.firstObject as? NSDictionary {
        //                let currentDrawerObj = DrawerHistoryModel()
        //                currentDrawerObj.starting_cash = dict["starting_cash"] as? String ?? ""
        //                currentDrawerObj.drawer_id = dict["cashdrawerID"] as? String ?? ""
        //                currentDrawerObj.started = dict["started"] as? String ?? ""
        //                currentDrawerObj.cash_sales = dict["cash_sales"] as? String ?? ""
        //                currentDrawerObj.cash_refunds = dict["cash_refunds"] as? String ?? ""
        //                currentDrawerObj.actualin_drawer = dict["actualin_drawer"] as? String ?? ""
        //                currentDrawerObj.expected_in_drawer = dict["expected_in_drawer"] as? String ?? ""
        //                currentDrawerObj.drawer_difference = dict["drawer_difference"] as? String ?? ""
        //                currentDrawerObj.paid_in = dict["pay_in"] as? String ?? ""
        //                currentDrawerObj.paid_out = dict["pay_out"] as? String ?? ""
        //                self.currentDrawerDetail.append(currentDrawerObj)
        //            }
        //        }
    }
    
    func parsePayInData(responseDict: JSONDictionary) {
        
        if let drawerData = responseDict["data"] as? [String:AnyObject]
        {
            let currentDrawerObj = DrawerHistoryModel()
            currentDrawerObj.starting_cash = drawerData["starting_cash"] as? String ?? ""
            currentDrawerObj.drawer_id = drawerData["cashdrawerID"] as? String ?? ""
            currentDrawerObj.started = drawerData["started"] as? String ?? ""
            currentDrawerObj.cash_sales = drawerData["cash_sales"] as? String ?? ""
            currentDrawerObj.cash_refunds = drawerData["cash_refunds"] as? String ?? ""
            currentDrawerObj.actualin_drawer = drawerData["actualin_drawer"] as? String ?? ""
            currentDrawerObj.expected_in_drawer = drawerData["expected_in_drawer"] as? String ?? ""
            currentDrawerObj.drawer_difference = drawerData["drawer_difference"] as? String ?? ""
            currentDrawerObj.paid_in = drawerData["pay_in"] as? String ?? ""
            currentDrawerObj.paid_out = drawerData["pay_out"] as? String ?? ""
            currentDrawerObj.drawer_desc = drawerData["drawer_desc"] as? String ?? ""
            
            self.payInDataDetail.append(currentDrawerObj)
        }
        
        /*
         if let data = responseDict[APIKeys.kData] as? NSArray {
         if let dict = data.firstObject as? NSDictionary {
         let currentDrawerObj = DrawerHistoryModel()
         currentDrawerObj.starting_cash = dict["starting_cash"] as? String ?? ""
         currentDrawerObj.drawer_id = dict["cashdrawerID"] as? String ?? ""
         currentDrawerObj.started = dict["started"] as? String ?? ""
         currentDrawerObj.cash_sales = dict["cash_sales"] as? String ?? ""
         currentDrawerObj.cash_refunds = dict["cash_refunds"] as? String ?? ""
         currentDrawerObj.actualin_drawer = dict["actualin_drawer"] as? String ?? ""
         currentDrawerObj.expected_in_drawer = dict["expected_in_drawer"] as? String ?? ""
         currentDrawerObj.drawer_difference = dict["drawer_difference"] as? String ?? ""
         currentDrawerObj.paid_in = dict["pay_in"] as? String ?? ""
         currentDrawerObj.paid_out = dict["pay_out"] as? String ?? ""
         
         self.payInDataDetail.append(currentDrawerObj)
         }
         }
         */
    }
    
    func parsePayOutData(responseDict: JSONDictionary) {
        
        
        if let drawerData = responseDict["data"] as? [String:AnyObject]
        {
            let currentDrawerObj = DrawerHistoryModel()
            currentDrawerObj.starting_cash = drawerData["starting_cash"] as? String ?? ""
            currentDrawerObj.drawer_id = drawerData["cashdrawerID"] as? String ?? ""
            currentDrawerObj.started = drawerData["started"] as? String ?? ""
            currentDrawerObj.cash_sales = drawerData["cash_sales"] as? String ?? ""
            currentDrawerObj.cash_refunds = drawerData["cash_refunds"] as? String ?? ""
            currentDrawerObj.actualin_drawer = drawerData["actualin_drawer"] as? String ?? ""
            currentDrawerObj.expected_in_drawer = drawerData["expected_in_drawer"] as? String ?? ""
            currentDrawerObj.drawer_difference = drawerData["drawer_difference"] as? String ?? ""
            currentDrawerObj.paid_in = drawerData["pay_in"] as? String ?? ""
            currentDrawerObj.paid_out = drawerData["pay_out"] as? String ?? ""
            currentDrawerObj.drawer_desc = drawerData["drawer_desc"] as? String ?? ""
            
            self.payOutDataDetail.append(currentDrawerObj)
        }
        /*
         if let data = responseDict[APIKeys.kData] as? NSArray {
         if let dict = data.firstObject as? NSDictionary {
         let currentDrawerObj = DrawerHistoryModel()
         currentDrawerObj.starting_cash = dict["starting_cash"] as? String ?? ""
         currentDrawerObj.drawer_id = dict["cashdrawerID"] as? String ?? ""
         currentDrawerObj.started = dict["started"] as? String ?? ""
         currentDrawerObj.cash_sales = dict["cash_sales"] as? String ?? ""
         currentDrawerObj.cash_refunds = dict["cash_refunds"] as? String ?? ""
         currentDrawerObj.actualin_drawer = dict["actualin_drawer"] as? String ?? ""
         currentDrawerObj.expected_in_drawer = dict["expected_in_drawer"] as? String ?? ""
         currentDrawerObj.drawer_difference = dict["drawer_difference"] as? String ?? ""
         currentDrawerObj.paid_in = dict["pay_in"] as? String ?? ""
         currentDrawerObj.paid_out = dict["pay_out"] as? String ?? ""
         
         self.payOutDataDetail.append(currentDrawerObj)
         }
         }
         */
    }
    
    func parseCartCalculationData(responseDict: JSONDictionary) {
        cartCalculationDetail = CartCalculationDetail()
        
        if let dict = responseDict[APIKeys.kData] as? NSDictionary {
            let tax = dict.value(forKey: "tax") as? Double ?? 0
            let shipping = dict.value(forKey: "shipping") as? Double ?? 0
            let total = dict.value(forKey: "total") as? Double ?? 0
            let subTotal = dict.value(forKey: "subtotal") as? Double ?? 0
            let couponDiscount = dict.value(forKey: "coupon_discount") as? Double ?? 0
            let discount = dict.value(forKey: "discount") as? Double ?? 0
            let couponType = dict.value(forKey: "coupon_type") as? String ?? ""
            let couponName = dict.value(forKey: "coupon_code") as? String ?? ""
            let isValidCoupon = (dict.value(forKey: "is_valid_coupon") as? String ?? "false") != "false"
            var amoutAval = 0.0
            if total > 0 {
                amoutAval =  dict.value(forKey: "amount_available_for_refund") as? Double ?? 0
            } else {
                amoutAval =  -(dict.value(forKey: "amount_available_for_refund") as? Double ?? 0)
            }
            cartCalculationDetail = CartCalculationDetail(tax: tax, shipping: shipping, total: total, subTotal: subTotal, couponDiscount: couponDiscount, discount: discount, couponType: couponType, couponName: couponName,isValidCoupon: isValidCoupon, amount_available_for_refund: amoutAval)
        }
        
    }
    
}

//Save OffLine Data
extension HomeVM {
    func parseCategoryDataOffline(responseDict: JSONDictionary) {
        CDManager.shared.deleteAllData(with: .category)
        
        if let data = responseDict[APIKeys.kData] as? Array<Any> {
            self.isMoreCategoryFound = (data.count == 0) ? false : true
            for category in data {
                let categoryName = category as? String ?? kEmptyString
                let category = Category(context: context)
                category.name = categoryName
                appDelegate.saveContext()
            }
        }
    }
    
    func parseProductDataOffline(responseDict: JSONDictionary) {
        CDManager.shared.deleteAllData(with: .product)
        
        if let data = responseDict[APIKeys.kData] as? Array<Any> {
            if data.count > 0 {
                for i in (0...data.count-1) {
                    let productsData = (data as AnyObject).object(at: i)
                    let product = Product(context: context)
                    product.title = ((productsData as AnyObject).value(forKey: "title")) as? String ?? ""
                    product.category = ((productsData as AnyObject).value(forKey: "product_category")) as? String ?? ""
                    product.externalProductId = ((productsData as AnyObject).value(forKey: "external_prod_id")) as? String ?? ""
                    product.shippingPrice = (((productsData as AnyObject).value(forKey: "shipping_prices")) as? String ?? "0").replacingOccurrences(of: ",", with: "")
                    product.price = (((productsData as AnyObject).value(forKey: "price")) as? String ?? "").replacingOccurrences(of: ",", with: "")
                    product.stock = ((productsData as AnyObject).value(forKey: "stock")) as? String ?? ""
                    product.id = ((productsData as AnyObject).value(forKey: "product_id")) as? String ?? ""
                    product.productCode = ((productsData as AnyObject).value(forKey: "product_code")) as? String ?? ""
                    product.longDescp = ((productsData as AnyObject).value(forKey: "long_description")) as? String ?? ""
                    product.shortDescp = ((productsData as AnyObject).value(forKey: "short_description")) as? String ?? ""
                    let imgUrl = ((productsData as AnyObject).value(forKey: "product_image")) as? String ?? ""
                    if let url = URL(string: imgUrl) {
                        do {
                            print("Image downloading with URL   : \(url.absoluteString).")
                            let (imgData, _) = try URLSession.shared.synchronousDataTask(with: URLRequest(url: url))
                            product.image = imgData
                            print("Image downloaded of URL      : \(url.absoluteString).")
                        } catch {
                            print ("There was an error for downloading image of URL: \(url.absoluteString).")
                        }
                        
                    }
                    product.limitQty = ((productsData as AnyObject).value(forKey: "limit_qty")) as? String ?? ""
                    product.is_taxable = ((productsData as AnyObject).value(forKey: "is_taxable")) as? String ?? ""
                    product.unlimitedStock = ((productsData as AnyObject).value(forKey: "unlimited_stock")) as? String ?? ""
                    product.keywords = ((productsData as AnyObject).value(forKey: "keywords")) as? String ?? ""
                    product.fileId = ((productsData as AnyObject).value(forKey: "fileID")) as? String ?? ""
                    let data = (((data as AnyObject).value(forKey: "attributes")as AnyObject).object(at: i) as? Array<Any>)!
                    product.attributesArrayData = NSKeyedArchiver.archivedData(withRootObject: data)
                    appDelegate.saveContext()
                }
            }
            
        }
    }
    
    func parseCustomerDataOffline(responseDict: JSONDictionary) {
        CDManager.shared.deleteAllData(with: .customer)
        
        if let arrayData: Array = responseDict[APIKeys.kData] as? Array<AnyObject>
        {
            if arrayData.count>0
            {
                for i in (0...arrayData.count-1)
                {
                    let customersdata = (arrayData as AnyObject).object(at: i)
                    let customer = Customer(context: context)
                    
                    if let dict = (customersdata as AnyObject).value(forKey: "cc") as? NSDictionary  {
                        customer.cardMonth = dict.value(forKey: "card_exp_mo") as? String ?? ""
                        customer.cardYear = dict.value(forKey: "card_exp_yr") as? String ?? ""
                        customer.cardType = dict.value(forKey: "card_type") as? String ?? ""
                        customer.cardNumber = dict.value(forKey: "last4") as? String ?? ""
                    }
                    
                    customer.firstName = (customersdata as AnyObject).value(forKey: "first_name") as? String ?? ""
                    customer.lastName = (customersdata as AnyObject).value(forKey: "last_name") as? String ?? ""
                    customer.email = (customersdata as AnyObject).value(forKey: "email") as? String ?? ""
                    customer.phone = (customersdata as AnyObject).value(forKey: "phone") as? String ?? ""
                    customer.billingCompany = (customersdata as AnyObject).value(forKey: "company") as? String ?? ""
                    customer.address1 = (customersdata as AnyObject).value(forKey: "address") as? String ?? ""
                    customer.address2 = (customersdata as AnyObject).value(forKey: "address2") as? String ?? ""
                    customer.city = (customersdata as AnyObject).value(forKey: "city") as? String ?? ""
                    customer.region = (customersdata as AnyObject).value(forKey: "region") as? String ?? ""
                    customer.postalCode = (customersdata as AnyObject).value(forKey: "postal_code") as? String ?? ""
                    customer.bpId = (customersdata as AnyObject).value(forKey: "bpid") as? String ?? ""
                    customer.userId = (customersdata as AnyObject).value(forKey: "userID") as? String ?? ""
                    customer.orderId = (customersdata as AnyObject).value(forKey: "order_id") as? String ?? ""
                    customer.displayName = (customersdata as AnyObject).value(forKey: "display_name") as? String ?? ""
                    customer.userCoupan = (customersdata as AnyObject)["user_coupon"] as? String ?? ""
                    customer.userCustomTax = (customersdata as AnyObject)["user_custom_tax"] as? String ?? ""
                    
                    if let dict = ((customersdata as AnyObject).value(forKey: "billing_addr")) as? NSDictionary {
                        customer.billingAddress1 = dict.value(forKey: "address_line_1") as? String ?? ""
                        customer.billingAddress2 = dict.value(forKey: "address_line_2") as? String ?? ""
                        customer.billingCity = dict.value(forKey: "city") as? String ?? ""
                        customer.billingRegion = dict.value(forKey: "region") as? String ?? ""
                        customer.billingPostalCode = dict.value(forKey: "postal_code") as? String ?? ""
                        customer.billingPhone = dict.value(forKey: "phone") as? String ?? ""
                        customer.billingEmail = dict.value(forKey: "email") as? String ?? ""
                        customer.billingFirstName = dict.value(forKey: "first_name") as? String ?? ""
                        customer.billingLastName = dict.value(forKey: "last_name") as? String ?? ""
                    }
                    
                    if let dict = ((customersdata as AnyObject).value(forKey: "shipping_addr")) as? NSDictionary {
                        customer.shippingAddress1 = dict.value(forKey: "address_line_1") as? String ?? ""
                        customer.shippingAddress2 = dict.value(forKey: "address_line_2") as? String ?? ""
                        customer.shippingCity = dict.value(forKey: "city") as? String ?? ""
                        customer.shippingRegion = dict.value(forKey: "region") as? String ?? ""
                        customer.shippingPostalCode = dict.value(forKey: "postal_code") as? String ?? ""
                        customer.shippingPhone = dict.value(forKey: "phone") as? String ?? ""
                        customer.shippingEmail = dict.value(forKey: "email") as? String ?? ""
                        customer.shippingFirstName = dict.value(forKey: "first_name") as? String ?? ""
                        customer.shippingLastName = dict.value(forKey: "last_name") as? String ?? ""
                        
                    }
                    appDelegate.saveContext()
                }
            }
        }
    }
    
    func parseTaxDataOffline(responseDict: JSONDictionary) {
        CDManager.shared.deleteAllData(with: .tax)
        
        if let data = responseDict[APIKeys.kData] as? [String: AnyObject] {
            if let arrayTaxData = data["tax_rows"] as? Array<Dictionary<String,AnyObject>>
            {
                if arrayTaxData.count > 0
                {
                    for i in (0...arrayTaxData.count-1)
                    {
                        let taxData = (arrayTaxData as AnyObject).object(at: i)
                        let tax = Tax(context: context)
                        tax.title = (taxData as AnyObject).value(forKey: "title") as? String ?? ""
                        tax.type = (taxData as AnyObject).value(forKey: "type") as? String ?? ""
                        tax.amount = ((taxData as AnyObject).value(forKey: "amount") as? String ?? "").replacingOccurrences(of: ",", with: "")
                        tax.settings = NSKeyedArchiver.archivedData(withRootObject: data)
                        appDelegate.saveContext()
                    }
                }
            }
        }
    }
    
    func parseRegionDataOffline(responseDict: JSONDictionary) {
        CDManager.shared.deleteAllData(with: .region)
        
        if let arrayData: Array = responseDict[APIKeys.kData] as? Array<AnyObject>
        {
            if arrayData.count>0 {
                for i in (0...arrayData.count-1) {
                    let regionsData = (arrayData as AnyObject).object(at: i)
                    let region = Region(context: context)
                    region.abbreviation = (regionsData as AnyObject).value(forKey: "regionAbv") as? String ?? ""
                    region.name = (regionsData as AnyObject).value(forKey: "regionName") as? String ?? ""
                    appDelegate.saveContext()
                }
            }
        }
    }
    
    func parseSourcesListData(responseDict: JSONDictionary) {
        
        if let data = responseDict[APIKeys.kData] as? [String] {
            sourcesList = data
            
        }
    }
    
    func parsePrinterListData(responseDict: JSONDictionary) {
        
        if let data = responseDict[APIKeys.kData] as? [String:AnyObject] {
            self.starCloudPrinterModel.is_multiple_printer = (data as AnyObject).value(forKey: "status") as? Bool ?? false

            self.starCloudPrinterModel.arrprinter_list_value.removeAll()
            if let arrayData = data["printer_list_value"] as? Array<Dictionary<String, AnyObject>>
            {
                if arrayData.count>0
                {
                    for i in (0...arrayData.count-1)
                    {
                        let receiptData = (arrayData as AnyObject).object(at: i)
                        let array_receiptModel = PrinterListValueDataModel()
                        
                        array_receiptModel.printerMAC = ((receiptData as AnyObject).value(forKey: "printerMAC")) as? String ?? ""
                        array_receiptModel.name = ((receiptData as AnyObject).value(forKey: "name")) as? String ?? ""
                        self.starCloudPrinterModel.arrprinter_list_value.append(array_receiptModel)
                        
                    }
                }
            }
            
        }
    }
    func parseUpdateDeliveryStatusListData(responseDict: JSONDictionary) {
        
        if let data = responseDict[APIKeys.kData] as? JSONDictionary {
            self.orderDeliveryStatusArry.removeAll()
            if let customOrderStatusObj = data["orderStatus"] as? JSONArray {
                for obj in customOrderStatusObj {
                    if let id = obj["status_id"] as? String ,let name = obj["name"] as? String, let color = obj["color"] as? String , let isDisabled = obj["isDisabled"] as? Bool, let isSelected = obj["isSelected"] as? Bool{
                        let model = OrderDeliveryStatus.init(status_id: id, name: name,color: color,isDisabled: isDisabled,isSelected: isSelected)
                        self.orderDeliveryStatusArry.append(model)
                    }
                }
            }
        }
    }
    func parseSerialNumberListData(responseDict: JSONDictionary) {
        if let data = responseDict[APIKeys.kData] as? JSONArray {
            self.SerialNumberDataListAry.removeAll()
            if data.count>0 {
                for i in (0...data.count-1) {
                    let serialData = (data as AnyObject).object(at: i)
                    let array_serialDataModel = SerialNumberDataModel()
                    
                    array_serialDataModel.location_name = ((serialData as AnyObject).value(forKey: "location_name")) as? String ?? ""
                    array_serialDataModel.serial_number = ((serialData as AnyObject).value(forKey: "serial_number")) as? String ?? ""
                    self.SerialNumberDataListAry.append(array_serialDataModel)
                }
            }
        }
    }
    // 08 nov 220 for invoice template by altab
    func parseInvoiceTemplateListData(responseDict: JSONDictionary) {
        objInvoiceTemplateModel = InvoiceTemplateDataModel()
        if let data = responseDict["defaultData"] as? JSONDictionary {
            objInvoiceTemplateModel.defaultID = ((data as AnyObject).value(forKey: "defaultID")) as? String ?? ""
            objInvoiceTemplateModel.defaultOnly = ((data as AnyObject).value(forKey: "defaultOnly")) as? Bool ?? false
            if let templatesSettingsObj = data["templatesSettings"] as? JSONArray {
                for objTemplate in templatesSettingsObj {
                    let model = InvoiceTemplatesSettingsDataModel()
                    model.id = ((objTemplate as AnyObject).value(forKey: "id")) as? String ?? ""
                    model.is_default = ((objTemplate as AnyObject).value(forKey: "is_default")) as? String ?? ""
                    model.template_name = ((objTemplate as AnyObject).value(forKey: "template_name")) as? String ?? ""
                    let setting = TemplatesSettingsDataModel()
                    if let settingsObj = objTemplate["settings"] as? JSONArray {
                        for obj in settingsObj {
                            if let value =  ((obj as AnyObject).value(forKey: "show_invoice_title_setting")) as? String {
                                setting.show_invoice_title_setting = value
                            }else if let value =  ((obj as AnyObject).value(forKey: "show_representative_setting")) as? String {
                                setting.show_representative_setting = value
                            }else if let value =  ((obj as AnyObject).value(forKey: "show_frequency_setting")) as? String {
                                setting.show_frequency_setting = value
                            }else if let value =  ((obj as AnyObject).value(forKey: "show_po_number_setting")) as? String {
                                setting.show_po_number_setting = value
                            }else if let value =  ((obj as AnyObject).value(forKey: "show_payment_terms_setting")) as? String {
                                setting.show_payment_terms_setting = value
                            }else if let value =  ((obj as AnyObject).value(forKey: "show_invoice_date_setting")) as? String {
                                setting.show_invoice_date_setting = value
                            }else if let value =  ((obj as AnyObject).value(forKey: "show_shipping_address_setting")) as? String {
                                setting.show_shipping_address_setting = value
                            }else if let value =  ((obj as AnyObject).value(forKey: "show_country_setting")) as? String {
                                setting.show_country_setting = value
                            }else if let value =  ((obj as AnyObject).value(forKey: "show_bcc_email_setting")) as? String {
                                setting.show_bcc_email_setting = value
                            }else if let value =  ((obj as AnyObject).value(forKey: "show_invoice_status_setting")) as? String {
                                setting.show_invoice_status_setting = value
                            }else if let value =  ((obj as AnyObject).value(forKey: "show_invoice_status_setting")) as? String {
                                setting.show_invoice_status_setting = value
                            }else if  let value =  ((obj as AnyObject).value(forKey: "payment_terms_values")) as? String  {
                                let array = value.toJSON() as? JSONArray
                                print(data)
                                if data.count > 0 {
                                    for dic in array! {
                                        let dict = dic as? JSONDictionary
                                        let textob = dict?["text"] as? String ?? ""
                                        let textid = dict?["id"] as? String ?? ""
                                        let obj = ProductSettingTerms(text: textob, id: textid)
                                        setting.payment_terms_values.append(obj)
                                    }
                                }
                            }
                        }
                        model.settings = setting
                    }
                    objInvoiceTemplateModel.aryTemplatesSettings.append(model)
                }
            }
        }
    }
    func parseProductInfoData(responseDict: JSONDictionary) { // Product details Api By Altab (23Dec2022)
        
        if let productsData:NSDictionary = responseDict[APIKeys.kData] as? NSDictionary {
            let ProductsModelObj = ProductsModel()
            ProductsModelObj.str_title = ((productsData as AnyObject).value(forKey: "title")) as? String ?? ""
            ProductsModelObj.str_external_prod_id = ((productsData as AnyObject).value(forKey: "external_prod_id")) as? String ?? ""
            ProductsModelObj.shippingPrice = (((productsData as AnyObject).value(forKey: "shipping_prices")) as? String ?? "0").replacingOccurrences(of: ",", with: "")
            ProductsModelObj.str_price = (((productsData as AnyObject).value(forKey: "price")) as? String ?? "").replacingOccurrences(of: ",", with: "")
            ProductsModelObj.mainPrice = (((productsData as AnyObject).value(forKey: "price")) as? String ?? "").replacingOccurrences(of: ",", with: "")
            ProductsModelObj.str_stock = ((productsData as AnyObject).value(forKey: "stock")) as? String ?? ""
            ProductsModelObj.str_product_id = ((productsData as AnyObject).value(forKey: "product_id")) as? String ?? ""
            ProductsModelObj.str_product_code = ((productsData as AnyObject).value(forKey: "product_code")) as? String ?? ""
            ProductsModelObj.str_price_wholesale = ((productsData as AnyObject).value(forKey: "price_wholesale")) as? String ?? ""
            //by anand
            ProductsModelObj.str_fulfillment_action = ((productsData as AnyObject).value(forKey: "fulfillment_action")) as? String ?? ""
            ProductsModelObj.str_supplier = ((productsData as AnyObject).value(forKey: "supplier")) as? String ?? ""
            ProductsModelObj.str_brand = ((productsData as AnyObject).value(forKey: "brand")) as? String ?? ""
            ProductsModelObj.str_website_Link = ((productsData as AnyObject).value(forKey: "website_link")) as? String ?? ""
            ProductsModelObj.on_order = ((productsData as AnyObject).value(forKey: "on_order")) as? String ?? ""
            //end anand

            ProductsModelObj.str_long_description = ((productsData as AnyObject).value(forKey: "long_description")) as? String ?? ""
            ProductsModelObj.str_short_description = ((productsData as AnyObject).value(forKey: "short_description_html_entity")) as? String ?? ""
            ProductsModelObj.str_product_image = ((productsData as AnyObject).value(forKey: "product_image")) as? String ?? ""
            ProductsModelObj.str_limit_qty = ((productsData as AnyObject).value(forKey: "limit_qty")) as? String ?? ""
            ProductsModelObj.is_taxable = ((productsData as AnyObject).value(forKey: "is_taxable")) as? String ?? ""
            ProductsModelObj.unlimited_stock = ((productsData as AnyObject).value(forKey: "unlimited_stock")) as? String ?? ""
            ProductsModelObj.str_keywords = ((productsData as AnyObject).value(forKey: "keywords")) as? String ?? ""
            ProductsModelObj.str_fileID = ((productsData as AnyObject).value(forKey: "fileID")) as? String ?? ""
            ProductsModelObj.isAllowDecimal = ((productsData as AnyObject).value(forKey: "qty_allow_decimal") as? String ?? "0") == "1"
            ProductsModelObj.isEditPrice = ((productsData as AnyObject).value(forKey: "prompt_for_price") as? String ?? "0") == "1"
            ProductsModelObj.isShowEditModel = (productsData as AnyObject).value(forKey: "showEditModel") as? Bool ?? false
            ProductsModelObj.isEditQty = ((productsData as AnyObject).value(forKey: "prompt_for_quantity") as? String ?? "0") == "1"
            ProductsModelObj.variations = (productsData as AnyObject).value(forKey: "variation_display") as? JSONDictionary ?? JSONDictionary()
            ProductsModelObj.taxDetails = (productsData as AnyObject).value(forKey: "tax_detail") as? JSONDictionary ?? JSONDictionary()
            ProductsModelObj.surchargeVariations = (productsData as AnyObject).value(forKey: "surcharge_variations_display") as? JSONDictionary ?? JSONDictionary()
            ProductsModelObj.attributesData = (productsData as AnyObject).value(forKey: "attributes") as? JSONArray ?? JSONArray()      //DD
            ProductsModelObj.variationsData = (productsData as AnyObject).value(forKey: "variations") as? JSONArray ?? JSONArray()      //DD
            ProductsModelObj.itemMetaData = (productsData as AnyObject).value(forKey: "item_meta_fields") as? JSONArray ?? JSONArray() // SD
            ProductsModelObj.surchagevariationsData = (productsData as AnyObject).value(forKey: "surcharge_variations") as? JSONArray ?? JSONArray()    //DD
            ProductsModelObj.width = ((productsData as AnyObject).value(forKey: "width")) as? Double ?? 0.0
            ProductsModelObj.height = ((productsData as AnyObject).value(forKey: "height")) as? Double ?? 0.0
            ProductsModelObj.length = ((productsData as AnyObject).value(forKey: "length")) as? Double ?? 0.0
            ProductsModelObj.weight = ((productsData as AnyObject).value(forKey: "weight")) as? Double ?? 0.0
            ProductsModelObj.EditPrice = ""
            ProductsModelObj.isOutOfStock = ((productsData as AnyObject).value(forKey: "is_out_of_stock")) as? Int ?? 0
            ProductsModelObj.allow_credit_product = ((productsData as AnyObject).value(forKey: "allow_credit_product")) as? Bool ?? false
            ProductsModelObj.allow_purchase_product = ((productsData as AnyObject).value(forKey: "allow_purchase_product")) as? Bool ?? false
            ProductsModelObj.automatic_upsell = (productsData as AnyObject).value(forKey: "automatic_upsell") as? [String] ?? [String]()      //DD
            if DataManager.automatic_upsellData.count == 0 {
                DataManager.automatic_upsellData = ProductsModelObj.automatic_upsell
            }

            //v_product_stock
            ProductsModelObj.v_product_stock = (productsData as AnyObject).value(forKey: "v_product_stock") as? String ?? "0"      //DD
           // for custom_fields
            ProductsModelObj.customFieldsArr.removeAll()
            if let termsObj = (productsData as AnyObject).value(forKey: "custom_fields") as? NSArray{
                for temp in termsObj {
                    if let dict = temp as? NSDictionary{
                        var customFields = CustomFieldsModel()
                        customFields.label = dict.value(forKey: "label") as? String ?? ""
                        customFields.value = dict.value(forKey: "value") as? String ?? ""
                        ProductsModelObj.customFieldsArr.append(customFields)
                    }
                }
            }
            
            ProductsModelObj.v_product_attributes_name = ((productsData as AnyObject).value(forKey: "v_product_attributes_name")) as? String ?? ""
            ProductsModelObj.v_product_attributes_values = (productsData as AnyObject).value(forKey: "v_product_attributes_values") as? [String] ?? [String]()
            ProductsModelObj.Wholesale_use_parent_price = (productsData as AnyObject).value(forKey: "use_parent_price") as? Bool ?? false
            ProductsModelObj.is_additional_product = (productsData as AnyObject).value(forKey: "is_additional_product") as? Bool ?? false

            ProductsModelObj.item_notes_title = ((productsData as AnyObject).value(forKey: "item_notes_title")) as? String ?? ""
            self.objProductsInfo = ProductsModelObj
        }
        
    }
}
