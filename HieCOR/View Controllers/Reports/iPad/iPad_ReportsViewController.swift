//
//  iPad_ReportsViewController.swift
//  HieCOR
//
//  Created by Rajshekar Pothu on 22/11/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class iPad_ReportsViewController: BaseViewController ,SWRevealViewControllerDelegate {
    
    //MARK: IBOutlet
    @IBOutlet weak var posLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var containerView_DrawerHistory: UIView!
    @IBOutlet weak var containerView_CurrentDrawer: UIView!
    @IBOutlet weak var containerView_CurrentDrawerDetail: UIView!
    @IBOutlet weak var containerView_DrawerHistoryDetail: UIView!
    @IBOutlet weak var containerView_EndDrawer: UIView!
    
    @IBOutlet weak var containerPayInPayOut: UIView!
    @IBOutlet weak var btn_Menu: UIButton!
    
    //MARK: Delegate
    var drawerHistoryDelegate: DetailReportViewControllerDelegate?
    var returnDelegate: DetailReportViewControllerDelegate?
    var currentDrawerDelegate: DetailReportViewControllerDelegate?
    var endDrawerDelegate: DetailReportViewControllerDelegate?
    
    var returnDrawerHistory: DetailReportViewControllerDelegate?
    var payinPayoutDelegate: PayInPayOutDelegate?
    
    var PayInOutViewControllerObj: PayInOutViewController?
    var currentVCObj : CurrentDrawerViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadViews()
        //Reset Header Text
        // self.headerLabel.text = "---"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Update Name
        if let name = DataManager.deviceNameText {
            posLabel.text = name
        }else {
            let nameDevice = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
            posLabel.text = nameDevice//UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reportList" {
            let vc = segue.destination as! ReportsViewController
            vc.drawerHistoryDelegate = self
            vc.PayInOutDelegate = self
        }
        if segue.identifier == "reportDetail" {
            let vc = segue.destination as! DetailReportViewController
            vc.currentDrawerDelegate = self
            drawerHistoryDelegate = vc as? DetailReportViewControllerDelegate
        }
        if segue.identifier == "drawerhistory" {
            let vc = segue.destination as! DrawerHistoryViewController
            vc.drawerHistoryDelegate = self
            returnDelegate = vc
        }
        if segue.identifier == "drawerhistorydetail" {
            let vc = segue.destination as! DrawerHistoryDetailViewController
            vc.drawerHistoryDelegate = self
            returnDrawerHistory = vc
        }
        if segue.identifier == "currentdrawer" {
            let vc = segue.destination as! CurrentDrawerViewController
            vc.currentDrawerDelegate = self
            vc.PayInOutDelegate = self
            currentDrawerDelegate = vc
            currentVCObj = vc
        }
        
        if segue.identifier == "PayInOutView" {
            let vc = segue.destination as! PayInOutViewController
            vc.PayInOutDelegate = self
            PayInOutViewControllerObj = vc
            vc.refreshCurrentVCDataDelegateObj = self
            
           // vc.refreshCurrentVCDataDelegateObj = self
            
            //currentDrawerDelegate = self
        }
        //        if segue.identifier == "enddrawer" {
        //            let vc = segue.destination as! EndDrawerViewController
        //            vc.endDrawerDelegate = self
        //            endDrawerDelegate = vc as? DetailReportViewControllerDelegate
        //        }
    }
    
    //Private Functions
    private func loadViews() {
        revealViewController().delegate = self
        if (self.revealViewController() != nil)
        {
            btn_Menu?.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        containerView_DrawerHistory.isHidden = true
        containerView_DrawerHistoryDetail.isHidden = true
        containerView_CurrentDrawerDetail.isHidden = true
        containerView_EndDrawer.isHidden = true
        // containerView_CurrentDrawer.isHidden = true
        
        UIApplication.shared.isStatusBarHidden = false
    }
    //MARK: IBAction
    @IBAction func btn_HomeAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "iPad", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController")
        appDelegate.window?.rootViewController = vc
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func btn_LockAction(_ sender: Any) {
        //...
    }
    
    @IBAction func btn_LogOutAction(_ sender: Any) {
        alertForLogOut()
    }
    
    
}
//MARK: ReportInfoViewControllerDelegate
extension iPad_ReportsViewController: DetailReportViewControllerDelegate {
    
    func didUpdateDrawerHistoryScreen(with data: JSONDictionary) {
        if data["show"] != nil
        {
            if data["show"] as! Bool == true
            {
                containerView_DrawerHistory.isHidden = false
                
            }
            else
            {
                containerView_DrawerHistory.isHidden = true
                
                
            }
            returnDelegate?.didUpdateDrawerHistoryScreen?(with: data)
        }
        if data["hide"] != nil
        {
            containerView_DrawerHistory.isHidden = true
        }
    }
    
