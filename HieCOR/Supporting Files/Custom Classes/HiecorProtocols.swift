//
//  HiecorProtocols.swift
//  HieCOR
//
//  Created by Deftsoft on 22/01/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import Foundation

//MARK: Optional Protocols
@objc protocol  HieCORPinDelegate {
    @objc optional func didGetSuccess()
}

@objc protocol  HieCORPickerDelegate {
    @objc optional func didSelectPickerViewAtIndex(index: Int)
    @objc optional func didSelectDatePicker(date: Date)
    @objc optional func didClickOnPickerViewDoneButton()
    @objc optional func didClickOnPickerViewCancelButton()
    @objc optional func didClickOnDatePickerViewDoneButton()
}

@objc protocol ProductsViewControllerDelegate: class {
    @objc optional func getProductList()
    @objc optional func didTapOnSearchButton()
    @objc optional func didReceiveProductDetail(data: ProductsModel)
    @objc optional func didReceiveRefundProductIds(string: String)
    @objc optional func didSelectCategory(string: String)
    @objc optional func didAutoUpSellDataValueIphone() // For iphone upsell by DD
    @objc optional func didShowInStockItemOnly(inStock:Bool) // For iphone upsell by DD
}

@objc protocol ResetCartDelegate {
    @objc optional func resetCart()
    @objc optional func resetHomeCart()
    @objc optional func refreshData()
    @objc optional func updateKeyboardStatus(isShow: Bool)
    @objc optional func updateCart(with isRefundProduct: Bool, data: JSONDictionary?)
    @objc optional func didAutoUpSellDataValue()
    @objc optional func didShowInStockItemOnly(isStock: Bool)
}

@objc protocol CustomerDelegates: class {
    @objc optional func didSelectAddCustomerButton()
    @objc optional func didAddNewCustomer()
    @objc optional func didUpdateCustomer(dict: JSONDictionary)
    @objc optional func didEditCustomer(dict: JSONDictionary)
    @objc optional func didRefreshNewCustomer()
    @objc optional func didSelectCustomer(data: CustomerListModel)
    @objc optional func resetCart()
    @objc optional func didCancelButtonTapped()
   
}

@objc protocol CatAndProductsViewControllerDelegate: class {
    @objc optional func updatePager(dict: JSONDictionary, isCategory: Bool)
    @objc optional func hideView(with identifier: String)
    @objc optional func didEditProduct(index: Int)
    @objc optional func didAddNewProduct(data: ProductsModel, productDetail: Any)
    @objc optional func didSaveNewProduct(data: ProductsModel, productDetail: Any)
    @objc optional func didSaveProductVariationData(data: ProductsModel, productData: Any)
    @objc optional func didSaveProductVariationSurchargeData(data: ProductsModel, productData: Any)
    @objc optional func didSaveProductAttributeData(data: ProductsModel, productData: Any)
    @objc optional func didTapOnManualPayment()
    @objc optional func didUpdatevalueatrribute(index: Int, attribute: AnyObject)
    @objc optional func didTapToRefreshHome()
    @objc optional func didSaveProductItemMetaFieldsData(data: ProductsModel, productData: Any)
}

@objc protocol RefreshHomeCartDelegate : class{
    @objc optional func didClickOnHomeRefresh()
}

@objc protocol showDetailsDelegate : class {
    @objc optional func didShowDetailsAtrribute(index: Int, cartArray:Array<AnyObject>)
    @objc optional func didShowDetailsAtrributePayment(index: Int, cartArray:Array<AnyObject>)
}

@objc protocol creditInfoDelegate :class{
    @objc optional func didDataShowCreditcard(paymentMethod:String)
}

@objc protocol UserInfoDelegate :class{
    @objc optional func didgetUserData()
}

@objc protocol savedCardDelegate :class{
    @objc optional func didCloseSavedCard()
}

@objc protocol EditProductDelegate : class {
    @objc optional func didClickOnCrossButton()
    @objc optional func didClickOnDoneButton()
    @objc optional func didUpdateHeight(isKeyboardOpen: Bool)
    @objc optional func didClickOnCloseButton()
    @objc optional func didClickOnCreditSavedButton()
    @objc optional func didShowSavedCardDetail(index: Int, cartSavedArray:Array<AnyObject>)
    
    @objc optional func showShippingCard()
    @objc optional func hideShippingCard()
    @objc optional func hideShippingCardFromDoneBtn()
    @objc optional func doneShippingCard(rate: String)
    @objc optional func didShowShippingAddress(data: CustomerListModel)
    @objc optional func getCartProductsArray(data: Array<Any>)
    @objc optional func showSubscriptionView()
    @objc optional func hideSubscriptionView()
    @objc optional func sendSelectedSubscription(StrSubscription:String)
   
}
@objc protocol SubscriptionDelegate : class {
   @objc optional func sendSelectedSubscriptionForiPhone(StrSubscription:String)
}


