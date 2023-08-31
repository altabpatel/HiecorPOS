//
//  Extension.swift
//  HieCOR
//
//  Created by Deftsoft on 23/07/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import Foundation
import SocketIO

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
extension String {
    func toDouble() -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        return numberFormatter.number(from: self)?.doubleValue
    }
}

extension Double {
    // Rounds the double to decimal places value
    var roundToTwoDecimal:String {
        let value = self.rounded(toPlaces: 2)
        return String(format: "%.2f", value)
    }
    
    var currencyFormat:String {
        let value = self.rounded(toPlaces: 2)
        let newString = String(format: "%.2f", value).replacingOccurrences(of: "-", with: "")
        return value < 0 ? "-$" + newString : "$" + newString
    }
    var currencyFormatA:String {
        let value = self.rounded(toPlaces: 2)
        let newString = String(format: "%.2f", value).replacingOccurrences(of: "-", with: "")
        return newString
    }
    
    var currencyFormatD:String {
        let value = self.rounded(toPlaces: 2)
        let newString = String(format: "%.2f", value).replacingOccurrences(of: "-", with: "")
        return newString
    }
    var roundOFF:String {
        let value = self.rounded(toPlaces: 2)
        return String(format: "%.0f", value)
    }
    
    var newValue:String {
        if self.isInt {
            return String(format: "%.0f", self)
        }
        return String(format: "%.2f", self)
    }
    
}

extension FloatingPoint {
    var isInt: Bool {
        return floor(self) == self
    }
}

extension NSObject
{
    func Convertcurrency(convertcur: NSNumber)->String
    {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_VI")// Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from:  convertcur )
        {
            return String(formattedTipAmount)
            
        }
        return "$0.00"
    }
}
extension UIViewController
{
    func Alert(mesaage: String)
    {
        let uiAlertController = UIAlertController(
            title: "Alert",
            message: mesaage,
            preferredStyle:.alert)
        
        uiAlertController.addAction(
            UIAlertAction.init(title: kOkay, style: .default, handler: { (UIAlertAction) in
                uiAlertController.dismiss(animated: true, completion: nil)
                
            }))
        self.present(uiAlertController, animated: true, completion: nil)
    }
}

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}

extension String {
    func isValidEmail() -> Bool {
        let testStr = self
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        if DataManager.isTaxTenDecimal {
            let value = self.roundedTax()
            let divisor = pow(10.0, Double(places))
            return (value * divisor).rounded() / divisor
        } else {
            //let value = self.roundedTax()
            let divisor = pow(10.0, Double(places))
            return (self * divisor).rounded() / divisor
        }
        
    }
    
    func roundedTax() -> Double {
        let divisor = pow(10.0, Double(10))
        return (self * divisor).rounded() / divisor
    }
}

public enum ImageFormat {
    case png
    case jpeg(CGFloat)
}

extension UIImage {
    
    public func base64(format: ImageFormat) -> String {
        var imageData: Data?
        switch format {
        case .png: imageData = UIImagePNGRepresentation(self)
        case .jpeg(let compression): imageData = UIImageJPEGRepresentation(self, compression)
        }
        return imageData?.base64EncodedString() ?? ""
    }
}

extension UITextField
{
    var isEmpty: Bool {
        return (self.text)!.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func validatePhoneNumber() -> Bool {
        let phoneNumber = self.text ?? ""
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phoneNumber == filtered
    }
    
    func isValidPhone() -> Bool {
        let phone = self.text ?? ""
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: phone)
        return result
    }
    
