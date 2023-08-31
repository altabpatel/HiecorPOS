//
//  DrawerHistoryViewController.swift
//  HieCOR
//
//  Created by Rajshekar Pothu on 23/11/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class DrawerHistoryViewController: BaseViewController ,SWRevealViewControllerDelegate{
    
    
    //MARK: Variables
    private var array_ListOpen = [DrawerHistoryModel]()
    private var array_ListEnd = [DrawerHistoryModel]()
    
    @IBOutlet weak var viewMsg: UIView!
    @IBOutlet var tbl_EndDrawer: UITableView!
    //MARK: IBOutlets
    @IBOutlet var tbl_OpenDrawer: UITableView!
    @IBOutlet var btn_Menu: UIButton!
    @IBOutlet weak var view_NavHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view_NavHeader: UIView!
    @IBOutlet weak var tableviewOpenDrawerHeightConstant: NSLayoutConstraint!
    var istableOpen = false
    
    private var isLastIndex: Bool = false
    private var indexofPage :Int = 1
    private var searchFetchOffset:Int = 0
    private var searchFetchLimit:Int = 10
    private var searchPageCount: Int = 1
    
    var currentDrawerDelegate : DetailReportViewControllerDelegate?
    var drawerHistoryDelegate : DetailReportViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeUI()
        initializeVariables()
        loadData()
        // tbl_DrawerHistory.tableFooterView = UIView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            // callAPItoGetDrawerHistory()
        }
    }
    
    func loadData() {
        indexofPage = 1
        //isCategory = false
        array_ListEnd.removeAll()
        tbl_EndDrawer.reloadData()
    }
    
    func customizeUI()  {
        
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            view_NavHeaderHeightConstraint.constant = 0.0
            view_NavHeader.isHidden = true
        }
        else
        {
            view_NavHeaderHeightConstraint.constant = 60.0
            view_NavHeader.isHidden = true
        }
    }
    
    private func initializeVariables() {
        indexofPage = 1
        searchFetchOffset = 0
        searchFetchLimit = 20
        searchPageCount = 1
    }
    
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension DrawerHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tbl_OpenDrawer{
            return array_ListOpen.count
        }else{
            return array_ListEnd.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewMsg.isHidden = true
        if array_ListOpen.count == 0 {
            viewMsg.isHidden = false
        }else{
            if tableView == tbl_OpenDrawer{
                viewMsg.isHidden = true
                istableOpen = true
                let kCell = tableView.dequeueReusableCell(withIdentifier: "OpenDrawerCell", for: indexPath) as! OpenDrawerCell
                kCell.labelTotal.text = array_ListOpen[indexPath.row].total_amount
                kCell.labelEndTime.text = array_ListOpen[indexPath.row].last_action
                let userNameLogin = array_ListOpen[indexPath.row].username_login
                //let userNameLogin = "Hiecor"
                let username = array_ListOpen[indexPath.row].user_name
                
                let first = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]
                let second = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)]
                
                let partOne = NSMutableAttributedString(string: username, attributes: first)
                let partTwo = NSMutableAttributedString(string: " (" + userNameLogin + ")", attributes: second)
                
                let combination = NSMutableAttributedString()
                
                combination.append(partOne)
                combination.append(partTwo)
                
                if userNameLogin == ""{
                    kCell.lblUsername.text = username
                }else{
                    kCell.lblUsername.attributedText =  combination
                }
                kCell.lblSalesLocation.text = array_ListOpen[indexPath.row].source 
                kCell.selectionStyle = .none
                return kCell
            }
        }
        
        if tableView == tbl_EndDrawer{
            viewMsg.isHidden = true
            istableOpen = false
            let kCell = tableView.dequeueReusableCell(withIdentifier: "EndDrawerCell", for: indexPath) as! EndDrawerCell
            kCell.labelTotal.text = array_ListEnd[indexPath.row].total_amount
            kCell.labelEndTime.text = array_ListEnd[indexPath.row].last_action
            let userNameLogin = array_ListEnd[indexPath.row].username_login
            //let userNameLogin = "Hiecor"
            let username = array_ListEnd[indexPath.row].user_name
            
            let first = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)]
            let second = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)]
            
            let partOne = NSMutableAttributedString(string: username, attributes: first)
            let partTwo = NSMutableAttributedString(string: " (" + userNameLogin + ")", attributes: second)
            
            let combination = NSMutableAttributedString()
            
            combination.append(partOne)
            combination.append(partTwo)
            
            if userNameLogin == ""{
                kCell.lblUsername.text = username
            }else{
                kCell.lblUsername.attributedText =  combination
            }
            kCell.lblSalesLocation.text = array_ListEnd[indexPath.row].source
            kCell.selectionStyle = .none
            return kCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tbl_OpenDrawer{
            let returnData = ["show":true , "items":array_ListOpen[indexPath.row]] as [String : Any]
            drawerHistoryDelegate?.didUpdateDrawerHistoryDetailScreen?(with: returnData)
        }else{
            let returnDataEnd = ["show":true , "items":array_ListEnd[indexPath.row]] as [String : Any]
            drawerHistoryDelegate?.didUpdateDrawerHistoryDetailScreenEndDrawer?(with: returnDataEnd)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            if array_ListOpen.count == 1{
                tbl_OpenDrawer.isScrollEnabled = false
                tbl_OpenDrawer.alwaysBounceVertical = false
                tableviewOpenDrawerHeightConstant.constant = 100
                return UITableViewAutomaticDimension
            }else if array_ListOpen.count == 2{
                tbl_OpenDrawer.isScrollEnabled = false
                tbl_OpenDrawer.alwaysBounceVertical = false
                tableviewOpenDrawerHeightConstant.constant = 200
                return UITableViewAutomaticDimension
            }else if array_ListOpen.count > 2{
                tbl_OpenDrawer.isScrollEnabled = true
                tbl_OpenDrawer.alwaysBounceVertical = true
                tableviewOpenDrawerHeightConstant.constant = 230
                return UITableViewAutomaticDimension
            }
            if tableView == tbl_EndDrawer{
                return UITableViewAutomaticDimension
            }
        }else{
            if array_ListOpen.count == 1{
                tbl_OpenDrawer.isScrollEnabled = false
                tbl_OpenDrawer.alwaysBounceVertical = false
                tableviewOpenDrawerHeightConstant.constant = 100
                return UITableViewAutomaticDimension
            }else if array_ListOpen.count == 2{
                tbl_OpenDrawer.isScrollEnabled = false
                tbl_OpenDrawer.alwaysBounceVertical = false
                tableviewOpenDrawerHeightConstant.constant = 200
                return UITableViewAutomaticDimension
            }else if array_ListOpen.count == 3{
                tbl_OpenDrawer.isScrollEnabled = false
                tbl_OpenDrawer.alwaysBounceVertical = false
                tableviewOpenDrawerHeightConstant.constant = 300
                return UITableViewAutomaticDimension
            }else if array_ListOpen.count > 3{
                tbl_OpenDrawer.isScrollEnabled = true
                tbl_OpenDrawer.alwaysBounceVertical = true
                tableviewOpenDrawerHeightConstant.constant = 300
                return UITableViewAutomaticDimension
            }
        }
        return UITableViewAutomaticDimension
    }
}

