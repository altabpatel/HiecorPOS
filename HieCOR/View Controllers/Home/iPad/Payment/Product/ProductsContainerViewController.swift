//
//  ProductsContainerViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 20/02/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
class ProductsContainerViewController: BaseViewController {
    
    enum CellParamIndex: Int {
        case portName = 0
        case modelName
        case macAddress
    }
    
    //MARK: IBOutlets
    @IBOutlet weak var view_ipadSearch: UIView!
    @IBOutlet weak var ipad_SearchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView?
    @IBOutlet weak var ipadsearchView: UIView!
    @IBOutlet weak var manualPaymentButton: UIButton!
    @IBOutlet var searchViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var searchViewVerticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewScanBtn: UIView!
    @IBOutlet weak var wiedthViewScanBtnConst: NSLayoutConstraint!
    
    //Variables
    var str_SelectedCategoryName = String()
    var selectedIndexSection0: Int?
    var selectedIndexSection1 = Int()
    var arraySected = [String]()
    var array_labelText = [String]()
    var array_SelectStock = Array<Any>()
    var selectedProductCollectionIndex = Int()
    var selectedCollectionIndex = Int()
    var array_Products = [ProductsModel]()
    var array_SearchProducts = [ProductsModel]()
    var isProductSearch : Bool = false
    var isSearchTyping :Bool = false
    var isAPICalled :Bool = false
    var dummyCardNumber = String()
    var delegate: ProductsContainerViewControllerDelegate?
    var catAndProductDelegate: CatAndProductsViewControllerDelegate?
    var editProductDelegate: EditProductsContainerViewDelegate?
    var isCollectionScrolled = false
    var str_noProductPurchase = String()
    var str_showImagesFunctionality = String()
    var str_showProductCodeFunctionality = String()
    var str_showProductPriceFunctionality = String()
    var delegateOne : AttributeUpdateDeleget?
    var cartview = CatAndProductsViewController()
    private var arraySelectedPaymet = [String]()
    var ordertype : OrderType = .newOrder
    var sourcesList = [String]()
    var isUpSell = false
    var indexUpsell = 0
    
    
    //Private variables
    private var searchFetchOffset:Int = 0
    private var searchFetchLimit:Int = 20
    private var searchPageCount: Int = 1
    private var controller: PopViewController?
    private var pageControl = UIPageControl()
    private var isDataLoading:Bool = false
    private var indexofPage :Int = 1
    private var isLastIndex: Bool = false
    private var refundId = String()
    
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
    var addCustomerPOPUPFlag = false
    //Star barcode reader
    var starIoExtManager: StarIoExtManager!
    var cellArray = NSMutableArray()
    var isInStockCheck = false
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomerPOPUPFlag = true
        self.startPrntArray = NSMutableArray()
        LoadStarPrinter.settingManager.load()

        self.customizeUI()
        self.initializeVariables()
        self.callAPIToGetIngenico()
        self.callAPItoGetCountryList()
        self.callAPItoGetSourcesList()
        /* let isSplit = DataManager.selectedPayment?.contains("MULTI CARD")
        if isSplit! {
            print("enterrrrrrrrrrrrrrrrr")
            DataManager.isSplitPayment = true
        } else {
            DataManager.isSplitPayment = false
            print("outerrrrrrrrrrrrrrrrr")
        }*/
        
        if  let isSplit = DataManager.selectedPayment?.contains("MULTI CARD") {
            if isSplit {
                print("enterrrrrrrrrrrrrrrrr")
                DataManager.isSplitPayment = true
            } else {
                DataManager.isSplitPayment = false
                print("outerrrrrrrrrrrrrrrrr")
            }
        }
        
        Keyboard._registerForExternalKeyboardChangeNotification()
        
        //SwipeAndSearchVC.shared.initialize()
        //OfflineDataManager Delegate
        if UI_USER_INTERFACE_IDIOM() == .phone {
            OfflineDataManager.shared.productContainerDelegate = self
            //Initialize Swipe Class
            SwipeAndSearchVC.shared.initialize()
        }
        
        
        