    func isValidEmail() -> Bool {
        let testStr = self.text ?? ""
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func setDropDown() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.frame.size.height))
        let imageView = UIImageView()
        imageView.frame.size.width = 15
        imageView.frame.size.height = 15
        imageView.center = paddingView.center
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "dropdown-arrow")
        imageView.clipsToBounds = true
        paddingView.clipsToBounds = true
        paddingView.addSubview(imageView)
        imageView.isUserInteractionEnabled = false
        paddingView.isUserInteractionEnabled = false
        
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setCalendarImage() {
           let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.frame.size.height))
           let imageView = UIImageView()
           imageView.frame.size.width = 15
           imageView.frame.size.height = 15
           imageView.center = paddingView.center
           imageView.contentMode = .scaleAspectFit
           imageView.image = #imageLiteral(resourceName: "Group 4523")
           imageView.clipsToBounds = true
           paddingView.clipsToBounds = true
           paddingView.addSubview(imageView)
           imageView.isUserInteractionEnabled = false
           paddingView.isUserInteractionEnabled = false
           
           self.rightView = paddingView
           self.rightViewMode = .always
       }
    
    
    func setDollar(color: UIColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0), font: UIFont = UIFont.systemFont(ofSize: 12)) {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 13, height: 20))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 13, height: 20))
        label.text = "$"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = color
        label.textAlignment = .center
        label.center = outerView.center
        outerView.addSubview(label)
        self.leftView = outerView
        self.leftViewMode = .always
    }
    
    func setCenterDollar(color: UIColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0), font: UIFont = UIFont.systemFont(ofSize: 12)) {
        let outerView = UIView(frame: CGRect(x: 5, y: 0, width: 13, height: 20))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 13, height: 20))
        label.text = "$"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = color
        label.textAlignment = .center
        label.center = outerView.center
        outerView.addSubview(label)
        self.leftView = outerView
        self.leftViewMode = .always
    }
    
    
    func setPadding(with image: UIImage) {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 28, height: 20))
        let iconView  = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        iconView.image = image
        outerView.addSubview(iconView)
        self.leftView = outerView
        self.leftViewMode = .always
    }
    
    func setAttributeText(withString: String) {
        
        let main_string = self.placeholder ?? ""
        let string_to_color = withString
        
        let range = (main_string as NSString).range(of: string_to_color)
        
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0,5))
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red , range: range)
        
        self.attributedPlaceholder = attribute
    }
    
    func setPlaceholder(placholder: String? = nil,color: UIColor? = UIColor.darkGray) {
        let myPlaceholder = placholder ?? self.placeholder!
        let attributedString = NSAttributedString(string: myPlaceholder, attributes: [NSAttributedStringKey.foregroundColor : color!, NSAttributedStringKey.font : self.font!])
        self.attributedPlaceholder = attributedString
    }
    
    public func hideAssistantBar()
    {
        if #available(iOS 9.0, *) {
            let assistant = self.inputAssistantItem;
            assistant.leadingBarButtonGroups = [];
            assistant.trailingBarButtonGroups = [];
        }
    }
    
    func setPadding() {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.leftView = outerView
        self.leftViewMode = .always
    }
    func setPaddingleft() {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        self.leftView = outerView
        self.leftViewMode = .always
    }
    func setRightPadding() {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.rightView = outerView
        self.rightViewMode = .always
    }
    
}
extension UITextView
{
    public func hideAssistantBar()
    {
        if #available(iOS 9.0, *) {
            let assistant = self.inputAssistantItem;
            assistant.leadingBarButtonGroups = [];
            assistant.trailingBarButtonGroups = [];
        }
    }
}
extension UIViewController
{
    func alertForLogOut()
    {
        let refreshAlert = UIAlertController(title: "Alert", message: "Are you sure want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: kOkay, style: .default, handler: { (action: UIAlertAction!) in
            
            ResetAllCartData()
            // reset customer facing app
            if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing{
                MainSocketManager.shared.connect()
                let socketConnectionStatus = MainSocketManager.shared.socket.status
                
                switch socketConnectionStatus {
                case SocketIOStatus.connected:
                    print("socket connected")
                    MainSocketManager.shared.onreset()
                case SocketIOStatus.connecting:
                    print("socket connecting")
                case SocketIOStatus.disconnected:
                    print("socket disconnected")
                case SocketIOStatus.notConnected:
                    print("socket not connected")
                }
            }
            
            //ResetPrinter Settings
            DispatchQueue.main.async {
                PrintersViewController.printerUUID = nil
                PrintersViewController.printerArray.removeAll()
                PrintersViewController.printerManager?.disconnectAllPrinter()
                PrintersViewController.printerManager = nil
                PrintersViewController.centeralManager = nil
            }
            
            if UI_USER_INTERFACE_IDIOM() == .pad
            {
                let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "iPad_LoginViewController")
                UIApplication.shared.keyWindow?.rootViewController = vc
            }
            else
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
                UIApplication.shared.keyWindow?.rootViewController = vc
            }
            
