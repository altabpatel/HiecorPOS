//
//  PrintersViewController.swift
//  HieCOR
//
//  Created by Hiecor on 19/02/21.
//  Copyright © 2021 HyperMacMini. All rights reserved.
//


import UIKit
import CoreData
import CoreBluetooth
import CoreBluetooth.CBService
import MobileCoreServices
import IQKeyboardManagerSwift
import ExternalAccessory

class PrintersViewController: BaseViewController, SWRevealViewControllerDelegate {
    enum CellParamIndex: Int {
        case portName = 0
        case modelName
        case macAddress
    }
    
    //MARK: IBOutlet
    @IBOutlet var tbl_Settings: UITableView!
    
    //MARK: Variables
    private var array_Printer = Array<Any>()
    private var array_iconsList = Array<Any>()
    private var isShowAlert = true
    static var centeralManager: CBCentralManager?
    static var printerManager: PrinterManager?
    static var printerArray = [PrinterStruct]()
    static var printerUUID: UUID? = nil
    var isSearch = false
    var isBluetoothOn = false
    var isPaperWidth = false
    var arrPaperWidthSize = ["58","80"]
    // Star printer
    var startPrntArray: NSMutableArray!
    var startArr = [PortInfo]()
    var currentSetting: PrinterSetting? = nil
    var manager = EAAccessoryManager.shared()
    
    var portName:     String!
    var portSettings: String!
    var modelName:    String!
    var macAddress:   String!
    var paperSizeIndex: PaperSizeIndex? = nil
    
    var emulation: StarIoExtEmulation!
    var selectedModelIndex: ModelIndex?
    var selectedPrinterIndex: Int = 0
    
    //MARK: Delegate
    var printersSettingDelegate: SettingViewControllerDelegate?
    
    var selectTextField = UITextField()
    var editPrinterNameIndex = Int()
    var editPrinterName = ""
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startPrntArray = NSMutableArray()
        LoadStarPrinter.settingManager.load()
        
        PrintersViewController.centeralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        tbl_Settings.isScrollEnabled = true
        array_Printer = ["STAR Cloud Printer", "Bluetooth Printer"]
        //array_Printer = ["Bluetooth Printer"]
        tbl_Settings.rowHeight = 50
        if DataManager.isBluetoothPrinter {
            loadPrinter()
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        loadStarPrint()
        if DataManager.isGooglePrinter {
            callAPItoGetstarCloudPrinterList()
        }
    }
    
