//
//  CurrentDrawerViewController.swift
//  HieCOR
//
//  Created by Rajshekar Pothu on 23/11/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class CurrentDrawerViewController: BaseViewController {
    
    //MARK: Variables
    var currentDrawerDetailData = [DrawerHistoryModel]()
    
    private var array_ListOpen = [DrawerHistoryModel]()
    private var array_ListEnd = [DrawerHistoryModel]()
    
    //MARK: IBOutlet
    
    @IBOutlet weak var payInOutVew: UIView!
    @IBOutlet weak var tableEnd: UITableView!
    @IBOutlet weak var viewMsg: UIView!
    @IBOutlet weak var tableOpen: UITableView!
    @IBOutlet weak var tfDescription1: UITextField!
    @IBOutlet var tfDescription: UITextField!
    @IBOutlet var viewDescription: UIView!
    @IBOutlet weak var view_NavHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view_iPadHeaderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var view_NavHeader: UIView!
    @IBOutlet weak var view_DrawerHistory: UIView!
    @IBOutlet weak var view_CurrentDrawer: UIView!
    @IBOutlet weak var lblStarted: UILabel!
    @IBOutlet weak var lblStartingCash: UILabel!
    @IBOutlet weak var lblCashRefund: UILabel!
    @IBOutlet weak var lblCashSales: UILabel!
    @IBOutlet weak var lblPaidIn: UILabel!
    @IBOutlet weak var lblPaidOut: UILabel!
    @IBOutlet weak var lblExpectedDrawer: UILabel!
    @IBOutlet weak var lblDifference: UILabel!
    @IBOutlet weak var lblActualInDrawer: UILabel!
    @IBOutlet weak var lblPaidInAmount: UILabel!
    @IBOutlet weak var lblPaidInTime: UILabel!
    @IBOutlet weak var lblPaidOutAmount: UILabel!
    @IBOutlet weak var lblPaidOutTime: UILabel!
    @IBOutlet weak var btnPayInOut: UIButton!
    @IBOutlet weak var btnEndDrawer: UIButton!
    @IBOutlet var btn_Menu: UIButton!
    @IBOutlet weak var btnDrawerHistory: UIButton!
    @IBOutlet weak var btnCurrentDrawer: UIButton!
    @IBOutlet weak var buttonEndDrawer: UIButton!
    @IBOutlet weak var buttonPayInOut: UIButton!
    @IBOutlet var tbl_DrawerHistory: UITableView!
    @IBOutlet var scroller: UIScrollView!
    
    var currentDrawerDelegate : DetailReportViewControllerDelegate?
    var endDrawerDelegate : DetailReportViewControllerDelegate?
    var PayInOutDelegate : PayInPayOutDelegate?
    var PayInOutViewControllerObj: PayInOutViewController?
    
    private var isLastIndex: Bool = false
    private var indexofPage :Int = 1
    private var searchFetchOffset:Int = 0
    private var searchFetchLimit:Int = 10
    private var searchPageCount: Int = 1
    var istableOpen = false
    var strExpectedDrawer = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view_DrawerHistory.isHidden = true
        
        if let data = UserDefaults.standard.object(forKey: "account_type") as? String {
            if data == "Administrator" {
                btnDrawerHistory.isHidden = false
            } else {
                btnDrawerHistory.isHidden = true
            }
        } else {
            btnDrawerHistory.isHidden = true
        }
        
        self.customizeUI()
        initializeVariables()
        loadData()
        // tbl_DrawerHistory.tableFooterView = UIView()
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            loadiPhoneCurrentDrawerData()
        }
    }
    
    func loadData() {
        indexofPage = 1
        //isCategory = false
        array_ListEnd.removeAll()
        tableEnd.reloadData()
    }
    private func initializeVariables() {
        indexofPage = 1
        searchFetchOffset = 0
        searchFetchLimit = 20
        searchPageCount = 1
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.revealViewController() != nil)
        {
            revealViewController().delegate = self as? SWRevealViewControllerDelegate
            btn_Menu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    
    
    func loadiPhoneCurrentDrawerData() {
        if currentDrawerDetailData.count>0
        {
            for i in (0...currentDrawerDetailData.count-1)
            {
                
                lblStarted.text = currentDrawerDetailData[i].started
                lblStartingCash.text = "$\(currentDrawerDetailData[i].starting_cash)"
                lblCashRefund.text = "$\(currentDrawerDetailData[i].cash_refunds)"
                lblCashSales.text = "$\(currentDrawerDetailData[i].cash_sales)"
                //  lblExpectedDrawer.text = "$\(currentDrawerDetailData[i].expected_in_drawer)"
                lblActualInDrawer.text = "$\(currentDrawerDetailData[i].actualin_drawer)"
                lblDifference.text = "$\(currentDrawerDetailData[i].drawer_difference)"
                lblPaidIn.text = "$\(currentDrawerDetailData[i].paid_in)"
                lblPaidOut.text = "$\(currentDrawerDetailData[i].paid_out)"
                var newValue = ""
                let expected : String = (currentDrawerDetailData[i].expected_in_drawer)
                let replaced = expected.replacingOccurrences(of: ",", with: "")
                var expected_in_drawer = (replaced as NSString).doubleValue
                
                if (expected_in_drawer < 0) {
                    expected_in_drawer = -(expected_in_drawer);
                    newValue = "-$\(expected_in_drawer)"
                } else {
                    newValue = "$\(expected_in_drawer)"
                }
                
                if newValue == "$-0.00" {
                    newValue = "$0.00"
                }
                lblExpectedDrawer.text = newValue
                strExpectedDrawer = newValue
                print("strExpectedDrawer",strExpectedDrawer)
            }
        }
    }
    
    private func customizeUI() {
        
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            view_NavHeaderHeightConstraint.constant = 0.0
            
            view_NavHeader.isHidden = true
            btnEndDrawer.layer.shadowColor = UIColor.gray.cgColor
            btnEndDrawer.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            btnEndDrawer.layer.shadowOpacity = 0.4//0.8
            btnEndDrawer.layer.shadowRadius = 8.0
            btnEndDrawer.backgroundColor = UIColor.white
            btnEndDrawer.titleLabel?.textColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
            btnEndDrawer.cornerRadius = 3
            btnPayInOut.layer.shadowColor = UIColor.gray.cgColor
            btnPayInOut.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            btnPayInOut.layer.shadowOpacity = 0.4//0.8
            btnPayInOut.layer.shadowRadius = 8.0
            btnPayInOut.backgroundColor = UIColor.white
            btnPayInOut.titleLabel?.textColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
            btnPayInOut.cornerRadius = 3
            viewDescription.layer.shadowColor = UIColor.gray.cgColor
            viewDescription.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            viewDescription.layer.shadowOpacity = 0.4
            viewDescription.layer.shadowRadius = 8.0
            viewDescription.backgroundColor = UIColor.white
            viewDescription.cornerRadius = 3
            //btnPayInOut.titleLabel?.textColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
        }
        else
        {
            view_NavHeaderHeightConstraint.constant = 322.0
            view_iPadHeaderHeightConstraint.constant = 0.0
            
            btnCurrentDrawer.backgroundColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
            btnCurrentDrawer.setTitleColor(.white, for: .normal)
            btnCurrentDrawer.layer.shadowColor = UIColor.gray.cgColor
            btnCurrentDrawer.layer.shadowOffset = CGSize.zero
            btnCurrentDrawer.layer.shadowOpacity = 0.3
            btnCurrentDrawer.layer.shadowRadius = 5.0
            btnCurrentDrawer.layer.cornerRadius = 5
            
            buttonPayInOut.backgroundColor = UIColor.white
            buttonPayInOut.setTitleColor(UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0), for: .normal)
            buttonPayInOut.layer.shadowColor = UIColor.gray.cgColor
            buttonPayInOut.layer.shadowOffset = CGSize.zero
            buttonPayInOut.layer.shadowOpacity = 0.3
            buttonPayInOut.layer.shadowRadius = 5.0
            buttonPayInOut.layer.cornerRadius = 5
            
            buttonEndDrawer.backgroundColor = UIColor.white
            buttonEndDrawer.setTitleColor(UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0), for: .normal)
            buttonEndDrawer.layer.shadowColor = UIColor.gray.cgColor
            buttonEndDrawer.layer.shadowOffset = CGSize.zero
            buttonEndDrawer.layer.shadowOpacity = 0.3
            buttonEndDrawer.layer.shadowRadius = 5.0
            buttonEndDrawer.layer.cornerRadius = 5
            
            btnDrawerHistory.backgroundColor = UIColor.white
            btnDrawerHistory.setTitleColor(UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0), for: .normal)
            btnDrawerHistory.layer.shadowColor = UIColor.gray.cgColor
            btnDrawerHistory.layer.shadowOffset = CGSize.zero
            btnDrawerHistory.layer.shadowOpacity = 0.3
            btnDrawerHistory.layer.shadowRadius = 5.0
            btnDrawerHistory.layer.cornerRadius = 5
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enddrawer" {
            let vc = segue.destination as! EndDrawerViewController
            vc.strDescription = self.tfDescription.text!
            vc.endDrawerDetailData = currentDrawerDetailData
        }
        if segue.identifier == "payinout" {
            let vc = segue.destination as! PayInOutViewController
            vc.currentDrawerVC = self
            vc.strExpectedInDrawer = strExpectedDrawer
        }
        
        if UI_USER_INTERFACE_IDIOM() == .phone
        {
            if segue.identifier == "NewPayInOut" {
                let vc = segue.destination as! PayInOutViewController
                vc.PayInOutDelegate = self
                PayInOutDelegate = self
                //vc.strExpectedInDrawer = strExpectedDrawer
                PayInOutViewControllerObj = vc
                vc.refreshCurrentVCDataForIphoneDelegateObj = self
            }
        }
        
    }
    // MARK: - Action:-
    @IBAction func buttonPayInOutAction(_ sender: Any) {
  /*      let vc = self.storyboard?.instantiateViewController(withIdentifier: "PayInOutViewController") as! PayInOutViewController
        vc.currentDrawerVC = self
        vc.strExpectedInDrawer = strExpectedDrawer
        self.navigationController?.pushViewController(vc, animated: true)
        // self.currentDrawerDelegate?.didUpdateHeaderText?(with: "End Drawer")
   */
        
        PayInOutDelegate?.didUpdateHeaderTextPay?(with: "Pay In/Pay Out")
        PayInOutDelegate?.sendPayInPayOutViewData?(expectedStr: strExpectedDrawer)
        PayInOutDelegate?.showPayInPayOutView?()
    }
    
    @IBAction func buttonEndDrawerAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EndDrawerViewController") as! EndDrawerViewController
        vc.endDrawerDetailData = currentDrawerDetailData
        vc.strDescription = self.tfDescription1.text!
        self.navigationController?.pushViewController(vc, animated: true)
        // self.currentDrawerDelegate?.didUpdateHeaderText?(with: "End Drawer")
        //        let returnData = ["show":true ] as [String : Any]
        //        currentDrawerDelegate?.didEndDrawerScreen?(with: returnData)
        
    }
    
    @IBAction func PayInOutActioniPhone(_ sender: Any) {
        PayInOutDelegate?.sendIphonePayInPayOutViewData?(expectedStr: strExpectedDrawer)
        
        self.payInOutVew.isHidden = false
        view_DrawerHistory.isHidden = true
        view_CurrentDrawer.isHidden = false
        scroller.isHidden = true
        view_NavHeaderHeightConstraint.constant = 140//155.0
        
//        view_DrawerHistory.isHidden = true
//        view_CurrentDrawer.isHidden = false
//        scroller.isHidden = false
//        view_NavHeaderHeightConstraint.constant = 322.0
        
       // PayInOutDelegate?.showIphonePayInOut!()
        //  self.performSegue(withIdentifier: "payinout", sender: nil)
        buttonPayInOut.backgroundColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
        buttonPayInOut.setTitleColor(.white, for: .normal)
        buttonPayInOut.layer.shadowColor = UIColor.gray.cgColor
        buttonPayInOut.layer.shadowOffset = CGSize.zero
        buttonPayInOut.layer.shadowOpacity = 0.3
        buttonPayInOut.layer.shadowRadius = 5.0
        buttonPayInOut.layer.cornerRadius = 5
        
        buttonEndDrawer.backgroundColor = UIColor.white
        buttonEndDrawer.setTitleColor(UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0), for: .normal)
        buttonEndDrawer.layer.shadowColor = UIColor.gray.cgColor
        buttonEndDrawer.layer.shadowOffset = CGSize.zero
        buttonEndDrawer.layer.shadowOpacity = 0.3
        buttonEndDrawer.layer.shadowRadius = 5.0
        buttonEndDrawer.layer.cornerRadius = 5
    }
    
    @IBAction func EndDrawerActioniPhone(_ sender: Any) {
        
        //  self.performSegue(withIdentifier: "enddrawer", sender: nil)
        buttonEndDrawer.backgroundColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
        buttonEndDrawer.setTitleColor(.white, for: .normal)
        buttonEndDrawer.layer.shadowColor = UIColor.gray.cgColor
        buttonEndDrawer.layer.shadowOffset = CGSize.zero
        buttonEndDrawer.layer.shadowOpacity = 0.3
        buttonEndDrawer.layer.shadowRadius = 5.0
        buttonEndDrawer.layer.cornerRadius = 5
        
        buttonPayInOut.backgroundColor = UIColor.white
        buttonPayInOut.setTitleColor(UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0), for: .normal)
        buttonPayInOut.layer.shadowColor = UIColor.gray.cgColor
        buttonPayInOut.layer.shadowOffset = CGSize.zero
        buttonPayInOut.layer.shadowOpacity = 0.3
        buttonPayInOut.layer.shadowRadius = 5.0
        buttonPayInOut.layer.cornerRadius = 5
        
    }
    
    @IBAction func DrawerHistoryActioniPhone(_ sender: Any) {
        view_DrawerHistory.isHidden = false
        view_CurrentDrawer.isHidden = true
        self.payInOutVew.isHidden = true
        scroller.isHidden = true
        view_NavHeaderHeightConstraint.constant = 155.0
        callAPItoGetDrawerHistory()
        
        btnDrawerHistory.backgroundColor = UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0)
        btnDrawerHistory.setTitleColor(.white, for: .normal)
        btnDrawerHistory.layer.shadowColor = UIColor.gray.cgColor
        btnDrawerHistory.layer.shadowOffset = CGSize.zero
        btnDrawerHistory.layer.shadowOpacity = 0.3
        btnDrawerHistory.layer.shadowRadius = 5.0
        btnDrawerHistory.layer.cornerRadius = 5
        
        btnCurrentDrawer.backgroundColor = UIColor.white
        btnCurrentDrawer.setTitleColor(UIColor(red: 42.0/255, green:123.0/255, blue: 195.0/255, alpha: 1.0), for: .normal)
        btnCurrentDrawer.layer.shadowColor = UIColor.gray.cgColor
        btnCurrentDrawer.layer.shadowOffset = CGSize.zero
        btnCurrentDrawer.layer.shadowOpacity = 0.3
        btnCurrentDrawer.layer.shadowRadius = 5.0
        btnCurrentDrawer.layer.cornerRadius = 5
    }
    
    @IBAction func CurrentDrawerActioniPhone(_ sender: Any) {
        view_DrawerHistory.isHidden = true
        view_CurrentDrawer.isHidden = false
         self.payInOutVew.isHidden = true
        scroller.isHidden = false
        view_NavHeaderHeightConstraint.constant = 322.0
        
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
        
        callAPItoCheckDrawerEnd()
    }
    
    
     // for iPad PayOut
    func updateCurrentDrawerPaidOutDataByContainer(data: [DrawerHistoryModel]) {
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            if data.count>0
            {
                for i in (0...data.count-1)
                {
                    lblPaidIn.text = "$\(data[i].paid_in)"
                    lblPaidOut.text = "$\(data[i].paid_out)"
                    lblExpectedDrawer.text = "$\(data[i].expected_in_drawer)"
                    lblDifference.text = "$\(data[i].drawer_difference)"
                    strExpectedDrawer = "\(data[i].expected_in_drawer)"
                }
                currentDrawerDetailData.append(contentsOf: data)
            }
        }else{
            if data.count>0
            {
                for i in (0...data.count-1)
                {
                    lblPaidIn.text = "$\(data[i].paid_in)"
                    lblPaidOut.text = "$\(data[i].paid_out)"
                    lblExpectedDrawer.text = "$\(data[i].expected_in_drawer)"
                    lblDifference.text = "$\(data[i].drawer_difference)"
                    strExpectedDrawer = "\(data[i].expected_in_drawer)"
                }
                currentDrawerDetailData.append(contentsOf: data)
            }
        }
        
        
    }
    
     // for iPad PayIn
    func updateCurrentDrawerPaidInDataByContainer(data: [DrawerHistoryModel]) {
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            if data.count>0
            {
                for i in (0...data.count-1)
                {
                    lblPaidIn.text = "$\(data[i].paid_in)"
                    lblPaidOut.text = "$\(data[i].paid_out)"
                    lblExpectedDrawer.text = "$\(data[i].expected_in_drawer)"
                    lblDifference.text = "$\(data[i].drawer_difference)"
                    strExpectedDrawer = "\(data[i].expected_in_drawer)"
                }
                currentDrawerDetailData.append(contentsOf: data)
            }
        }else{
            if data.count>0
            {
                for i in (0...data.count-1)
                {
                    lblPaidIn.text = "$\(data[i].paid_in)"
                    lblPaidOut.text = "$\(data[i].paid_out)"
                    lblExpectedDrawer.text = "$\(data[i].expected_in_drawer)"
                    lblDifference.text = "$\(data[i].drawer_difference)"
                    strExpectedDrawer = "\(data[i].expected_in_drawer)"
                }
                currentDrawerDetailData.append(contentsOf: data)
            }
        }
        
        
    }
    
    // for iPhone PayIn
    func updateCurrentDrawerPaidInDataForIphone(with data: [DrawerHistoryModel]) {
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            if data.count>0
            {
                for i in (0...data.count-1)
                {
                    lblPaidIn.text = "$\(data[i].paid_in)"
                    lblPaidOut.text = "$\(data[i].paid_out)"
                    lblExpectedDrawer.text = "$\(data[i].expected_in_drawer)"
                    lblDifference.text = "$\(data[i].drawer_difference)"
                    strExpectedDrawer = "\(data[i].expected_in_drawer)"
                }
                currentDrawerDetailData.append(contentsOf: data)
            }
        }else{
            if data.count>0
            {
                for i in (0...data.count-1)
                {
                    lblPaidIn.text = "$\(data[i].paid_in)"
                    lblPaidOut.text = "$\(data[i].paid_out)"
                    lblExpectedDrawer.text = "$\(data[i].expected_in_drawer)"
                    lblDifference.text = "$\(data[i].drawer_difference)"
                    strExpectedDrawer = "\(data[i].expected_in_drawer)"
                }
                currentDrawerDetailData.append(contentsOf: data)
            }
        }
        
        
    }
    
}

