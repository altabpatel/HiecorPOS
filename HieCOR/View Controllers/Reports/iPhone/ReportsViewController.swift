//
//  ReportsViewController.swift
//  HieCOR
//
//  Created by Rajshekar Pothu on 22/11/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class ReportsViewController: BaseViewController {

    //MARK: Variables
    private var array_List = Array<Any>()
    @IBOutlet var tbl_Reports: UITableView!
    var drawerHistoryDelegate : DetailReportViewControllerDelegate?
   // var currentDrawerDelegate: DetailReportViewControllerDelegate?
    var PayInOutDelegate : PayInPayOutDelegate?
    
    private var array_currentDrawer = [DrawerHistoryModel]()
    
    var checkDrawerEnd : Bool = false
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Load Data
        
        tbl_Reports.isScrollEnabled = false
        if let data = UserDefaults.standard.object(forKey: "account_type") as? String {
            if data == "Administrator" {
                array_List = ["Current Drawer", "Drawer History"]
            } else {
                array_List = ["Current Drawer"]
            }
        } else {
            array_List = ["Current Drawer"]
        }
        
        tbl_Reports.tableFooterView = UIView()
        if UI_USER_INTERFACE_IDIOM() == .pad {
                callAPItoCheckDrawerEnd()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("CheckDrawerEnd"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationEndDrawer(notification:)), name: Notification.Name("CheckEndDrawerEnd"), object: nil)

    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        self.checkDrawerEnd = false
    }
    
    @objc func methodOfReceivedNotificationEndDrawer(notification: Notification) {
        self.checkDrawerEnd = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(row: 0, section: 0)
        tbl_Reports.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
    
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "reports" {
//            let vc = segue.destination as! DetailReportViewController
//
//        }
//    }
    
}


//MARK: UITableViewDataSource, UITableViewDelegate
extension ReportsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_List.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.default
        cell.labelTitle.text = array_List[indexPath.row] as? String
        cell.labelTitle.textColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let cell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
//        cell.labelTitle.backgroundColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
//        cell.labelTitle.textColor = UIColor.white
//        cell.labelTitle.layer.shadowColor = UIColor.gray.cgColor
//        cell.labelTitle.layer.shadowOffset = CGSize.zero
//        cell.labelTitle.layer.shadowOpacity = 0.3
//        cell.labelTitle.layer.shadowRadius = 5.0
//        cell.labelTitle.layer.cornerRadius = 8
        
        cell.viewBase.backgroundColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
                cell.labelTitle.textColor = UIColor.white
                cell.viewBase.layer.shadowColor = UIColor.gray.cgColor
                cell.viewBase.layer.shadowOffset = CGSize.zero
                cell.viewBase.layer.shadowOpacity = 0.3
                cell.viewBase.layer.shadowRadius = 5.0
                cell.viewBase.layer.cornerRadius = 3
                cell.labelTitle.backgroundColor = .clear
        
        
        
        
        cell.contentView.backgroundColor = UIColor.white
        self.PayInOutDelegate?.hidePayInPayOutView!()
        
        if indexPath.row == 0 {
            
            if checkDrawerEnd == true {
                let returnData = ["show":true ] as [String : Any]
                drawerHistoryDelegate?.checkEndDrawerCloseOrNot?(with: returnData)
                drawerHistoryDelegate?.didUpdateHeaderText?(with: "Cash Drawer")
                checkDrawerEnd = true
            }else{
                let returnData = ["show":true] as [String : Any]
                drawerHistoryDelegate?.didUpdateCurrentDrawerScreen?(with: returnData)
                drawerHistoryDelegate?.didUpdateHeaderText?(with: "Current Drawer")
                checkDrawerEnd = false
            }
            callAPItoCheckDrawerEnd()
        }
            
        if indexPath.row == 1 {
            let returnData = ["show":true] as [String : Any]
            drawerHistoryDelegate?.didUpdateDrawerHistoryScreen?(with: returnData)
            if checkDrawerEnd != false {
                checkDrawerEnd = true
            }else if checkDrawerEnd == false{
                checkDrawerEnd = false
            }else{
                checkDrawerEnd = true
            }
           
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
//            cell.labelTitle.textColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
//            cell.labelTitle.layer.shadowColor = UIColor.gray.cgColor
//            cell.labelTitle.layer.shadowOffset = CGSize.zero
//            cell.labelTitle.layer.shadowOpacity = 0.3
//            cell.labelTitle.layer.cornerRadius = 8
//            cell.labelTitle.layer.shadowRadius = 5.0
                        cell.viewBase.backgroundColor = .white
                        cell.labelTitle.textColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
                        cell.viewBase.layer.shadowColor = UIColor.gray.cgColor
                        cell.viewBase.layer.shadowOffset = CGSize.zero
                        cell.viewBase.layer.shadowOpacity = 0.3
                        cell.viewBase.layer.cornerRadius = 3
                        cell.viewBase.layer.shadowRadius = 5.0

            
        }else{
            let cell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
//            cell.labelTitle.textColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
//            cell.labelTitle.layer.shadowColor = UIColor.gray.cgColor
//            cell.labelTitle.layer.shadowOffset = CGSize.zero
//            cell.labelTitle.layer.shadowOpacity = 0.3
//            cell.labelTitle.layer.cornerRadius = 8
//            cell.labelTitle.layer.shadowRadius = 5.0
            cell.viewBase.backgroundColor = .white
            cell.labelTitle.textColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
            cell.viewBase.layer.shadowColor = UIColor.gray.cgColor
            cell.viewBase.layer.shadowOffset = CGSize.zero
            cell.viewBase.layer.shadowOpacity = 0.3
            cell.viewBase.layer.cornerRadius = 3
            cell.viewBase.layer.shadowRadius = 5.0
           
        }
   
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell:MenuTableViewCell = cell as! MenuTableViewCell
            cell.setSelected(true, animated: true)
//            cell.labelTitle.backgroundColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
//            cell.labelTitle.textColor = UIColor.white
//            cell.labelTitle.layer.shadowColor = UIColor.gray.cgColor
//            cell.labelTitle.layer.shadowOffset = CGSize.zero
//            cell.labelTitle.layer.shadowOpacity = 0.3
//            cell.labelTitle.layer.shadowRadius = 5.0
//            cell.labelTitle.layer.cornerRadius = 8
            cell.contentView.backgroundColor = UIColor.white
            cell.viewBase.backgroundColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
            cell.labelTitle.textColor = UIColor.white
            cell.viewBase.layer.shadowColor = UIColor.gray.cgColor
            cell.viewBase.layer.shadowOffset = CGSize.zero
            cell.viewBase.layer.shadowOpacity = 0.3
            cell.viewBase.layer.shadowRadius = 5.0
            cell.viewBase.layer.cornerRadius = 3
            cell.labelTitle.backgroundColor = .clear
        }else{
            let cell:MenuTableViewCell = cell as! MenuTableViewCell
            cell.viewBase.layer.shadowColor = UIColor.gray.cgColor
            cell.viewBase.layer.shadowOffset = CGSize.zero
            cell.viewBase.layer.shadowOpacity = 0.3
            cell.viewBase.layer.shadowRadius = 5.0
            cell.viewBase.layer.cornerRadius = 3
            cell.labelTitle.backgroundColor = .clear
            cell.contentView.backgroundColor = UIColor.white
            cell.setSelected(false, animated: false)

        }

      
    }

}
//MARK: API Methods
extension ReportsViewController : DetailReportViewControllerDelegate {
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
                 let datavalue = OrderVM.shared.checkDrawerEnd
                DispatchQueue.main.async {
                    if UI_USER_INTERFACE_IDIOM() == .pad {
                        Indicator.sharedInstance.hideIndicator()
                        if datavalue.count == 0 {
                            
                            let returnData = ["show":true] as [String : Any]
                            self.drawerHistoryDelegate?.checkEndDrawerCloseOrNot?(with: returnData)
                            self.checkDrawerEnd = true
                            DataManager.isDrawerOpen = false
                        }else{
                            let returnData = ["show":true , "items":OrderVM.shared.checkDrawerEnd] as [String : Any]
                            self.drawerHistoryDelegate?.checkEndDrawerScreen?(with: returnData)
                            self.drawerHistoryDelegate?.didUpdateHeaderText?(with: "Current Drawer")
                            self.checkDrawerEnd = false
                            DataManager.isDrawerOpen = true
                        }
                       
                    }else{
                        //self.performSegue(withIdentifier: <#T##String#>, sender: nil)
                    }
                }
                
               
            }else {
                DispatchQueue.main.async {
                    if UI_USER_INTERFACE_IDIOM() == .pad {
                        Indicator.sharedInstance.hideIndicator()
                        let returnData = ["show":true] as [String : Any]
                        self.drawerHistoryDelegate?.checkEndDrawerCloseOrNot?(with: returnData)
                        self.checkDrawerEnd = true
                        DataManager.isDrawerOpen = false
                    }
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