            //Ingenico.sharedInstance()?.paymentDevice.release()
            //Ingenico.sharedInstance()?.paymentDevice.stopSearch()
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func updateLoggedInCustomer() {
        if let userObject = UserDefaults.standard.value(forKey: "userdata") as? NSData {
            let userdata = NSKeyedUnarchiver.unarchiveObject(with: userObject as Data)
            
            
            var city = ""
            var region = ""
            var postal_code = ""
            var country = ""
            
            if let regionData = (userdata as AnyObject).value(forKey: "region") as? String {
                region = regionData
            }
            
            if let cityData = (userdata as AnyObject).value(forKey: "city") as? String {
                city = cityData
            }
            
            if let countryData = (userdata as AnyObject).value(forKey: "country") as? String {
                country = countryData
            }
            
            if let postal_codeData = (userdata as AnyObject).value(forKey: "postal_code") as? String {
                postal_code = postal_codeData
            }
            
            let customerObj: JSONDictionary = ["country": country , "billingCountry": country,"shippingCountry": country,"coupan": "", "str_first_name":"", "str_last_name":"", "str_company": "" ,"str_address": "", "str_bpid":"", "str_city": city, "str_order_id": "", "str_email": "", "str_userID": "", "str_phone": "","str_region": region, "str_address2": "", "str_Billingcity": city, "str_postal_code": postal_code, "str_Billingphone": "", "str_Billingaddress": "", "str_Billingaddress2": "", "str_Billingregion": region, "str_Billingpostal_code": postal_code,"shippingPhone": "","shippingAddress" : "", "shippingAddress2": "", "shippingCity": city, "shippingRegion" : region, "shippingPostalCode": postal_code, "billing_first_name": "", "billing_last_name": "","user_custom_tax": "","shipping_first_name": "", "shipping_last_name": "","shippingEmail":  "", "str_Billingemail": "",  "str_BillingCustom1TextField": "", "str_BillingCustom2TextField": ""]
            DataManager.customerObj = customerObj
        }
    }
}

func ResetAllCartData()
{
    //    UserDefaults.standard.removeObject(forKey: "LoginBaseUrl")
    UserDefaults.standard.removeObject(forKey: "LoginUsername")
    UserDefaults.standard.removeObject(forKey: "LoginPassword")
    UserDefaults.standard.removeObject(forKey: "isUserLogin")
    UserDefaults.standard.synchronize()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        UserDefaults.standard.removeObject(forKey: "recentOrder")
        UserDefaults.standard.removeObject(forKey: "recentOrderID")
        UserDefaults.standard.removeObject(forKey: "isCheckUncheckShippingBilling")
        UserDefaults.standard.removeObject(forKey: "cartdata")
        UserDefaults.standard.removeObject(forKey: "CustomerObj")
        UserDefaults.standard.removeObject(forKey: "SelectedCustomer")
        UserDefaults.standard.removeObject(forKey: "cartProductsArray")
        UserDefaults.standard.removeObject(forKey: "addnotesordersummary")
        UserDefaults.standard.removeObject(forKey: "defaultTaxID")
        
        appDelegate.localBezierPath.removeAllPoints()
        appDelegate.amount = 0.0
        
        //DataManager.selectedPaxDeviceName = ""
        UserDefaults.standard.synchronize()
        DataManager.isshipOrderButton = false
        DataManager.isPromptAddCustomer = false
        DataManager.selectedCategory = "Home"
        DataManager.isCheckForAppUpdate = false
        DataManager.socketAppUrl = ""
//        DataManager.showCustomerStatusAllInOne = ""
//        DataManager.showOfficePhoneAllInOne = ""
//        DataManager.showContactSourceBoxAllInOne = ""
            DataManager.isshippingRefundOnly = false
                DataManager.isTipRefundOnly  = false
                appDelegate.tipRefundOnly = 0.0
                
                HomeVM.shared.isAllDataLoaded = [false, false, false]
                DataManager.isCheckUncheckShippingBilling = true
                DataManager.OrderDataModel = nil
                DispatchQueue.global(qos: .userInitiated).async {
                    DispatchQueue.main.async {
                        //DataManager.selectedPaxDeviceName = ""
                        DataManager.isUserPaxToken = ""
                        DataManager.shippingaddressCount = 0
                        DataManager.CardCount = 0
                        DataManager.EmvCardCount = 0
                        DataManager.IngenicoCardCount = 0
                        DataManager.Bbpid = ""
                        DataManager.ErrorBbpid = ""
                        DataManager.customerId = ""
                        HomeVM.shared.customerUserId = ""
                        DataManager.customerForShippingAddressId = ""
                        DataManager.shippingValue = 0.0
                        DataManager.shippingValueForAddress = 0.0
                        DataManager.recentOrderID = nil
                        DataManager.recentOrder = JSONDictionary()
                        DataManager.isBalanceDueData = false
                        HomeVM.shared.amountPaid = 0.0
                        HomeVM.shared.tipValue = 0.0
                        HomeVM.shared.DueShared = 0.0
                        HomeVM.shared.errorTip = 0.0
                        DataManager.selectedCarrier = ""
                        DataManager.selectedService = ""
                        DataManager.selectedCarrierName = ""
                        DataManager.selectedServiceName = ""
                        DataManager.selectedServiceId = ""
                        //Reset Cart
                        if DataManager.isCaptureButton == true {
                            DataManager.cartProductsArray?.removeAll()
                            DataManager.isCaptureButton = false
                        }
                    }
                }
            }
        }