//MARK: DetailReportViewControllerDelegate
extension DrawerHistoryViewController: DetailReportViewControllerDelegate {
    
    func didUpdateDrawerHistoryScreen(with data: JSONDictionary) {
        
        drawerHistoryDelegate?.didUpdateHeaderText?(with: "Drawer History")
        callAPItoGetDrawerHistory()
        
    }
}

//MARK: API Methods
extension DrawerHistoryViewController {
    func callAPItoGetDrawerHistory() {
        //Device Name
        var str_DeviceName = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
        if let name = DataManager.deviceNameText {
            str_DeviceName = name
        }
        
        OrderVM.shared.getDrawerHistory(source: str_DeviceName.encodeUrl(), pageNumber: indexofPage){ (success, message, error) in
            if success == 1 {
                self.array_ListOpen.removeAll()
                self.array_ListOpen = OrderVM.shared.drawerHistoryOpen
                
                print("self.array_ListOpen",self.array_ListOpen)
                print("array_ListEnd", self.array_ListEnd)
                // self.array_ListOpen.reverse()
                self.tbl_OpenDrawer.reloadData()
                
                if !OrderVM.shared.isMoreEndDrawerFound {
                    self.indexofPage = self.indexofPage - 1
                }
                
                self.array_ListEnd.removeAll()
                self.array_ListEnd = OrderVM.shared.drawerHistoryEnd
                self.tbl_EndDrawer.reloadData()
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
                
            }else {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    Indicator.sharedInstance.hideIndicator()
                }
                if message != nil {
                    // self.showAlert(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        
        if (tbl_EndDrawer!.contentOffset.y + tbl_EndDrawer!.frame.height) >= (tbl_EndDrawer!.contentSize.height - 50) {
            if array_ListEnd.count > 0 {
                indexofPage = indexofPage + 1
                callAPItoGetDrawerHistory()
            }
        }
    }
    
}