//MARK: DetailReportViewControllerDelegate
extension CurrentDrawerViewController: DetailReportViewControllerDelegate {
    
    func didUpdateCurrentDrawerScreen(with data: JSONDictionary) {
        
        if data["items"] != nil
        {
            currentDrawerDetailData = data["items"] as! [DrawerHistoryModel]
            
            if currentDrawerDetailData.count>0
            {
                for i in (0...currentDrawerDetailData.count-1)
                {
                    lblStarted.text = currentDrawerDetailData[i].started
                    lblStartingCash.text = "$\(currentDrawerDetailData[i].starting_cash)"
                    lblCashRefund.text = "$\(currentDrawerDetailData[i].cash_refunds)"
                    lblCashSales.text = "$\(currentDrawerDetailData[i].cash_sales)"
                    // lblExpectedDrawer.text = "$\(currentDrawerDetailData[i].expected_in_drawer)"
                    lblActualInDrawer.text = "$\(currentDrawerDetailData[i].actualin_drawer)"
                    lblDifference.text = "$\(currentDrawerDetailData[i].drawer_difference)"
                    lblPaidIn.text = "$\(currentDrawerDetailData[i].paid_in)"
                    lblPaidOut.text = "$\(currentDrawerDetailData[i].paid_out)"
                    var newValue = ""
                    let expected : String = (currentDrawerDetailData[i].expected_in_drawer)
                    let replaced = expected.replacingOccurrences(of: ",", with: "")
                    var expected_in_drawer = (replaced as NSString).doubleValue
                    
                    if (expected_in_drawer < 0) {
                        expected_in_drawer = -(expected_in_drawer);
                        newValue = "-$\(expected_in_drawer.currencyFormatA)"
                    } else {
                        newValue = "$\(expected_in_drawer.currencyFormatA)"
                    }
                    lblExpectedDrawer.text = newValue
                    strExpectedDrawer = newValue
                    print("strExpectedDrawer",strExpectedDrawer)
                    
                }
            }
            
        }
        
    }
    
