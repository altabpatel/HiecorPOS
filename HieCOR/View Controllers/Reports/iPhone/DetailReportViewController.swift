//
//  DetailReportViewController.swift
//  HieCOR
//
//  Created by Rajshekar Pothu on 23/11/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

@objc protocol DetailReportViewControllerDelegate: class {
    @objc optional func didUpdateDrawerHistoryScreen(with data: JSONDictionary)
    @objc optional func didUpdateCurrentDrawerScreen(with data: JSONDictionary)
    @objc optional func didUpdateDrawerHistoryDetailScreen(with data: JSONDictionary)
    @objc optional func didUpdateDrawerHistoryDetailScreenEndDrawer(with data: JSONDictionary)
    @objc optional func didEndDrawerScreen(with data: JSONDictionary)
    @objc optional func checkEndDrawerScreen(with data: JSONDictionary)
    @objc optional func checkEndDrawerCloseOrNot(with data: JSONDictionary)
    @objc optional func didUpdateHeaderText(with string: String)
}

class DetailReportViewController: BaseViewController ,UITextFieldDelegate{
    
    //MARK: Variables
    private var array_currentDrawer = [DrawerHistoryModel]()
    
    private var array_ListOpen = [DrawerHistoryModel]()
    private var array_ListEnd = [DrawerHistoryModel]()
    
    
    private var isLastIndex: Bool = false
    private var indexofPage :Int = 1
    private var searchFetchOffset:Int = 0
    private var searchFetchLimit:Int = 10
    private var searchPageCount: Int = 1
    
    //MARK: IBOutlet
    @IBOutlet weak var view_NavHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view_NavHeader: UIView!
    @IBOutlet weak var view_CashDrawer: UIView!
    // @IBOutlet weak var viewDrawerHistory: UIView!
    @IBOutlet weak var btnTwiceZero: UIButton!
    @IBOutlet weak var tfNumbers: UITextField!
    @IBOutlet weak var btnDrawerHistory: UIButton!
    @IBOutlet weak var btnCurrentDrawer: UIButton!
    @IBOutlet weak var viewBase: UIView!
    @IBOutlet var btn_Menu: UIButton!
    //  @IBOutlet var tbl_DrawerHistory: UITableView!
    
    @IBOutlet weak var viewMsg: UIView!
    @IBOutlet weak var viewDrawerHistory: UIView!
    @IBOutlet weak var tableEndDrawer: UITableView!
    @IBOutlet weak var tableOpenDrawer: UITableView!
    
    var istableOpen = false
    
    //MARK: Delegate
    var currentDrawerDelegate : DetailReportViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = UserDefaults.standard.object(forKey: "account_type") as? String {
            if data == "Administrator" {
                btnDrawerHistory.isHidden = false
            } else {
                btnDrawerHistory.isHidden = true
            }
        } else {
            btnDrawerHistory.isHidden = true
        }
        //DataManager.isDrawerOpen = false
        
