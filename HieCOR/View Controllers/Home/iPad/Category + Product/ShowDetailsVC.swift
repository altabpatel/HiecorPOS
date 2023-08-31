//
//  ShowDetailsVC.swift
//  HieCOR
//
//  Created by Hiecor on 10/06/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import UIKit

class ShowDetailsVC: UIViewController {

    var delegate: EditProductDelegate?
    var cartProductsArray = Array<Any>()
    
    var attributeData = [[String]]()
    
    var dictAttribute = [String : AnyObject]()
    var arrdict = NSMutableArray()
    
    @IBOutlet weak var tableViewDetails: UITableView!
    @IBOutlet weak var constantMainViewHeights: NSLayoutConstraint!
    @IBOutlet weak var constTableViewHeights: NSLayoutConstraint!
    
    //MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let val = DataManager.cartProductsArray {
            self.cartProductsArray = val
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let val = DataManager.cartProductsArray {
            self.cartProductsArray = val
        }
    }
    
    //MARK: -- Private Method
    func getShowDetailsData() {
        
    }
    
    //MARK: -- Action Method
    @IBAction func btnCloseShowDetails_Action(_ sender: UIButton) {
        delegate?.didClickOnCloseButton?()
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension ShowDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrdict.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowDetailsCell", for: indexPath)
        let lbl_Attributes = cell.contentView.viewWithTag(1) as? UILabel
        let lbl_AttributesName = cell.contentView.viewWithTag(2) as? UILabel
        
        let attribute = arrdict.object(at: arrdict.count - 1) as! NSDictionary
        print(attribute)
        lbl_Attributes?.text = "\(attribute.allKeys[indexPath.row])"
        
        let name = attribute.value(forKey: lbl_Attributes!.text!) as! NSArray
        
        var data = ""
        
        var index = 0
        
        for val in name {
            index += 1
            let strName = "\(val) "
            if index == 1 {
                data = strName
            } else {
                data = strName + "," + data
            }
        }
        
        
        lbl_AttributesName?.text = "\(data)"
        
        return cell
    }
}

extension ShowDetailsVC: showDetailsDelegate {    
    func didShowDetailsAtrribute(index: Int, cartArray: Array<AnyObject>) {
        print(index)
        
        print(cartArray)
        
        //variationData
        
        let productAttribute = (cartArray[0] as AnyObject).value(forKey: "attributeString") as? String
        
        if let selectedAttribute = (cartArray[0] as AnyObject).value(forKey: "selectedAttributes") as? [JSONDictionary] {
           
            dictAttribute.removeAll()
            attributeData.removeAll()
            arrdict.removeAllObjects()
            
            if let jsonArray = (cartArray[0] as AnyObject).value(forKey: "variationData") as? JSONArray {
            
                for value in selectedAttribute {
                    let attribute_id = value["attribute_id"] as? String
                    let attributevalueIdDataSelect = value["attribute_value_id"] as? NSArray
                
                    for data in jsonArray {
                        
                        let attrId = data["attribute_id"] as? String
                        let attributename = data["attribute_name"] as? String
                        if attribute_id == attrId {
                            print(attribute_id)
                            
                            if let attributevalueIdData = data["attribute_values"] as? JSONArray {
                                
                                var dataAtt = [String]()
                                var isShowDetails = false
                                
                                for dataval in attributevalueIdData {
                                    let attrvalId = dataval["attribute_value_id"] as? String
                                    let attributename = dataval["attribute_value"] as? String
                                    
                                    for data in attributevalueIdDataSelect! {
                                        let id = data as? String
                                        if id == attrvalId {
                                            dataAtt.append(attributename!)
                                            isShowDetails = true
                                        }
                                    }
                                }
                                
                                if isShowDetails {
                                    dictAttribute[attributename!] = dataAtt as AnyObject
                                    arrdict.add(dictAttribute)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if let dictArray = (cartArray[0] as AnyObject).value(forKey: "attributesArray") as? [JSONDictionary] {
            dictAttribute.removeAll()
            attributeData.removeAll()
            arrdict.removeAllObjects()
            for dict in dictArray {
                let key = dict["key"] as? String ?? ""
                var name = String()
                if let jsonArray = dict["values"] as? JSONArray {
                    for value in jsonArray {
                        
                        if let data = value["jsonArray"] as? JSONArray {
                            let attributename = value["attributeName"] as? String
                            var dataAtt = [String]()
                            var isShowDetails = false
                            for val in data {
                                let select = val["isSelect"] as? Bool
                                let name = val["attribute_value"] as? String
                                if select == true {
                                    dataAtt.append(name!)
                                    isShowDetails = true
                                }
                            }
                            if isShowDetails {
                                dictAttribute[attributename!] = dataAtt as AnyObject
                                arrdict.add(dictAttribute)
                            }
                        }
                        
                    }
                }
            }
        }
        
        print(dictAttribute)
        
        if dictAttribute.count < 8 {
            constTableViewHeights.constant = CGFloat(dictAttribute.count * 44)
            constantMainViewHeights.constant = constTableViewHeights.constant + 158
        } else {
            constTableViewHeights.constant = CGFloat(7 * 44)
            constantMainViewHeights.constant = constTableViewHeights.constant + 158
        }
        
        tableViewDetails.reloadData()
    }
}