    func checkEndDrawerScreen(with data: JSONDictionary) {
        
        if data["items"] != nil
        {
            currentDrawerDetailData = data["items"] as! [DrawerHistoryModel]
            
            if currentDrawerDetailData.count>0
            {
                for i in (0...currentDrawerDetailData.count-1)
                {
                    lblStarted.text = currentDrawerDetailData[i].started
                    lblStartingCash.text = "$\(currentDrawerDetailData[i].starting_cash)"
                    lblCashRefund.text = "$\(currentDrawerDetailData[i].cash_refunds)"
                    lblCashSales.text = "$\(currentDrawerDetailData[i].cash_sales)"
                    // lblExpectedDrawer.text = "$\(currentDrawerDetailData[i].expected_in_drawer)"
                    lblActualInDrawer.text = "$\(currentDrawerDetailData[i].actualin_drawer)"
                    lblDifference.text = "$\(currentDrawerDetailData[i].drawer_difference)"
                    lblPaidIn.text = "$\(currentDrawerDetailData[i].paid_in)"
                    lblPaidOut.text = "$\(currentDrawerDetailData[i].paid_out)"
                    var newValue = ""
                    let expected : String = (currentDrawerDetailData[i].expected_in_drawer)
                    let replaced = expected.replacingOccurrences(of: ",", with: "")
                    var expected_in_drawer = (replaced as NSString).doubleValue
                    
                    if (expected_in_drawer < 0) {
                        expected_in_drawer = -(expected_in_drawer);
                        newValue = "-$\(expected_in_drawer.roundToTwoDecimal)"
                    } else {
                        newValue = "$\(expected_in_drawer.roundToTwoDecimal)"
                    }
                    lblExpectedDrawer.text = newValue
                    strExpectedDrawer = newValue
                    print("strExpectedDrawer",strExpectedDrawer)
                    
                }
            }
            
        }
        
    }
    