        if (self.revealViewController() != nil)
        {
            revealViewController().delegate = self as? SWRevealViewControllerDelegate
            btn_Menu?.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        self.customizeUI()
        loadData()
        initializeVariables()
        // tbl_DrawerHistory.tableFooterView = UIView()
        if UI_USER_INTERFACE_IDIOM() == .phone {
            callAPItoCheckDrawerEnd()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func loadData() {
        indexofPage = 1
        //isCategory = false
        array_ListEnd.removeAll()
        tableEndDrawer.reloadData()
    }
    
    private func initializeVariables() {
        indexofPage = 1
        searchFetchOffset = 0
        searchFetchLimit = 20
        searchPageCount = 1
    }
    
    
    func customizeUI()  {
        
        //        viewBase.layer.shadowColor = UIColor.gray.cgColor
        //        viewBase.layer.shadowOffset = CGSize.zero
        //        viewBase.layer.shadowOpacity = 0.5
        //        viewBase.layer.cornerRadius = 4
        //        viewBase.layer.shadowRadius = 3
        
        viewDrawerHistory.isHidden = true
        
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            view_NavHeaderHeightConstraint.constant = 0.0
        }
        else
        {
            view_NavHeaderHeightConstraint.constant = 150.0
            
            btnCurrentDrawer.backgroundColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
            btnCurrentDrawer.setTitleColor(.white, for: .normal)
            btnCurrentDrawer.layer.shadowColor = UIColor.gray.cgColor
            btnCurrentDrawer.layer.shadowOffset = CGSize.zero
            btnCurrentDrawer.layer.shadowOpacity = 0.3
            btnCurrentDrawer.layer.shadowRadius = 5.0
            btnCurrentDrawer.layer.cornerRadius = 5
        }
    }
    
    //MARK: Action
    @IBAction func buttonStartDrawerAction(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.8862745098, green: 0.9294117647, blue: 0.9647058824, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  .white
        }
        let inputStr:String = tfNumbers.text ?? ""
        if  inputStr == "" || (inputStr as NSString).integerValue < 0 {
//            self.showAlert(message: "Please Enter Amount")
             appDelegate.showToast(message: "Please Enter Amount")
            return
        }else{
            loadCurrentDrawer()
        }
        
    }
    @IBAction func actionNumbers(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.8862745098, green: 0.9294117647, blue: 0.9647058824, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  .white
        }
        let tag = sender.tag
        if let text = tfNumbers.text {
            if text.contains(".") {
                let indexOfDot = text.distance(from: text.startIndex, to: text.index(of: ".")!)
                let totalIndexes = text.count - 1
                if (totalIndexes - indexOfDot) < 2 {
                    tfNumbers.text = "\(text)\(tag)"
                }
            } else {
                tfNumbers.text = "\(text)\(tag)"
            }
        } else {
            tfNumbers.text = "\(tag)"
        }
    }
    
    @IBAction func actionTwiceZero(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.8862745098, green: 0.9294117647, blue: 0.9647058824, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  .white
        }
        if let text = tfNumbers.text {
            if btnTwiceZero.tag == 00 {
                tfNumbers.text = "\(text)\(0)\(0)"
            }
        }
    }
    
    @IBAction func actionPoint(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.8862745098, green: 0.9294117647, blue: 0.9647058824, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  .white
        }
        if let text = tfNumbers.text {
            if !text.contains("."){
                tfNumbers.text = text.count == 0 ? "0\(text)." : "\(text)."
            }
        }else{
            tfNumbers.text = "0."
        }
    }
    
    @IBAction func actionBackRemove(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.8862745098, green: 0.9294117647, blue: 0.9647058824, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  .white
        }
        if let text = tfNumbers.text , text.count > 0 {
            let start = text.index(text.startIndex, offsetBy: 0)
            let end = text.index(text.endIndex, offsetBy: -1)
            let result = text[start..<end]
            tfNumbers.text = String(result)
        }
    }
    
    @IBAction func actionCurrentDrawer(_ sender: UIButton) {
        viewDrawerHistory.isHidden = true
        view_CashDrawer.isHidden = false
        
        btnCurrentDrawer.backgroundColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
        btnCurrentDrawer.setTitleColor(.white, for: .normal)
        btnCurrentDrawer.layer.shadowColor = UIColor.gray.cgColor
        btnCurrentDrawer.layer.shadowOffset = CGSize.zero
        btnCurrentDrawer.layer.shadowOpacity = 0.3
        btnCurrentDrawer.layer.shadowRadius = 5.0
        btnCurrentDrawer.layer.cornerRadius = 5
        
        btnDrawerHistory.backgroundColor = UIColor.white
        btnDrawerHistory.setTitleColor(UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0), for: .normal)
        btnDrawerHistory.layer.shadowColor = UIColor.gray.cgColor
        btnDrawerHistory.layer.shadowOffset = CGSize.zero
        btnDrawerHistory.layer.shadowOpacity = 0.3
        btnDrawerHistory.layer.shadowRadius = 5.0
        btnDrawerHistory.layer.cornerRadius = 5
    }
    
    @IBAction func actionDrawerHistory(_ sender: UIButton) {
        viewDrawerHistory.isHidden = false
        callAPItoGetDrawerHistory()
        btnCurrentDrawer.backgroundColor = UIColor.white
        btnCurrentDrawer.setTitleColor(UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0), for: .normal)
        btnCurrentDrawer.layer.shadowColor = UIColor.gray.cgColor
        btnCurrentDrawer.layer.shadowOffset = CGSize.zero
        btnCurrentDrawer.layer.shadowOpacity = 0.3
        btnCurrentDrawer.layer.shadowRadius = 5.0
        btnCurrentDrawer.layer.cornerRadius = 5
        
        btnDrawerHistory.backgroundColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
        btnDrawerHistory.setTitleColor(.white, for: .normal)
        btnDrawerHistory.layer.shadowColor = UIColor.gray.cgColor
        btnDrawerHistory.layer.shadowOffset = CGSize.zero
        btnDrawerHistory.layer.shadowOpacity = 0.3
        btnDrawerHistory.layer.shadowRadius = 5.0
        btnDrawerHistory.layer.cornerRadius = 5
        
        
    }
    
    
    func loadCurrentDrawer() {
        
        //Device Name
        var str_DeviceName = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
        if let name = DataManager.deviceNameText {
            str_DeviceName = name
        }
        
        //Parameters
        let parameters: JSONDictionary = [
            "userID":DataManager.userID,
            "start_amount": tfNumbers.text ?? 0.0,
            "status":"open",
            "description":"",
            "end_amount":"0",
            "source":str_DeviceName
        ]
        
        NotificationCenter.default.post(name: Notification.Name("CheckDrawerEnd"), object: self.callAPItoStartDrawer(parameters: parameters))
        
        
        //callAPItoStartDrawer
        // self.callAPItoStartDrawer(parameters: parameters)
    }
    
    //MARK: API Methods
    
    func callAPItoStartDrawer(parameters: JSONDictionary) {
        HomeVM.shared.startDrawer(parameters: parameters) { (success, message, error) in
            if success == 1 {
                self.array_currentDrawer = HomeVM.shared.currentDrawerDetail
                DataManager.isDrawerOpen = true
                //DataManager.deviceName = false
                if UI_USER_INTERFACE_IDIOM() == .pad
                {
                    let returnData = ["show":true , "items":HomeVM.shared.currentDrawerDetail] as [String : Any]
                    self.currentDrawerDelegate?.didUpdateCurrentDrawerScreen?(with: returnData)
                    self.currentDrawerDelegate?.didUpdateHeaderText?(with: "Current Drawer")
                }else{
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "CurrentDrawerViewController") as! CurrentDrawerViewController
                    controller.currentDrawerDetailData = HomeVM.shared.currentDrawerDetail
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }else {
                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    
    //MARK: Textfield Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            textField.resignFirstResponder()
            //Inilialize SwipeReader Class
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension DetailReportViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            if tableView == tableOpenDrawer{
                return array_ListOpen.count
            }else{
                return array_ListEnd.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewMsg.isHidden = true
        if array_ListOpen.count == 0 {
            viewMsg.isHidden = false
        }else{
            if tableView == tableOpenDrawer{
                viewMsg.isHidden = true
                istableOpen = true
                let kCell = tableView.dequeueReusableCell(withIdentifier: "OpenDrawerCell", for: indexPath) as! OpenDrawerCell
                kCell.labelTotal.text = array_ListOpen[indexPath.row].total_amount
                kCell.labelEndTime.text = array_ListOpen[indexPath.row].last_action
                let userNameLogin = array_ListOpen[indexPath.row].username_login
                let username = array_ListOpen[indexPath.row].user_name
                
                let first = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]
                let second = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)]
                
                let partOne = NSMutableAttributedString(string: username, attributes: first)
                let partTwo = NSMutableAttributedString(string: "(" + userNameLogin + ")", attributes: second)
                
                let combination = NSMutableAttributedString()
                
                combination.append(partOne)
                combination.append(partTwo)
                
                if userNameLogin == ""{
                    kCell.lblUsername.text = username
                }else{
                    kCell.lblUsername.attributedText =  combination
                }
                kCell.lblSalesLocation.text = array_ListOpen[indexPath.row].source
                //kCell.accessoryType = .disclosureIndicator
                kCell.selectionStyle = .none
                return kCell
            }
        }
        
        if tableView == tableEndDrawer{
            viewMsg.isHidden = true
            istableOpen = false
            let kCell = tableView.dequeueReusableCell(withIdentifier: "EndDrawerCell", for: indexPath) as! EndDrawerCell
            kCell.labelTotal.text = array_ListEnd[indexPath.row].total_amount
            kCell.labelEndTime.text = array_ListEnd[indexPath.row].last_action
            let userNameLogin = array_ListEnd[indexPath.row].username_login
            let username = array_ListEnd[indexPath.row].user_name
            
            let first = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]
            let second = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)]
            
            let partOne = NSMutableAttributedString(string: username, attributes: first)
            let partTwo = NSMutableAttributedString(string: "(" + userNameLogin + ")", attributes: second)
            
            let combination = NSMutableAttributedString()
            
            combination.append(partOne)
            combination.append(partTwo)
            
            if userNameLogin == ""{
                kCell.lblUsername.text = username
            }else{
                kCell.lblUsername.attributedText =  combination
            }
            kCell.lblSalesLocation.text = array_ListEnd[indexPath.row].source
            // kCell.accessoryType = .disclosureIndicator
            kCell.selectionStyle = .none
            return kCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "DrawerHistoryDetailViewController") as! DrawerHistoryDetailViewController
            
            if tableView == tableOpenDrawer {
                controller.drawerDetailData = array_ListOpen[indexPath.row]
            }else{
                controller.drawerDetailEndData = array_ListEnd[indexPath.row]
                controller.str_DrawerId = array_ListEnd[indexPath.row].cashdrawerID
                controller.isEndDrawer = true
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UI_USER_INTERFACE_IDIOM() == .phone {
            if tableView == tableOpenDrawer{
                if array_ListOpen.count == 1{
                    tableOpenDrawer.isScrollEnabled = false
                    tableOpenDrawer.alwaysBounceVertical = false
                    return 100
                }else if array_ListOpen.count == 2{
                    tableOpenDrawer.isScrollEnabled = false
                    tableOpenDrawer.alwaysBounceVertical = false
                    return 200
                }else if array_ListOpen.count == 3{
                    tableOpenDrawer.isScrollEnabled = false
                    tableOpenDrawer.alwaysBounceVertical = false
                    return 300
                }else if array_ListOpen.count > 3{
                    tableOpenDrawer.isScrollEnabled = true
                    tableOpenDrawer.alwaysBounceVertical = true
                    return UITableViewAutomaticDimension
                }
            }else{
                return 100
            }
        }
        return UITableViewAutomaticDimension
    }
}