        if DataManager.isBluetoothPrinter {
            loadStarPrint()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // SwipeAndSearchVC.delegate = nil
        appDelegate.orderDataClear = false
        SwipeAndSearchVC.delegate = self
        ipad_SearchBar.delegate = self
        collectionView?.isPagingEnabled = UI_USER_INTERFACE_IDIOM() == .pad
        if !Keyboard._isExternalKeyboardAttached() {
            UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        }
        
        SwipeAndSearchVC.shared.isEnable = true
        if DataManager.isBluetoothPrinter {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                self.starIoExtManager = StarIoExtManager(type: StarIoExtManagerType.onlyBarcodeReader,
                                                         portName: LoadStarPrinter.getPortName(),
                                                         portSettings: LoadStarPrinter.getPortSettings(),
                                                         ioTimeoutMillis: 10000)                                      // 10000mS!!!
                
                self.starIoExtManager.cashDrawerOpenActiveHigh = LoadStarPrinter.getCashDrawerOpenActiveHigh()
                
                self.starIoExtManager.delegate = self
                
                GlobalQueueManager.shared.serialQueue.async {
                    DispatchQueue.main.async {
                        self.starIoExtManager.connect()
                    }
                }
            })
        }
        if UI_USER_INTERFACE_IDIOM() == .phone {
            SwipeAndSearchVC.delegate = nil
            SwipeAndSearchVC.delegate = self
            
            if Keyboard._isExternalKeyboardAttached() {
                SwipeAndSearchVC.shared.enableTextField()
            }
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
//        if UI_USER_INTERFACE_IDIOM() == .pad {
//        if Keyboard._isExternalKeyboardAttached() {
//            self.ipad_SearchBar.becomeFirstResponder()
//        }
//        }
//        })
     //   ipad_SearchBar.becomeFirstResponder()
        manualPaymentButton.isHidden = ordertype == .refundOrExchangeOrder
        searchViewTrailingConstraint.isActive = ordertype == .refundOrExchangeOrder
//        searchViewVerticalSpaceConstraint.isActive = ordertype == .refundOrExchangeOrder

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.starIoExtManager == nil {
            return
        }
        GlobalQueueManager.shared.serialQueue.async {
            self.starIoExtManager.disconnect()
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView?.collectionViewLayout.invalidateLayout()
        self.updatePager()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.ipadsearchView.updateCustomBorder()
        }
        controller?.dismiss(animated: true, completion: nil)
    }
    
    func addCustometPopup(){
        
        if appDelegate.str_Refundvalue == "" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                if DataManager.isCustomerManagementOn && DataManager.isPromptAddCustomer && (DataManager.cartProductsArray?.count == 0 || DataManager.cartProductsArray == nil) && self.addCustomerPOPUPFlag == true
                {
                    if DataManager.customerObj == nil  {
                        DataManager.isPaymentBtnAddCustomer = false
                        if UI_USER_INTERFACE_IDIOM() == .pad
                        {
                            self.catAndProductDelegate?.hideView?(with: "addcustomerBtn_ActionIPAD")
                        }
                        else
                        {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let secondVC = storyboard.instantiateViewController(withIdentifier: "SelectCustomerViewController") as! SelectCustomerViewController
                            //secondVC.selectedUser = CustomerObj
                            secondVC.delegate = self
                            self.present(secondVC, animated: true, completion: nil)
                            //performSegue(withIdentifier: "selectcustomer", sender: nil)
                        }
                        self.addCustomerPOPUPFlag = false
                    }
                }
            }
        }
    }
    
    //MARK: Private Functions
    private func customizeUI() {
        if(UI_USER_INTERFACE_IDIOM() == .pad)  {
            if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
            self.view_ipadSearch.isHidden = false
            if DataManager.showProductNewScan == "true"{
                self.viewScanBtn.isHidden = false
                self.wiedthViewScanBtnConst.constant = 32
                if ordertype == .refundOrExchangeOrder {
                    self.viewScanBtn.isHidden = true
                    self.wiedthViewScanBtnConst.constant = 0
                }
            }else{
                self.viewScanBtn.isHidden = true
                self.wiedthViewScanBtnConst.constant = 0
            }
        } else {
            if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .vertical
            }
            self.view_ipadSearch.isHidden = true
        }
        collectionView?.isPagingEnabled = true
        ipad_SearchBar.keyboardType = .asciiCapable
        ipad_SearchBar.setBorder(borderWidth: 1.0, borderColor: UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0), cornerRadius: 4.0)
        if #available(iOS 13.0, *) {
            ipad_SearchBar.searchTextField.backgroundColor = UIColor.white
        }
        self.view.layoutIfNeeded()
    }
    
    private func initializeVariables() {
        self.array_Products = [ProductsModel]()
        self.array_SearchProducts = [ProductsModel]()
        
        self.collectionView?.reloadData()
        isProductSearch = false
        indexofPage = 1
        searchFetchOffset = 0
        searchFetchLimit = 20
        searchPageCount = 1
        ipad_SearchBar.text = ""
        if #available(iOS 13.0, *) {
            ipad_SearchBar.searchTextField.font = UIFont.init(name: "OpenSans", size: 14)
        } else {
            // need to test iOS 12
//           if let textFieldInsideSearchBar = value(forKey: "searchField") as? UITextField {
//                textFieldInsideSearchBar.font = UIFont(name: "OpenSans", size: 14)
//            }
        }
    }
    
    //EditProductAction
    @objc func editProductAction(_ sender: UIButton) {
        selectedCollectionIndex = sender.tag
        
        delegate?.didSelectEditButton?(data: (isProductSearch == false ? self.array_Products[selectedCollectionIndex] : self.array_SearchProducts[selectedCollectionIndex]), index: selectedCollectionIndex, isSearching: isProductSearch)
        if(UI_USER_INTERFACE_IDIOM() == .pad)
        {
       //  self.editProductDelegate?.didEditProduct?(with: "editproductIPAD")
        self.editProductDelegate?.didEditProduct?(with: "iPad_ProductInfoViewController")
        }
        else
        {
            self.editProductDelegate?.didSelectProduct?(with: "editproduct")
        }
        
        controller?.dismiss(animated: true, completion: nil)
//        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
          
//
//        controller = PopViewController()
//        controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pop") as? PopViewController
//        controller?.modalPresentationStyle = UIModalPresentationStyle.popover
//        controller?.preferredContentSize = CGSize(width: 80, height: 40)
//        controller?.delegate = self
//
//        let popController = controller?.popoverPresentationController
//        popController?.permittedArrowDirections = .up
//        popController?.backgroundColor = UIColor.white
//        popController?.delegate = self
//        popController?.sourceRect = CGRect(x: -7, y: 8 , width: 3, height: 3)
//        popController?.sourceView = sender
//        if let controller = controller {
//            self.present(controller, animated: true, completion: {
//                controller.view.superview?.layer.cornerRadius = 4
//            })
//        }
    }
    
    func editButtonClicked(isClicked: Bool) {
        
        self.view.endEditing(true)
        if isClicked
        {
            delegate?.didSelectEditButton?(data: (isProductSearch == false ? self.array_Products[selectedCollectionIndex] : self.array_SearchProducts[selectedCollectionIndex]), index: selectedCollectionIndex, isSearching: isProductSearch)
            if(UI_USER_INTERFACE_IDIOM() == .pad)
            {
                self.editProductDelegate?.didEditProduct?(with: "editproductIPAD")
            }
            else
            {
                self.editProductDelegate?.didSelectProduct?(with: "editproduct")
            }
            
        }
        controller?.dismiss(animated: true, completion: nil)
    }
    
    func updateCollection()
    {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            if (self.array_SearchProducts.count>0)
            {
                self.collectionView?.isHidden = false
            }
            else
            {
                self.collectionView?.isHidden = true
            }
            self.updatePager()
        }
    }
    
    //MARK: IBAction Method
    @IBAction func manualPaymentAction(_ sender: UIButton) {
        sender.backgroundColor =  #colorLiteral(red: 0.02745098039, green: 0.5215686275, blue: 0.9058823529, alpha: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            sender.backgroundColor =  #colorLiteral(red: 0.0431372549, green: 0.462745098, blue: 0.831372549, alpha: 1)
        }
        if DataManager.isshippingRefundOnly || DataManager.isTipRefundOnly {
            return
        }
        delegate?.didTapOnManualPayment?()
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }
    @IBAction func btnScanBarCode_action(_ sender: Any) {
        if let videoDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            guard (try?AVCaptureDeviceInput(device: videoDevice)) != nil else {
                self.showAlert(title:"", message: "You have denied this app permission to access the camera. Please go to settings and enable camera access permission to be able to scan bar codes.", otherButtons: ["Enable Camera":{ (_) in
                    //...
//                 self.view_bgPopup.isHidden = true
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
                    }], cancelTitle:kCancel) { (_) in
                }
                return
            } }
    
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            BarCodeScannerVC.scanCode(fromController: self) { (scannedValue, type) in
                print(scannedValue)
                self.ipad_SearchBar.text = scannedValue
                self.callStarSerchProductScan(string: scannedValue)
            }
        }else{
            let alert = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                      UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
                    }))
            present(alert, animated: true)
        }
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

            let modelIndex: ModelIndex = ModelCapability.modelIndex(of: modelName) ?? .tsp650II


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