extension UIView {
    func setCornerRadius(cornerRadius: CGFloat? = nil) {
        self.clipsToBounds = true
        self.layer.cornerRadius = (cornerRadius == nil) ? self.frame.size.height / 2 : cornerRadius!
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}

extension String {
    
    public var containEmoji: Bool
    {
        for ucode in unicodeScalars
        {
            switch ucode.value
            {
            case 0x3030, 0x00AE, 0x00A9,
                 0x1D000...0x1F77F,
                 0x2100...0x27BF,
                 0xFE00...0xFE0F,
                 0x1F900...0x1F9FF:
                return true
            default:
                continue
            }
        }
        return false
    }
    
    private static let decimalFormatter:NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        return formatter
    }()
    
    private var decimalSeparator:String{
        return String.decimalFormatter.decimalSeparator ?? "."
    }
    
    public var hasWhiteSpace: Bool {
        return self.contains(" ")
    }
    
    func isValidDecimal(maximumFractionDigits:Int)->Bool{
        
        if self.hasWhiteSpace {
            return false
        }
        
        // Depends on you if you consider empty string as valid number
        guard self.isEmpty == false else {
            return true
        }
        
        // Check if valid decimal
        if let _ = String.decimalFormatter.number(from: self){
            
            // Get fraction digits part using separator
            let numberComponents = self.components(separatedBy: decimalSeparator)
            let fractionDigits = numberComponents.count == 2 ? numberComponents.last ?? "" : ""
            return fractionDigits.count <= maximumFractionDigits
        }
        
        return false
    }
    
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge? = nil, color: UIColor, thickness: CGFloat) {
        
        let border1 = CALayer()
        let border2 = CALayer()
        let border3 = CALayer()
        let border4 = CALayer()
        border1.name = "border1"
        border2.name = "border2"
        border3.name = "border3"
        border4.name = "border4"
        
        border1.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        border2.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        border3.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)  // <
        border4.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height) //>
        
        border1.backgroundColor = color.cgColor;
        border2.backgroundColor = color.cgColor;
        
        if edge == nil {
            border3.backgroundColor =  edge == .left ? color.cgColor : UIColor.clear.cgColor
            border4.backgroundColor = edge == .right ? color.cgColor : UIColor.clear.cgColor
        }else {
            border3.backgroundColor =  edge! == .left ? color.cgColor : UIColor.clear.cgColor
            border4.backgroundColor = edge! == .right ? color.cgColor : UIColor.clear.cgColor
        }
        
        self.sublayers?.append(border1)
        self.sublayers?.append(border2)
        self.sublayers?.append(border3)
        self.sublayers?.append(border4)
    }
    
    func removeBorder() {
        if let sublayers = self.sublayers {
            for layer: CALayer in sublayers  {
                if layer.name == "border1" || layer.name == "border2" || layer.name == "border3" || layer.name == "border4"{
                    layer.removeFromSuperlayer()
                    break
                }
            }
        }
    }
    
}



func encode(data: CardDataModel?) -> [String: Any] {
    var dict = [String: Any]()
    dict["cardNumber"] = data?.cardNumber
    dict["month"] = data?.month
    dict["year"] = data?.year
    dict["type"] = data?.type
    dict["bpid"] = data?.bpId
    return dict
}

func decode(dict: [String: Any]) -> CardDataModel {
    return CardDataModel(cardNumber: dict["cardNumber"] as? String ?? "", month: dict["month"] as? String ?? "", year: dict["year"] as? String ?? "", type: dict["type"] as? String ?? "", bpId: dict["bpid"] as? String ?? "")
}