//MARK: API Methods
extension DetailReportViewController {
    func callAPItoGetDrawerHistory() {
        //Device Name
        var str_DeviceName = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
        if let name = DataManager.deviceNameText {
            str_DeviceName = name
        }
        
        OrderVM.shared.getDrawerHistory(source: str_DeviceName.encodeUrl(), pageNumber: indexofPage) { (success, message, error) in
            if success == 1 {
                self.array_ListOpen.removeAll()
                self.array_ListOpen = OrderVM.shared.drawerHistoryOpen
                self.tableOpenDrawer.reloadData()
                
                if !OrderVM.shared.isMoreEndDrawerFound {
                    self.indexofPage = self.indexofPage - 1
                }
                
                self.array_ListEnd.removeAll()
                self.array_ListEnd = OrderVM.shared.drawerHistoryEnd
                self.tableEndDrawer.reloadData()
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
            }else {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    Indicator.sharedInstance.hideIndicator()
                }
                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if (tableEndDrawer!.contentOffset.y + tableEndDrawer!.frame.height) >= (tableEndDrawer!.contentSize.height - 50) {
            if array_ListEnd.count > 0 {
                indexofPage = indexofPage + 1
                callAPItoGetDrawerHistory()
            }
        }
    }
    
}
//MARK: API Methods
extension DetailReportViewController {
    func callAPItoCheckDrawerEnd() {
        //Device Name
        var str_DeviceName = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
        if let name = DataManager.deviceNameText {
            str_DeviceName = name
        }
        Indicator.sharedInstance.showIndicator()
        OrderVM.shared.checkDrawerEnd(source: str_DeviceName){ (success, message, error) in
            DispatchQueue.main.async {
                Indicator.sharedInstance.hideIndicator()
            }
            if success == 1 {
                DispatchQueue.main.async {
                    self.array_ListOpen = OrderVM.shared.checkDrawerEnd
                    if self.array_ListOpen.count == 0 {
                        DataManager.isDrawerOpen = false
                        //                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        //                    let controller = storyboard.instantiateViewController(withIdentifier: "DetailReportViewController") as! DetailReportViewController
                        //                    self.navigationController?.pushViewController(controller, animated: true)
                    }else{
                        DataManager.isDrawerOpen = true
                        //DataManager.deviceName = false
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "CurrentDrawerViewController") as! CurrentDrawerViewController
                        controller.currentDrawerDetailData = OrderVM.shared.checkDrawerEnd
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
                
                
            }else {
                DataManager.isDrawerOpen = false
                DispatchQueue.main.async {
                Indicator.sharedInstance.hideIndicator()
                //   self.performSegue(withIdentifier: "reports", sender: nil)
                
                if message != nil {
                    // self.showAlert(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
                }
            }
        }
    }
    
    
}