//MARK:- CollectionView Datasource Methods
extension ProductsContainerViewController:  UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return isProductSearch ? array_SearchProducts.count :  array_Products.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iPadcell", for: indexPath) as! iPadProductCollectionCell
        
        let array_Products: ProductsModel = isProductSearch ? self.array_SearchProducts[indexPath.row] : self.array_Products[indexPath.row]
        
        if DataManager.isshippingRefundOnly || DataManager.isTipRefundOnly {
            collectionView.isUserInteractionEnabled = false
            cell.alpha = 0.5
            //return
        } else {
            collectionView.isUserInteractionEnabled = true
            cell.alpha = 1
        }
        let price = Double(array_Products.str_price.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "$", with: "")) ?? 0.0
        cell.productPrice.text = "$" + price.roundToTwoDecimal
        cell.productCode.text = array_Products.str_product_code
        
        if refundId != "" {
            cell.productCode.isHidden = false
            
            cell.productPrice.isHidden = false
        }else{
            if self.str_showProductCodeFunctionality == "true" {
                 cell.productCode.isHidden = false
                
            }else{
                 cell.productCode.text = ""
                 cell.productCode.isHidden = true
            }
            
            if self.str_showProductPriceFunctionality == "true" {
                cell.productPrice.isHidden = false
                
            }else{
                cell.productPrice.isHidden = true
            }
        }
        
        if self.str_showImagesFunctionality == "true" {
            let image = UIImage(named: "category-bg")
            cell.productImage.image = #imageLiteral(resourceName: "m-payment")
            if let url = URL(string: array_Products.str_product_image) {
                cell.productImage.kf.setImage(with: url, placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
            }else {
                if let data = array_Products.productImageData {
                    cell.productImage.image = UIImage(data: data)
                }
            }
        }else{
            cell.productImage.image = nil
            cell.productImage.image = cell.productImage.image?.withRenderingMode(.alwaysTemplate)
            cell.productImage.tintColor =  #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        }
        
        cell.productTitle.text = array_Products.str_title
        
        cell.editButton.tag = indexPath.row
        
        if DataManager.isPosProductViewInfo == "true" {
            cell.editButton.isHidden = false
        } else {
            cell.editButton.isHidden = true
        }
        
//        if let data = UserDefaults.standard.object(forKey: "account_type") as? String {
//            if data == "Administrator" && DataManager.isProductEdit {
//
//                if ordertype == .newOrder {
//                    cell.editButton.isHidden = false
//                }else{
//                    cell.editButton.isHidden = true
//                }
//
//            } else {
//                cell.editButton.isHidden = true
//            }
//        } else {
//            cell.editButton.isHidden = true
//        }
        
        cell.editButton.addTarget(self, action: #selector(editProductAction(_:)), for: .touchUpInside)
        
        
        cell.imgOutOfStock.isHidden = true
        let ob = array_Products.str_stock
        let obj = Double(ob) ?? 0
        
        if (array_Products.isOutOfStock == 1) {
            cell.imgOutOfStock.isHidden = false
        }
        
        //        if(array_Products.unlimited_stock == "No" && (obj < 1) && self.str_noProductPurchase == "false")
        //        {
        //            cell.imgOutOfStock.isHidden = false
        //        }
        return cell
    }
    
}

//MARK:- CollectionViewLayout Delegate Methods
extension ProductsContainerViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
      //  self.editProductDelegate?.didEditProduct?(index: indexPath.row)
        
        //        self.view.endEditing(true)
        //        UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
        //
        //        let ob = self.array_Products[selectedProductCollectionIndex].str_stock
        //        let obj = Double(ob)
        //
        //        //let cartProductsArray = self.cartProductsArray[indexPath.row]
        //        let isRefundProduct = (ob as AnyObject).value(forKey: "isRefundProduct") as? Bool ?? false
        //
        //        if !isRefundProduct {
        //            if UI_USER_INTERFACE_IDIOM() == .pad {
        //                self.catAndProductDelegate?.didEditProduct?(index: indexPath.row)
        //            }else {
        //                self.editProductDelegate?.didEditProduct?(index: indexPath.row)
        //            }
        //        }
        
        if DataManager.isshippingRefundOnly || DataManager.isTipRefundOnly {
            return
        }
        
        let array_Products: ProductsModel = isProductSearch ? self.array_SearchProducts[indexPath.row] : self.array_Products[indexPath.row]
        
        HomeVM.shared.isAllDataLoaded = [false, false, false]
        selectedProductCollectionIndex = indexPath.row
        let ob = array_Products.str_stock
        let obj = Double(ob) ?? 0
        indexUpsell = indexPath.row
        if(UI_USER_INTERFACE_IDIOM() == .pad)
        {
            
            if (array_Products.isOutOfStock == 1 && self.str_noProductPurchase == "false") {
                //showAlert(message: "Out of Stock")
                return
            } else {
                self.view.endEditing(true)
                UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
                self.catAndProductDelegate?.didAddNewProduct?(data: (isProductSearch == false ? self.array_Products[selectedProductCollectionIndex] : self.array_SearchProducts[selectedProductCollectionIndex]), productDetail: (isProductSearch == false ? self.array_Products[selectedProductCollectionIndex].attributesData : self.array_SearchProducts[selectedProductCollectionIndex].attributesData))  //DDDD
                
            }
            //            if(array_Products.unlimited_stock == "No" && (obj < 1) && self.str_noProductPurchase == "false"){
            //                showAlert(message: "Out of Stock")
            //                return
            //            }else{
            //                self.view.endEditing(true)
            //                UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
            //                self.catAndProductDelegate?.didAddNewProduct?(data: (isProductSearch == false ? self.array_Products[selectedProductCollectionIndex] : self.array_SearchProducts[selectedProductCollectionIndex]), productDetail: (isProductSearch == false ? self.array_Products[selectedProductCollectionIndex].attributesData : self.array_SearchProducts[selectedProductCollectionIndex].attributesData))  //DDDD
            //            }
        }
        else
        {
            if (array_Products.isOutOfStock == 1 && self.str_noProductPurchase == "false") {
                //showAlert(message: "Out of Stock")
                return
            } else {
                self.editProductDelegate?.didSelectProduct?(with: "productDetails")
                self.editProductDelegate?.didReceiveProductDetail?(data: (isProductSearch == false ? self.array_Products[selectedProductCollectionIndex] : self.array_SearchProducts[selectedProductCollectionIndex]))
                
            }
            
            //            if(array_Products.unlimited_stock == "No" && (obj < 1)  && self.str_noProductPurchase == "false"){
            //                showAlert(message: "Out of Stock")
            //                return
            //            }else{
            //                self.editProductDelegate?.didSelectProduct?(with: "productDetails")
            //                self.editProductDelegate?.didReceiveProductDetail?(data: (isProductSearch == false ? self.array_Products[selectedProductCollectionIndex] : self.array_SearchProducts[selectedProductCollectionIndex]))
            //            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.controller?.dismiss(animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(UI_USER_INTERFACE_IDIOM() == .pad) {
            if (UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)) {
                return CGSize(width: CGFloat((collectionView.frame.size.width/4)-15), height: CGFloat((collectionView.frame.size.height / 3)-14))
            }else {
                return CGSize(width: CGFloat((collectionView.frame.size.width/3)-13), height: CGFloat((collectionView.frame.size.width / 4)+14))
            }
        }else {
            return CGSize(width: CGFloat((collectionView.frame.size.width / 3)-5), height: CGFloat((collectionView.frame.size.width / 3)-5))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left:  UI_USER_INTERFACE_IDIOM() == .pad ? 10 : 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return UI_USER_INTERFACE_IDIOM() == .pad ? 10 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return UI_USER_INTERFACE_IDIOM() == .pad ? UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) ? 15 : 13 : 2
    }
}

//MARK:- UIScrollViewDelegate Methods
extension ProductsContainerViewController:  UIScrollViewDelegate {
    
    func updatePager() {
        DispatchQueue.main.async {
            var pages = Int()
            
            if UI_USER_INTERFACE_IDIOM() == .pad {
                pages = Int(round(self.collectionView!.contentSize.width / self.collectionView!.frame.size.width))
                self.pageControl.numberOfPages = pages == 0 ? 1 : pages > 5 ? 5 : pages
            }
            
            let width = self.collectionView!.frame.width - (self.collectionView!.contentInset.left*2)
            let index = Int(round(self.collectionView!.contentOffset.x / width)) + 1
            
            let newIndex = index > 5 ? (index <= (pages - 5)) ? (Int(index/5) > 0) ? ((index - ((pages - 5) % 5)) % 5) == 0 ? 5 : ((index - ((pages - 5) % 5)) % 5) : index : (index - (pages - 5)) : index
            
            print(index,newIndex,pages)
            self.pageControl.currentPage = newIndex - 1
            
            self.catAndProductDelegate?.updatePager?(dict: ["numberofpages": self.pageControl.numberOfPages, "pageCount":self.pageControl.currentPage], isCategory: false)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isCollectionScrolled = decelerate
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        if isCollectionScrolled {
            isCollectionScrolled = !isCollectionScrolled
            if UI_USER_INTERFACE_IDIOM() == .pad {
                if (self.collectionView!.contentOffset.x + self.collectionView!.frame.width) + 10 >= (self.collectionView!.contentSize.width) {
                    indexofPage = indexofPage + 1
                    searchPageCount = searchPageCount + 1
                    isProductSearch == true ? self.getSearchProductsList() : self.getProductsList()
                }
            }else {
                if (self.collectionView!.contentOffset.y + self.collectionView!.frame.height) + 10 >= (self.collectionView!.contentSize.height) {
                    indexofPage = indexofPage + 1
                    searchPageCount = searchPageCount + 1
                    isProductSearch == true ? self.getSearchProductsList() : self.getProductsList()
                }
            }
        }
        updatePager()
    }
}

extension ProductsContainerViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
        if DataManager.isshippingRefundOnly || DataManager.isTipRefundOnly {
            return false
        }
        ipadsearchView.resetCustomError(isAddAgain: false)
        searchBar.autocorrectionType = .no
        SwipeAndSearchVC.shared.isSearchWithScanner = false
        //Hide Tool Bar
        let shortcut: UITextInputAssistantItem? = searchBar.inputAssistantItem
        shortcut?.leadingBarButtonGroups = []
        shortcut?.trailingBarButtonGroups = []
        