extension UITextField {
    
    func setBottomLine(borderColor: UIColor) {
        removeBorder()
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.size.height) - height - 1, width: Double(self.frame.size.width), height: height)
        borderLine.backgroundColor = borderColor
        borderLine.tag = 10000001
        self.addSubview(borderLine)
    }
    
    func removeBorder() {
        for view in self.subviews {
            if view.tag == 10000001 {
                view.removeFromSuperview()
            }
        }
    }
}
extension UIView {
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var maskToBound: Bool {
        get {
            return layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderWidth : CGFloat {
        set
        {
            layer.borderWidth = newValue
        }
        
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor.init(cgColor: color)
            }
            return nil
        }
        set(newValue) {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UISegmentedControl {
    func replaceSegments(segments: Array<String>) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegment(withTitle: segment, at: self.numberOfSegments, animated: false)
        }
    }
}

extension UINavigationController {
    
    ///Get previous view controller of the navigation stack
    func previousThirdViewController() -> UIViewController?{
        let length = self.viewControllers.count
        let previousViewController: UIViewController? = length >= 2 ? self.viewControllers[length-3] : nil
        return previousViewController
    }
    
}

extension UIScrollView {
    var currentPage:Int{
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)+1
    }
}

extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() }) { (_) in
            completion()
        }
    }
}

extension UIView
{
    func searchVisualEffectsSubview() -> UIVisualEffectView?
    {
        if let visualEffectView = self as? UIVisualEffectView
        {
            return visualEffectView
        }
        else
        {
            for subview in subviews
            {
                if let found = subview.searchVisualEffectsSubview()
                {
                    return found
                }
            }
        }
        
        return nil
    }
}

extension UIAlertController {
    
    private struct AssociatedKeys {
        static var blurStyleKey = "UIAlertController.blurStyleKey"
    }
    
    public var blurStyle: UIBlurEffectStyle {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.blurStyleKey) as? UIBlurEffectStyle ?? .extraLight
        } set (style) {
            objc_setAssociatedObject(self, &AssociatedKeys.blurStyleKey, style, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    public var cancelButtonColor: UIColor? {
        return blurStyle == .dark ? UIColor(red: 28.0/255.0, green: 28.0/255.0, blue: 28.0/255.0, alpha: 1.0) : nil
    }
    
    private var visualEffectView: UIVisualEffectView? {
        if let presentationController = presentationController, presentationController.responds(to: Selector(("popoverView"))), let view = presentationController.value(forKey: "popoverView") as? UIView // We're on an iPad and visual effect view is in a different place.
        {
            return view.recursiveSubviews.compactMap({$0 as? UIVisualEffectView}).first
        }
        
        return view.recursiveSubviews.compactMap({$0 as? UIVisualEffectView}).first
    }
    
    private var cancelActionView: UIView? {
        return view.recursiveSubviews.compactMap({
            $0 as? UILabel}
            ).first(where: {
                $0.text == actions.first(where: { $0.style == .cancel })?.title
            })?.superview?.superview
    }
    
    public convenience init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle, blurStyle: UIBlurEffectStyle) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        self.blurStyle = blurStyle
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        visualEffectView?.effect = UIBlurEffect(style: blurStyle)
        cancelActionView?.backgroundColor = cancelButtonColor
    }
}

extension UIView {
    
    var recursiveSubviews: [UIView] {
        var subviews = self.subviews.compactMap({$0})
        subviews.forEach { subviews.append(contentsOf: $0.recursiveSubviews) }
        return subviews
    }
}

//MARK: Compare Two Dictionaries
func == <K, V>(left: [K:V], right: [K:V]) -> Bool {
    return NSDictionary(dictionary: left).isEqual(to: right)
}

extension UIView {
    
    func setBorder(borderWidth : CGFloat = 1.0,borderColor : UIColor , cornerRadius : CGFloat = 5.0) {
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.borderColor = borderColor.cgColor
    }
}



extension URLSession {
    
    func synchronousDataTask(with request: URLRequest) throws -> (data: Data?, response: HTTPURLResponse?) {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var responseData: Data?
        var theResponse: URLResponse?
        var theError: Error?
        
        dataTask(with: request) { (data, response, error) -> Void in
            
            responseData = data
            theResponse = response
            theError = error
            
            semaphore.signal()
            
            }.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        if let error = theError {
            throw error
        }
        
        return (data: responseData, response: theResponse as! HTTPURLResponse?)
        
    }
    
}