    func updateCurrentDrawerPaidInData(with data: [DrawerHistoryModel]) {
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            if data.count>0
            {
                for i in (0...data.count-1)
                {
                    lblPaidIn.text = "$\(data[i].paid_in)"
                    lblPaidOut.text = "$\(data[i].paid_out)"
                    lblExpectedDrawer.text = "$\(data[i].expected_in_drawer)"
                    lblDifference.text = "$\(data[i].drawer_difference)"
                    strExpectedDrawer = "\(data[i].expected_in_drawer)"
                }
                currentDrawerDetailData.append(contentsOf: data)
            }
        }else{
            if data.count>0
            {
                for i in (0...data.count-1)
                {
                    lblPaidIn.text = "$\(data[i].paid_in)"
                    lblPaidOut.text = "$\(data[i].paid_out)"
                    lblExpectedDrawer.text = "$\(data[i].expected_in_drawer)"
                    lblDifference.text = "$\(data[i].drawer_difference)"
                    strExpectedDrawer = "\(data[i].expected_in_drawer)"
                }
                currentDrawerDetailData.append(contentsOf: data)
            }
        }
        
        
    }
    
    func updateCurrentDrawerPaidOutData(with data: [DrawerHistoryModel]) {
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            if data.count>0
            {
                for i in (0...data.count-1)
                {
                    lblPaidIn.text = "$\(data[i].paid_in)"
                    lblPaidOut.text = "$\(data[i].paid_out)"
                    lblExpectedDrawer.text = "$\(data[i].expected_in_drawer)"
                    lblDifference.text = "$\(data[i].drawer_difference)"
                    strExpectedDrawer = "\(data[i].expected_in_drawer)"
                }
                currentDrawerDetailData.append(contentsOf: data)
            }
        }else{
            if data.count>0
            {
                for i in (0...data.count-1)
                {
                    lblPaidIn.text = "$\(data[i].paid_in)"
                    lblPaidOut.text = "$\(data[i].paid_out)"
                    lblExpectedDrawer.text = "$\(data[i].expected_in_drawer)"
                    lblDifference.text = "$\(data[i].drawer_difference)"
                    strExpectedDrawer = "\(data[i].expected_in_drawer)"
                }
                currentDrawerDetailData.append(contentsOf: data)
            }
        }
        
        
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension CurrentDrawerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if UI_USER_INTERFACE_IDIOM() == .phone {
            if tableView == tableOpen{
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
            if tableView == tableOpen{
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
        
        if tableView == tableEnd{
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
            // controller.drawerDetailData = array_ListOpen[indexPath.row]
            if tableView == tableOpen {
                controller.drawerDetailData = array_ListOpen[indexPath.row]
            }else{
                controller.drawerDetailEndData = array_ListEnd[indexPath.row]
                controller.isEndDrawer = true
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UI_USER_INTERFACE_IDIOM() == .phone {
            if array_ListOpen.count == 1{
                tableOpen.isScrollEnabled = false
                tableOpen.alwaysBounceVertical = false
                return 100
            }else if array_ListOpen.count == 2{
                tableOpen.isScrollEnabled = false
                tableOpen.alwaysBounceVertical = false
                return 200
            }else if array_ListOpen.count == 3{
                tableOpen.isScrollEnabled = false
                tableOpen.alwaysBounceVertical = false
                return 300
            }else if array_ListOpen.count > 3{
                tableOpen.isScrollEnabled = true
                tableOpen.alwaysBounceVertical = true
                return UITableViewAutomaticDimension
            }
            if tableView == tableEnd{
                return 100
            }
        }
        return UITableViewAutomaticDimension
    }
}

//MARK: API Methods
extension CurrentDrawerViewController {
    func callAPItoGetDrawerHistory() {
        
        //Device Name
        var str_DeviceName = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
        if let name = DataManager.deviceNameText {
            str_DeviceName = name
        }
        
        OrderVM.shared.getDrawerHistory(source: str_DeviceName.encodeUrl(), pageNumber: indexofPage) { (success, message, error) in
            if success == 1 {
                //                self.array_ListOpen = OrderVM.shared.drawerHistory
                //                self.tbl_DrawerHistory.reloadData()
                
                self.array_ListOpen.removeAll()
                self.array_ListOpen = OrderVM.shared.drawerHistoryOpen
                self.tableOpen.reloadData()
                
                
                if !OrderVM.shared.isMoreEndDrawerFound {
                    self.indexofPage = self.indexofPage - 1
                }
                
                self.array_ListEnd.removeAll()
                self.array_ListEnd = OrderVM.shared.drawerHistoryEnd
                self.tableEnd.reloadData()
                
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
        
        if (tableEnd!.contentOffset.y + tableEnd!.frame.height) >= (tableEnd!.contentSize.height - 50) {
            if array_ListEnd.count > 0 {
                indexofPage = indexofPage + 1
                callAPItoGetDrawerHistory()
            }
        }
    }
    
}


extension CurrentDrawerViewController {
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
                        //                    //DataManager.deviceName = false
                        //                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        //                    let controller = storyboard.instantiateViewController(withIdentifier: "CurrentDrawerViewController") as! CurrentDrawerViewController
                        //                    controller.currentDrawerDetailData = OrderVM.shared.checkDrawerEnd
                        //                    self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
                
                
            }else {
                DataManager.isDrawerOpen = false
                DispatchQueue.main.async {
                    Indicator.sharedInstance.hideIndicator()
                    //   self.performSegue(withIdentifier: "reports", sender: nil)
                    
                    if message != nil {
                        // self.showAlert(message: message!)
                        self.navigationController?.popViewController(animated: true)
                    }else {
                        self.showErrorMessage(error: error)
                    }
                }
                
            }
        }
    }
}
extension CurrentDrawerViewController: PayInPayOutDelegate {
    func showIphonePayInOut() {
        self.payInOutVew.isHidden = false
    }
    func hideIphonePayInOut() {
        view_DrawerHistory.isHidden = true
        view_CurrentDrawer.isHidden = false
        self.payInOutVew.isHidden = true
        scroller.isHidden = false
        view_NavHeaderHeightConstraint.constant = 322.0
        
    }
    func sendIphonePayInPayOutViewData(expectedStr: String) {
         PayInOutViewControllerObj!.getIphoneExpectedStrValue(expectedStr: expectedStr)
    }
}

extension CurrentDrawerViewController : refreshCurrentVCDataForIphoneDelegate {
    func refreshCurrentViewContollPayOutDataForIphone(data: [DrawerHistoryModel]) {
        updateCurrentDrawerPaidOutDataByContainer(data: data)
    }
    
    func refreshCurrentViewContollPayInDataForIphone(data: [DrawerHistoryModel]) {
        updateCurrentDrawerPaidInDataByContainer(data: data)
    }

}