        dummyCardNumber = ""
        Indicator.isEnabledIndicator = false
        searchBar.showsCancelButton = false
        collectionView?.isUserInteractionEnabled = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        //Handle Swipe Reader Data
        let isSingleBeepSwiper = String(describing: dummyCardNumber.prefix(1)) == ";"
        
        if (String(describing: dummyCardNumber.prefix(2)) != "%B" && !isSingleBeepSwiper) || (String(describing: dummyCardNumber.prefix(1)) != ";" && isSingleBeepSwiper) {
            self.dummyCardNumber = ""
            return true
        }
        
        let cardNumberArray = dummyCardNumber.split(separator: isSingleBeepSwiper ? "=" : "^")
        if isSingleBeepSwiper ? cardNumberArray.count > 1 : cardNumberArray.count > 2 {
            let number = String(describing: String(describing: cardNumberArray.first ?? "").dropFirst(isSingleBeepSwiper ? 1 : 2))
            let month = String(describing: String(describing: String(describing: cardNumberArray[isSingleBeepSwiper ? 1 : 2]).prefix(4)).dropFirst(2))
            let year = String(describing: String(describing: cardNumberArray[isSingleBeepSwiper ? 1 : 2]).prefix(2))
            let name = String(describing: String(describing: cardNumberArray[isSingleBeepSwiper ? 1 : 2]).prefix(2))
            
            SwipeAndSearchVC.shared.cardData = CardData(number: number, year: "20" + year, month: month, name: name)
            self.didGetCardDetail(number: number, month: month, year: "20" + year)
        }else {
            SwipeAndSearchVC.shared.cardData = CardData(number: "", year: "", month: "", name: "")
        }
        self.dummyCardNumber = ""
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar)
    {
        ipadsearchView.resetCustomError(isAddAgain: false)
        Indicator.isEnabledIndicator = true
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            searchBar.resignFirstResponder()
            SwipeAndSearchVC.shared.enableTextField()
        }
        collectionView?.isUserInteractionEnabled = true
        isSearchTyping = false
        
        self.dummyCardNumber = ""
        isProductSearch = !(searchBar.text == "")
        
        if searchBar.text == "" {
            collectionView?.isUserInteractionEnabled = true
            searchPageCount = 1
            searchFetchLimit = 20
            searchFetchOffset = 0
            isProductSearch = false
            self.array_SearchProducts.removeAll()
            if array_Products.count > 0 {
                self.collectionView?.isHidden = false
            }else {
                self.collectionView?.isHidden = true
            }
            self.collectionView?.reloadData()
            searchBar.resignFirstResponder()
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        DataManager.automatic_upsellData.removeAll()
        ipadsearchView.resetCustomError(isAddAgain: false)
        isSearchTyping = true
        searchPageCount = 1
        indexofPage = 1
        isProductSearch = false
        
        searchPageCount = 1
        searchFetchLimit = 20
        searchFetchOffset = 0
        indexUpsell = 0
        collectionView?.isUserInteractionEnabled = true
        isUpSell = false
        if searchText.count>0
        {
            isProductSearch = true
            array_SearchProducts.removeAll()
            self.collectionView?.reloadData()
            getSearchProductsList()
        }
        else
        {
            isProductSearch = false
            Indicator.isEnabledIndicator = true
            Indicator.sharedInstance.hideIndicator()
            self.array_SearchProducts.removeAll()
            HomeVM.shared.searchProductsArray.removeAll()
            self.collectionView?.reloadData()
            self.collectionView?.isHidden = false
            indexofPage = 1
            searchPageCount = 1
            self.getProductsList()
        }
        self.updatePager()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.showsCancelButton = false
        collectionView?.isUserInteractionEnabled = true
        isProductSearch = !(searchBar.text == "")
        
        if Keyboard._isExternalKeyboardAttached() {
            searchBar.resignFirstResponder()
            return
        }
        
        guard ipad_SearchBar.text!.count >= 1 else {
            ipadsearchView.setCustomError(text: "Please enter your search.", bottomSpace: -2.0, bottomLabelSpace: -3, fontSize: 10.0)
            return
        }
        
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.contains(UIPasteboard.general.string ?? "") && text.containEmoji {
            return false
        }
        
        if range.location == 0 && text == " " {
            return false
        }
        
        dummyCardNumber.append(text)
        if String(describing: dummyCardNumber.prefix(1)) == "%" || String(describing: dummyCardNumber.prefix(2)) == "%B" ||  String(describing: dummyCardNumber.prefix(1)) == ";" {
            if (dummyCardNumber.hasPrefix("%B") &&  dummyCardNumber.hasSuffix("?\n")) || (dummyCardNumber.hasPrefix(";") &&  dummyCardNumber.hasSuffix("?")) {
                searchBar.resignFirstResponder()
            }
            return false
        }
        dummyCardNumber = ""
        
        if text == "\t" {
            return false
        }
        return true
    }
}

//MARK:- PopoverView Delegate Methods
extension ProductsContainerViewController: PopOverEditDelegate {
    override func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }
    
    override func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    override func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool
    {
        return true
    }
}

//MARK: API Methods
extension ProductsContainerViewController {
    