extension CALayer {
    var customBorderColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}


extension UITextField {
    
    func addDropDownArrow() {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 20))
        let iconView  = UIImageView(frame: CGRect(x: 5, y: 7, width: 10, height: 7))
        iconView.image = UIImage(named: "dropdown-arrow")
        outerView.isUserInteractionEnabled = true
        iconView.isUserInteractionEnabled = true
        outerView.addSubview(iconView)
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(handleTap(sender:)))
        
        iconView.addGestureRecognizer(tapGesture)
        
        self.rightView = outerView
        self.rightViewMode = .always
    }
    
    func addLeftSidePadding() {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        outerView.backgroundColor = UIColor.clear
        self.leftView = outerView
        self.leftViewMode = .always
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.becomeFirstResponder()
    }
    
    func setCrossButton() {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: self.bounds.size.height))
        let iconView  = UIImageView(frame: CGRect(x: 5, y: 7, width: 10, height: 10))
        iconView.image = #imageLiteral(resourceName: "cancel")
        outerView.isUserInteractionEnabled = true
        iconView.isUserInteractionEnabled = true
        outerView.addSubview(iconView)
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(handleCrossTap(sender:)))
        
        outerView.addGestureRecognizer(tapGesture)
        
        self.rightView = outerView
        self.rightViewMode = .always
    }
    
    @objc func handleCrossTap(sender: UITapGestureRecognizer) {
        self.text = ""
        self.becomeFirstResponder()
    }
    
}

extension UIView {
    func setBorder(color: UIColor? = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0)) {
        let border = CALayer()
        border.borderColor = color!.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - 1.0, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = 1.0
        border.name = "in_line"
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func resetCustomError(isAddAgain: Bool? = true) {
        for view in self.subviews {
            if view.tag == 100000001 || view.tag == 100000002 {
                view.removeFromSuperview()
            }
        }
        if isAddAgain! {
            //setBorder()
        }
    }
    
    func removeInLineBorder() {
        for view in self.subviews {
            if view.tag == 100000001 || view.tag == 100000002 {
                view.removeFromSuperview()
            }
        }
        
        if let layers = self.layer.sublayers {
            for lay in layers {
                if lay.name == "in_line" {
                    lay.removeFromSuperlayer()
                }
            }
        }
    }
    
    func setCustomError(text: String? = "Please swipe the card properly.",bottomSpace: CGFloat? = 2.0,rightSpace: CGFloat? = 0,isRightSide: Bool? = false, bottomLabelSpace:CGFloat = 5, fontSize: CGFloat = 12.0) {
        removeInLineBorder()
        
        let badgeLabel = UILabel()
        badgeLabel.text = text
        badgeLabel.tag = 100000002
        badgeLabel.textColor = UIColor.red
        badgeLabel.backgroundColor = UIColor.clear
        badgeLabel.font = UIFont.systemFont(ofSize: fontSize)
        badgeLabel.sizeToFit()
        badgeLabel.textAlignment = .left
        badgeLabel.frame = CGRect(x: isRightSide! ? -50 :  rightSpace!, y: self.bounds.height + bottomLabelSpace, width: 250, height: 15)
        
        badgeLabel.layer.cornerRadius = badgeLabel.frame.height/2
        badgeLabel.layer.masksToBounds = true
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        addSubview(badgeLabel)
        
        let borderLine = UIView()
        borderLine.frame = CGRect(x: 0, y: self.bounds.height + bottomSpace!, width: self.frame.size.width, height: 1)
        borderLine.backgroundColor = UIColor.red
        borderLine.tag = 100000001
        borderLine.sizeToFit()
        borderLine.layer.masksToBounds = true
        borderLine.clipsToBounds = false
        addSubview(borderLine)
    }
    
    func updateCustomBorder() {
        for view in self.subviews {
            if view.tag == 100000001 {
                view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: self.frame.size.width, height: view.frame.height)
                view.sizeToFit()
                break
            }
        }
    }
}

extension UILabel {
    
