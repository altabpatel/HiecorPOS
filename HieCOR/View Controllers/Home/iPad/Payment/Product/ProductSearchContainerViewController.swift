//
//  ProductSearchContainerViewController.swift
//  HieCOR
//
//  Created by Deftsoft on 17/08/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import CoreData

class ProductSearchContainerViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet var searchTable: UITableView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet weak var searchBackView: UIView!
    @IBOutlet weak var wiedthScanBtnConst: NSLayoutConstraint!
    //MARK: Variables
    var productsArray = [ProductsModel]()
    var recentSearchArray = [String]()
    var str_SelectedCategoryName = String()
    var delegate: ProductSearchContainerDelegate?
    var selectedProductIds = String()
    var indexUpsell = 0
    var orderType: OrderType = .newOrder
    //MARK: Private Variables
    fileprivate var fetchOffset = 1
    fileprivate var fetchLimit = 15
    fileprivate var isLoadMore : Bool = false
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
    }
    
    //MARK: Private Functions
    private func customizeUI() {
        searchTable.tableFooterView = UIView()
        searchTextField.delegate = self
        if DataManager.showProductNewScan == "true" || orderType == .refundOrExchangeOrder{
            wiedthScanBtnConst.constant = 35
        }else{
            wiedthScanBtnConst.constant = 0
        }
    }
    
    func removeData() {
        searchBackView.resetCustomError()
        searchTextField.text = ""
        self.productsArray.removeAll()
        self.recentSearchArray.removeAll()
        if let array = DataManager.recentProductSearchArray {
            self.recentSearchArray = array
        }
        self.searchTable.reloadData()
        DispatchQueue.main.async {
            self.searchTextField.becomeFirstResponder()
        }
    }
    
    //MARK: IBAction Method 
    @IBAction func btn_BackAction(_ sender: Any) {
        self.view.endEditing(true)
        searchBackView.resetCustomError()
        fetchLimit = 15
        fetchOffset = 1
        searchTable.reloadData()
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        delegate?.didSearchCancel()
    }
    @IBAction func btnSacnBarCode_Action(_ sender: Any) { // by Altab
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            BarCodeScannerVC.scanCode(fromController: self) { (scannedValue, type) in
                print(scannedValue)
                self.fetchLimit = 15
                self.fetchOffset = 1
                self.searchTextField.text = scannedValue
                self.getSearchProductsList()
//                self.callStarSerchProductScan(string: scannedValue)
            }
        }else{
            let alert = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
            }))
            present(alert, animated: true)
        }
    }
    
    @IBAction func searchTextFieldDidChange(_ sender: Any) {
        fetchLimit = 15
        fetchOffset = 1
        searchBackView.resetCustomError()
        if searchTextField.text != "" {
            self.getSearchProductsList()
        }else {
            self.productsArray.removeAll()
        }
        searchTable.reloadData()
    }
}

//MARK: ProductsViewControllerDelegate
extension ProductSearchContainerViewController: ProductsViewControllerDelegate {
    func didTapOnSearchButton() {
        str_SelectedCategoryName = DataManager.selectedCategory
        removeData()
    }
    func didReceiveRefundProductIds(string: String) {
        selectedProductIds = string
    }
    func didAutoUpSellDataValueIphone() {
        print("work data")
        if HomeVM.shared.searchProductsArray.count > 0 {
            if HomeVM.shared.searchProductsArray[indexUpsell].automatic_upsell.count > 0 {
                searchTextField.text = HomeVM.shared.searchProductsArray[indexUpsell].automatic_upsell[0]
                getSearchProductsList()
                DataManager.automatic_upsellData.removeAll()
                indexUpsell = 0
            }
        }
        
    }
}

//MARK: UIsearchTextFieldDelegate
extension ProductSearchContainerViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchBackView.resetCustomError()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        fetchLimit = 15
          fetchOffset = 1
        if searchTextField.text == "" {
            self.productsArray.removeAll()
        }
        searchTable.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == searchTextField {
            if string.contains(UIPasteboard.general.string ?? "") && string.containEmoji {
                return false
            }
            if range.location == 0 && string == " " {
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if searchTextField.text == ""{
            searchBackView.setCustomError(text: "Please enter product name to search.",bottomSpace: -1, rightSpace: 10, bottomLabelSpace: 0)
        }
        searchTextField.resignFirstResponder()
        appendValueToRecentSearch()
        return true
    }
}

