//
//  ConnectCustomeFacingVC.swift
//  HieCOR
//
//  Created by Hiecor Software on 24/01/20.
//  Copyright © 2020 HyperMacMini. All rights reserved.
//

import UIKit
import SocketIO
import Alamofire

class ConnectCustomeFacingVC: BaseViewController {
    
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var tfSelectDevice: UITextField!
    @IBOutlet weak var viewBase: UIView!
    var showItems = [String]()
    var customerFacingDeviceList = [CustomerFacingDeviceList]()
    var indexForSelectDevice = 0
    let deviceId = UIDevice.current.identifierForVendor?.uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        RoomApiCall()
        if DataManager.socketAppUrl != "" && DataManager.showCustomerFacing {
            MainSocketManager.shared.connect()
            MainSocketManager.shared.onConnect {
                // MainSocketManager.shared.userJoinOnConnect(deviceId: self.deviceId!)
            }
            MainSocketManager.shared.emitConnectionResponse {(joinData) in
                if self.customerFacingDeviceList.count > 0 {
                DataManager.roomID  =  self.customerFacingDeviceList[self.indexForSelectDevice].room_id
                DataManager.sessionID = joinData.session_id
                MainSocketManager.shared.socket.off("connectionResponse")
                
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    let storyboard = UIStoryboard(name: "iPad", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "iPad_SWRevealViewController") as! SWRevealViewController
                    appDelegate.window?.rootViewController = controller
                    appDelegate.window?.makeKeyAndVisible()
                }else{
                    self.setRootViewControllerForIphone()
                }
                }
                
            }
        }
        
        //  if DataManager.deviceNameCustomerFacing != "" {
        tfSelectDevice?.text = ""
        // }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.revealViewController() != nil)
        {
            revealViewController().delegate = self as? SWRevealViewControllerDelegate
            btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    //MARK load UI....
    func loadUI() {
        //Add Shadow
        viewBase?.layer.shadowColor = UIColor.lightGray.cgColor
        viewBase?.layer.shadowOffset = CGSize.zero
        viewBase?.layer.shadowOpacity = 0.3
        viewBase?.layer.shadowRadius = 5.0
        viewBase?.layer.cornerRadius = 5
        tfSelectDevice.setPadding()
        tfSelectDevice.setDropDown()
        tfSelectDevice.addTarget(self, action: #selector(handleItemsTextField(sender:)), for: .editingDidBegin)
        let image = UIImage(named: "cancel-white")?.withRenderingMode(.alwaysTemplate)
        btnMenu.setImage(image, for: .normal)
        btnMenu.tintColor = UIColor.white
    }
    
    @objc func handleItemsTextField(sender: UITextField) {
        self.pickerDelegate = self
        showItems.removeAll()
        let array = self.customerFacingDeviceList.compactMap({$0.room_name})
        self.setPickerView(textField: sender, array: array)
    }
    
    //MARK Action.....
    @IBAction func actionConnect(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            sender.backgroundColor = #colorLiteral(red: 0, green: 0.5450556278, blue: 0.8285357952, alpha: 1)
        }
        if tfSelectDevice.text != "" {
            if customerFacingDeviceList.count > 0 {
                Indicator.sharedInstance.showIndicator()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    Indicator.sharedInstance.hideIndicator()
                }
                MainSocketManager.shared.userJoinOnConnect(deviceId:  customerFacingDeviceList[indexForSelectDevice].room_id)
                MainSocketManager.shared.handleJoinData(roomID : customerFacingDeviceList[indexForSelectDevice].room_id)
            }
        }else{
//            showAlert(message: "Please select Device.")
            appDelegate.showToast(message: "Please select Device.")
        }
        
        tfSelectDevice.resignFirstResponder()
    }
    
    @IBAction func actionBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionRefresh(_ sender: Any) {
        RoomApiCall()
      }
    
    //MARK: API Call Method
    func RoomApiCall(){
        HomeVM.shared.roomApi(responseCallBack: {(success, message, error) in
            if success == 1 {
                self.customerFacingDeviceList =  HomeVM.shared.customerFacingDeviceList
                if self.customerFacingDeviceList.count > 0 {
                    for i in 0..<self.customerFacingDeviceList.count {
                        if DataManager.sessionID != "" {
                            if DataManager.sessionID == self.customerFacingDeviceList[i].session_id{
                                self.indexForSelectDevice = i
                                self.tfSelectDevice.text = self.customerFacingDeviceList[i].room_name
                            }
                        }
                        
                    }
                }
                
            }else {
                if message != nil {
//                    self.showAlert(message: message!)
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        })
    }
//    func acceptSessionApiCall(parameters: JSONDictionary){
//        HomeVM.shared.acceptSessionApi(parameters: parameters) { (success, message, error) in
//            Indicator.sharedInstance.hideIndicator()
//            if success == 1 {
//                print("Success")
//               // DataManager.sessionID = self.customerFacingDeviceList[self.indexForSelectDevice].session_id
//              //  DataManager.roomID = self.customerFacingDeviceList[self.indexForSelectDevice].room_id
//            }
//            else {
//                  print("error")
//                if message != nil {
//                    // showAlert(message: message!)
//                }else {
//                    //self.showErrorMessage(error: error)
//                }
//            }
//        }
//    }
    
}

//MARK: HieCORPickerDelegate
extension ConnectCustomeFacingVC: HieCORPickerDelegate {
    func didSelectPickerViewAtIndex(index: Int) {
        if pickerTextfield == tfSelectDevice {
            pickerTextfield.text = "\(self.customerFacingDeviceList[index].room_name)"
            indexForSelectDevice = index
        }
    }
    
    override func pickerViewDoneAction() {
        self.view.endEditing(true)
        if customerFacingDeviceList.count > 0 {
            pickerTextfield.text = "\(self.customerFacingDeviceList[indexForSelectDevice].room_name)"
        }
        pickerTextfield.resignFirstResponder()
    }
    
    override func pickerViewCancelAction() {
        self.view.endEditing(true)
        pickerTextfield.resignFirstResponder()
    }
    
}