    @IBInspectable var addDashedBorderWidth : CGFloat {
        set(newValue)
        {
            self.layoutIfNeeded()
            let shapeLayer:CAShapeLayer = CAShapeLayer()
            let frameSize = self.frame.size
            let shapeRect = CGRect(x: 0, y: 0, width: newValue, height: 0)
            shapeLayer.bounds = shapeRect
            shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height)
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = UIColor.blue.cgColor
            shapeLayer.lineWidth = 1 //0.50
            shapeLayer.lineJoin = kCALineJoinRound
            // shapeLayer.lineDashPattern = [3,2]
            shapeLayer.lineDashPattern = [2,3.5]
            shapeLayer.path = UIBezierPath(roundedRect: CGRect(x:0, y: shapeRect.height, width: shapeRect.width,height: 0), cornerRadius: 0).cgPath
            self.layer.addSublayer(shapeLayer)
        }
        
        get {
            return layer.frame.size.width
        }
    }
    
    @IBInspectable var addDashedBorder: UIColor? {
        
        get {
            if let color = self.addDashedBorder {
                return UIColor.init(cgColor: color as! CGColor)
            }
        
            return nil
        }
        set(newValue) {
            self.layoutIfNeeded()
            let shapeLayer:CAShapeLayer = CAShapeLayer()
            let frameSize = self.frame.size
            let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: 0)
            shapeLayer.bounds = shapeRect
            shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height)
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = newValue?.cgColor
            shapeLayer.lineWidth = 1 //0.50
            shapeLayer.lineJoin = kCALineJoinRound
            // shapeLayer.lineDashPattern = [3,2]
            shapeLayer.lineDashPattern = [2,3.5]
            shapeLayer.path = UIBezierPath(roundedRect: CGRect(x:0, y: shapeRect.height, width: shapeRect.width,height: 0), cornerRadius: 0).cgPath
            self.layer.addSublayer(shapeLayer)
        }
    }

}

extension UITableView {
    func scrollToBottom(){
        DispatchQueue.main.async {
            guard self.numberOfSections > 0 else { return }
            
            // Make an attempt to use the bottom-most section with at least one row
            var section = max(self.numberOfSections - 1, 0)
            var row = max(self.numberOfRows(inSection: section) - 1, 0)
            var indexPath = IndexPath(row: row, section: section)
            
            // Ensure the index path is valid, otherwise use the section above (sections can
            // contain 0 rows which leads to an invalid index path)
            while !self.indexPathIsValid(indexPath) {
                section = max(section - 1, 0)
                row = max(self.numberOfRows(inSection: section) - 1, 0)
                indexPath = IndexPath(row: row, section: section)
                
                // If we're down to the last section, attempt to use the first row
                if indexPath.section == 0 {
                    indexPath = IndexPath(row: 0, section: 0)
                    break
                }
            }
            
            // In the case that [0, 0] is valid (perhaps no data source?), ensure we don't encounter an
            // exception here
            guard self.indexPathIsValid(indexPath) else { return }
            
            self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
    }
    
    func scrollToFooterView() {
        DispatchQueue.main.async {
            let footerBounds = self.tableFooterView?.bounds
            let footerRectInTable = self.convert(footerBounds!, from: self.tableFooterView!)
            self.scrollRectToVisible(footerRectInTable, animated: false)
        }
    }
    
}

extension String {
    static func stringCompare(lhs: String, rhs: String) -> Bool {
        return lhs.compare(rhs, options: .numeric) == .orderedAscending
    }
}

extension String
{
    func encodeUrl() -> String
    {
        return self.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
    }
    
}

private var bottomLineColorAssociatedKey : UIColor = .black
private var topLineColorAssociatedKey : UIColor = .black
private var rightLineColorAssociatedKey : UIColor = .black
private var leftLineColorAssociatedKey : UIColor = .black
extension UIView {
    @IBInspectable var bottomLineColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &bottomLineColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &bottomLineColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    @IBInspectable var bottomLineWidth: CGFloat {
        get {
            return self.bottomLineWidth
        }
        set {
            DispatchQueue.main.async {
                self.addBottomBorderWithColor(color: self.bottomLineColor, width: newValue)
            }
        }
    }
    @IBInspectable var topLineColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &topLineColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &topLineColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    @IBInspectable var topLineWidth: CGFloat {
        get {
            return self.topLineWidth
        }
        set {
            DispatchQueue.main.async {
                self.addTopBorderWithColor(color: self.topLineColor, width: newValue)
            }
        }
    }
    @IBInspectable var rightLineColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &rightLineColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &rightLineColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    @IBInspectable var rightLineWidth: CGFloat {
        get {
            return self.rightLineWidth
        }
        set {
            DispatchQueue.main.async {
                self.addRightBorderWithColor(color: self.rightLineColor, width: newValue)
            }
        }
    }
    @IBInspectable var leftLineColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &leftLineColorAssociatedKey) as? UIColor {
                return color
            } else {
                return .black
            }
        } set {
            objc_setAssociatedObject(self, &leftLineColorAssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    @IBInspectable var leftLineWidth: CGFloat {
        get {
            return self.leftLineWidth
        }
        set {
            DispatchQueue.main.async {
                self.addLeftBorderWithColor(color: self.leftLineColor, width: newValue)
            }
        }
    }
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "topBorderLayer"
        removePreviouslyAddedLayer(name: border.name ?? "")
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y : 0,width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "rightBorderLayer"
        removePreviouslyAddedLayer(name: border.name ?? "")
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width : width, height :self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "bottomBorderLayer"
        removePreviouslyAddedLayer(name: border.name ?? "")
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,width : self.frame.size.width,height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.name = "leftBorderLayer"
        removePreviouslyAddedLayer(name: border.name ?? "")
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0,width : width, height : self.frame.size.height)
        self.layer.addSublayer(border)
    }
    func removePreviouslyAddedLayer(name : String) {
        if self.layer.sublayers?.count ?? 0 > 0 {
            self.layer.sublayers?.forEach {
                if $0.name == name {
                    $0.removeFromSuperlayer()
                }
            }
        }
    }
}