@objc protocol iPad_PaymentTypesViewControllerDelegate: class {
    @objc optional func didResetCart()
    @objc optional func didUpdateShippingRefund(isselected: Bool)
    @objc optional func didUpdateCoupon(name: String,amount: Double)
    @objc optional func didUpdateManualDiscount(amount: Double,isPercentage: Bool)
    @objc optional func didUpdateTax(amount: Double,type: String, title: String)
    @objc optional func didUpdateShipping(amount: Double)
    @objc optional func didUpdateCustomer(data: CustomerListModel)
    @objc optional func didAddNewCustomer()
    @objc optional func didAddShippingRate(rate: String)
    @objc optional func didupdateOrderHistoryInfo()
}

@objc protocol PaymentTypeDelegate: class {
    @objc optional func reset()
    @objc optional func disableCardReader()
    @objc optional func enableCardReader()
    @objc optional func sendCreditCardData(with key: String, isIPad: Bool)
    @objc optional func sendIngenicoCardData(with key: String, isIPad: Bool, data: Any)
    @objc optional func sendCashData(isIPad: Bool)
    @objc optional func sendInvoiceData(isSaveInvoice: Bool, isIPad: Bool)
    @objc optional func sendACHCheckData(isIPad: Bool)
    @objc optional func sendCheckData(isIPad: Bool)
    @objc optional func sendGiftCardData(isIPad: Bool)
    @objc optional func sendExternalGiftCardData(isIPad: Bool)
    @objc optional func sendExternalCardData(isIPad: Bool)
    @objc optional func sendInternalGiftCardData(isIPad: Bool)
    @objc optional func sendNotesData(isIPad: Bool)
    @objc optional func sendMulticardData(isIPad: Bool)
    @objc optional func sendPAXData(with key: String, isIPad: Bool)
    @objc optional func didGetCardDetail()
    @objc optional func noCardDetailFound()
    @objc optional func didUpdateDevice()
    @objc optional func saveData()
    @objc optional func loadClassData()
    @objc optional func updateError(textfieldIndex: Int, message: String)
    // Start ..... by priya loyalty change
    @objc optional func didUpdateTotal(amount: Double , subToal : Double)
    // end .......by priya
    @objc optional func didUpdateCustomer(data: CustomerListModel)
    @objc optional func placeOrder(isIpad: Bool)
    @objc optional func enableCreditCardDelegate()
    @objc optional func gettingErrorDuringPayment(isMulticard: Bool, message: String?, error: NSError?)
    @objc optional func didMoveToSuccessScreen(totalAmount: Double, orderedData: [String: AnyObject], paymentName: String)
    @objc optional func didPerformSegueWith(identifier: String)
    @objc optional func didSendCreditSavedCardData(cartDataArray:Array<AnyObject>)
    @objc optional func didUpdateRemainingAmt(RemainingAmt: Double)
    @objc optional func didOpenErrorAlert(identifier: String)
    @objc optional func sendSignatureScreen(arrcardData : NSMutableArray)
}

@objc protocol ProductsContainerViewControllerDelegate: class {
    @objc optional func didSelectEditButton(data: ProductsModel, index: Int, isSearching: Bool)
    @objc optional func didGetCardDetail()
    @objc optional func noCardDetailFound()
    @objc optional func didTapOnManualPayment()
    @objc optional func didUpdateInternet(isOn: Bool)
    @objc optional func didGetProductListData()
}

@objc protocol EditProductsContainerViewDelegate: class {
    @objc optional func didEditProduct(with identiifier: String)
    @objc optional func didSelectProduct(with identifier: String)
    @objc optional func didCalculateCartTotal()
    @objc optional func didReceiveProductDetail(data: ProductsModel)
    @objc optional func refreshCart()
    @objc optional func hideDetailView()
    @objc optional func didEditProduct(index: Int)
}

@objc protocol AddDiscountPopupVCDelegate {
    @objc optional func didSelectApplyCoupon()
    @objc optional func didSelectManualFlatDiscount()
    @objc optional func didSelectManualPrcentageDiscount()
}


@objc protocol CategoriesContainerViewControllerDelegate: class {
    @objc optional func getProduct(withCategory name: String)
    @objc optional func didTapOnManualPayment()
}

@objc protocol ManualPaymentDelegate {
    @objc optional func didTapOnCrossButton()
    @objc optional func didTapOnAddButton()
}

