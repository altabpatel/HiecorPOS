//
//  OrdersViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 05/12/17.
//  Copyright © 2017 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SocketIO
class OrdersViewController: BaseViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var view_NavHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view_NavHeader: UIView!
    @IBOutlet weak var lbl_TotalOrders: UILabel!
    @IBOutlet var lbl_MonthYear: UILabel!
    @IBOutlet var tbl_Orders: UITableView!
    @IBOutlet var btn_Menu: UIButton!
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var lbl_customerNameAndID: UILabel!
    //MARK: Variables
    var isOrderSearch :Bool = false
    var FirstDateInMonth = String()
    var LastDateInMonth = String()
    var indexofPage:Int = 1
    var isDataLoading:Bool = false
    var isLastIndex: Bool = false
    var currentDate = Date()
    var orderId = String()
    var ACCEPTABLE_CHARACTERS = "0123456789"
    var ordersList = [String: [OrdersHistoryList]]()
    var orderInfoDelegate : OrderInfoViewControllerDelegate?
    let refreshControl = UIRefreshControl()
    var selectDefaultOrder = false
    var userHasOpenInvoice = false
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadSWRewealController()
        self.customizeUI()
        self.loadData()
        self.tbl_Orders.reloadData()
      
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UI_USER_INTERFACE_IDIOM() == .pad ? .default : .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            //Disable IQKeyboardManager
            IQKeyboardManager.shared.enableAutoToolbar = false
            if appDelegate.orderDataClear {// for pay invoice on payment method
                DataManager.cartData = nil
                DataManager.cartProductsArray = nil
                DataManager.customerObj = nil
                appDelegate.orderDataClear = false
              //  appDelegate.isOpenToOrderHistory = false
                HomeVM.shared.coupanDetail.code = ""
                HomeVM.shared.tipValue = 0.0
                DataManager.customerId = ""
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
            }
        }
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "Refresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh(notification:)), name: NSNotification.Name(rawValue: "Refresh"), object: nil)
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if UI_USER_INTERFACE_IDIOM() == .phone {
            //Enable IQKeyboardManager
            IQKeyboardManager.shared.enableAutoToolbar = true
        }
        //Remove Observer
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderinfo"
        {
            let vc = segue.destination as! OrderInfoViewController
            vc.orderID = orderId
            vc.delegateForCustomer = self
        }
    }
    
    //Handle Notification
    @objc func refresh(notification: NSNotification) {
        loadData()
    }

    //MARK: Private Functions
    private func loadSWRewealController() {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            let storyboard = UIStoryboard(name: "iPad", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController") as? SWRevealViewController
            if (vc != nil)
            {
                vc!.delegate = self
                btn_Menu?.addTarget(vc, action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
                self.view.addGestureRecognizer(vc!.panGestureRecognizer())
                self.view.addGestureRecognizer(vc!.tapGestureRecognizer())
            }
        }else {
            if (self.revealViewController() != nil)
            {
                revealViewController().delegate = self
                btn_Menu?.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            }
        }
    }
    
    private func customizeUI() {
        tbl_Orders.rowHeight = 75.0
        lbl_MonthYear.layer.borderWidth = 1.0
        lbl_MonthYear.layer.borderColor = UIColor.white.cgColor
        lbl_MonthYear.layer.cornerRadius = 17.0
        lbl_MonthYear.layer.masksToBounds = true
        //Mark changes by indore team
        searchBarTextField.keyboardType =  .numbersAndPunctuation
        
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            view_NavHeaderHeightConstraint.constant = 0.0
        }
        else
        {
            view_NavHeaderHeightConstraint.constant = 195.0
        }
        //Refresh Controller
        if #available(iOS 10.0, *) {
            tbl_Orders.refreshControl = refreshControl
            refreshControl.addTarget(self, action: #selector(refreshOrderHistory(_:)), for: .valueChanged)
        } else {
            tbl_Orders.addSubview(refreshControl)
        }
    }
    
    private func loadData() {
        indexofPage = 1
        let CurrentMonth = Calendar.current.date(byAdding: .month, value: 0, to: Date())
        currentDate = CurrentMonth!
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, yyyy"
        let myStringafd = formatter.string(from: CurrentMonth!)
        lbl_MonthYear.text = myStringafd
        searchBarTextField.text = ""
        getFirstAndLastDateInMonth(date: currentDate)
        tbl_Orders.tableFooterView = UIView()
        self.view.layoutIfNeeded()
    }
    
    private func updateCollection()
    {
        DispatchQueue.main.async {
            self.tbl_Orders?.reloadData()
            if (self.ordersList.count>0)
            {
                self.tbl_Orders?.isHidden = false
            }
            else
            {
                self.tbl_Orders?.isHidden = true
            }
        }
    }
    
    private func getFirstAndLastDateInMonth(date: Date)
    {
        // Set calendar and date
        let calendar = Calendar.current
        
        // Get range of days in month
        let range = calendar.range(of: .day, in: .month, for: currentDate)! // Range(1..<32)
        
        // Get first day of month
        var firstDayComponents = calendar.dateComponents([.year, .month], from: currentDate)
        firstDayComponents.day = range.lowerBound
        let firstDay = calendar.date(from: firstDayComponents)!
        
        // Get last day of month
        var lastDayComponents = calendar.dateComponents([.year, .month], from: currentDate)
        lastDayComponents.day = range.upperBound - 1
        let lastDay = calendar.date(from: lastDayComponents)!
        
        // Set date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        FirstDateInMonth = "\(dateFormatter.string(from: firstDay))T00:00:00"
        LastDateInMonth = "\(dateFormatter.string(from: lastDay))T24:00:00"
        
        self.isLastIndex = false
        indexofPage = 1
        ordersList.removeAll()
        self.tbl_Orders.reloadData()
        callAPItoGetOrder()
    }
    
    @objc private func refreshOrderHistory(_ sender: Any) {
        self.refreshControl.isHidden = false
        self.refreshControl.beginRefreshing()
        loadData()
    }
    
    //MARK: IBAction
    @IBAction func btn_PreviousMonthAction(_ sender: Any) {
        self.ordersList.removeAll()
        self.tbl_Orders.reloadData()
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)
        currentDate = previousMonth!
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM-yyyy"
        let myStringafd = formatter.string(from: previousMonth!)
        lbl_MonthYear.text = myStringafd
        
        getFirstAndLastDateInMonth(date: currentDate)
    }
    
    @IBAction func btn_NextMonth(_ sender: Any) {
        self.ordersList.removeAll()
        self.tbl_Orders.reloadData()
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)
        currentDate = nextMonth!
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM-yyyy"
        let myStringafd = formatter.string(from: nextMonth!)
        lbl_MonthYear.text = myStringafd
        
        getFirstAndLastDateInMonth(date: currentDate)
        
    }
    
    @IBAction func btn_BackAction(_ sender: Any) {
        //...
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return  ordersList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let keys = ordersList.keys.sorted { (key1, key2) -> Bool in
            return key1 > key2
        }
        return ordersList[keys[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell()
        cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let keys = ordersList.keys.sorted { (key1, key2) -> Bool in
            return key1 > key2
        }
        var tempOrd = ordersList[keys[indexPath.section]]!
        
        let lbl_OrderID = cell.contentView.viewWithTag(1) as? UILabel
        lbl_OrderID?.text = "#\(tempOrd[indexPath.row].order_id)"
        
        let lbl_OrderStatus = cell.contentView.viewWithTag(3) as? UILabel
        lbl_OrderStatus?.text = tempOrd[indexPath.row].status
        
        let lbl_OrderTotal = cell.contentView.viewWithTag(2) as? UILabel
        let total = NSString(string: tempOrd[indexPath.row].total)
        lbl_OrderTotal?.text = total.doubleValue.currencyFormat
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if selectDefaultOrder {
                if tempOrd[indexPath.row].order_id == orderId {
                    if tempOrd[indexPath.row].background_color == "" || tempOrd[indexPath.row].background_color == "transparent" || tempOrd[indexPath.row].background_color == "white"{
                        cell.contentView.backgroundColor = tempOrd[indexPath.row].test_order == 1 ? #colorLiteral(red: 0.9960784314, green: 0.9019607843, blue: 0.3019607843, alpha: 1) : UIColor(red: 235.0/255, green: 248.0/255, blue: 254.0/255, alpha: 0.8)  //: UIColor(red: 254.0/255, green: 231.0/255, blue: 78.0/255, alpha: 1.0)
                    }else if tempOrd[indexPath.row].background_color == "red" {
                        cell.contentView.backgroundColor = .red.darker()
                    } else {
                        let color = UIColor(hexCode: tempOrd[indexPath.row].background_color)
                        cell.contentView.backgroundColor = color?.darker()
                    }
                } else {
                    if tempOrd[indexPath.row].background_color == "" || tempOrd[indexPath.row].background_color == "transparent" || tempOrd[indexPath.row].background_color == "white"{
                        cell.contentView.backgroundColor = tempOrd[indexPath.row].test_order == 1 ? #colorLiteral(red: 0.9882352941, green: 0.9764705882, blue: 0.5843137255, alpha: 1)  :  UIColor.white
                    }else if tempOrd[indexPath.row].background_color == "red" {
                        cell.contentView.backgroundColor = .red
                    }else {
                        let color = UIColor(hexCode: tempOrd[indexPath.row].background_color)
                        cell.contentView.backgroundColor = color
                    }
                    //cell.contentView.backgroundColor = tempOrd[indexPath.row].order_id == orderId ? UIColor(red: 235.0/255, green: 248.0/255, blue: 254.0/255, alpha: 0.8) : UIColor.white
                }
                
                
            }else{
                if tempOrd[indexPath.row].background_color == "" || tempOrd[indexPath.row].background_color == "transparent" || tempOrd[indexPath.row].background_color == "white"{
                    cell.contentView.backgroundColor = tempOrd[indexPath.row].test_order == 1 ? #colorLiteral(red: 0.9882352941, green: 0.9764705882, blue: 0.5843137255, alpha: 1)  :  UIColor.white
                }else if tempOrd[indexPath.row].background_color == "red" {
                    cell.contentView.backgroundColor = .red
                }else {
                    let color = UIColor(hexCode: tempOrd[indexPath.row].background_color)
                    cell.contentView.backgroundColor = color
                }
            }
            //cell.contentView.backgroundColor = tempOrd[indexPath.row].order_id == orderId ? UIColor(red: 235.0/255, green: 248.0/255, blue: 254.0/255, alpha: 0.8) : UIColor.white
        }else{
            if tempOrd[indexPath.row].background_color == "" || tempOrd[indexPath.row].background_color == "transparent" || tempOrd[indexPath.row].background_color == "white"{
                cell.contentView.backgroundColor = tempOrd[indexPath.row].test_order == 1 ? #colorLiteral(red: 0.9882352941, green: 0.9764705882, blue: 0.5843137255, alpha: 1)  :  UIColor.white
            }else if tempOrd[indexPath.row].background_color == "red" {
                cell.contentView.backgroundColor = .red
            }else {
                let color = UIColor(hexCode: tempOrd[indexPath.row].background_color)
                cell.contentView.backgroundColor = color
            }
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let keys = ordersList.keys.sorted { (key1, key2) -> Bool in
            return key1 > key2
        }
        var tempSelectOrd = ordersList[keys[indexPath.section]]!
        
        orderId = tempSelectOrd[indexPath.row].order_id
        
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            selectDefaultOrder = true
            orderInfoDelegate?.didGetOrderInformation?(with: orderId, defualtView: false)
            tbl_Orders.reloadData()
        }
        else
        {
            //Offline
            if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline {
                return
            }
            //Online
            self.performSegue(withIdentifier: "orderinfo", sender: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tbl_Orders.dequeueReusableCell(withIdentifier: "cellsection")
        let lbl_Date = cell?.contentView.viewWithTag(1) as? UILabel
        let keys = ordersList.keys.sorted { (key1, key2) -> Bool in
            return key1 > key2
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.date(from: keys[section]) ?? Date()
        
        lbl_Date?.text = newDate.stringFromDate(format: .newDateTime2, type: .local)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 40
    }
    
}

//MARK: UIScrollViewDelegate
extension OrdersViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if (tbl_Orders!.contentOffset.y + tbl_Orders!.frame.height) >= (tbl_Orders!.contentSize.height - 50) {
            if !isOrderSearch {
                if ordersList.count > 0 {
                    indexofPage = indexofPage + 1
                    isOrderSearch = false
                    //callAPItoGetOrder()
                     isOrderSearch == true ? self.callAPItoSearchOrder(): self.callAPItoGetOrder()
                }
            }
        }
    }
}

//MARK: UISearchBarDelegate
extension OrdersViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEmpty {
            /*
             //   self.ordersList.removeAll()
             Commet for screen saver auto hide keyboard functionality
             by altab
             */
            self.tbl_Orders.reloadData()
        }
        //Custom Toolbar for iPhone
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return
        }
        
        