extension UIApplication {
    
    static func topViewController(rootViewController: UIViewController? = appDelegate.window?.rootViewController) -> UIViewController? {
        guard let rootViewController = rootViewController else {
            return nil
        }
        if (rootViewController.isKind(of: UITabBarController.self)) {
            return topViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
        } else if (rootViewController.isKind(of: UINavigationController.self)) {
            return topViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
        } else if (rootViewController.presentedViewController != nil) {
            return topViewController(rootViewController: rootViewController.presentedViewController)
        }
        return rootViewController
    }
    
}
extension UIAlertController {
    typealias AlertHandler = @convention(block) (UIAlertAction) -> Void
    
    func tapButton(atIndex index: Int) {
        guard let block = actions[index].value(forKey: "handler") else { return }
        let handler = unsafeBitCast(block as AnyObject, to: AlertHandler.self)
        handler(actions[index])
    }
}

extension Date {
    
    static func getCurrentDate() -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        return dateFormatter.string(from: Date())
        
    }
}


extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

private var highlightedBackgroundColors = [UIButton:UIColor]()
private var unhighlightedBackgroundColors = [UIButton:UIColor]()
extension UIButton {
    
    @IBInspectable var highlightedBackgroundColor: UIColor? {
        get {
            return highlightedBackgroundColors[self]
        }
        
        set {
            highlightedBackgroundColors[self] = newValue
        }
    }
    
    override open var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        
        set {
            unhighlightedBackgroundColors[self] = newValue
            super.backgroundColor = newValue
        }
    }
    
    override open var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        
        set {
            if highlightedBackgroundColor != nil {
                super.backgroundColor = newValue ? highlightedBackgroundColor : unhighlightedBackgroundColors[self]
            }
            super.isHighlighted = newValue
        }
    }
}
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
// remove multiple spaces in Strings source list
extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
extension UITextField {
    func isValidApprovalNo() -> Bool {
        let testStr = self
        let noRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let noTest = NSPredicate(format:"SELF MATCHES %@", noRegEx)
        return noTest.evaluate(with: testStr)
    }
}

//MARK:- Add dash border
extension UIView {
    func addDashBorder(color:UIColor = .green,width:CGFloat = 3,cornerRadius:CGFloat = 8) {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineDashPattern = [5, 2]
        shapeLayer.lineWidth = width
        shapeLayer.frame = self.bounds
        shapeLayer.fillColor = nil
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds,cornerRadius: cornerRadius).cgPath
        self.layer.masksToBounds = false
        self.layer.addSublayer(shapeLayer)
    }
        
}
extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
class Shadow: UIView {
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    override func layoutSubviews() {
        self.setup()
    }
    
    func setup() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 5.0
        self.cornerRadius = 8.0
        self.layer.masksToBounds = false
    }

}