    @IBAction func printersBackAction(_ sender: Any) {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            
            printersSettingDelegate?.hidePrinterView?()
        }else{
            //  self.navigationController?.popViewController(animated: true)
            printersSettingDelegate?.didMoveToNextScreen?(with: "Hardware")
        }
    }
    
    @objc func btn_GooglePrinter(sender: UISwitch)
    {
        DataManager.isGooglePrinter = sender.isOn
        DataManager.isBluetoothPrinter = false
        if DataManager.isGooglePrinter {
            callAPItoGetstarCloudPrinterList()
        }
        tbl_Settings.reloadData()
    }
    @objc func btn_BluetoothPrinter(sender: UISwitch)
    {
        DataManager.isBluetoothPrinter = sender.isOn
        DataManager.isGooglePrinter = false
        if DataManager.isBluetoothPrinter {
            loadPrinter()
            loadStarPrint()
        }
        tbl_Settings.reloadData()
    }
    @objc func btn_SearchBleAction(sender: UIButton)
    {
        if !isBluetoothOn {
            self.moveToSettings()
            return
        }
        if isSearch {
            sender.isUserInteractionEnabled = true
            self.isSearch.toggle()
            PrintersViewController.centeralManager?.stopScan()
            self.tbl_Settings.reloadData()
            //  PrintersViewController.printerManager?.stopScan()
            return
        }
        isSearch.toggle()
        sender.isUserInteractionEnabled = false
        self.tbl_Settings.reloadData()
        self.loadPrinter()
        self.loadStarPrint()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isSearch.toggle()
            self.tbl_Settings.reloadData()
            sender.isUserInteractionEnabled = true
        }
    }
    @objc func btn_EditStarCloudPRNTNameAction(sender: UIButton) {

        editPrinterNameIndex = sender.tag - 1
        let macAddress = HomeVM.shared.starCloudPrinterModel.arrprinter_list_value[sender.tag - 1].printerMAC
        let alert = UIAlertController(title: "Edit Printer name", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
         //   self.discountTextField = textField
          //  textField.delegate = self
            textField.keyboardType = .default
            textField.text = HomeVM.shared.starCloudPrinterModel.arrprinter_list_value[self.editPrinterNameIndex].name
            textField.placeholder =  "Please enter printer name"
            textField.tag = 3000
            textField.selectAll(nil)
        }
        alert.addAction(UIAlertAction(title: kOkay, style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            self.editPrinterName = textField.text ?? ""
           // self.handleDiscount(textField: textField)
            self.callAPItoUpdatePrinterName(cloudPrinterAddress: macAddress, cloudPrinterName: textField.text ?? "")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            //self.catAndProductDelegate?.hideView?(with:  "alertblurcancel")
            
        }))
       // self.catAndProductDelegate?.hideView?(with:  "alertblur")
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func btn_DefaultStarCloudPRNTNameAction(sender: UIButton) {
        DataManager.starCloudMACaAddress =  HomeVM.shared.starCloudPrinterModel.arrprinter_list_value[sender.tag - 1].printerMAC
        tbl_Settings.reloadData()
    }
    
    //MARK: Get Star print
    func loadStarPrint() {
        
        self.startPrntArray?.removeAllObjects()
        
        // self.selectedIndexPath = nil
        
        
        var searchPrinterResult: [PortInfo]? = nil
        
        do {
            // Bluetooth
            searchPrinterResult = try SMPort.searchPrinter(target: "BT:")  as? [PortInfo]
            //DataManager.isStarPrinterConnected = true
            if  searchPrinterResult?.count == 0 {
                DataManager.isStarPrinterConnected = false
            } else {
                if DataManager.isBluetoothPrinter {
                    DataManager.isStarPrinterConnected = true
                } else {
                    DataManager.isStarPrinterConnected = false
                }
            }
            
        }
        catch {
            // do nothing
            DataManager.isStarPrinterConnected = false
        }
        
        guard let portInfoArray: [PortInfo] = searchPrinterResult else {
            //  self.tableView.reloadData()
            return
        }
        
        print("Star portInfoArray \(portInfoArray)")
        let portName:   String = currentSetting?.portName ?? ""
        let modelName:  String = currentSetting?.portSettings ?? ""
        let macAddress: String = currentSetting?.macAddress ?? ""
        
        var row: Int = 0
        startArr.removeAll()
        for portInfo: PortInfo in portInfoArray {
            print(portInfo)
            startArr.append(portInfo)
            self.startPrntArray.add([portInfo.portName, portInfo.modelName, portInfo.macAddress])
            
            if portInfo.portName   == portName  &&
                portInfo.modelName  == modelName &&
                portInfo.macAddress == macAddress {
                // self.selectedIndexPath = IndexPath(row: row, section: 0)
            }
            
            row += 1
            if startArr.count > 0 {
                modelSelect1AlertClickedButtonAt(buttonIndex: 5)
            }
        }
    }
    func modelSelect1AlertClickedButtonAt(buttonIndex: Int?) {
        if buttonIndex != 0 {   // Not cancel
            let cellParam: [String] = self.startPrntArray[0] as! [String]
            
            self.portName   = cellParam[CellParamIndex.portName  .rawValue]
            self.modelName  = cellParam[CellParamIndex.modelName .rawValue]
            self.macAddress = cellParam[CellParamIndex.macAddress.rawValue]
            let modelName:  String = cellParam[CellParamIndex.modelName.rawValue]
//            let modelIndex: ModelIndex = ModelCapability.modelIndex(at: 0)
            let modelIndex: ModelIndex = ModelCapability.modelIndex(of: modelName) ?? ModelIndex.tsp650II
            self.portSettings = ModelCapability.portSettings(at: modelIndex)
            self.emulation = ModelCapability.emulation(at: modelIndex)
            self.selectedModelIndex = modelIndex
            
            let supportedExternalCashDrawer = ModelCapability.supportedExternalCashDrawer(at: modelIndex)!
            switch self.emulation {
            case .escPos?:
                self.paperSizeIndex = .escPosThreeInch
            case .starDotImpact?:
                self.paperSizeIndex = .dotImpactThreeInch
            default:
                self.paperSizeIndex = nil
            }
            
            if (selectedPrinterIndex != 0) {
                self.paperSizeIndex = LoadStarPrinter.settingManager.settings[0]?.selectedPaperSize
            }
            
            self.saveParams(portName: self.portName,
                            portSettings: self.portSettings,
                            modelName: self.modelName,
                            macAddress: self.macAddress,
                            emulation: self.emulation,
                            isCashDrawerOpenActiveHigh: true,
                            modelIndex:  modelIndex,
                            paperSizeIndex: .threeInch)
            
        }
    }
    
    fileprivate func saveParams(portName: String,
                                portSettings: String,
                                modelName: String,
                                macAddress: String,
                                emulation: StarIoExtEmulation,
                                isCashDrawerOpenActiveHigh: Bool,
                                modelIndex: ModelIndex?,
                                paperSizeIndex: PaperSizeIndex?) {
        if let modelIndex = modelIndex,
            let paperSizeIndex = paperSizeIndex {
            let allReceiptsSetting = LoadStarPrinter.settingManager.settings[selectedPrinterIndex]?.allReceiptsSettings ?? 0x07
            
            LoadStarPrinter.settingManager.settings[selectedPrinterIndex] = PrinterSetting(portName: portName,
                                                                                           portSettings: portSettings,
                                                                                           macAddress: macAddress,
                                                                                           modelName: modelName,
                                                                                           emulation: emulation,
                                                                                           cashDrawerOpenActiveHigh: isCashDrawerOpenActiveHigh,
                                                                                           allReceiptsSettings: allReceiptsSetting,
                                                                                           selectedPaperSize: paperSizeIndex,
                                                                                           selectedModelIndex: modelIndex)
            
            LoadStarPrinter.settingManager.save()
        } else {
            fatalError()
        }
    }
    
    
}
extension PrintersViewController {
    func callAPItoGetstarCloudPrinterList(){
        HomeVM.shared.starCloudPrinterModel.arrprinter_list_value.removeAll()
        HomeVM.shared.getPrinterList { (success, message, error) in
            if success == 1 {
                //self.sourcesList =  HomeVM.shared.sourcesList
                if DataManager.isGooglePrinter {
                    DispatchQueue.main.async {
                        self.tbl_Settings.reloadData()
                        
                    }
                }
                print( HomeVM.shared.starCloudPrinterModel)
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
    
    func callAPItoUpdatePrinterName(cloudPrinterAddress: String, cloudPrinterName: String){
        HomeVM.shared.getUpdatePrinterName(cloudPrinterAddress: cloudPrinterAddress, cloudPrinterName: cloudPrinterName) { (success, message, error) in
            if success == 1 {
                DispatchQueue.main.async {
                    appDelegate.showToast(message: message ?? "")
                    HomeVM.shared.starCloudPrinterModel.arrprinter_list_value[self.editPrinterNameIndex].name = self.editPrinterName
                    print( HomeVM.shared.starCloudPrinterModel)
                    self.tbl_Settings.reloadData()
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
}
//MARK: UITableViewDataSource, UITableViewDelegate
extension PrintersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var row = array_Printer.count
        if DataManager.isBluetoothPrinter {
            if PrintersViewController.printerArray.count>0 {
                row = PrintersViewController.printerArray.count + array_Printer.count + 1 + startArr.count
            }else {
                row = array_Printer.count + 1
            }
        }else if DataManager.isGooglePrinter {
            return array_Printer.count + HomeVM.shared.starCloudPrinterModel.arrprinter_list_value.count
        }else{
            
            row = array_Printer.count
        }
        return row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_Settings.dequeueReusableCell(withIdentifier: "SettingsTableCell", for: indexPath) as! SettingsTableCell
        if UI_USER_INTERFACE_IDIOM() == .phone
        {
            cell.paperWidth_widthConst.constant = 70
        }else {
            cell.paperWidth_widthConst.constant = 90
        }
        cell.paperSizeTextfield.isHidden = true
        cell.paperSizeTextfield.hideAssistantBar()
        cell.lblLeadingConstant.constant = 20
        // let lbl_Title = cell.contentView.viewWithTag(1) as? UILabel
        cell.viewLineLeadingConstrant.constant = 20
        cell.label?.isHidden = false
        cell.switchButton.isHidden = false
        cell.button.isHidden = true
        cell.accessoryType = .none
        cell.accessoryView = nil
        cell.viewStarCloudPrnt.isHidden = true
        cell.backgroundColor = UIColor.white
        // MARK Hide for V5
        if indexPath.row == 0 {
            cell.label?.text = array_Printer[indexPath.row] as? String
            cell.switchButton.setOn(DataManager.isGooglePrinter, animated: false)
            cell.switchButton.addTarget(self, action:#selector(btn_GooglePrinter(sender:)), for: .touchUpInside)
            return cell
        } else if DataManager.isGooglePrinter == false && indexPath.row == 1 {
            cell.label?.text = array_Printer[indexPath.row] as? String
            cell.switchButton.setOn(DataManager.isBluetoothPrinter, animated: false)
            cell.switchButton.addTarget(self, action:#selector(btn_BluetoothPrinter(sender:)), for: .touchUpInside)
            return cell
        }else if DataManager.isGooglePrinter == true  {
            if  indexPath.row == HomeVM.shared.starCloudPrinterModel.arrprinter_list_value.count + 1{
                cell.label?.text = array_Printer[1] as? String
                cell.switchButton.setOn(DataManager.isBluetoothPrinter, animated: false)
                cell.switchButton.addTarget(self, action:#selector(btn_BluetoothPrinter(sender:)), for: .touchUpInside)
                return cell
            }
            if HomeVM.shared.starCloudPrinterModel.arrprinter_list_value.count > 0 {
            cell.viewStarCloudPrnt.isHidden = false
            cell.txtStarPrinterName.text = HomeVM.shared.starCloudPrinterModel.arrprinter_list_value[indexPath.row - 1].name
            cell.txtStarPrinterName.isUserInteractionEnabled = false
           // cell.txtStarPrinterName.becomeFirstResponder()
            cell.btnEdit.tag = indexPath.row
            cell.btnEdit.addTarget(self, action: #selector(btn_EditStarCloudPRNTNameAction(sender:)), for: .touchUpInside)
                cell.btnDefault.tag = indexPath.row
                cell.btnDefault.addTarget(self, action: #selector(btn_DefaultStarCloudPRNTNameAction(sender:)), for: .touchUpInside)
                if UI_USER_INTERFACE_IDIOM() == .phone {
                    cell.lblMacAdrsMob.text = HomeVM.shared.starCloudPrinterModel.arrprinter_list_value[indexPath.row - 1].printerMAC
                    cell.lblMacAdrs.text = ""
                }else{
                    cell.lblMacAdrs.text = HomeVM.shared.starCloudPrinterModel.arrprinter_list_value[indexPath.row - 1].printerMAC
                    cell.lblMacAdrsMob.text = ""
                }
                if DataManager.starCloudMACaAddress == HomeVM.shared.starCloudPrinterModel.arrprinter_list_value[indexPath.row - 1].printerMAC {
                    cell.btnDefault.backgroundColor = UIColor.init(red: 11/255, green: 118/255, blue: 201/255, alpha: 1.0)
                    cell.btnDefault.setTitleColor(.white, for: .normal)
                    cell.btnCheckMark.setImage(UIImage.init(named: "check-select"), for: .normal)
                    cell.txtStarPrinterName.textColor = UIColor.init(red: 11/255, green: 118/255, blue: 201/255, alpha: 1.0)
                }else {
                    cell.btnDefault.backgroundColor = UIColor.white
                    cell.btnDefault.setTitleColor(UIColor.init(red: 11/255, green: 118/255, blue: 201/255, alpha: 1.0), for: .normal)
                    cell.btnCheckMark.setImage(UIImage.init(named: "check-unselect"), for: .normal)
                    cell.txtStarPrinterName.textColor = UIColor.darkGray
                }
//                if editPrinterNameIndex == indexPath.row.description {
//                    cell.txtStarPrinterName.isUserInteractionEnabled = true
//                   // cell.txtStarPrinterName.becomeFirstResponder()
//                }
            return cell
            }
//            cell.label?.text = array_Printer[indexPath.row] as? String
//            cell.switchButton.setOn(DataManager.isBluetoothPrinter, animated: false)
//            cell.switchButton.addTarget(self, action:#selector(btn_BluetoothPrinter(sender:)), for: .touchUpInside)
        }else{
            cell.viewLineLeadingConstrant.constant = 30
            cell.button.isHidden = true
            cell.switchButton.isHidden = true
            cell.accessoryType = .none
            cell.accessoryView = nil
            cell.label?.isHidden = false
            cell.button.addTarget(self, action: #selector(btn_SearchBleAction(sender:)), for: .touchUpInside)
            if isSearch {
                cell.searchBtn_widthConst.constant = 60
                cell.activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                cell.activity.startAnimating()
                cell.accessoryView = cell.activity
                cell.button.setTitle("Stop", for: .normal)
            } else {
                cell.searchBtn_widthConst.constant = 114
                cell.activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                cell.activity.stopAnimating()
                cell.accessoryView = .none
                cell.button.setTitle("Search for printer", for: .normal)
            }
            cell.lblLeadingConstant.constant = 30
            if PrintersViewController.printerArray.count == 0
            {
                //                    lbl_Title?.text = "No printer found."
                //                    let v = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                //                    v.startAnimating()
                //                    cell.accessoryView = v
                cell.paperSizeTextfield.tag = 104
                cell.accessoryType = .none
                cell.label?.isHidden = false
                cell.label?.text = "Printer paper width:"
                // cell.textfield.isHidden = false
                cell.paperSizeTextfield.isHidden = false
                cell.paperSizeTextfield?.placeholder = "Paper width"
                cell.paperSizeTextfield.addLeftSidePadding()
                cell.paperSizeTextfield.setDropDown()
                cell.paperSizeTextfield.delegate = self
                
                cell.paperSizeTextfield.keyboardType = .decimalPad
                cell.button.isHidden = false
                //  cell.button.setTitle("Search for printer", for: .normal)
                cell.lblLeadingConstant.constant = 30
                cell.paperSizeTextfield.text = String(describing: DataManager.paperSize)
            }else {
                //                    lbl_Title?.text = "No printer found."
                
                if indexPath.row == 2 {
                    cell.paperSizeTextfield.tag = 104
                    cell.accessoryType = .none
                    cell.label?.isHidden = false
                    cell.label?.text = "Printer paper width:"
                    // cell.textfield.isHidden = false
                    cell.paperSizeTextfield.isHidden = false
                    cell.paperSizeTextfield?.placeholder = "Paper width"
                    cell.paperSizeTextfield.addLeftSidePadding()
                    cell.paperSizeTextfield.setDropDown()
                    cell.paperSizeTextfield.delegate = self
                    
                    cell.paperSizeTextfield.keyboardType = .decimalPad
                    cell.button.isHidden = false
                    //  cell.button.setTitle("Search for printer", for: .normal)
                    cell.lblLeadingConstant.constant = 30
                    cell.paperSizeTextfield.text = String(describing: DataManager.paperSize)
                }else {
                    //guard (indexPath.row - 3) < PrintersViewController.printerArray.count else {
                        if startArr.count > 0 {
                            if indexPath.row == 3 {
                                cell.label?.text = startArr[0].portName
                                if startArr[0].portName == LoadStarPrinter.settingManager.settings[self.selectedPrinterIndex]?.portName {
                                    cell.accessoryType = .checkmark
                                    cell.backgroundColor = UIColor.yellow
                                }
                                return cell
                            }
                        }
                        
                   // }
                    //
                    let printer = PrintersViewController.printerArray[indexPath.row - 3 - startArr.count]
                    
                    cell.label?.text = printer.name ?? printer.identifier.description
                    cell.accessoryType = printer.state == .connected ? .checkmark : .none
                    cell.backgroundColor = printer.state == .connected ? UIColor.yellow : UIColor.white
                    
                    if startArr.count > 0 {
                        //let p = PrintersViewController.printerArray[indexPath.row - 3]
                        cell.accessoryType =  .none
                        cell.backgroundColor = UIColor.white
                        //UserDefaults.standard.set("", forKey: "auto.connect.uuid")
                        //PrintersViewController.printerManager?.disconnect(printer)
                        //PrintersViewController.printerUUID = nil
                    }
                    
                    cell.contentView.isUserInteractionEnabled = printer.state == .connecting ? false : true
                    if printer.isConnecting {
                        let v = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                        v.startAnimating()
                        cell.accessoryView = v
                    } else {
                        cell.accessoryView = nil
                        cell.setEditing(false, animated: false)
                    }
                }
            }
        }
        // lbl_Name?.text = array_Printer[indexPath.row] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if DataManager.isGooglePrinter {
            return
        }
        if indexPath.row == 0 || indexPath.row == 1  || indexPath.row == 2{
            return
        }
        
        guard indexPath.row - 3 < PrintersViewController.printerArray.count else {
            return
        }

        if  startArr.count > 0 {
            if indexPath.row == 3 {
                return
            }
        }
        
        let p = PrintersViewController.printerArray[indexPath.row - 3 - startArr.count]
        
        let name  = p.name ?? p.identifier.description
        
        if name.contains("RP45") {
            return
        }
        
        if startArr.count > 0 {
            self.showAlert(message: "Star printer connected, please go to device bluetooth setting.")
            return
        }
        
        if p.state == .connected {
            UserDefaults.standard.set("", forKey: "auto.connect.uuid")
            PrintersViewController.printerManager?.disconnect(p)
            PrintersViewController.printerUUID = nil
        } else {
            let show = PrintersViewController.printerArray.filter({$0.state == .connecting})
            if show.count > 0 {
                return
            } else {
                if let uuid = UserDefaults.standard.object(forKey:"auto.connect.uuid") as? String {
                    if PrintersViewController.printerArray.contains(where: {$0.identifier.uuidString == uuid.description}) {
                        if let index = PrintersViewController.printerArray.firstIndex(where: {$0.identifier.uuidString == uuid.description}) {
                            let indexValue =   PrintersViewController.printerArray[index]
                            print(indexValue)
                            PrintersViewController.printerManager?.disconnect(indexValue)
                            PrintersViewController.printerUUID = nil
                        }
                        
                    }
                    
                }
                
                UserDefaults.standard.set("", forKey: "auto.connect.uuid")
                PrintersViewController.printerManager?.connect(p)
                if p.name == nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        if PrintersViewController.printerArray.contains(where: {$0.identifier.uuidString == p.identifier.description}) {
                            if let index = PrintersViewController.printerArray.firstIndex(where: {$0.identifier.uuidString == p.identifier.description}) {
                                //                                             let indexValue =   PrintersViewController.printerArray[index]
                                //                                                print(indexValue)
                                //                                                PrintersViewController.printerManager?.disconnect(indexValue)
                                PrintersViewController.printerArray[index].state = .disconnected
                                self.tbl_Settings.reloadData()
                            }
                            
                        }
                    }
                }
            }
            
        }
        tbl_Settings.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
}
//MARK: PrinterManagerDelegate
extension PrintersViewController: PrinterManagerDelegate {
    
    func loadPrinter() {
        PrintersViewController.printerManager = PrinterManager()
        PrintersViewController.printerManager?.delegate = self
        PrintersViewController.printerArray = PrintersViewController.printerManager!.nearbyPrinters
        PrintersViewController.printerUUID = nil
        self.tbl_Settings.reloadData()
    }
    
    public func nearbyPrinterDidChange(_ change: NearbyPrinterChange) {
        switch change {
        case let .add(p):
            if PrintersViewController.printerArray.contains(where: {$0.identifier == p.identifier}) == false {
                PrintersViewController.printerArray.append(p)
            }
        // PrintersViewController.printerArray.append(p)
        case let .update(p):
             guard let row = (PrintersViewController.printerArray.index() { $0.identifier == p.identifier } ) else {
                           return
                       }
                       PrintersViewController.printerArray[row] = p
                       if p.state == .connected {
                           DataManager.receipt = true
                           PrintersViewController.printerUUID = p.identifier
                           PrintersViewController.printerArray.swapAt(0, row)
                       }
                       else if p.state == .disconnected {
                           PrintersViewController.printerUUID = nil
                       }
                      // PrintersViewController.printerArray[row] = p
                       self.tbl_Settings.reloadData()
                       print(p.state)
            
        case let .remove(identifier):
            guard let row = (PrintersViewController.printerArray.index() { $0.identifier == identifier } ) else {
                return
            }
            
            if PrintersViewController.printerUUID == PrintersViewController.printerArray[row].identifier {
                PrintersViewController.printerUUID = nil
            }
            PrintersViewController.printerArray.remove(at: row)
        }
        
        if startArr.count > 0 {
            for i in 0..<PrintersViewController.printerArray.count {
                let p = PrintersViewController.printerArray[i]
                if p.state == .connected {
                    UserDefaults.standard.set("", forKey: "auto.connect.uuid")
                    PrintersViewController.printerManager?.disconnect(p)
                    PrintersViewController.printerUUID = nil
                }
            }
        }
        
        self.tbl_Settings.reloadData()
    }
    
    func moveToSettings() {
        if !isShowAlert {
            
            return
        }
        //        self.showAlert(title: "Alert", message: "Please enable the bluetooth from Settings.", otherButtons: nil, cancelTitle: kOkay) { (action) in
        ////            guard let url = URL(string: "App-Prefs:root=Bluetooth") else {return}
        ////            if #available(iOS 10.0, *) {
        ////                UIApplication.shared.open(url, options: [:], completionHandler: nil)
        ////            } else {
        ////                UIApplication.shared.openURL(url)
        ////            }
        //        }
        self.showAlert(title:"Alert", message: "Please enable the bluetooth from Settings.", otherButtons: ["Settings":{ (_) in
            //...
            guard let url = URL(string: "App-Prefs:root=Bluetooth") else {return}
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            }], cancelTitle:kOkay) { (_) in
        }
    }
}

//MARK: CBCentralManagerDelegate, CBPeripheralDelegate
extension PrintersViewController : CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        //  if DataManager.isBluetoothPrinter {
        if central.state == .poweredOn {
            //Scan For Printer
            
            isBluetoothOn = true
            if DataManager.isBluetoothPrinter {
                self.loadPrinter()
            }
            
            //  PrintersViewController.centeralManager?.scanForPeripherals(withServices: nil, options: nil)
            
        }else {
            isShowAlert = true
            isBluetoothOn = false
            if DataManager.isBluetoothPrinter {
                
                self.moveToSettings()
            }
            PrintersViewController.printerUUID = nil
            PrintersViewController.printerArray.removeAll()
            PrintersViewController.printerManager?.disconnectAllPrinter()
            PrintersViewController.printerManager = nil
            self.tbl_Settings.reloadData()
            
        }
        //  }
    }
}



//MARK: HieCORPickerDelegate
extension PrintersViewController: HieCORPickerDelegate {
    func didSelectPickerViewAtIndex(index: Int) {
        if isPaperWidth {
            DataManager.paperSize = Int(arrPaperWidthSize[index]) ?? 58
            pickerTextfield.text = arrPaperWidthSize[index]
            return
        }
        let array = HomeVM.shared.countryDetail.compactMap({$0.abbreviation})
        pickerTextfield.text = array[index]
    }
    
    func didClickOnPickerViewDoneButton() {
        if isPaperWidth {
            isPaperWidth = false
            // DataManager.paperSize = Int(arrPaperWidthSize[index]) ?? 58
            DataManager.paperSize = Int(pickerTextfield.text ?? "58") ?? 58
            pickerTextfield.resignFirstResponder()
            
            
            return
        }
        DataManager.selectedCountry = pickerTextfield.text ?? ""
        pickerTextfield.resignFirstResponder()
        HomeVM.shared.regionsList.removeAll()
    }
    
    func didClickOnPickerViewCancelButton() {
        if isPaperWidth {
            isPaperWidth = false
            DataManager.paperSize =  58
            pickerTextfield.text = "58"
            pickerTextfield.resignFirstResponder()
            // tbl_Settings.reloadData()
            return
        }
        pickerTextfield.text = "US"
        DataManager.selectedCountry = "US"
        pickerTextfield.resignFirstResponder()
        HomeVM.shared.regionsList.removeAll()
    }
}

//MARK: UITextFieldDelegate
extension PrintersViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.tag == 104 {
            isPaperWidth = true
            self.pickerDelegate = self
            textField.text = "58"
            DataManager.paperSize = 58
            self.setPickerView(textField: textField, array: arrPaperWidthSize)
        }
        
        if textField.tag == 101 || textField.tag == 102 || textField.tag == 103 {
            textField.selectAll(nil)
        }
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneAction))
        doneButton.tintColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
        
        if (textField.textInputMode?.primaryLanguage == "emoji") || !((textField.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        
        if range.location == 0 && string == " " {
            return false
        }
        
        if textField.tag == 1001 {
            let cs = CharacterSet.decimalDigits.inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            if string == filtered {
                return charactersCount < 4
            }
            return false
        }
        
        if textField.tag == 1000 {
            
            if textField.isEmpty && string == " " {
                return false
            }
            
            return charactersCount < 51
        }
        
        if textField.tag == 101 || textField.tag == 102 || textField.tag == 103 {
            let replacementText = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
            let amount = Double(replacementText) ?? 0.0
            return replacementText.isValidDecimal(maximumFractionDigits: 2) && amount <= 100
        }
        
        return charactersCount < 21
    }
    
    @objc func doneAction() {
        self.view.endEditing(true)
    }
}