@objc protocol CartContainerViewControllerDelegate: class {
    @objc optional func didRemoveCartArray()
    @objc optional func didUpdateCart(with identifier: String)
    @objc optional func didUpdateCartCountAndSubtotalPriceCoupon(dict: JSONDictionary)
    @objc optional func didHideView(with identifier: String)
    @objc optional func didTapOnPayButton(dict: JSONDictionary)
    @objc optional func refreshCart()
    @objc optional func refreshCart(isNewOrder: Bool)
    @objc optional func didGetCardDetail()
    @objc optional func noCardDetailFound()
    @objc optional func didPlaceOrderWithCardInformation()
    @objc optional func callHomeFromCart()
    @objc optional func callDataSendRate()
    @objc optional func callOpenOrCloseCustomer()
    @objc optional func addSubscriptionString(string : String)
}

@objc protocol ShippingDelegate: class {
    @objc optional func didRemoveCartArray()
    @objc optional func didUpdateCart(with identifier: String)
    @objc optional func didUpdateCartCountAndSubtotalPriceCoupon(dict: JSONDictionary)
    @objc optional func didHideView(with identifier: String)
    @objc optional func didSelectShipping(data: CustomerListModel)
}

@objc protocol PaymentTypeContainerViewControllerDelegate: class {
    @objc optional func didSelectPaymentMethod(with key: String)
    @objc optional func getPaymentData(with dict: JSONDictionary)
    @objc optional func placeOrderForIpad(with data: AnyObject)
    @objc optional func moveBackPage()
    @objc optional func enableCardReaders()
    @objc optional func disableCardReaders()
    @objc optional func didGetCardDetail()
    @objc optional func noCardDetailFound()
    @objc optional func didUpdateDevice()
    @objc optional func updateTotal(with amount: Double)
    @objc optional func placeOrder(isIpad: Bool)
    @objc optional func didUpdateCashValue(returnDue: String, totalDue: String)
    @objc optional func didUpdateAmountRemaining(amount: String)
    @objc optional func placeOrderWithSignature(image: UIImage)
    @objc optional func showCreditCard()
    @objc optional func sendCardCustomerCardData(data: CustomerListModel)
    @objc optional func didUpdateAmountChangeDue(amount: String)
    @objc optional func balanceDueAfterVoid(with amount: Double)
    @objc optional func checkPayButtonColorChange(isCheck: Bool, text : String)
    @objc optional func checkIphonePayButtonColorChange(isCheck: Bool, text : String)
    @objc optional func returnDataSignature(arrCardDataSignature: JSONArray)
    @objc optional func balanceRemoveTip(with amount: Double)
    @objc optional func balanceDueRemaining(with amount: Double)
    @objc optional func paxModeCheckAuth(strPaxMode:String)
    @objc optional func showCustomerViewfromInvoice()
}

@objc protocol OrderInfoViewControllerDelegate: class {
    @objc optional func didGetOrderInformation(with orderId: String, defualtView: Bool)
    @objc optional func didUpdateReturnScreen(with data: JSONDictionary)
    @objc optional func didUpdateTransactionScreen(with data: JSONDictionary)
    @objc optional func didProductReturned()
    @objc optional func didProductRefunded()
    @objc optional func didUpdateHeaderText(with string: String)
    @objc optional func didUpdateRefundScreen(with data: JSONDictionary)
    @objc optional func didHideRefundView(isRefresh: Bool)
    @objc optional func didMoveToCartScreen(with data: JSONDictionary?)
    @objc optional func didMoveToCartShipingScreen()
    @objc optional func didGetOrdersListNotFound(defualtView: Bool)
    //@objc optional func didHideUserDetailView(isRefresh: Bool)
    //@objc optional func didgetUserOrderId(with orderId: String)
    
}

@objc protocol UserDetailsDelegate {
    @objc optional func didHideUserDetailView(isRefresh: Bool)
    @objc optional func didgetUserOrderId(with orderId: String)
}

@objc protocol SelectShippingDelegate   {
    @objc optional func didHideSelectShippingView(isRefresh: Bool)
    @objc optional func sendSelectShippingAddessData(ShippingSelectDataArray:Array<AnyObject>)
}

@objc protocol addressShippingDelegate {
    @objc optional func didCallAPIShipping(strID: String)
}

@objc protocol SwipeAndSearchDelegate {
    @objc optional func didSearchingProduct()
    @objc optional func didSearchedProduct(product: ProductsModel)
    @objc optional func noProductFound()
    @objc optional func didBeginSearching()
    @objc optional func didEndSearching()
    @objc optional func didGetCardDetail(number: String, month: String, year: String)
    @objc optional func didGetError(error: String)
    @objc optional func noCardDetailFound()
    @objc optional func didUpdateDevice()
    @objc optional func didSearchedProductMultiProduct(product: [ProductsModel],text:String)
    @objc optional func didSearchingProductScaner(text:String)
}

