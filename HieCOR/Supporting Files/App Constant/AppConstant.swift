//
//  AppConstant.swift
//  HieCOR
//
//  Created by Deftsoft on 17/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation
import UIKit

//AppDelegate
let appDelegate = UIApplication.shared.delegate as! AppDelegate
//Context
let context = appDelegate.persistentContainer.viewContext
//Offline Payment Array
let offlinePaymentArray = ["CASH", "EXTERNAL_GIFT", "CHECK", "EXTERNAL"]
//let refundPaymentMethods = ["CREDIT", "CASH", "CHECK", "EXTERNAL", "PAX PAY"]
var refundPaymentMethods = ["CREDIT", "ACH CHECK", "CASH", "CHECK", "EXTERNAL", "EXTERNAL GIFT CARD", "GIFT CARD", "INTERNAL GIFT CARD", "PAX PAY", "CARD READER"]


//URL
var BaseURL = "" //"https://del.corcrm.biz"
let kLogin = "/rest/v1/auth/login/"
let kAccessPIN = "/rest/v1/auth/pin/"
let kGetCategories = "/rest/v1/product/category/?user_id="
let kNonAdminValidatePIN = "/rest/v1/auth/validate-pin/"
let kZreportCheckData = "/rest/v1/order/check-source-exists/"
let kGetAllCategories = "/rest/v1/product/category/"
let kGetProducts = "/rest/v1/product/list/?category="
let kGetAllProducts = "/rest/v1/product/list/"
let kGetTotalProducts = "/rest/v1/product/list/"
let kUpdateProduct = "/rest/v1/product/"
let kCreateCustomer = "/rest/v1/user/"
let kGetCustomerList = "/rest/v1/user/"
let kGetUserDetails = "/rest/v1/user/"
let kGetCouponsList = "/rest/v1/coupon/"
let kGetIngenicoData = "/rest/v1/merchant_settings/?module_name=ingenico"
let kGetTaxList = "/rest/v1/tax/"
let kGetRegionsList = "/rest/v1/region/"
let kCreateInvoice = "/rest/v1/invoice/"
let kGetPing = "/rest/v1/auth/ping/"
let kGetSingleProductDataUsingProductCode = "/rest/v1/product/list/?key="
let kCreateOrder = "/rest/v1/order/"
let kOrdersList = "/rest/v1/order/?"
let kGetOrderInfo = "/rest/v1/order/"
let kGetTransations = "/rest/v1/transaction/"
let kGetReturnConditions = "/rest/v1/order/return/conditions/"
let kReturnProducts = "/rest/v1/order/return/"
let kSendEmail = "/rest/v1/order/email/"
let kSendText = "/rest/v1/order/text/"
let kOrderAddNote = "/rest/v1/order/notes/"
let kPaxSettings = "/rest/v1/pax_settings/"
let kGetRepresentativesList = "/rest/v1/user/representative/list/"
let kRefund = "/rest/v1/order/refund/"
let kReceiptContent = "/rest/v1/order/reciept/"
let kTransactionPrintReceiptContent = "/rest/v1/order/transaction-reciept/"
let kReceiptEndDrawerURL = "/rest/v1/drawer/getdrawerreceipturl/"
let kReceiptEndDrawerDetails = "/rest/v1/drawer/getreceiptdetails/"
let kCountryList = "/rest/v1/countries/"
let kMultiOrder = "/rest/v1/order/multi-order/"
let kCart = "/rest/v1/cart/"
let kDrawerHistory = "/rest/v1/drawer/drawer-history/"
let kStartDrawer =  "/rest/v1/drawer/"
let kEndDrawer =  "/rest/v1/drawer/"
let kCheckDrawerEnd = "/rest/v1/drawer/"
let kGiftCardBalance = "/rest/v1/giftcard/balance/"
let kGiftCardActivate = "/rest/v1/giftcard/activate/"
let kGiftCardDeactivate = "/rest/v1/giftcard/deactivate/"
let kGiftCardReplace = "/rest/v1/giftcard/replace/"
let kGiftCardReverse = "/rest/v1/giftcard/reverse/"
let kGiftGetBalance = "/rest/v1/giftcard/"
let kSettingsList = "/rest/v1/settings/"
let KUserCardId = "/rest/v1/user/cards/"
let KUserEmvCardId = "/rest/v1/user/emvcards/"
let KUserIngenicoCard = "/rest/v1/user/ingenicocards/"
let KUserCardDeleteId = "/rest/v1/user/cards/"
let KUserCardUpdate = "/rest/v1/user/creditcard/"
let kShippingCarrier = "/rest/v1/shipping/carrier/"
let kShippingService = "/rest/v1/shipping/"
let kMailingList = "/rest/v1/user/contact/list/"
let KUserPutDetail = "/rest/v1/user/"
let KUserShippingAddress = "/rest/v1/user/shippingaddress/"
let KUpdateShippingAddress = "/rest/v1/user/shippingaddress/"
let KVoidTransaction = "/rest/v1/transaction/void/"
let KSaveSignatureOrder = "/rest/v1/order/save-signatures/"
let kroomApi = "/api/room/" // for socket sudama
let kselectedCarrierName = "selectedCarrierName"
let kisPosSingleResultAutoAddToCart = "isPosSingleResultAutoAddToCart"
let KContactSourcesList = "/rest/v1/contact-sources/"//by anand
let kSendTip = "/rest/v1/transaction/add-tip/"
let kSourcesList = "/rest/v1/sources/"
let kGetPrinterList = "/rest/v1/get_printer_list/"
let kUpdatePrinterName = "/rest/v1/update_printer_name/"
let kLoadGiftCardOnlyOnPurchase = "load_gift_card_only_on_purchase"
let kCustomerStatus = "CustomerStatus"
let kPosProductViewInfo = "PosProductViewInfo"
let kcustomerStatusDefaultName = "customerStatusDefaultName"
let kshowCustomerStatusAllInOne = "showCustomerStatusAllInOne"
let kposDefaultPaymentMethod = "posDefaultPaymentMethod"
let kposDropDownDefaultRegion = "pos_dropdown_default_region"
let kposChangeDefaultStoreName = "pos_change_default_store_name"
let kshowFullRecieptOptionForPrint = "showFullRecieptOptionForPrint"
let kshowMultipleShippingPopup = "showMultipleShippingPopup"
//Alert
let kAlert = "Alert"
let kError = "Error"
let kOkay = "OK"
let kCancel = "Cancel"
let kSuccess = "success"
let kEmptyString = ""
let kDeaultString = "https://devb.hiecor.biz:3000"
let kUnableRequestMsg  = "Unable to proceed your request."
let kSerialNumber = "/rest/v1/product/get-serial-numbers/"
let kInvoiceTemplates = "/rest/v1/invoice/templates/"
//DataManager
let kIsDeviceUnlocked = "isDeviceUnlocked"
let kshowContactSourceBoxAllInOne = "showContactSourceBoxAllInOne"
let kshowOfficePhoneAllInOne = "showOfficePhoneAllInOne"
let kPinloginEveryTransaction = "pinlogineverytransaction"
let kUserTypeFleg = "userTypeFleg"
let kBaseURL = "BaseUrl"
let kIsUserLogin = "isUserLogin"
let kIsDefaultTaxSelected = "isDefaultTaxSelected"
let kIsFirstTimeUserLogin = "isLoginFirstTime"
let kLoginBaseUrl = "LoginBaseUrl"
let kUrlTextFeildValue = "UrlTextFeildValue"
let kLoginUsername = "LoginUsername"
let kerrorOccure = "errorOccure"
let kLoginPassword = "LoginPassword"
let kUserName = "user_name"
let kAuthKey = "auth_key"
let kUserID = "userID"
let kallowUserPriceChange = "allowUserPriceChange"
let kallowIngenicoPaymentMethod = "allowIngenicoPaymentMethod"
let kShowPaxHeartlandGiftcardsMethod = "ShowPaxHeartlandGiftcardsMethod"
let kShowHeartlandGiftcardsMethod = "ShowHeartlandGiftcardsMethod"
let kCartProductsArray = "cartProductsArray"
let kOrderDataModel = "OrderDataModelValue"
let kcartShippingProductsArray = "cartShippingProductsArray"
let kIsOffline = "offline"
let kTaxes = "taxes"
let kProductsSYNC = "productsSYNC"
let kCustomerManagement = "customermanagement"
let kPromptAddCustomer = "promptaddcustomer" // for Prompt Add Customer
let kingenicpaymentmethodcancelandmessage = "ingenicopaymentmethodcancelandmessage"
let krefundExchangeCheckForCustomerApp = "refundExchangeCheckForCustomerApp"
let kPrinters = "printers"
let kDeviceName = "devicename"
let kDeviceNameText  = "DeviceNameText"
let kSignature = "signature"
let kTempSignature = "tempSignature"
let kCustomerObj = "CustomerObj"
let kCartData = "cartdata"
let kdueBalnaceData = "dueBalnaceData"
let kReceipt = "receipt"
let kPrinterConnected = "printerconnected"
let kSelectedCustomer = "SelectedCustomer"
let kIsCheckUncheckShippingBilling = "isCheckUncheckShippingBilling"
let kRecentCategorySearchArray = "RecentCategorySearchArray"
let kRecentProductSearchArray = "RecentProductSearchArray"
let kCardReaders = "CardReaders"
let kIsSwipeToPay = "isSwipeToPay"
let kIsBarCodeReaderOn = "isBarCodeReaderOn"
let kCollectTips = "CollectTips"
let kTempCollectTips = "TempCollectTips"
let kPaperSize = "paperSize"
let kDefaultTaxID = "defaultTaxID"
let kRecentOrderID = "recentOrderID"
let kRemaingAmt = "RemaingAmt"
let kTenDiscountValue = "tenDiscountValue"
let kTwentyDiscountValue = "twentyDiscountValue"
let kSeventyDiscountValue = "seventyDiscountValue"
let kRecentOrder = "recentOrder"
let kArraySelectedPaymet = "arraySelectedPaymet"
let kselectedPaxRefund = "selectedPaxRefund"
let kselectedCarrier = "selectedCarrier"
let kselectedService = "selectedService"
let kselectedServiceName = "selectedServiceName"
let kselectedServiceId = "selectedServiceId"
let kselectedShippingRate = "selectedShippingRate"
let kautomaticupsell = "automaticupsell"
let kshippingWeight = "shippingWeight"
let kshippingHeight = "shippingHeight"
let kshippingWidth = "shippingWidth"
let kshippingLength = "shippingLength"

