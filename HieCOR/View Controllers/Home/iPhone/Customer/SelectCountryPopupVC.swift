
//
//  SelectCountryPopupVC.swift
//  HieCOR
//
//  Created by Deftsoft on 01/11/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SelectCountryPopupVC: BaseViewController {
    
    //MARK: Outlets
    @IBOutlet var countrySearchBar: UISearchBar!
    @IBOutlet var countryTable: UITableView!
    
    //MARK: Variables
    var nameArray = [String]()
    var delegate: SelectCountryPopupVCDelegate?
    var selectContactSource = false
    var selectSerialNumber = false
    public var isSearchingContact = false
    var serialNumAry = [SerialNumberDataModel]()
    var searchSerialNumAry = [SerialNumberDataModel]()
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup Search Bar
        countrySearchBar.becomeFirstResponder()
        countrySearchBar.returnKeyType = .done
        countryTable.tableFooterView = UIView()
        if selectSerialNumber {
            serialNumAry = HomeVM.shared.SerialNumberDataListAry
            countrySearchBar.placeholder = "Type here"
        }else{
            countrySearchBar.placeholder = "Search"
        }
    }
    
    //Override Key Commands
    override var keyCommands: [UIKeyCommand]? {
        return [ UIKeyCommand(input: UIKeyInputUpArrow, modifierFlags: [], action: #selector(self.up), discoverabilityTitle: ""),
                 UIKeyCommand(input: UIKeyInputDownArrow, modifierFlags: [], action: #selector(self.down), discoverabilityTitle: "")
        ]
    }
    
    //Handle Key Commands
    @objc func up() {
        if let index = countryTable.indexPathForSelectedRow?.row {
            if index - 1 < 0 {
                return
            }
            self.countryTable.selectRow(at: IndexPath(row: index - 1, section: 0), animated: false, scrollPosition: .middle)
        }else {
            if nameArray.count == 0 {
                return
            }
            self.countryTable.selectRow(at: IndexPath(row: nameArray.count - 1, section: 0), animated: false, scrollPosition: .middle)
        }
    }
    
    @objc func down() {
        if let index = countryTable.indexPathForSelectedRow?.row {
            if index + 1 > nameArray.count - 1 {
                return
            }
            self.countryTable.selectRow(at: IndexPath(row: index + 1, section: 0), animated: false, scrollPosition: .middle)
        }else {
            if nameArray.count == 0 {
                return
            }
            self.countryTable.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .middle)
        }
    }
    
    //MARK: IBAction Method 
    @IBAction func searchBarCancelAction(_ sender: Any) {
        countrySearchBar.text = ""
        if let index = countryTable.indexPathForSelectedRow {
            countryTable.deselectRow(at: index, animated: false)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate
extension SelectCountryPopupVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectContactSource == true{
            if isSearchingContact {
                return searchedContactArray.count
            } else {
                return nameArray.count
            }
        } else if isInvoiceTamplate == true{
            if isSearchingContact {
                return searchedContactArray.count
            } else {
                return nameArray.count
            }
        } else if selectSerialNumber {
            if isSearchingContact {
                return searchSerialNumAry.count
            } else {
                return serialNumAry.count
            }
        }else{
            return nameArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountryTableViewCell
        if selectContactSource == true{
            if isSearchingContact {
                cell.nameLabel.text = searchedContactArray[indexPath.row]
            } else {
                cell.nameLabel.text = nameArray[indexPath.row]
            }
        } else if selectSerialNumber == true {
            if isSearchingContact {
                if searchSerialNumAry[indexPath.row].location_name != "" {
                    cell.nameLabel.text = "\(searchSerialNumAry[indexPath.row].serial_number.uppercased()) - \(searchSerialNumAry[indexPath.row].location_name.uppercased())"
                }else{
                    cell.nameLabel.text = "\(searchSerialNumAry[indexPath.row].serial_number.uppercased())"
                }
                
            } else {
                if serialNumAry[indexPath.row].location_name != "" {
                    cell.nameLabel.text = "\(serialNumAry[indexPath.row].serial_number.uppercased()) - \(serialNumAry[indexPath.row].location_name.uppercased())"
                }else{
                    cell.nameLabel.text = "\(serialNumAry[indexPath.row].serial_number.uppercased())"
                }
                
            }
        }else{
            cell.nameLabel.text = nameArray[indexPath.row]
            cell.selectionStyle = .blue
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let selectionColor = UIView()
        selectionColor.backgroundColor = UIColor.HieCORColor.blue.colorWith(alpha: 1.0)
        cell.selectedBackgroundView = selectionColor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectContactSource == true{
            if isSearchingContact{
                delegate?.didSelectValue(string: searchedContactArray[indexPath.row], index: indexPath.row)
            }else{
                delegate?.didSelectValue(string: nameArray[indexPath.row], index: indexPath.row)
            }
        }else if selectSerialNumber {
            if isSearchingContact{
                delegate?.didSelectValue(string: searchSerialNumAry[indexPath.row].serial_number.uppercased(), index: indexPath.row)
            }else{
                delegate?.didSelectValue(string: serialNumAry[indexPath.row].serial_number.uppercased(), index: indexPath.row)
            }
        }else{
            delegate?.didSelectValue(string: nameArray[indexPath.row], index: indexPath.row)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: UISearchBarDelegate
extension SelectCountryPopupVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let shortcut: UITextInputAssistantItem? = searchBar.inputAssistantItem
        shortcut?.leadingBarButtonGroups = []
        shortcut?.trailingBarButtonGroups = []

        if Keyboard._isExternalKeyboardAttached() {
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if selectContactSource == true{
            //searchedContactArray = nameArray.filter({$0.lowercased().contains(searchText.count) == searchText.lowercased()})
            if searchText != ""{
                searchedContactArray = nameArray.filter { $0.contains(searchText) }
                isSearchingContact = true
                countryTable.reloadData()
            }else{
                isSearchingContact = false
                countryTable.reloadData()
            }
        }else if selectSerialNumber == true{
            if searchText != ""{
                var text = ""
                text = searchText.trimmingCharacters(in: .whitespaces).condenseWhitespace()
                self.searchSerialNumAry.removeAll()
                var isSpaceInVal = true
                let spaceCount = text.filter{$0 == " "}.count
                if spaceCount > 0 {
                    isSpaceInVal = false
                }
                for i in 0..<serialNumAry.count {
                    let strVal = serialNumAry[i].serial_number
                    let strArry = strVal.split(separator: " ")
                    if strArry.count > 0 && isSpaceInVal {
                        
                        for ar in strArry {
                            if (ar.lowercased)().hasPrefix(text.lowercased()) {
                                searchSerialNumAry.append(serialNumAry[i])
                                break
                            }
                        }
                    }
                }
                isSearchingContact = true
                countryTable.reloadData()
            }else{
                isSearchingContact = false
                countryTable.reloadData()
            }
        }else{
            if let index = nameArray.index(where: {(String(describing: $0.prefix(searchText.count))).lowercased() == searchText.lowercased()}) {
                countryTable.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .middle)
            }
        }
        
        if let index = countryTable.indexPathForSelectedRow, searchText == "" {
            countryTable.deselectRow(at: index, animated: false)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        if selectContactSource == true{
            // delegate?.customContactSourceData(string: searchBar.text ?? "")
            if let indexPath = countryTable.indexPathForSelectedRow {
                delegate?.didSelectValue(string: searchedContactArray[indexPath.row], index: indexPath.row)
            }else{
                delegate?.customContactSourceData(string: searchBar.text ?? "")
            }
        }else if selectSerialNumber {
            // delegate?.customContactSourceData(string: searchBar.text ?? "")
            if let indexPath = countryTable.indexPathForSelectedRow {
                delegate?.didSelectValue(string: searchSerialNumAry[indexPath.row].serial_number, index: indexPath.row)
            }else{
                delegate?.customContactSourceData(string: searchBar.text ?? "")
            }
        
    }else{
            if let indexPath = countryTable.indexPathForSelectedRow {
                delegate?.didSelectValue(string: nameArray[indexPath.row], index: indexPath.row)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
        if text.contains(UIPasteboard.general.string ?? "") && text.containEmoji {
            return false
        }

        if range.location == 0 && text == " " {
            return false
        }
        return true
    }
}