//        searchBarTextField.autocorrectionType = .no
//        SwipeAndSearchVC.shared.isSearchWithScanner = true
//        //Hide Tool Bar
//        let shortcut: UITextInputAssistantItem? = searchBarTextField.inputAssistantItem
//        shortcut?.leadingBarButtonGroups = []
//        shortcut?.trailingBarButtonGroups = []
//
//        searchBarTextField.tintColor = UIColor.clear
//        tbl_Orders?.isUserInteractionEnabled = true
//        SwipeAndSearchVC.shared.isSearchWithScanner = true

        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(self.searchAction))
        doneButton.tintColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelAction))
        cancelButton.tintColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if DataManager.isScreenSaverOnThenKeyboardHide {
              self.tbl_Orders.reloadData()
            return
        }
        if !textField.isEmpty {
//            if Keyboard._isExternalKeyboardAttached() {
//                searchBarTextField.resignFirstResponder()
//                SwipeAndSearchVC.shared.enableTextField()
//            }
            
            isOrderSearch = !(textField.text == "")
            isOrderSearch = true
            self.isLastIndex = true
            indexofPage = 1
            ordersList.removeAll()
            self.tbl_Orders.reloadData()
            self.orderId = ""
            self.callAPItoSearchOrder()
        }else{
//            if Keyboard._isExternalKeyboardAttached() {
//                searchBarTextField.resignFirstResponder()
//                SwipeAndSearchVC.shared.enableTextField()
//            }
            isOrderSearch = false
            self.isLastIndex = false
            indexofPage = 1
            ordersList.removeAll()
            self.tbl_Orders.reloadData()
            self.orderId = ""
            callAPItoGetOrder()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let cs = CharacterSet.alphanumerics.inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        if string == " " && textField.text != "" {
            return true
        }
        if string == "\n" {
            textField.resignFirstResponder()
            return true
        }
        if range.location == 0 && string == " " {
            return false
        }

        return string == filtered
        
//        if string.contains(UIPasteboard.general.string ?? "") && string.containEmoji {
//            return false
//        }
//
//        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
//            return false
//        }
//
//        if string == "\n" {
//            textField.resignFirstResponder()
//            return true
//        }
//        if range.location == 0 && string == " " {
//            return false
//        }
//        // mark change by indore team
//
//        //let cs = string.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).filter({!isEmpty($0)})  //NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
//        let filtered = string.components(separatedBy: "").joined(separator: "")
//        return string == filtered
      //  return true
    }
    
    @objc func searchAction() {
        searchBarTextField.resignFirstResponder()
    }
    
    @objc func cancelAction() {
        searchBarTextField.resignFirstResponder()
    }
    
}