let kArraySelectedPAX = "arraySelectedPAX"
let kSelectedCountry = "selectedCountry"
let kLogoImageUrl = "logoImageUrl"
let knoInventoryPurchase = "noInventoryPurchase"
let kshowImagesFunctionality = "showImagesFunctionality"
let kshowPriceFunctionality = "showPriceFunctionality"
let kshowProductCodeFunctionality = "showProductCodeFunctionality"
let kposAutoPrintCreditCardFunctionality = "posAutoPrintCreditCardFunctionality"
let kposDisableDiscountFeature = "posDisableDiscountFeature"
let kRUADeviceTypeValue = "RUADeviceTypeValue"
let kRUADeviceConnectValueDataSet = "RUADeviceConnectValueDataSet"
let kTaxListData = "kTaxListData"
let kshowShipOrderInPos = "showShipOrderInPos"
let kcustomFieldShow = "customFieldShow"
let kisBalanceDueData = "isBalanceDueData"
let kisSplitPayment = "isSplitPayment"
let kshowShippingCalculatiosInPos = "showShippingCalculatiosInPos"
let kcustomText1Type = "customText1Type"
let kcustomText2Type = "customText2Type"
let kcustomText1Label = "customText1Label"
let kcustomText2Label = "customText2Label"
let kSelectedCategory = "selectedCategory"
let kIsLineItemtaxExempt = "isLineItemtaxExempt"
let kIsEditOrder = "isEditOrder"
let kIsDiscountOptions = "isDiscountOptions"
let kIsSplitRow = "isSplitRow"
let kIsShowCountry = "isShowCountry"
let kIsDefaultCategory = "isDefaultCategory"
let kIsCouponList = "isCouponList"
let kIsAuthentication = "isAuthentication"
let KIsEditProduct = "isEditProduct"
let KIsAppVersion = "version"
let KFirstNameCardHolder = "FirstNameCardHolder"
let KLastNameCardHolder = "LastNameCardHolder"
let kSignatureOnReceipt = "SignatureOnReceipt"
let kInternalGiftCard = "InternalGiftValue"
let kGiftCard = "GiftCardValue"
let kPaxPayGiftCard = "GiftCardPaxPayValue"
let kSingatureOnEMV = "SingatureOnEMV"
let kPaxTokenEnable = "PaxTokenEnable"
let kGooglePrinter = "GooglePrinter"
let kBluetoothPrinter = "BluetoothPrinter"
let kCustomeId = "CustomeId"
let kCardReader = "CardReader"
let kisIngenicoConnected = "isIngenicoConnected"
let KcustomerForShippingAddressId = "customerForShippingAddressId"
let kshippingValue = "shippingValue"
let kSettingCRM = "SettingCRM"
let kbpId = "bpId"
let kErrorbpId = "ErrorbpId"
let kCardCount = "CardCount"
let kEmvCardCount = "EmvCardCount"
let kIngenicoCardCount = "IngenicoCardCount"
let kBaseUrlData = "BaseUrlData"
let kselectedFullfillmentId = "selectedFullfillmentId"
let KshipOrderButton = "shipOrderBtn"
let KuserPaxToken = "userPaxToken"
let Kshippingaddress = "shippingaddress"
let KCaptureButton = "isCaptureButton"
let kIsShippOpen = "isShippOpen"
let kIsshippingRefundOnly = "isshippingRefundOnly"
let kIsTipRefundOnly = "isTipRefundOnly"
let kIsSideMenuSwiperCard = "isSideMenuSwiperCard"
let kIsExternalKeyBoardAttach = "IsExternalKeyBoardAttach"
let kselectedPaxDeviceName = "selectedPaxDeviceName"
let KPaymentBtnAddCustomer = "isPaymentBtnAddCustomer"
let kShippingValueForAddress = "shippingValueForAddress"
let kisDrawerOpen = "isDrawerOpen"
let kLast4DigitCard = "last4DigitCard"
let kSavedPaymentArray = "SavedPaymentArray"
let kappUserId = "appUserId"
let kappUserName = "appUserName"
let kmanual_product_tax_data = "manual_product_tax_data"
let kpostaxonshippinghandlingfunctionality = "pos_tax_on_shipping_handling_functionality"
let kposiOSVersion = "posiOSVersion"
let kposAppVersion = "posAppVersion"
let kposBuildNumber = "posBuildNumber"
let kisCheckForAppUpdate = "isCheckForAppUpdate"
let kisShowUpdateNow = "isShowUpdateNow"
let kIngenicoOflineCaseData = "ingenicoOflineCaseData" // DD 08 Nov 2022 for ingnico
let kisZreportLowerCase = "isZreportLowerCase"
let kisTaxTenDecimal = "isTaxTenDecimal"
let kisOpenPayNowInApp = "isOpenPayNowInApp"
// by sudama offline
let kofflineccProcess = "offlineccProcess"
let kshowQueuedOfflineOrders = "showQueuedOfflineOrders"
let kshowSubscription = "showSubscription"
let kIsTotalTipCount = "isTotalTipCount"
let kisPartialAprrov = "isPartialAprrov"
let kofflineOrderData = "offlineOrderData"
let kofflineOrderdataAPIData = "offlineOrderdataAPIData"
let kpaxTokenizationEnable = "paxTokenizationEnable"
let kallowZeroDollarTxn = "allowZeroDollarTxn"
let kofflineTaxData = "offlineTaxData" // by sudama add sub
let kStarPrinterConnected = "isStarPrinterConnected"
let kIsUPSellProduct = "isUPSellProduct"
let kIsEditProductForUpsell = "isEditProductForUpsell"
// Start ..... by priya loyalty change
let kloyaltyMaxSaveOrder = "loyaltyMaxSaveOrder"
let kloyaltyPercentSaving = "loyaltyPercentSaving"
let kfinalLoyaltyDiscount = "finalLoyaltyDiscount"
// end .....priya
let kproductSettingTerms = "ProductSettingTerms"
let kInvoiceTerms = "InvoiceTerms"
let kInvoicePoNumber = "InvoicePoNumber"
let kInvoiceRep = "InvoiceRep"
let kInvoiceDate = "InvoiceDate"
let kInvoiceTitle = "InvoiceTitle"
let kInvoiceCountry = "InvoiceCountry"
let karrTempListing = "arrTempListing"
let kStarCloudMACaAddress = "starCloudMACaAddress"
let kstrIngenicoDeviceName = "strIngenicoDeviceName"
let kupdateDeliveryStatus = "/rest/v1/order/update-delivery-status/"
let kSaveCustomerPickup = "/rest/v1/order/save-customer-pickup/"
// socket sudama
let kRoomID = "RoomID"
let kSessionID = "SessionID"
let ksocketAppUrl = "socketAppUrl"
let kdeviceNameCustomerFacing = "deviceNameCustomerFacing"
let ksubTotalForSocket = "subTotalForSocket"
let kshowCustomerFacing = "showCustomerFacing"
let kshowCustomerFacingForMobile = "showCustomerFacingForMobile"
//

// screen saveer
let kisScreenSaverOn = "isScreenSaverOn"
let kisScreenSaverOnThenKeyboardHide = "isScreenSaverOnThenKeyboardHide"
let kscreenSaverTimeInSec = "screenSaverTimeInSec"
//



//Email Validation
let kEmailValidation = "[a-z0-9!#$%üäöß&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!üäöß#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"

// View Controller Identifiers
let kCategoriesContainerViewController = "CategoriesContainerViewController"