    func callAPItoGetCountryList() {
        HomeVM.shared.getCountryList(country: "") { (success, message, error) in
            if success == 1 {
                //...
            }else {
                if !Indicator.isEnabledIndicator {
                    return
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
    
    func callAPItoGetSourcesList(){
        HomeVM.shared.getSourcesList { (success, message, error) in
            if success == 1 {
                self.sourcesList =  HomeVM.shared.sourcesList
                print(self.sourcesList)
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
    
    func getProductsList(isCheckForAPI: Bool = false) {
        if isCheckForAPI && isAPICalled && UI_USER_INTERFACE_IDIOM() == .phone {
            return
        }
        self.isAPICalled = true
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        
        let categoryName = str_SelectedCategoryName
        var productIDS = ""
        var prodAry = [String]()
        let isInStock = isInStockCheck ? "true" : "false"

        let categoryUrl = kGetTotalProducts + "?category=\(categoryName)&show_in_stock_item_only=\(isInStock)"
        let refundIdUrl = kGetTotalProducts +  "?refundIds=\(refundId)"
        let refundIdAndCategoryUrl = kGetTotalProducts +  "?refundIds=\(refundId)&category=\(categoryName)"
        if let cartArray = DataManager.cartProductsArray {
            for i in 0..<cartArray.count {
                let obj = (cartArray as AnyObject).object(at: i)
                let productid = (obj as AnyObject).value(forKey: "productid") as? String ?? ""
                prodAry.append(productid)
            }
            productIDS = prodAry.joined(separator: ",")
        }

        var searchUrl = String()
        
        if categoryName != "" {
            searchUrl = categoryUrl
        }
        if categoryName == "Related" && productIDS != "" {
            searchUrl = categoryUrl + "&ids=\(productIDS)"
        }

        if refundId != "" {
            searchUrl = refundIdUrl
        }
        
        if categoryName != "" && refundId != "" {
            searchUrl = refundIdAndCategoryUrl
        }
        
        HomeVM.shared.getProduct(categoryName: searchUrl, pageNumber: indexofPage) { (success, message, error) in
            self.isAPICalled = false
            if success == 1 {
                let objPosApVersion =  DataManager.posAppVersion
                let objiOSVersion =  DataManager.posiOSVersion
                
                if self.addCustomerPOPUPFlag {
                    self.addCustometPopup()
                }
                //Update Data
                self.isLastIndex = !HomeVM.shared.isMoreProductFound
                self.array_Products = HomeVM.shared.productsArray
                self.str_noProductPurchase = DataManager.noInventoryPurchase!
                
                if let val = DataManager.showImagesFunctionality {
                    self.str_showImagesFunctionality = val
                }
                if let productCode = DataManager.showProductCodeFunctionality {
                    self.str_showProductCodeFunctionality = productCode
                }
                if let productPrice = DataManager.showPriceFunctionality {
                    self.str_showProductPriceFunctionality = productPrice
                }
                
                //self.str_showImagesFunctionality = DataManager.showImagesFunctionality!
                
                self.collectionView?.reloadData()
                self.updatePager()
                
                if !HomeVM.shared.isMoreProductFound {
                    self.indexofPage = self.indexofPage - 1
                }else {
                    if UI_USER_INTERFACE_IDIOM() == .pad {
                        DispatchQueue.main.async {
                            let width = self.collectionView!.frame.width - (self.collectionView!.contentInset.left*2)
                            let index = Int(round(self.collectionView!.contentOffset.x / width))
                            self.collectionView?.setContentOffset(CGPoint(x:  CGFloat(index) * (self.collectionView?.bounds.size.width)! , y: 0), animated: true)
                        }
                    }
                }
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    if DataManager.showProductNewScan == "true"{
                        self.viewScanBtn.isHidden = false
                        self.wiedthViewScanBtnConst.constant = 32
                        if self.ordertype == .refundOrExchangeOrder {
                            self.viewScanBtn.isHidden = true
                            self.wiedthViewScanBtnConst.constant = 0
                        }
                    }else{
                        self.viewScanBtn.isHidden = true
                        self.wiedthViewScanBtnConst.constant = 0
                    }
                }else{
                    self.delegate?.didGetProductListData?()
                }
                if (self.array_Products.count>0)
                {
                    self.collectionView?.isHidden = false
                }
                else
                {
                    self.collectionView?.isHidden = true
                }
                
                if HomeVM.shared.productsArray.count > 10 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        Indicator.isEnabledIndicator = true
                        Indicator.sharedInstance.hideIndicator()
                    })
                } else {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: nil)
                self.catAndProductDelegate?.didTapToRefreshHome!()
                if objiOSVersion != objPosApVersion{
                    if DataManager.isShowUpdateNow {
                        if !DataManager.isCheckForAppUpdate{
                            Indicator.isEnabledIndicator = true
                            Indicator.sharedInstance.hideIndicator()
                            DataManager.isCheckForAppUpdate = true
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "AppVersionViewController") as! AppVersionViewController
                            // self.navigationController?.pushViewController(controller, animated: false)
                            self.navigationController?.present(controller, animated: true, completion: nil)
                        }
                    }
                }
            }else {
                self.indexofPage = self.indexofPage - 1
                if (self.array_Products.count>0)
                {
                    self.collectionView?.isHidden = false
                }
                else
                {
                    self.collectionView?.isHidden = true
                }
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
                self.updatePager()
                
                if message != nil {
                    //                    self.showAlert(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    
    func getSearchProductsList() {
        let categoryName = str_SelectedCategoryName
        
        let isInStock = isInStockCheck ? "true" : "false"
        let categoryUrl = "&category=\(categoryName)&show_in_stock_item_only=\(isInStock)"
        let refundIdUrl = "&refundIds=\(refundId)"
        let refundIdAndCategoryUrl = "&refundIds=\(refundId)&category=\(categoryName)"
        let searchText = ipad_SearchBar.text!
        
        var searchUrl = ""
        
        if isUpSell == true {
            print("working upsell")
            //searchUrl = kGetTotalProducts + "?ids=" + "\(searchText)"
            searchUrl = kUpdateProduct + "\(searchText)/?category=&ids=\(searchText)"
            //isUpSell = false
        } else {
            print("not working upsell")
            searchUrl = kGetTotalProducts + "?key=" + searchText
            if categoryName != "" {
                searchUrl += categoryUrl
            }
            
            if refundId != "" {
                searchUrl += refundIdUrl
            }
            
            if categoryName != "" && refundId != "" {
                searchUrl += refundIdAndCategoryUrl
            }
        }
        
        //searchUrl = kGetTotalProducts + "?key=" + searchText
                
        DispatchQueue.main.async {
            Indicator.isEnabledIndicator = false
            Indicator.sharedInstance.showIndicator()
        }
        
        SwipeAndSearchVC.shared.isSearchWithScanner = false
        HomeVM.shared.getSearchProduct(searchText: searchUrl, searchFetchLimit: searchFetchLimit, searchPageCount: searchPageCount) { (success, message, error) in
            if success == 1 {
                //Update Data
                DispatchQueue.main.async {
                    self.array_SearchProducts = HomeVM.shared.searchProductsArray
                    self.collectionView?.reloadData()
                    self.collectionView?.isHidden = HomeVM.shared.searchProductsArray.count == 0
                    
                    if HomeVM.shared.searchProductsArray.count == 1 {
                        if(UI_USER_INTERFACE_IDIOM() == .pad)
                        {
                            //self.cartview.delegateUpdate = self
                            self.view.endEditing(true)
                            UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
                            appDelegate.strSearch = self.ipad_SearchBar.text!
                            
                            let (successOne, variationValue) = ProductModel.shared.parseVariationData(productData: HomeVM.shared.searchProductsArray.first!)
                            print(variationValue as Any)
                            if categoryName == "Serial Number" {
                                HomeVM.shared.searchProductsArray[0].serialNumberSearch = searchText
                            }
                            if variationValue?.count ?? 0 > 0 {
                                self.catAndProductDelegate?.didAddNewProduct?(data: HomeVM.shared.searchProductsArray.first!, productDetail: HomeVM.shared.searchProductsArray.first!)
                            }else{
                                if !DataManager.isPosSingleResultAutoAddToCart {
                                    if self.isUpSell {
                                        DataManager.isUPSellProduct = true
                                    } else {
                                        DataManager.isUPSellProduct = false
                                    }
                                    self.catAndProductDelegate?.didAddNewProduct?(data: HomeVM.shared.searchProductsArray.first!, productDetail: HomeVM.shared.searchProductsArray.first!) //DDDD
                                } else {
                                    if self.isUpSell {
                                        DataManager.isUPSellProduct = true
                                        self.catAndProductDelegate?.didAddNewProduct?(data: HomeVM.shared.searchProductsArray.first!, productDetail: HomeVM.shared.searchProductsArray.first!) //DDDD
                                    } else {
                                        DataManager.isUPSellProduct = false
                                        if self.array_SearchProducts[0].isEditPrice {
                                            self.catAndProductDelegate?.didAddNewProduct?(data: HomeVM.shared.searchProductsArray.first!, productDetail: HomeVM.shared.searchProductsArray.first!)
                                        }
                                        
                                    }
                                }
                            }
                        }
                        else
                        {
                            if categoryName == "Serial Number" {
                                HomeVM.shared.searchProductsArray[0].serialNumberSearch = searchText
                            }
                            self.editProductDelegate?.didSelectProduct?(with: "productDetails")
                            self.editProductDelegate?.didReceiveProductDetail?(data: HomeVM.shared.searchProductsArray.first!)
                        }
                        
                        self.searchPageCount = 1
                        self.searchFetchLimit = 20
                        self.searchFetchOffset = 0
                        if HomeVM.shared.searchProductsArray.count > 0 {
                            let (successOne, variationValue) = ProductModel.shared.parseVariationData(productData: HomeVM.shared.searchProductsArray.first!)
                            print(variationValue as Any)
                            if variationValue?.count ?? 0 > 0 {
                                if !DataManager.isPosSingleResultAutoAddToCart {
                                    if self.isUpSell {
                                        self.isProductSearch = false
                                        self.array_SearchProducts.removeAll()
                                    } else {
                                        self.isProductSearch = true
                                    }
                                    
                                    //self.array_SearchProducts.removeAll()
                                } else {
                                    if self.isUpSell {
                                        self.isProductSearch = false
                                        self.array_SearchProducts.removeAll()
                                    } else {
                                        self.isProductSearch = true
                                    }
                                }
                            }else{
                                if !DataManager.isPosSingleResultAutoAddToCart {
                                    self.isProductSearch = false
                                    self.array_SearchProducts.removeAll()
                                }else{
                                    if self.isUpSell {
                                        self.isProductSearch = false
                                        self.array_SearchProducts.removeAll()
                                    } else {
                                        self.isProductSearch = true
                                    }
                                    // self.array_SearchProducts.removeAll()
                                }
                            }
                        }
                        //self.isProductSearch = false
                        self.collectionView?.isHidden = false
                       // self.array_SearchProducts.removeAll()
                        self.collectionView?.reloadData()
                        self.ipad_SearchBar.text = ""
                    }
                    self.updatePager()
                    
                    if !HomeVM.shared.isMoreProductFound {
                        self.searchPageCount = self.searchPageCount - 1
                    } else {
                        if UI_USER_INTERFACE_IDIOM() == .pad {
                            DispatchQueue.main.async {
                                let width = self.collectionView!.frame.width - (self.collectionView!.contentInset.left*2)
                                let index = Int(round(self.collectionView!.contentOffset.x / width))
                                self.collectionView?.setContentOffset(CGPoint(x:  CGFloat(index) * (self.collectionView?.bounds.size.width)! , y: 0), animated: true)
                            }
                        }
                    }
                }
                
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    if !Keyboard._isExternalKeyboardAttached() && DataManager.isBarCodeReaderOn {
                        self.ipad_SearchBar.becomeFirstResponder()
                    }
                }
                
                DispatchQueue.main.async {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                }
            } else {
                self.isUpSell = false
                DispatchQueue.main.async {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                }
                
                if (self.ipad_SearchBar.text?.isEmpty ?? false) && error == nil {
                    HomeVM.shared.searchProductsArray.removeAll()
                    self.array_SearchProducts.removeAll()
                    self.searchPageCount = 1
                    self.searchFetchLimit = 20
                    self.searchFetchOffset = 0
                    self.isProductSearch = false
                    self.isProductSearch = false
                    self.collectionView?.reloadData()
                    self.collectionView?.isHidden = false
                    self.updatePager()
                    return
                }
                if self.searchPageCount == 1 {
                    self.searchPageCount = self.searchPageCount - 1
                    self.array_SearchProducts.removeAll()
                    self.collectionView?.reloadData()
                    self.collectionView?.isHidden = true
                }
//                self.searchPageCount = self.searchPageCount - 1
//                self.array_SearchProducts.removeAll()
//                self.collectionView?.reloadData()
//                self.collectionView?.isHidden = true
                self.updatePager()
                if message != nil {
                    //...
                } else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    
}

extension ProductsContainerViewController: CategoriesContainerViewControllerDelegate {
    func getProduct(withCategory name: String) {
        self.array_Products = [ProductsModel]()
        self.array_SearchProducts = [ProductsModel]()
        DataManager.automatic_upsellData.removeAll()
        HomeVM.shared.searchProductsArray.removeAll()
        self.array_Products.removeAll()
        array_SearchProducts.removeAll()
        ipad_SearchBar.text = ""
        isProductSearch = false
        self.collectionView?.reloadData()
        self.updatePager()
        
        self.str_SelectedCategoryName = name
        indexofPage = 1
        getProductsList()
    }
}

//MARK: ProductsViewControllerDelegate
extension ProductsContainerViewController: ProductsViewControllerDelegate {
    func getProductList() {
        if isProductSearch {
            self.array_SearchProducts = HomeVM.shared.searchProductsArray
        }else {
            self.array_Products = HomeVM.shared.productsArray
            str_noProductPurchase = DataManager.noInventoryPurchase!
            
        }
        
        self.collectionView?.reloadData()
        self.collectionView?.isHidden = false
        self.collectionView?.isUserInteractionEnabled = true
        
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
        
    }
}

//MARK: ProductsViewControllerDelegate
extension ProductsContainerViewController: ProductSearchContainerDelegate {
    func didSearchCancel() {
        //....
    }
    func didShowInStockItemOnly(inStock: Bool) {
        self.array_Products.removeAll()
        array_SearchProducts.removeAll()
        isInStockCheck = inStock
        indexofPage = 1
        searchPageCount = 1
        self.collectionView?.reloadData()
        isProductSearch == true ? self.getSearchProductsList() : self.getProductsList()
        updatePager()
    }
    func didSelectCategory(string: String) {
        self.array_Products.removeAll()
        array_SearchProducts.removeAll()
        self.indexofPage = 1
        self.collectionView?.reloadData()
        self.str_SelectedCategoryName = string
        getProductsList()
    }
    func didAutoUpSellDataValueIphone() { // For iphone upsell by dd (30 Nov 2022)
        print("work data value")
        if DataManager.isEditProductForUpsell {
            DataManager.isEditProductForUpsell = false
            return
        }
        if HomeVM.shared.searchProductsArray.count > indexUpsell {
            if HomeVM.shared.searchProductsArray[indexUpsell].automatic_upsell.count > 0{
                let productQtyInCart = self.getPreviousQty(productId: HomeVM.shared.searchProductsArray[indexUpsell].automatic_upsell[0])
                let array_Products: ProductsModel = isProductSearch ? HomeVM.shared.searchProductsArray[0] : self.array_Products[0]
                let stock = Double(array_Products.str_stock) ?? 0
                let unlimitedstock = array_Products.unlimited_stock
                let limitqty = Double(array_Products.str_limit_qty) ?? 0
                let variationQuantity = Double(array_Products.str_stock) ?? 0
                let availableqty = self.getAvailableQty(unlimited: unlimitedstock, limitQty: limitqty, stock: stock)
                if (productQtyInCart) >= availableqty {
                    
                    if DataManager.noInventoryPurchase == "false" {
                        
                        if limitqty > 0 {
                            if Int((productQtyInCart)) >= Int(limitqty) {
                                return
                            }
                        }
                        
                        if Double((productQtyInCart)) >= variationQuantity {
                            print("enterrrrrrrr")
                            return
                        } else {
                            print("ouuuuuutttterrerrerre")
                        }
                    } else {
                        if limitqty > 0 {
                            if Int((productQtyInCart)) >= Int(limitqty) {
                                                        
                                return
                            }
                        }
                    }
                }
            }

            isUpSell = false
            if HomeVM.shared.searchProductsArray[indexUpsell].automatic_upsell.count > 0 {
                isUpSell = true
                ipad_SearchBar.text = HomeVM.shared.searchProductsArray[indexUpsell].automatic_upsell[0]
                callStarSerchProductScan(string: ipad_SearchBar.text!)
                DataManager.automatic_upsellData.removeAll()
                indexUpsell = 0
            } else {
                print("data value change u")
                isUpSell = false
                DataManager.automatic_upsellData.removeAll()
                if isProductSearch {
                    HomeVM.shared.productsArray.removeAll()
                } else {
                    HomeVM.shared.searchProductsArray.removeAll()
                }
                DataManager.isUPSellProduct = false
            }
        } else if HomeVM.shared.productsArray.count > indexUpsell {
            isUpSell = false
            if HomeVM.shared.productsArray[indexUpsell].automatic_upsell.count > 0 {
                isUpSell = true
                ipad_SearchBar.text = HomeVM.shared.productsArray[indexUpsell].automatic_upsell[0]
                callStarSerchProductScan(string: ipad_SearchBar.text!)
                DataManager.automatic_upsellData.removeAll()
                indexUpsell = 0
            } else {
                print("data value change u")
                isUpSell = false
                DataManager.automatic_upsellData.removeAll()
                HomeVM.shared.searchProductsArray.removeAll()
                DataManager.isUPSellProduct = false

            }
        } else {
            isUpSell = false
            print("data value change")
            DataManager.automatic_upsellData.removeAll()
            HomeVM.shared.searchProductsArray.removeAll()
            DataManager.isUPSellProduct = false
        }
        
    }

    func didSearchComplete(with product: ProductsModel) {
        if(UI_USER_INTERFACE_IDIOM() == .pad)
        {
            self.view.endEditing(true)
            UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
            self.catAndProductDelegate?.didAddNewProduct?(data: product, productDetail: product)  //DDDD
        }
        else
        {
            self.editProductDelegate?.didSelectProduct?(with: "productDetails")
            self.editProductDelegate?.didReceiveProductDetail?(data: product)
        }
    }
}
//MARK: SelectedCutomerDelegate
extension ProductsContainerViewController: SelectedCutomerDelegate {
    func selectedCustomerData(customerdata: CustomerListModel)
    {
        if UI_USER_INTERFACE_IDIOM() == .pad {
            return
        }
        
        if customerdata.user_has_open_invoice == "true" {
            print("true")
            self.dismiss(animated: true, completion: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController2 = storyboard.instantiateViewController(withIdentifier: "OrdersViewController") as! OrdersViewController
            self.navigationController?.pushViewController(viewController2, animated: true)
            // }
        }
    }
}
//MARK: ResetCartDelegate
extension ProductsContainerViewController: ResetCartDelegate {
    func updateKeyboardStatus(isShow: Bool) {
        if isShow {
            if !iPad_AccessPINViewController.isPresented {
                //self.ipad_SearchBar.becomeFirstResponder()
            }
        }else {
            self.ipad_SearchBar.resignFirstResponder()
        }
    }
    
    func resetHomeCart() {
        self.resetCart()
    }
    
    func resetCart() {
        self.refundId = ""
        self.view.endEditing(true)
        isSearchTyping = false
        isProductSearch = false
        isUpSell = false
        ipad_SearchBar.resignFirstResponder()
        self.initializeVariables()
        self.updatePager()
        self.getProductsList()
        
        self.callAPItoGetSourcesList()
    }

    func getPreviousQty(productId: String) -> Double {
        var productPrevQty: Double = 0
        if let cartArray = DataManager.cartProductsArray {
            for cartProd in cartArray {
                let prevQty = Double((cartProd as AnyObject).value(forKey: "productqty") as? String ?? "") ?? 0
                let id = (cartProd as AnyObject).value(forKey: "productid") as? String ?? ""
                let attributesID = (cartProd as AnyObject).value(forKey: "attributesID") as? [String] ?? [String]()
                
                //                let dat = (cartProd as AnyObject).value(forKey: "variation_use_parent_stock") as? String ?? ""
                //                print(dat)
                
                let array_Products: ProductsModel = isProductSearch ? self.array_SearchProducts[0] : self.array_Products[0]
                
                let stock_Check = Double(array_Products.str_stock) ?? 0
                let limt_Check = Double(array_Products.str_limit_qty) ?? 0
                
                if stock_Check > 0.0 && array_Products.unlimited_stock == "No" {
                    if productId == id {//&& productAttributesID.containsSameElements(as: attributesID) {
                        productPrevQty += prevQty
                    }
                } else if limt_Check > 0.0 {
                    if productId == id {//&& productAttributesID.containsSameElements(as: attributesID) {
                        productPrevQty += prevQty
                    }
                } else {
                    if productId == id {//&& productAttributesID.containsSameElements(as: attributesID) {
                        productPrevQty += prevQty
                    }
                }
            }
        }
        return productPrevQty
    }
        
    func getAvailableQty(unlimited: String, limitQty: Double, stock: Double ) -> Double {
        var availableQty: Double = 9999
        if(unlimited.uppercased()=="YES"){
            if(limitQty>0){
                availableQty = limitQty
            }
        }else if(unlimited.uppercased()=="NO"){
            if(stock<=0){
                availableQty=0;
            }else if(limitQty>0 && stock>0){
                if(limitQty>stock){
                    availableQty = stock
                }else{
                    availableQty = limitQty
                }
            }else if(limitQty==0 && stock>0){
                availableQty = stock
            }
        }
        return availableQty
    }
    
    func didAutoUpSellDataValue() {
        print("work data value")
        if DataManager.isEditProductForUpsell {
            DataManager.isEditProductForUpsell = false
            return
        }
        if HomeVM.shared.searchProductsArray.count > indexUpsell {
            if HomeVM.shared.searchProductsArray[indexUpsell].automatic_upsell.count > 0{
                let productQtyInCart = self.getPreviousQty(productId: HomeVM.shared.searchProductsArray[indexUpsell].automatic_upsell[0])
                let array_Products: ProductsModel = isProductSearch ? HomeVM.shared.searchProductsArray[0] : self.array_Products[0]
                let stock = Double(array_Products.str_stock) ?? 0
                let unlimitedstock = array_Products.unlimited_stock
                let limitqty = Double(array_Products.str_limit_qty) ?? 0
                let variationQuantity = Double(array_Products.str_stock) ?? 0
                let availableqty = self.getAvailableQty(unlimited: unlimitedstock, limitQty: limitqty, stock: stock)
                if (productQtyInCart) >= availableqty {
                    
                    if DataManager.noInventoryPurchase == "false" {
                        
                        if limitqty > 0 {
                            if Int((productQtyInCart)) >= Int(limitqty) {
                                return
                            }
                        }
                        
                        if Double((productQtyInCart)) >= variationQuantity {
                            print("enterrrrrrrr")
                            return
                        } else {
                            print("ouuuuuutttterrerrerre")
                        }
                    } else {
                        if limitqty > 0 {
                            if Int((productQtyInCart)) >= Int(limitqty) {
                                                        
                                return
                            }
                        }
                    }
                }
            }

            isUpSell = false
            if HomeVM.shared.searchProductsArray[indexUpsell].automatic_upsell.count > 0 {
                isUpSell = true
                ipad_SearchBar.text = HomeVM.shared.searchProductsArray[indexUpsell].automatic_upsell[0]
                callStarSerchProductScan(string: ipad_SearchBar.text!)
                DataManager.automatic_upsellData.removeAll()
                indexUpsell = 0
            } else {
                print("data value change u")
                isUpSell = false
                DataManager.automatic_upsellData.removeAll()
                if isProductSearch {
                    HomeVM.shared.productsArray.removeAll()
                } else {
                    HomeVM.shared.searchProductsArray.removeAll()
                }
                DataManager.isUPSellProduct = false
            }
        } else if HomeVM.shared.productsArray.count > indexUpsell {
            isUpSell = false
            if HomeVM.shared.productsArray[indexUpsell].automatic_upsell.count > 0 {
                isUpSell = true
                ipad_SearchBar.text = HomeVM.shared.productsArray[indexUpsell].automatic_upsell[0]
                callStarSerchProductScan(string: ipad_SearchBar.text!)
                DataManager.automatic_upsellData.removeAll()
                indexUpsell = 0
            } else {
                print("data value change u")
                isUpSell = false
                DataManager.automatic_upsellData.removeAll()
                HomeVM.shared.searchProductsArray.removeAll()
                DataManager.isUPSellProduct = false

            }
        } else {
            isUpSell = false
            print("data value change")
            DataManager.automatic_upsellData.removeAll()
            HomeVM.shared.searchProductsArray.removeAll()
            DataManager.isUPSellProduct = false
        }
        
    }
    func didShowInStockItemOnly(isStock: Bool) {
        isInStockCheck = isStock
        self.array_Products = [ProductsModel]()
        self.array_SearchProducts = [ProductsModel]()
        ipad_SearchBar.text = ""
        isProductSearch = false
        self.collectionView?.reloadData()
        indexofPage = 1
        searchPageCount = 1
        isProductSearch == true ? self.getSearchProductsList() : self.getProductsList()
        updatePager()
    }
}

//MARK: SwipeAndSearchDelegate
extension ProductsContainerViewController: SwipeAndSearchDelegate {
    func didReceiveRefundProductIds(string: String) {
        controller?.dismiss(animated: true, completion: nil)
        self.refundId = string
        self.manualPaymentButton.isHidden = string != ""
        searchViewTrailingConstraint.isActive = string != ""
        searchViewVerticalSpaceConstraint.isActive = string == ""
        
        if string != "" {
            self.getProductsList()
        }
    }
    
    func didSearchingProduct() {
        print("Searching")
        controller?.dismiss(animated: true, completion: nil)
        
    }
    func didSearchingProductScaner(text: String) {
        self.array_SearchProducts.removeAll()
        self.searchPageCount = 1
        self.searchFetchLimit = 20
        self.searchFetchOffset = 0
        isProductSearch = true
        ipad_SearchBar.text = text
        collectionView?.reloadData()
        getSearchProductsList()
    }
    
    func didSearchedProduct(product: ProductsModel) {
        controller?.dismiss(animated: true, completion: nil)
        self.catAndProductDelegate?.hideView?(with: "addcustomerCancelIPAD")
        DispatchQueue.main.async {
            if(UI_USER_INTERFACE_IDIOM() == .pad)
            {
                self.view.endEditing(true)
                UIApplication.shared.keyWindow?.rootViewController?.view.endEditing(true)
                self.catAndProductDelegate?.didAddNewProduct?(data: product, productDetail: product)  //DDDD
            }
            else
            {
                self.editProductDelegate?.didSelectProduct?(with: "productDetails")
                self.editProductDelegate?.didReceiveProductDetail?(data: product)
            }
            
            self.searchPageCount = 1
            self.searchFetchLimit = 20
            self.searchFetchOffset = 0
            self.isProductSearch = false
            self.collectionView?.isHidden = false
            self.array_SearchProducts.removeAll()
            self.collectionView?.reloadData()
            self.ipad_SearchBar.text = ""
        }
        self.updatePager()
    }
    func didSearchedProductMultiProduct(product: [ProductsModel],text:String) {
        ipad_SearchBar.text = text
        isProductSearch = true
        self.array_SearchProducts = HomeVM.shared.searchProductsArray
        self.collectionView?.reloadData()
        updatePager()
    }
    func noProductFound() {
        print("no product found")
        controller?.dismiss(animated: true, completion: nil)
        self.catAndProductDelegate?.hideView?(with: "addcustomerCancelIPAD")
        self.collectionView?.isHidden = true
        self.editProductDelegate?.hideDetailView?()
    }
    
    func didEndSearching() {
        controller?.dismiss(animated: true, completion: nil)
        if UI_USER_INTERFACE_IDIOM() == .phone {
            getProductsList(isCheckForAPI: true)
        }
        collectionView?.isUserInteractionEnabled = true
        isProductSearch = false
        
        searchPageCount = 1
        searchFetchLimit = 20
        searchFetchOffset = 0
        ipad_SearchBar.text = ""
        if UI_USER_INTERFACE_IDIOM() == .pad
        {
            if !HomeVM.shared.isAllDataLoaded.contains(false) && DataManager.isBarCodeReaderOn  {
                if !Keyboard._isExternalKeyboardAttached() {
                    if !iPad_AccessPINViewController.isPresented {
                        //self.ipad_SearchBar.becomeFirstResponder()
                    }
                }
            }
        }
        
        self.array_SearchProducts.removeAll()
        self.collectionView?.isHidden = false
        self.collectionView?.reloadData()
    }
    
    func didGetCardDetail(number: String, month: String, year: String) {
        controller?.dismiss(animated: true, completion: nil)
        delegate?.didGetCardDetail?()
    }
    
    func noCardDetailFound() {
        controller?.dismiss(animated: true, completion: nil)
        delegate?.noCardDetailFound?()
    }
}

//MARK: OfflineDataManagerDelegate
extension ProductsContainerViewController: OfflineDataManagerDelegate {
    func didUpdateInternetConnection(isOn: Bool) {
        self.delegate?.didUpdateInternet?(isOn: isOn)
        if isOn {
            self.resetCart()
        }else {
            array_SearchProducts.removeAll()
            array_Products.removeAll()
            collectionView?.reloadData()
            self.collectionView?.isHidden = true
            self.catAndProductDelegate?.hideView?(with: "addcustomerCancelIPAD")
            self.editProductDelegate?.hideDetailView?()
        }
    }
}

extension ProductsContainerViewController: StarIoExtManagerDelegate {
    func didBarcodeDataReceive(_ manager: StarIoExtManager!, data: Data!) {
        NSLog("%@", MakePrettyFunction())
        
        guard let str = String(data: data, encoding: .ascii) else {
            return
        }
        
        var lines = [String]()
        
        str.enumerateLines { (line, stop) -> () in
            lines.append(line)
        }
        print("lines :   \(lines)")
        for bcrStr in lines {
            ipad_SearchBar.text = bcrStr
            callStarSerchProductScan(string: bcrStr)
                        self.cellArray.add([bcrStr])
            break

//            if self.cellArray.count > 30 {     // Max.30Line
//                self.cellArray.removeObject(at: 0)
//
////                self.tableView.reloadData()
//            }
//
//            self.cellArray.add([bcrStr])
        }
        ScreenSaver.sharedInstance.hideScreenSaver()
        
        print("Bar code array\(self.cellArray)")
       
    }
    
    func callStarSerchProductScan(string: String){
        ipadsearchView.resetCustomError(isAddAgain: false)
        isSearchTyping = true
        searchPageCount = 1
        indexofPage = 1
        isProductSearch = false
        
        searchPageCount = 1
        searchFetchLimit = 20
        searchFetchOffset = 0
        
        collectionView?.isUserInteractionEnabled = true
        
        if string.count>0
        {
            isProductSearch = true
            array_SearchProducts.removeAll()
            self.collectionView?.reloadData()
            getSearchProductsList()
        }
        else
        {
            isProductSearch = false
            Indicator.isEnabledIndicator = true
            Indicator.sharedInstance.hideIndicator()
            self.array_SearchProducts.removeAll()
            self.collectionView?.reloadData()
            self.collectionView?.isHidden = false
        }
        self.updatePager()
    }
    
    func didBarcodeReaderImpossible(_ manager: StarIoExtManager!) {
        NSLog("%@", MakePrettyFunction())
        
//        self.commentLabel.text = "Barcode Reader Impossible."
//
//        self.commentLabel.textColor = UIColor.red
//
//        self.beginAnimationCommantLabel()
    }
    
    func didBarcodeReaderConnect(_ manager: StarIoExtManager!) {
        NSLog("%@", MakePrettyFunction())
        
//        self.commentLabel.text = "Barcode Reader Connect."
//
//        self.commentLabel.textColor = UIColor.blue
//
//        self.beginAnimationCommantLabel()
    }
    
    func didBarcodeReaderDisconnect(_ manager: StarIoExtManager!) {
        NSLog("%@", MakePrettyFunction())
        
//        self.commentLabel.text = "Barcode Reader Disconnect."
//
//        self.commentLabel.textColor = UIColor.red
//
//        self.beginAnimationCommantLabel()
    }
    
    func didAccessoryConnectSuccess(_ manager: StarIoExtManager!) {
        NSLog("%@", MakePrettyFunction())
        
//        self.commentLabel.text = "Accessory Connect Success."
//
//        self.commentLabel.textColor = UIColor.blue
//
//        self.beginAnimationCommantLabel()
    }
    
    func didAccessoryConnectFailure(_ manager: StarIoExtManager!) {
        NSLog("%@", MakePrettyFunction())
        
//        self.commentLabel.text = "Accessory Connect Failure."
//
//        self.commentLabel.textColor = UIColor.red
//
//        self.beginAnimationCommantLabel()
    }
    
    func didAccessoryDisconnect(_ manager: StarIoExtManager!) {
        NSLog("%@", MakePrettyFunction())
        
//        self.commentLabel.text = "Accessory Disconnect."
//
//        self.commentLabel.textColor = UIColor.red
//
//        self.beginAnimationCommantLabel()
    }
    
    func didStatusUpdate(_ manager: StarIoExtManager!, status: String!) {
        NSLog("%@", MakePrettyFunction())
        
//      self.commentLabel.text = status
//
//      self.commentLabel.textColor = UIColor.green
//
//      self.beginAnimationCommantLabel()
    }
}
