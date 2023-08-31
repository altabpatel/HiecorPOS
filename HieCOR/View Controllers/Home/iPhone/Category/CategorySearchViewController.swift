//
//  CategorySearchViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 19/01/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import CoreData

class CategorySearchViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet var tbl_Search: UITableView!
    @IBOutlet weak var searchBackView: UIView!
    @IBOutlet var searchTextField: UITextField!
    
    //MARK: Variables
    var array_Categories = [CategoriesModel]()
    var recentSearchArray = [String]()
     var delegate: CategoriesContainerViewControllerDelegate?
    
    //MARK: Private Variables
    fileprivate var isLoadMore : Bool = false
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeUI()
        removeData()
    }
    //MARK: Private Functions
    private func customizeUI() {
        tbl_Search.tableFooterView = UIView()
        searchTextField.becomeFirstResponder()
    }
    
    func removeData() {
        searchTextField.text = ""
        self.array_Categories.removeAll()
        self.recentSearchArray.removeAll()
        if let array = DataManager.recentCategorySearchArray {
            self.recentSearchArray = array
        }
        self.tbl_Search.reloadData()
        self.searchTextField.becomeFirstResponder()
    }
    
    //MARK: IBAction Method
    @IBAction func btn_BackAction(_ sender: Any) {
        self.view.endEditing(true)
        searchBackView.resetCustomError()
        tbl_Search.reloadData()
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
        //Enable External Keyboard
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }
    
    @IBAction func searchTextFieldDidChange(_ sender: Any) {
        searchBackView.resetCustomError()
        if searchTextField.text != "" {
            self.getCategoriesList()
        }else {
            self.array_Categories.removeAll()
        }
        tbl_Search.reloadData()
    }
}

//MARK: UITextFieldDelegate
extension CategorySearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchBackView.resetCustomError()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if searchTextField.text == "" {
            self.array_Categories.removeAll()
        }
        tbl_Search.reloadData()
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
            searchBackView.setCustomError(text: "Please enter category name to search.",bottomSpace: -1, rightSpace: 10, bottomLabelSpace: 0)
        }
        
        searchTextField.resignFirstResponder()
        appendValueToRecentSearch()
        return true
    }
}


//MARK: UITableViewDelegate & UITableViewDataSource
extension CategorySearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        if section == 1 {
//            return recentSearchArray.count
//        }
        return self.array_Categories.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let lbl_Name = cell.contentView.viewWithTag(1) as? UILabel
        
//        if indexPath.section == 1 {
//            lbl_Name?.text = recentSearchArray[indexPath.row]
//            return cell
//        }
        lbl_Name?.text = self.array_Categories[indexPath.row].str_CategoryName
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 1 {
//            self.array_Categories = [CategoriesModel]()
//            searchTextField.text = recentSearchArray[indexPath.row]
//            getCategoriesList()
//            return
//        }
        appendValueToRecentSearch()
        DataManager.selectedCategory = self.array_Categories[indexPath.row].str_CategoryName         // change
        delegate?.getProduct?(withCategory: self.array_Categories[indexPath.item].str_CategoryName)
        self.navigationController?.popToRootViewController(animated: true)

        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cellHeader")
////            let button = cell?.contentView.viewWithTag(20) as? UIButton
////            button?.addTarget(self, action: #selector(handleCrossButtonAction(sender:)), for: .touchUpInside)
//            return cell
//        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 1 {
//            //return 40
//            return 0
//        }
        return 0
    }
    
    @objc func handleCrossButtonAction(sender: UIButton) {
        self.recentSearchArray.removeAll()
        DataManager.recentCategorySearchArray?.removeAll()
        self.tbl_Search.reloadData()
    }
    
    func appendValueToRecentSearch() {
        if searchTextField.text != "" {
            if let index = recentSearchArray.index(where: {$0.lowercased() == searchTextField.text?.lowercased()}) {
                recentSearchArray.remove(at: index)
            }
            self.recentSearchArray.append(searchTextField.text!)
            DataManager.recentCategorySearchArray = self.recentSearchArray
        }
        self.tbl_Search.reloadData()
    }
    
    //ScrollView Methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBackView.resetCustomError()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (tbl_Search.contentOffset.y + tbl_Search.frame.height) >= (tbl_Search.contentSize.height - 50) {
            if array_Categories.count > 0 {
                getCategoriesList()
            }
        }
    }
}

//MARK: API Methods
extension CategorySearchViewController {
    
    func getCategoriesList() {
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()

        let searchText = searchTextField.text!
        HomeVM.shared.getSearchCategory(searchText: searchText) { (success, message, error) in
            if success == 1 {
                DispatchQueue.main.async {
                    self.array_Categories = HomeVM.shared.searchCategoriesArray
                    self.tbl_Search.reloadData()
                }
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
            }else {
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
                if message != nil {
                    self.searchBackView.setCustomError(text: message!,bottomSpace: -1, rightSpace: 10, bottomLabelSpace: 0)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    
}