@objc protocol SwipeAndSearchConnectionDelegate {
    @objc optional func didUpdateJackReader(isConnected: Bool)
}

@objc protocol SwipeAndSearchTextDidChangeDelegate {
    @objc optional func textDidchange(text: String)
    @objc optional func textDidBeginEditing()
    @objc optional func textDidEndEditing()
}

@objc protocol OfflineDataManagerDelegate {
    @objc optional func didUpdateInternetConnection(isOn: Bool)
}

//MARK: Required Protocols
protocol PaymentModeMenuDelegate: class {
    func paymentModeMenu(sender:UIButton,selctedIndex:Int)
    func didDismiss()
}

protocol MultiCardContainerViewControllerDelegate: class {
    func didHideButton(with tag: Int, isHidden: Bool)
}

protocol CartViewControllerDelegate {
    func didHideView(with identifier: String)
    func didUpdateView(with OriginY: CGFloat)
    func moveToSuccessScreen()
    func didTapOnSearchbar()
}

protocol PopOverEditDelegate {
    func editButtonClicked(isClicked: Bool)
}

protocol SelectedCutomerDelegate: class {
    func selectedCustomerData(customerdata: CustomerListModel)
}

protocol AddNewCutomerViewControllerDelegate: class {
    func didAddNewCustomer(data: CustomerListModel)
    
}

protocol SelectCountryPopupVCDelegate {
    func didSelectValue(string: String, index: Int)
    func customContactSourceData(string: String)
}

protocol iPadTableViewCellDelegate {
    func didUpdateAttribute(indexPath: IndexPath, attributes: [AttributesModel], isRadio: String, isSelect: Bool, price: Double)
    func didUpdateSurchargeAttribute(indexPath: IndexPath, attributes: [AttributesModel], isRadio: String, isSelect: Bool, price: Double, isSurchargeValueChange:Bool, arraySuchargevariationData : JSONArray, arrSurchargeModel: [ProductSurchageVariationDetail])

}

protocol ProductSearchContainerDelegate {
    func didSearchComplete(with product: ProductsModel)
    func didSearchCancel()
}

protocol AttributeUpdateDeleget {
    func didUpdateAttributeProduct(index: Int, attributes: [AttributesModel])
}

@objc protocol PayInPayOutDelegate {
    @objc optional func showPayInPayOutView()
    @objc optional func hidePayInPayOutView()
    @objc optional func sendPayInPayOutViewData(expectedStr: String)
    @objc optional func didUpdateHeaderTextPay(with string: String)
    @objc optional func showIphonePayInOut()
    @objc optional func hideIphonePayInOut()
    @objc optional func sendIphonePayInPayOutViewData(expectedStr: String)
}

protocol refreshCurrentVCDataDelegate {
    func refreshCurrentViewContollPayOutData(data: [DrawerHistoryModel])
    func refreshCurrentViewContollPayInData(data: [DrawerHistoryModel])
}

protocol refreshCurrentVCDataForIphoneDelegate {
    func refreshCurrentViewContollPayOutDataForIphone(data: [DrawerHistoryModel])
    func refreshCurrentViewContollPayInDataForIphone(data: [DrawerHistoryModel])
}

@objc protocol CancelPAXDelegate {
    func didCancelPAX()
}
// new setting delegate method
@objc protocol SettingViewControllerDelegate: class {
   
    @objc optional func didMoveToNextScreen(with string: String)
    @objc optional func showPaymentMethodView()
    @objc optional func hidePaymentMethodView()
    @objc optional func hidePrinterView()
    @objc optional func deviceNameUpdate(with string: String)
    @objc optional func cardReaderViewShowHide(with bool: Bool)
    @objc optional func IngenicoDeviceListDelegate()
    @objc optional func IngenicoDeviceDataDelegate()
    @objc optional func IngenicoDeviceDataDelegateData(with data:[RUADevice])
    @objc optional func paymentScreenReloadDelegate()
}

// new Device name change delegate method
@objc protocol ChangeDeviceNamePopupVCDelegate{
   
    @objc optional func deviceNameUpdatePopup(with string: String)
    @objc optional func deviceNamePopHieght(with height: Float)
    @objc optional func deviceNamePopHide()
}


@objc protocol ingenicoCancelViewControllerDelegate: class {
    func didTapOnCancelButton()
}

@objc protocol StarCloudPRNTVCDelegate: class {
    func didTapOnStarCloudPrintButton()
}

@objc protocol CustomerPickupDelegete{
    @objc optional func didMoveToOrderInfoForCustomerPickup()
    @objc optional func reloadDataByCustomerPickUp()
}