//MARK: SWRevealViewControllerDelegate
extension OrdersViewController: SWRevealViewControllerDelegate {
    func revealController(_ revealController: SWRevealViewController, willMoveTo position: FrontViewPosition) {
        if position == FrontViewPositionRight {
            self.view.alpha = 0.5
            self.view.endEditing(true)
            
        }
        else if position == FrontViewPositionLeft {
            self.view.alpha = 1.0
        }
        //Hide Keyboard
        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }
}

//MARK: API Methods
extension OrdersViewController {
    
    func callAPItoGetOrder() {
        var stringUrl = String()
        if DataManager.customerId != "" {
        if let customerObj = DataManager.customerObj {
            let str_first_name = customerObj["str_first_name"] as? String ?? ""
            let str_last_name = customerObj["str_last_name"] as? String ?? ""
            if str_first_name == "" && str_last_name == ""  {
                self.lbl_customerNameAndID.text = "Order For Customer #\(DataManager.customerId)"
            }else{
                self.lbl_customerNameAndID.text = "Order For \(str_first_name) \(str_last_name) (#\(DataManager.customerId))"
            }
        }
        }else{
            self.lbl_customerNameAndID.text = ""
        }
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            if DataManager.customerId != "" { // For customer order data fetch
                stringUrl = String(format: "%@%@%@",BaseURL, kOrdersList,"&sort=order_id&sortBy=DESC&perpage=20&page=\(indexofPage)&userID=\(DataManager.customerId)")
            } else {
                stringUrl = String(format: "%@%@%@",BaseURL, kOrdersList,"&sort=order_id&sortBy=DESC&perpage=20&page=\(indexofPage)")
            }
        }
        else
        {
            if DataManager.customerId != "" { // For customer order data fetch
                stringUrl = String(format: "%@%@%@%@%@%@%@",BaseURL, kOrdersList,"&dateFrom=",FirstDateInMonth,"&dateTo=",LastDateInMonth, "&sort=order_id&sortBy=DESC&perpage=20&page=\(indexofPage)&userID=\(DataManager.customerId)")
            } else {
                stringUrl = String(format: "%@%@%@%@%@%@%@",BaseURL, kOrdersList,"&dateFrom=",FirstDateInMonth,"&dateTo=",LastDateInMonth, "&sort=order_id&sortBy=DESC&perpage=20&page=\(indexofPage)")
            }
           // stringUrl = String(format: "%@%@%@%@%@%@%@",BaseURL, kOrdersList,"&dateFrom=",FirstDateInMonth,"&dateTo=",LastDateInMonth, "&sort=order_id&sortBy=DESC&perpage=20&page=\(indexofPage)")
        }
        
