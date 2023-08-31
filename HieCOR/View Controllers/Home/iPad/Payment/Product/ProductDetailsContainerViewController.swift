//
//  ProductDetailsContainerViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 21/02/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit

class ProductDetailsContainerViewController: BaseViewController, SWRevealViewControllerDelegate {
    
    //MARK: IBOutlets
    @IBOutlet var tbl_ProductDetails: UITableView!
    @IBOutlet var tf_QtyDopDown: UITextField!
    
    //MARK: Variables
    var array_SelectStock = Array<String>()
    var selectedProductCollectionIndex = Int()
    var selectedCollectionIndex = Int()
    var array_Products = [ProductsModel]()
    var selectedIndexSection1 = Int()
    var arraySected = [String]()
    var array_labelText = [String]()
    var cartProductsArray = Array<Any>()
    var cartDict =  [String:Any]()
    var editProductDelegate: EditProductsContainerViewDelegate?
    var delegate: CatAndProductsViewControllerDelegate?
    var cartDelegate: CartContainerViewControllerDelegate?
    var qty:Double = 1
    var selectedAttributes = [JSONDictionary]()

    //MARK: Private Variables
    private var arrayIndexpath = [IndexPath]()
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Load Data
        cartProductsArray = Array<Any>()
        if let cartArray = DataManager.cartProductsArray {
            for i in (0..<cartArray.count)
            {
                let obj = (cartArray as AnyObject).object(at: i)
                cartProductsArray.append(obj)
            }
        }
    }
    
    //MARK: Private Functions
    private func customizeUI() {
        tbl_ProductDetails.rowHeight = 60.0
        
        tf_QtyDopDown?.delegate = self
        tf_QtyDopDown?.layer.cornerRadius = 6.0
        tf_QtyDopDown?.layer.borderWidth = 1.0
        tf_QtyDopDown?.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        tf_QtyDopDown?.layer.masksToBounds = true
        
        let padding = 8
        let size = 20
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: size+padding, height: size))
        let iconView  = UIImageView(frame: CGRect(x: 5, y: 7, width: 14, height: 10))
        iconView.image = UIImage(named: "dropdown-arrow")
        iconView.center = outerView.center
        outerView.addSubview(iconView)
        tf_QtyDopDown?.rightView = outerView
        tf_QtyDopDown?.rightViewMode = .always
        
        tf_QtyDopDown?.text = "  Qty: 1"
        
        let paddingViewQty = UIView(frame: CGRect(x: 0, y: 0 , width: 1, height: (self.tf_QtyDopDown?.frame.height)!)) //UIView(frame: CGRectMake(0, 0, 15, self.tf_AddDiscount.frame.height))
        tf_QtyDopDown?.leftView = paddingViewQty
        tf_QtyDopDown?.leftViewMode = UITextFieldViewMode.always
        
        arrayIndexpath = [IndexPath(row: 0, section: 0)]
    }
    
    func removeCartArray()
    {
        UserDefaults.standard.removeObject(forKey: "cartProductsArray")
        UserDefaults.standard.synchronize()
        cartProductsArray.removeAll()
        
    }
    
    private func addToCart(model:ProductsModel)
    {
        let addedCartProducts = model
        var isAdded = false
        
        if Int(addedCartProducts.str_stock) == 0 && addedCartProducts.unlimited_stock == "NO"{
            let alertController = UIAlertController(title: "Alert", message: "Product out of stock", preferredStyle:.alert)
            alertController.addAction(UIAlertAction.init(title: kOkay, style: .default, handler: { (UIAlertAction) in alertController.dismiss(animated: true, completion: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        var selectedIDArray = [Int]()
        for attr in selectedAttributes {
            let id = attr["id"] as! Int
            selectedIDArray.append(id)
        }
        selectedIDArray = selectedIDArray.sorted()
        if let index = cartProductsArray.index(where: {(($0 as! JSONDictionary)["productid"] as? String ?? "" == model.str_product_id) && ((($0 as! JSONDictionary)["attributesID"] as? [Int] ?? [Int]()).containsSameElements(as: selectedIDArray))}) , !DataManager.isSplitRow {
            var tempCartArray = self.cartProductsArray
            let cartProd = self.cartProductsArray[index]
            
            var prevQty = (cartProd as AnyObject).value(forKey: "productqty") as? String ?? ""
            let stock = (cartProd as AnyObject).value(forKey: "productstock") as? String ?? ""
            let unlimitedstock = (cartProd as AnyObject).value(forKey: "productunlimitedstock") as? String
            let limitqty = (cartProd as AnyObject).value(forKey: "productlimitqty") as? String
            
            var availableqty:Double  = 1
            
            if unlimitedstock == "Yes" && limitqty == "0"{
                availableqty = 100
            }
            else if(unlimitedstock == "No" && limitqty == "0")
            {
                availableqty = Double(stock) ?? 0
            }
            else
            {
                availableqty = Double(limitqty!) ?? 0
            }
            prevQty = "\((Double(prevQty) ?? 0) + self.qty)"
            var qty = Double(prevQty) ?? 0
            if ((Double(prevQty) ?? 0) <= availableqty )
            {
                qty =  Double(prevQty) ?? 0
            }
            else
            {
                self.showAlert(title: "Warning!", message: "\(model.str_title) Has Limited Purchase - \(availableqty)")
                return
            }
            
            var temDic :[String:AnyObject] = tempCartArray[index] as! [String:AnyObject]
            temDic["productqty"] =  "\(qty)" as AnyObject
            temDic["mainprice"] = model.str_price as AnyObject
            temDic["attributesArray"] = self.selectedAttributes as AnyObject
            temDic["shippingPrice"] = model.shippingPrice as AnyObject
            temDic["allAttributesArray"] = model.array_Atributes as AnyObject
            temDic["productimage"] = model.str_product_image as AnyObject
            temDic["productimagedata"] = (model.productImageData == nil ? "" as AnyObject : model.productImageData as AnyObject)

            var attributeIdArray = [Int]()
            for data in self.selectedAttributes {
                let id = data["id"] as! Int
                attributeIdArray.append(id)
            }
            attributeIdArray = attributeIdArray.sorted()
            temDic["attributesID"] = attributeIdArray as AnyObject
            
            
            tempCartArray[index] = temDic
            CartContainerViewController.updatedProductIndex = index
            self.cartProductsArray = tempCartArray
            isAdded = true
            UserDefaults.standard.setValue(self.cartProductsArray, forKey: "cartProductsArray")
            UserDefaults.standard.synchronize()
        }
        else {
            CartContainerViewController.updatedProductIndex = nil
            let stock = addedCartProducts.str_stock
            let unlimitedstock = addedCartProducts.unlimited_stock
            let limitqty = addedCartProducts.str_limit_qty
            
            var prevQty = Double()
            
            if let cartArray = DataManager.cartProductsArray {
                for data in cartArray {
                    if let dict = data as? JSONDictionary {
                        let id = Double(dict["productid"] as? String ?? "0") ?? 0
                        let qty = Double(dict["productqty"] as? String ?? "0") ?? 0
                        
                        if id == (Double(addedCartProducts.str_product_id) ?? -1) {
                            prevQty += qty
                        }
                    }
                }
            }
            
            let totalQty = Double(tf_QtyDopDown.text?.replacingOccurrences(of: "  Qty: ", with: "") ?? "1") ?? 1
            var availableqty:Double  = 1
            
            if unlimitedstock == "Yes" && limitqty == "0"{
                availableqty = 100
            }
            else if(unlimitedstock == "No" && limitqty == "0")
            {
                availableqty = Double(stock) ?? 0
            }
            else
            {
                availableqty = Double(limitqty) ?? 0
            }
            if (totalQty + prevQty) > availableqty {
                self.showAlert(title: "Warning!", message: "\(model.str_title) Has Limited Purchase - \(availableqty)")
                return
            }

            self.cartDict["producttitle"] = addedCartProducts.str_title
            self.cartDict["productid"] = addedCartProducts.str_product_id
            self.cartDict["productqty"] = String(totalQty)
            self.cartDict["productprice"] = addedCartProducts.str_price
            self.cartDict["mainprice"] = addedCartProducts.str_price
            self.cartDict["productimage"] = addedCartProducts.str_product_image
            self.cartDict["productimagedata"] = addedCartProducts.productImageData
            self.cartDict["productdesclong"] = addedCartProducts.str_long_description
            self.cartDict["productdescshort"] = addedCartProducts.str_short_description
            self.cartDict["productstock"] = addedCartProducts.str_stock
            self.cartDict["productlimitqty"] = addedCartProducts.str_limit_qty
            self.cartDict["productistaxable"] = addedCartProducts.is_taxable
            self.cartDict["productunlimitedstock"] = addedCartProducts.unlimited_stock
            self.cartDict["attributesArray"] = self.selectedAttributes
            self.cartDict["shippingPrice"] = model.shippingPrice
            self.cartDict["allAttributesArray"] = model.array_Atributes as AnyObject

            var attributeIdArray = [Int]()
            for data in self.selectedAttributes {
                let id = data["id"] as! Int
                attributeIdArray.append(id)
            }
            attributeIdArray = attributeIdArray.sorted()
            self.cartDict["attributesID"] = attributeIdArray
            cartProductsArray.append(cartDict)
            isAdded = true
            UserDefaults.standard.setValue(cartProductsArray, forKey: "cartProductsArray")
            UserDefaults.standard.synchronize()
        }

        
        var subTotal: Double?
        subTotal = 0.00
        if cartProductsArray.count>0 {
            for i in (0..<self.cartProductsArray.count)
            {
                let obj = (cartProductsArray as AnyObject).object(at: i)
                let price = Double((obj as AnyObject).value(forKey: "productprice") as? String  ?? "0") ?? 0.00
                let qty = Double((obj as AnyObject).value(forKey: "productqty") as? String ?? "0") ?? 0.00
                let total: Double = qty * price
                subTotal = total + subTotal!
            }
        }
        
        if !isAdded {
            return
        }
        self.editProductDelegate?.didCalculateCartTotal?()

        if(UI_USER_INTERFACE_IDIOM() == .pad)
        {
            self.delegate?.hideView?(with: "addedtocartIPAD")
            self.cartDelegate?.didUpdateCartCountAndSubtotalPriceCoupon?(dict:["subtotal":subTotal ?? 0.00])
            self.cartDelegate?.didUpdateCart?(with: "refreshCart")
        }
        else
        {
            self.editProductDelegate?.didSelectProduct?(with: "addedtocart")
        }
    }
    
    //MARK: IBAction
    @IBAction func btn_ProductDetailsCancel(_ sender: Any) {
        if(UI_USER_INTERFACE_IDIOM() == .pad)
        {
            self.delegate?.hideView?(with: "productDetailsCancelIPAD")
        }
        else
        {
            self.editProductDelegate?.didSelectProduct?(with: "productDetailsCancel")
            
        }
        
        tbl_ProductDetails.reloadData()
    }
    
    @IBAction func btn_AddtoCartAction(_ sender: Any)
    {
        cartProductsArray = Array<Any>()
        if UserDefaults.standard.value(forKey: "cartProductsArray") != nil
        {
            let cartProd = UserDefaults.standard.value(forKey: "cartProductsArray") as! Array<Any>
            for i in (0..<cartProd.count)
            {
                let obj = (cartProd as AnyObject).object(at: i)
                
                cartProductsArray.append(obj)
            }
        }
        
        let textarray = tf_QtyDopDown?.text?.components(separatedBy: ":")
        let textqty = (textarray as AnyObject).object(at: 1)
        let str_qty = (textqty as AnyObject).replacingOccurrences(of: " ", with: "")
        self.qty = Double(str_qty) ?? 0
        
        let addedCartProducts = self.array_Products[selectedProductCollectionIndex]
        
        addToCart(model: addedCartProducts)
        
    }
    
    //MARK:- Quantity dropdown action
    @IBAction func tf_QtyDropDownAction(_ sender: Any)
    {
        array_SelectStock = Array<String>()
        if self.array_Products[selectedProductCollectionIndex].unlimited_stock == "Yes" {
            for i in (1...100) {
                array_SelectStock.append("\(i)")
            }
        }
        else
        {
            let qty = Int(round(Double(self.array_Products[selectedProductCollectionIndex].str_stock)!))
            
            for i in (1...qty) {
                array_SelectStock.append("\(i)")
            }

        }
        self.pickerDelegate = self
        self.setPickerView(textField: tf_QtyDopDown, array: array_SelectStock)
        
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource
extension ProductDetailsContainerViewController : UITableViewDelegate, UITableViewDataSource {
    //MARK:- TableView Delegate Methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        if array_Products.count>0
        {
            return array_Products[0].array_Atributes.count
        }
        else
        {
            return 0
        }
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ((array_Products[0].array_Atributes[section] as AnyObject).value(forKey: "attribute_values")as AnyObject).count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellproductdetails", for: indexPath)
        let view = cell.contentView.viewWithTag(1)
        view?.layer.cornerRadius = 8.0
        view?.layer.masksToBounds = true
        view?.layer.borderWidth = 1.0
        view?.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        
        let btn_Selection = cell.contentView.viewWithTag(2) as? UIButton
        btn_Selection?.addTarget(self, action: #selector(self.SelectProductItem), for: .touchUpInside)
        
        
        let lbl_Title = cell.contentView.viewWithTag(3) as? UILabel
        
        let lbl_Price = cell.contentView.viewWithTag(4) as? UILabel
        
        lbl_Title?.text = (((array_Products[0].array_Atributes[indexPath.section] as AnyObject).value(forKey: "attribute_values")as AnyObject).object(at: indexPath.row) as AnyObject).value(forKey: "attribute_value") as? String
        
        lbl_Price?.text = (((array_Products[0].array_Atributes[indexPath.section] as AnyObject).value(forKey: "attribute_values")as AnyObject).object(at: indexPath.row) as AnyObject).value(forKey: "price") as? String
        
        if arrayIndexpath.contains(indexPath)
        {
            
            view?.backgroundColor = UIColor.init(red: 201.0/255.0, green: 233.0/255.0, blue: 250.0/255.0, alpha: 1.0)
            view?.layer.borderColor = UIColor.init(red: 1.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 0.2).cgColor
            lbl_Title?.textColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
            lbl_Price?.textColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
            btn_Selection?.setImage(UIImage(named: "radio-checked"), for: .normal)
        }
        else
        {
            view?.backgroundColor = UIColor.white
            view?.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
            lbl_Title?.textColor = UIColor.init(red: 58.0/255.0, green: 58.0/255.0, blue: 58.0/255.0, alpha: 1.0)
            lbl_Price?.textColor = UIColor.init(red: 58.0/255.0, green: 58.0/255.0, blue: 58.0/255.0, alpha: 1.0)
            btn_Selection?.setImage(UIImage(named: "radio-unchecked"), for: .normal)
        }
        return cell
    }
    
    @objc func SelectProductItem(_ sender: Any)
    {
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let attributeName = (array_Products[0].array_Atributes[indexPath.section] as AnyObject).value(forKey: "attribute_name") as? String ?? ""
        let name = (((array_Products[0].array_Atributes[indexPath.section] as AnyObject).value(forKey: "attribute_values")as AnyObject).object(at: indexPath.row) as AnyObject).value(forKey: "attribute_value") as? String ?? ""
        let id = (((array_Products[0].array_Atributes[indexPath.section] as AnyObject).value(forKey: "attribute_values")as AnyObject).object(at: indexPath.row) as AnyObject).value(forKey: "attribute_value_id") as? Int ?? 0
        
        let dict: JSONDictionary = ["name" : name, "id" : id , "attributeName": attributeName] as [String : Any]
        
        if let index = selectedAttributes.index(where: {($0["attributeName"] as? String ?? "") == attributeName}) {
            selectedAttributes[index] = dict
        }else {
            selectedAttributes.append(dict)
        }

       if tableView == tbl_ProductDetails {
            var isExist = Bool()
            for i in(0..<arrayIndexpath.count)
            {
                if(arrayIndexpath[i].section == indexPath.section)
                {
                    isExist = true
                    arrayIndexpath[i] = indexPath
                }
            }
            if(!isExist)
            {
                arrayIndexpath.append(indexPath)
            }
            tbl_ProductDetails.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerViewcell = UITableViewCell()
        if(tableView == tbl_ProductDetails)
        {
            headerViewcell = tbl_ProductDetails.dequeueReusableCell(withIdentifier: "cellproductdetailsHeader")!
            let lbl_SetionTitle = headerViewcell.contentView.viewWithTag(3) as? UILabel
            lbl_SetionTitle?.text = (array_Products[0].array_Atributes[section] as AnyObject).value(forKey: "attribute_name") as? String
            let btn_Required = headerViewcell.contentView.viewWithTag(2) as? UIButton
            
            if section == 0
            {
                btn_Required?.isHidden = false
            }
            else
            {
                btn_Required?.isHidden = true
            }
        }
        
        return headerViewcell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}

//MARK: UITextFieldDelegate
extension ProductDetailsContainerViewController :UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        if textField == tf_QtyDopDown
        {
            self.tf_QtyDropDownAction((Any).self)
            self.editProductDelegate?.didSelectProduct?(with: "customviewUnHide")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Check For External Accessory
        if Keyboard._isExternalKeyboardAttached() {
            textField.resignFirstResponder()
            //Inilialize SwipeReader Class
            SwipeAndSearchVC.shared.enableTextField()
            return
        }
    }
}

//MARK: ProductsViewControllerDelegate
extension ProductDetailsContainerViewController: ProductsViewControllerDelegate {
    func didReceiveProductDetail(data: ProductsModel) {
        let ProductsData = data
        qty = 1
        tf_QtyDopDown?.text = "  Qty: \(1)"
        selectedAttributes.removeAll()
        arrayIndexpath.removeAll()
        
            for i in 0..<data.array_Atributes.count {
                let attributeName = (data.array_Atributes[i] as AnyObject).value(forKey: "attribute_name") as? String ?? ""
                let name = (((data.array_Atributes[i] as AnyObject).value(forKey: "attribute_values")as AnyObject).object(at: 0) as AnyObject).value(forKey: "attribute_value") as? String ?? ""
                let id = (((data.array_Atributes[i] as AnyObject).value(forKey: "attribute_values")as AnyObject).object(at: 0) as AnyObject).value(forKey: "attribute_value_id") as? Int ?? 0
                
                let dict: JSONDictionary = ["name" : name, "id" : id , "attributeName": attributeName] as [String : Any]
                selectedAttributes.append(dict)
                arrayIndexpath.append(IndexPath(row: 0, section: i))
            }
        cartProductsArray = Array<Any>()
        if UserDefaults.standard.value(forKey: "cartProductsArray") != nil
        {
            let cartProd = UserDefaults.standard.value(forKey: "cartProductsArray") as! Array<Any>
            for i in (0..<cartProd.count)
            {
                let obj = (cartProd as AnyObject).object(at: i)
                
                cartProductsArray.append(obj)
            }
        }
        
        var attributesCountArray: [Int] = []
        
        for data in ProductsData.array_Atributes {
            if let dict = data as? NSDictionary {
                if let attributes = dict.value(forKey: "attribute_values") as? NSArray {
                    attributesCountArray.append(attributes.count)
                }
            }
        }

        if attributesCountArray.contains(where: {$0 > 1})
        {
            array_Products = [ProductsData]
            tbl_ProductDetails.reloadData()
            
            self.delegate?.hideView?(with: "productDetailsIPAD")

            if self.array_Products[selectedProductCollectionIndex].unlimited_stock == "NO" && self.array_Products[selectedProductCollectionIndex].str_stock == "0"{
                tf_QtyDopDown?.text = "  Qty: 0"
            }
        }
        else
        {
            self.qty = 0
            self.delegate?.hideView?(with: "productDetailsCancelIPAD")
//            addToCart(model: ProductsData)
        }
        tbl_ProductDetails.reloadData()
    }
}

//MARK: HieCORPickerDelegate
extension ProductDetailsContainerViewController: HieCORPickerDelegate {
    func didSelectPickerViewAtIndex(index: Int) {
        if self.array_SelectStock.count>0
        {
            tf_QtyDopDown?.text = "  Qty: \(array_SelectStock[index])"
        }
    }
    
    func didClickOnPickerViewCancelButton() {
        self.editProductDelegate?.didSelectProduct?(with: "customviewHide")
        
        tf_QtyDopDown?.text = "  Qty: 1"
        tf_QtyDopDown?.resignFirstResponder()
    }
    
    func didClickOnPickerViewDoneButton() {
        self.editProductDelegate?.didSelectProduct?(with: "customviewHide")
        tf_QtyDopDown?.resignFirstResponder()
    }
}

//MARK: CartContainerViewControllerDelegate
extension ProductDetailsContainerViewController: CartContainerViewControllerDelegate {
    func didRemoveCartArray() {
        self.removeCartArray()
    }
}