    func didUpdateCurrentDrawerScreen(with data: JSONDictionary) {
        if data["show"] != nil
        {
            if data["show"] as! Bool == true
            {
                containerView_CurrentDrawerDetail.isHidden = false
                containerView_DrawerHistory.isHidden = true
                containerView_DrawerHistoryDetail.isHidden = true
            }
            else
            {
                containerView_CurrentDrawerDetail.isHidden = true
            }
            currentDrawerDelegate?.didUpdateCurrentDrawerScreen?(with: data)
            
        }
        if data["hide"] != nil
        {
            containerView_CurrentDrawerDetail.isHidden = true
        }
    }
    
    func didUpdateDrawerHistoryDetailScreen(with data: JSONDictionary) {
        if data["show"] != nil
        {
            if data["show"] as! Bool == true
            {
                containerView_DrawerHistoryDetail.isHidden = false
            }
            else
            {
                containerView_DrawerHistoryDetail.isHidden = true
            }
            returnDrawerHistory?.didUpdateDrawerHistoryDetailScreen?(with: data)
        }
        if data["hide"] != nil
        {
            containerView_DrawerHistoryDetail.isHidden = true
        }
    }
    
    func didUpdateDrawerHistoryDetailScreenEndDrawer(with data: JSONDictionary) {
        if data["show"] != nil
        {
            if data["show"] as! Bool == true
            {
                containerView_DrawerHistoryDetail.isHidden = false
            }
            else
            {
                containerView_DrawerHistoryDetail.isHidden = true
            }
            returnDrawerHistory?.didUpdateDrawerHistoryDetailScreenEndDrawer?(with: data)
        }
        if data["hide"] != nil
        {
            containerView_DrawerHistoryDetail.isHidden = true
        }
    }
    
    func checkEndDrawerScreen(with data: JSONDictionary) {
        if data["show"] != nil
        {
            if data["show"] as! Bool == true
            {
                containerView_CurrentDrawerDetail.isHidden = false
                containerView_DrawerHistory.isHidden = true
                containerView_DrawerHistoryDetail.isHidden = true
            }
            else
            {
                containerView_CurrentDrawerDetail.isHidden = true
            }
            currentDrawerDelegate?.checkEndDrawerScreen?(with: data)
        }
        if data["hide"] != nil
        {
            containerView_CurrentDrawerDetail.isHidden = true
        }
    }
    
    func checkEndDrawerCloseOrNot(with data: JSONDictionary) {
        if data["show"] != nil
        {
            if data["show"] as! Bool == true
            {
                containerView_CurrentDrawerDetail.isHidden = true
                containerView_DrawerHistory.isHidden = true
                containerView_DrawerHistoryDetail.isHidden = true
                containerView_CurrentDrawer.isHidden = false
            }
            else
            {
                containerView_CurrentDrawer.isHidden = true
            }
            currentDrawerDelegate?.checkEndDrawerScreen?(with: data)
        }
        if data["hide"] != nil
        {
            containerView_CurrentDrawer.isHidden = true
        }
    }
    
    func didUpdateHeaderText(with string: String) {
        self.headerLabel.text = string
    }
    
    //    func didEndDrawerScreen(with data: JSONDictionary) {
    //        if data["show"] != nil
    //        {
    //            if data["show"] as! Bool == true
    //            {
    //                containerView_EndDrawer.isHidden = false
    //
    //            }
    //            else
    //            {
    //                containerView_EndDrawer.isHidden = true
    //            }
    //            currentDrawerDelegate?.didEndDrawerScreen?(with: data)
    //        }
    //        if data["hide"] != nil
    //        {
    //            containerView_EndDrawer.isHidden = true
    //        }
    //    }
    
}

extension iPad_ReportsViewController: PayInPayOutDelegate {
    func showPayInPayOutView() {
        containerPayInPayOut.isHidden = false
    }
    
    func hidePayInPayOutView() {
        containerPayInPayOut.isHidden = true
        
    }
    func sendPayInPayOutViewData(expectedStr: String) {
        print("send data delegate call")
        PayInOutViewControllerObj!.getExpectedStrValue(expectedStr: expectedStr)
    }
    
    func didUpdateHeaderTextPay(with string: String) {
        self.headerLabel.text = string
    }
}

extension iPad_ReportsViewController : refreshCurrentVCDataDelegate {
    
    func refreshCurrentViewContollPayOutData(data: [DrawerHistoryModel]) {
        currentVCObj!.updateCurrentDrawerPaidOutDataByContainer(data: data)
    }
    
    func refreshCurrentViewContollPayInData(data: [DrawerHistoryModel]) {
        currentVCObj!.updateCurrentDrawerPaidInDataByContainer(data: data)
    }
    
}