        if indexofPage == 1 {
            OrderVM.shared.ordersList.removeAll()
            ordersList.removeAll()
            OrderVM.shared.totalRecord = "0"
            self.lbl_TotalOrders.text = OrderVM.shared.totalRecord
            self.tbl_Orders.reloadData()
        }
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            Indicator.isEnabledIndicator = false
            Indicator.sharedInstance.showIndicator()
        }
        
        if refreshControl.isRefreshing{
            Indicator.isEnabledIndicator = false
        }
        
        let startDate = UI_USER_INTERFACE_IDIOM() == .phone ? FirstDateInMonth : nil
        let endDate = UI_USER_INTERFACE_IDIOM() == .phone ? LastDateInMonth : nil

       // SwipeAndSearchVC.shared.isSearchWithScanner = false

        OrderVM.shared.getOrder(url: stringUrl, startDate: startDate, endDate: endDate, pageNumber: indexofPage) { (success, message, error) in
            if success == 1 {
                
                if !OrderVM.shared.isMoreOrderFound {
                    self.indexofPage = self.indexofPage - 1
                }
                
                self.lbl_TotalOrders.text = OrderVM.shared.totalRecord
                self.ordersList.removeAll()
                self.ordersList = OrderVM.shared.ordersList
                self.tbl_Orders?.reloadData()
                if appDelegate.authOrderIdForOrderHistory  != ""{
                    self.orderId = appDelegate.authOrderIdForOrderHistory
                    
                }
                if UI_USER_INTERFACE_IDIOM() == .pad && self.orderId == ""
                {
//                    if self.ordersList.count > 0 {
//                        let keys = self.ordersList.keys.sorted { (key1, key2) -> Bool in
//                            return key1 > key2
//                        }
//                        let tempOrd = self.ordersList[keys[0]]!
//                        if tempOrd.count > 0 {
//                            self.orderId = tempOrd.first!.order_id
//                            self.orderInfoDelegate?.didGetOrderInformation?(with: tempOrd.first!.order_id, defualtView: true)
//                        }
//                    }
                    // INVOICE order info show when customer select
                    // Cusromer INVOICE order info showing
                    if DataManager.customerId != "" {
                        let sortOrderArry = self.ordersList.sorted { (key1, key2) -> Bool in
                            return key1.key > key2.key
                        }
                        
                        DispatchQueue.main.async {
                            outer: for arr in sortOrderArry {
                                print(arr.key)
                                for obj in arr.value {
                                    print(obj.order_id)
                                    print("\(obj.status)")
                                    if obj.status == "INVOICE" {
                                        self.orderId = obj.order_id
                                        print("INVOICE Fetch \(obj.order_id)")
                                        self.selectDefaultOrder = true
                                        self.orderInfoDelegate?.didGetOrderInformation?(with:obj.order_id, defualtView: false)
                                        self.tbl_Orders?.reloadData()
                                         break outer
                                    }
                                }
                            }
                        }
                    } else{
                        if self.ordersList.count > 0 {
                            let keys = self.ordersList.keys.sorted { (key1, key2) -> Bool in
                                return key1 > key2
                            }
                            let tempOrd = self.ordersList[keys[0]]!
                            if tempOrd.count > 0 {
                                self.orderId = tempOrd.first!.order_id
                                self.orderInfoDelegate?.didGetOrderInformation?(with: tempOrd.first!.order_id, defualtView: true)
                            }
                        }
                    }
                } else if UI_USER_INTERFACE_IDIOM() == .phone && self.orderId == "" {
                    if DataManager.customerId != "" {
                        let sortOrderArry = self.ordersList.sorted { (key1, key2) -> Bool in
                            return key1.key > key2.key
                        }
                        DispatchQueue.main.async {
                            outer: for arr in sortOrderArry {
                                print(arr.key)
                                for obj in arr.value {
                                    print(obj.order_id)
                                    print("\(obj.status)")
                                    if obj.status == "INVOICE" {
                                        self.orderId = obj.order_id
                                        print("INVOICE Fetch \(obj.order_id)")
                                        self.selectDefaultOrder = true
                                        self.performSegue(withIdentifier: "orderinfo", sender: nil)
                                        self.tbl_Orders?.reloadData()
                                        break outer
                                    }
                                }
                            }
                        }
                    }
                }else if UI_USER_INTERFACE_IDIOM() == .phone && appDelegate.isOpenUrl {
                    self.selectDefaultOrder = true
                    self.performSegue(withIdentifier: "orderinfo", sender: nil)
                    self.tbl_Orders?.reloadData()
                }else {
                    if UI_USER_INTERFACE_IDIOM() == .pad {
                        Indicator.isEnabledIndicator = true
                        Indicator.sharedInstance.hideIndicator()
                    }
                }
                if self.orderId  == "" {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                }
//                if UI_USER_INTERFACE_IDIOM() == .pad {
//                    if !Keyboard._isExternalKeyboardAttached() && DataManager.isBarCodeReaderOn {
//                        self.searchBarTextField.becomeFirstResponder()
//                    }
//                }
            }
            else {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                    if self.ordersList.count == 0 {
                        self.orderInfoDelegate?.didGetOrdersListNotFound?(defualtView: true)
                    }
                }
                self.tbl_Orders?.reloadData()
                
                if  message != nil {
                    //self.showAlert(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
            if self.refreshControl.isRefreshing{
                Indicator.isEnabledIndicator = true
            }
            self.refreshControl.endRefreshing()
            self.refreshControl.isHidden = true
        }
    }
    
    func callAPItoSearchOrder() {
        if indexofPage == 1 {
            ordersList.removeAll()
            OrderVM.shared.ordersList.removeAll()
            OrderVM.shared.totalRecord = "0"
            self.lbl_TotalOrders.text = OrderVM.shared.totalRecord
            self.tbl_Orders.reloadData()
        }
    
        if UI_USER_INTERFACE_IDIOM() == .pad {
            Indicator.isEnabledIndicator = false
            Indicator.sharedInstance.showIndicator()
        }
        
        if refreshControl.isRefreshing{
            Indicator.isEnabledIndicator = false
        }
        var stringUrl = ""
        if DataManager.customerId != "" {
            stringUrl = String(format: "%@","\(searchBarTextField.text ?? "0")&userID=\(DataManager.customerId)")

        }else {
            stringUrl = searchBarTextField.text ?? "0"

        }
        if DataManager.customerId != "" {
        if let customerObj = DataManager.customerObj {
            let str_first_name = customerObj["str_first_name"] as? String ?? ""
            let str_last_name = customerObj["str_last_name"] as? String ?? ""
            if str_first_name == "" && str_last_name == ""  {
                self.lbl_customerNameAndID.text = "Order For Customer #\(DataManager.customerId)"
            }else{
                self.lbl_customerNameAndID.text = "Order For \(str_first_name) \(str_last_name) (#\(DataManager.customerId))"
            }
        }
        }else{
            self.lbl_customerNameAndID.text = ""
        }

//        SwipeAndSearchVC.shared.isSearchWithScanner = false

        //Call API
        OrderVM.shared.getSearchOrder(searchText: stringUrl,pageNumber: indexofPage, responseCallBack: { (success, message, error) in
            if success == 1 {
                
                if !OrderVM.shared.isMoreOrderFound {
                    self.indexofPage = self.indexofPage - 1
                }
                self.lbl_TotalOrders.text = OrderVM.shared.totalRecord
                self.ordersList = OrderVM.shared.ordersList
                self.tbl_Orders?.reloadData()
                
                if UI_USER_INTERFACE_IDIOM() == .pad && self.orderId == ""
                {
                    self.tbl_Orders.reloadData()
                    if self.ordersList.count > 0 {
                        let keys = self.ordersList.keys.sorted()
                        let tempOrd = self.ordersList[keys[0]]!
                        if tempOrd.count > 0 {
                            self.orderId = tempOrd.first!.order_id
                            self.orderInfoDelegate?.didGetOrderInformation?(with: tempOrd.first!.order_id, defualtView: false)
                        }
                    }
                }
                else {
                    if UI_USER_INTERFACE_IDIOM() == .pad {
                        Indicator.isEnabledIndicator = true
                        Indicator.sharedInstance.hideIndicator()
                    }
                }
//                if UI_USER_INTERFACE_IDIOM() == .pad {
//                    if !Keyboard._isExternalKeyboardAttached() && DataManager.isBarCodeReaderOn {
//                        self.searchBarTextField.becomeFirstResponder()
//                    }
//                }
            }
            else {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                    self.orderInfoDelegate?.didGetOrdersListNotFound?(defualtView: true)
                }
                self.tbl_Orders?.reloadData()
                
                if  message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
            if self.refreshControl.isRefreshing{
                Indicator.isEnabledIndicator = true
            }
            self.refreshControl.endRefreshing()
            self.refreshControl.isHidden = true
        })
    }
}

extension OrdersViewController: CustomerPickupDelegete {
    func reloadDataByCustomerPickUp() {
        isOrderSearch == true ? self.callAPItoSearchOrder(): self.callAPItoGetOrder()
    }
}