//MARK: UITableViewDelegate & UITableViewDataSource
extension ProductSearchContainerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 1 {
            return 0
        }
        return self.productsArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let lbl_Name = cell.contentView.viewWithTag(1) as? UILabel
        
        if indexPath.section == 1 {
            lbl_Name?.text = recentSearchArray[indexPath.row]
            return cell
        }
        lbl_Name?.text = self.productsArray[indexPath.row].str_title
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchTextField.resignFirstResponder()
        if indexPath.section == 1 {
            self.productsArray = [ProductsModel]()
            fetchLimit = 15
            fetchOffset = 1
            searchTextField.text = recentSearchArray[indexPath.row]
            getSearchProductsList()
            return
        }
        indexUpsell = indexPath.row
        appendValueToRecentSearch()
        delegate?.didSearchComplete(with: self.productsArray[indexPath.row])
        delegate?.didSearchCancel()
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellHeader")
            let button = cell?.contentView.viewWithTag(20) as? UIButton
            button?.addTarget(self, action: #selector(handleCrossButtonAction(sender:)), for: .touchUpInside)
            return cell
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 0
        }
        return 0
    }
    
    @objc func handleCrossButtonAction(sender: UIButton) {
        self.recentSearchArray.removeAll()
        DataManager.recentProductSearchArray?.removeAll()
        self.searchTable.reloadData()
    }
    
    func appendValueToRecentSearch() {
        if searchTextField.text != "" {
            if let index = recentSearchArray.index(where: {$0.lowercased() == searchTextField.text?.lowercased()}) {
                recentSearchArray.remove(at: index)
            }
            self.recentSearchArray.append(searchTextField.text!)
            DataManager.recentProductSearchArray = self.recentSearchArray
        }
        self.searchTable.reloadData()
    }
    
    //ScrollView Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBackView.resetCustomError()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (searchTable.contentOffset.y + searchTable.frame.height) >= (searchTable.contentSize.height - 50) {
            if productsArray.count > 0 {
                fetchOffset = fetchOffset + 1
                getSearchProductsList()
            }
        }
    }
}

//MARK: API Methods
extension ProductSearchContainerViewController {

    func getSearchProductsList() {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()

        let categoryName = str_SelectedCategoryName
        
        let categoryUrl = "&category=\(categoryName)"
        let refundIdUrl = "&refundIds=\(selectedProductIds)"
        let refundIdAndCategoryUrl = "&refundIds=\(selectedProductIds)&category=\(categoryName)"
        let searchText = searchTextField.text!
        
        var searchUrl = ""
        if DataManager.isUPSellProduct == true {
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
            
            if selectedProductIds != "" {
                searchUrl += refundIdUrl
            }
            
            if categoryName != "" && selectedProductIds != "" {
                searchUrl += refundIdAndCategoryUrl
            }
        }
        
        DispatchQueue.main.async {
            Indicator.isEnabledIndicator = false
            Indicator.sharedInstance.showIndicator()
        }
        
        SwipeAndSearchVC.shared.isSearchWithScanner = false
        HomeVM.shared.getSearchProduct(searchText: searchUrl, searchFetchLimit: fetchLimit, searchPageCount: fetchOffset) { (success, message, error) in
            if success == 1 {
                if !HomeVM.shared.isMoreProductFound {
                    self.fetchOffset = self.fetchOffset - 1
                }
                //Update Data
                DispatchQueue.main.async {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                    self.productsArray = HomeVM.shared.searchProductsArray
                    if self.searchTextField.text == "" {
                        self.productsArray.removeAll()
                    }
                    self.searchTable.reloadData()
                    //Add Automatically to cart
                    if HomeVM.shared.searchProductsArray.count == 1 { //}&& (HomeVM.shared.searchProductsArray[0].str_title.lowercased() == searchText.replacingOccurrences(of: category, with: "").replacingOccurrences(of: "%20", with: " ").lowercased() || HomeVM.shared.searchProductsArray[0].code.lowercased() == searchText.replacingOccurrences(of: category, with: "").lowercased() ) {
                        if categoryName == "Serial Number" {
                            HomeVM.shared.searchProductsArray[0].serialNumberSearch = searchText
                        }
                        self.appendValueToRecentSearch()
                        self.delegate?.didSearchComplete(with: HomeVM.shared.searchProductsArray[0])
                        self.delegate?.didSearchCancel()
                        self.view.endEditing(true)
                    }
                }
            }else {
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
                self.fetchOffset = self.fetchOffset - 1
                if message != nil {
                    self.productsArray.removeAll()
                    self.searchTable.reloadData()
                    self.searchBackView.setCustomError(text: message!,bottomSpace: -1, rightSpace: 10, bottomLabelSpace: 0)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }

}
