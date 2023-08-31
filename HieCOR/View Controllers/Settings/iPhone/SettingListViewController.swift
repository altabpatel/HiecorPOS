//
//  SettingListViewController.swift
//  HieCOR
//
//  Created by Hiecor on 16/02/21.
//  Copyright © 2021 HyperMacMini. All rights reserved.
//

import UIKit


class SettingListViewController: BaseViewController, SWRevealViewControllerDelegate {
    
    
    //MARK: IBOutlet
    @IBOutlet var tbl_SettingList: UITableView!
    
    
    //MARK: Variables
    private var array_List = Array<Any>()
    private var array_iconsList = Array<Any>()
    var indexColor = 0
    
    //MARK: Delegate
    var settingListDelegate: SettingViewControllerDelegate?
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        array_List.append("Checkout Options")
        array_iconsList.append("card_icon")
        
        array_List.append("Hardware")
        array_iconsList.append("hardware_icon")
        
        array_List.append("Advanced Setting")
        array_iconsList.append("advance_settings_icon")
        
        tbl_SettingList.rowHeight = 50
        
    }
    
}
//MARK: UITableViewDataSource, UITableViewDelegate
extension SettingListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let lbl_Name = cell.contentView.viewWithTag(2) as? UILabel
        lbl_Name?.text = array_List[indexPath.row] as? String
        let img = cell.contentView.viewWithTag(1) as? UIImageView
        img?.image = UIImage(named: array_iconsList[indexPath.row] as! String)
        if(UI_USER_INTERFACE_IDIOM() == .pad){
            if indexColor == indexPath.row {
                cell.contentView.backgroundColor = UIColor(red: 235.0/255, green: 248.0/255, blue: 254.0/255, alpha: 0.8)
            } else {
                cell.contentView.backgroundColor = .white
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indexColor = indexPath.row
        settingListDelegate?.didMoveToNextScreen?(with: array_List[indexPath.row] as! String)
        tbl_SettingList.reloadData()
        
    }
    
}

