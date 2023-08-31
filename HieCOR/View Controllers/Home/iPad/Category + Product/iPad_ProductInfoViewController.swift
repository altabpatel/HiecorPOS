//
//  iPad_ProductInfoViewController.swift
//  HieCOR
//
//  Created by Hiecor on 13/01/22.
//  Copyright © 2022 HyperMacMini. All rights reserved.
//

import UIKit
import Alamofire
import AssetsLibrary
import Photos
import IQKeyboardManagerSwift
import Kingfisher

class iPad_ProductInfoViewController: BaseViewController {
    
    @IBOutlet var img_Product:UIImageView!
    @IBOutlet var lbl_Title: UILabel!
    @IBOutlet var lbl_ProductCode: UILabel!
    @IBOutlet var lbl_Brand: UILabel!
    @IBOutlet var lbl_Supplier: UILabel!
    @IBOutlet var lbl_WebSiteLink: UILabel!
    @IBOutlet var lbl_Price: UILabel!
    @IBOutlet var lbl_Quantity: UILabel!
    @IBOutlet var lbl_OnOrder: UILabel!
    @IBOutlet var lbl_InFulfillment: UILabel!
    @IBOutlet var lbl_ShortDescription: UILabel!
    @IBOutlet var view_image: UIView!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    //mark: inside stack views hide or show acording to json response
    
    @IBOutlet weak var lbl_Keywords: UILabel!
    @IBOutlet weak var lbl_title_short_Description: UILabel!
    @IBOutlet weak var product_code_view: UIView!
    @IBOutlet weak var brand_View: UIView!
    @IBOutlet weak var supplier_View: UIView!
    @IBOutlet weak var quantity_View: UIView!
    @IBOutlet weak var price_View: UIView!
    @IBOutlet weak var website_link_View: UIView!
    
    @IBOutlet weak var keywords_View: UIView!
    @IBOutlet weak var onOrder_view: UIView!
    @IBOutlet weak var view_veriation_product_attributes: UIView!
    @IBOutlet weak var popUpScrollView: UIScrollView!
    @IBOutlet weak var veriation_product_attributes_value: UILabel!
        @IBOutlet weak var veriation_product_attributes_name: UILabel!

    @IBOutlet weak var colletionView_customField: UICollectionView!
        @IBOutlet weak var colletionViewHieghtConst: NSLayoutConstraint!
    @IBOutlet weak var lbl_wholesalePrice: UILabel!
    @IBOutlet weak var view_wholesalePrice: UIView!
    var cancelProductDelegate: EditProductsContainerViewDelegate?
    var image = UIImage(named: "category-bg")
    var tapGestureRecognizer:UITapGestureRecognizer!
    var urlString = ""
    var arrCustomFields = [CustomFieldsModel]()
    @IBOutlet weak var onOrderAndFullfilmentStackHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.isEditable = false
        tapGestureRecognizer = UITapGestureRecognizer(target:self, action:      #selector(onUserClickingSendToken(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        lbl_WebSiteLink.isUserInteractionEnabled = true
        lbl_WebSiteLink.addGestureRecognizer(tapGestureRecognizer)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // popUpScrollView.setContentOffset(.zero, animated: true)
    }
    @objc func onUserClickingSendToken(_ sender: Any)
    {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func customizeUI() {
        
        img_Product?.layer.cornerRadius = 8.0
        img_Product?.layer.borderWidth = 0.0
        img_Product?.layer.masksToBounds = true
        img_Product?.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        
        view_image.layer.masksToBounds = true
        view_image.layer.cornerRadius = 2
        view_image.layer.borderWidth = 1.0
        view_image.layer.shadowColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        view_image.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view_image.layer.shadowOpacity = 0.6
        view_image.layer.shadowRadius = 4.0
        
    }
    
    @IBAction func btn_CancelProductInfo(_ sender : Any){
        cancelProductDelegate?.didEditProduct?(with: "ipad_CancelProductInfo")
    }
    
}
extension iPad_ProductInfoViewController { // by Altab
    func callAPIToGetProductInfoDetail(productId:String) {
        HomeVM.shared.getProductInfoDetailsApi(productId: productId) { (success, message, error) in
            if success == 1 {
                //self.dismiss(animated: true, completion: nil)
                print("Featch Product Info")
                print(HomeVM.shared.objProductsInfo)
                self.setDataShow(data: HomeVM.shared.objProductsInfo)
            }else {
                if message != nil {
                    appDelegate.showToast(message: message!)
                }else {
                    self.showErrorMessage(error: error)
                }
            }
        }
    }
    
    func setDataShow(data: ProductsModel){
        //        self.isSearching = isSearching
        //        self.index = index
        print(data)
        colletionViewHieghtConst.constant = 0
        if let url = URL(string: data.str_product_image) {
            img_Product.kf.setImage(with: url, placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
        }else {
            if let data = data.productImageData {
                img_Product.image = UIImage(data: data)
            }
        }
        lbl_Title.text = data.str_title
        lbl_ProductCode.text = data.str_product_code
        lbl_Price.text = Double(data.str_price == "" ? "0" : data.str_price)?.currencyFormat ?? "0.00"
        lbl_Quantity.text = data.v_product_stock
        // lbl_InFulfillment.text = data.str_fulfillment_action
        veriation_product_attributes_value.frame.size.height = 0
        if data.v_product_attributes_name == "" {
            view_veriation_product_attributes.isHidden = true
            veriation_product_attributes_value.text = ""
        }else{
            view_veriation_product_attributes.isHidden = false
            veriation_product_attributes_name.text = data.v_product_attributes_name
            if data.v_product_attributes_values.count > 0 {
                let value = data.v_product_attributes_values.joined(separator: ",")
                veriation_product_attributes_value.text = value.replacingOccurrences(of: ",", with: "\n")
            }
        }
        if data.str_brand == ""{
            brand_View.isHidden = true
            
        }else{
            lbl_Brand.text = data.str_brand
            brand_View.isHidden = false
        }
        if data.str_supplier == ""{
            supplier_View.isHidden = true
        } else{
            lbl_Supplier.text = data.str_supplier
            supplier_View.isHidden = false
        }
        
        if data.str_short_description != "" {
            descriptionTextView.text = ""
            lbl_title_short_Description.isHidden = false
            descriptionTextView.isHidden = false
            
            let attrStr = try! NSAttributedString(
                data: data.str_short_description.data(using: .unicode, allowLossyConversion: true)!,
                options:[.documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
            descriptionTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.init(red: 11.0/255.0, green: 118/255.0, blue: 201.0/255.0, alpha: 1.0)]
            descriptionTextView.attributedText = attrStr
            descriptionTextView.font =  UIFont(name: "OpenSans", size: 14.0)
        }else{
            descriptionTextView.text = ""
            lbl_title_short_Description.isHidden = true
            descriptionTextView.isHidden = true
        }
        
        if data.str_website_Link == "" {
            lbl_WebSiteLink.text = ""
            website_link_View.isHidden = true
        }else{
            lbl_WebSiteLink.text = ""
            website_link_View.isHidden = false
            lbl_WebSiteLink.text = data.str_website_Link
            urlString = data.str_website_Link
            lbl_WebSiteLink.isUserInteractionEnabled = true
            
        }
        
        if data.str_keywords == ""{
            lbl_Keywords.text = ""
            keywords_View.isHidden = true
        }else{
            lbl_Keywords.text = data.str_keywords
            keywords_View.isHidden = false
        }
        lbl_OnOrder.frame.size.height = 0
        if data.on_order == "" {
            lbl_OnOrder.text = ""
            onOrder_view.isHidden = true
        }
        else{
            lbl_OnOrder.text = ""
            onOrder_view.isHidden = false
            let Orderstring = data.on_order
            lbl_OnOrder.text = Orderstring.replacingOccurrences(of: "<br>", with: "\n")
        }
        if (data.on_order == "" && data.str_keywords == ""){
            onOrderAndFullfilmentStackHeight.constant = 0.0
        }else{
            onOrderAndFullfilmentStackHeight.constant = 56.0
        }
        view_wholesalePrice.isHidden = true
        if data.str_price_wholesale != "" && data.str_price_wholesale != "0"{
          let value =  Double(data.str_price_wholesale == "" ? "0" : data.str_price_wholesale)?.currencyFormat ?? "0.00"
            lbl_wholesalePrice.text = value
            view_wholesalePrice.isHidden = false
        }
        popUpScrollView.setContentOffset(.zero, animated: false)
        arrCustomFields = data.customFieldsArr
        colletionView_customField.reloadData()
    }
}
extension iPad_ProductInfoViewController: ProductsContainerViewControllerDelegate{
    func didSelectEditButton(data: ProductsModel, index: Int, isSearching: Bool) {
        //        self.isSearching = isSearching
        //        self.index = index
        print(data)
        colletionViewHieghtConst.constant = 0
        if let url = URL(string: data.str_product_image) {
            img_Product.kf.setImage(with: url, placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
        }else {
            if let data = data.productImageData {
                img_Product.image = UIImage(data: data)
            }
        }
        lbl_Title.text = data.str_title
        lbl_ProductCode.text = data.str_product_code
        lbl_Price.text = Double(data.str_price == "" ? "0" : data.str_price)?.currencyFormat ?? "0.00"
        lbl_Quantity.text = data.v_product_stock
        // lbl_InFulfillment.text = data.str_fulfillment_action
        veriation_product_attributes_value.frame.size.height = 0
        if data.v_product_attributes_name == "" {
            view_veriation_product_attributes.isHidden = true
            veriation_product_attributes_value.text = ""
        }else{
            view_veriation_product_attributes.isHidden = false
            veriation_product_attributes_name.text = data.v_product_attributes_name
            if data.v_product_attributes_values.count > 0 {
                let value = data.v_product_attributes_values.joined(separator: ",")
                veriation_product_attributes_value.text = value.replacingOccurrences(of: ",", with: "\n")
            }
        }
        if data.str_brand == ""{
            brand_View.isHidden = true
            
        }else{
            lbl_Brand.text = data.str_brand
            brand_View.isHidden = false
        }
        if data.str_supplier == ""{
            supplier_View.isHidden = true
        } else{
            lbl_Supplier.text = data.str_supplier
            supplier_View.isHidden = false
        }
        
        if data.str_short_description != "" {
            descriptionTextView.text = ""
            lbl_title_short_Description.isHidden = false
            descriptionTextView.isHidden = false
            
            let attrStr = try! NSAttributedString(
                data: data.str_short_description.data(using: .unicode, allowLossyConversion: true)!,
                options:[.documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
            descriptionTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.init(red: 11.0/255.0, green: 118/255.0, blue: 201.0/255.0, alpha: 1.0)]
            descriptionTextView.attributedText = attrStr
            descriptionTextView.font =  UIFont(name: "OpenSans", size: 14.0)
        }else{
            descriptionTextView.text = ""
            lbl_title_short_Description.isHidden = true
            descriptionTextView.isHidden = true
        }
        
        if data.str_website_Link == "" {
            lbl_WebSiteLink.text = ""
            website_link_View.isHidden = true
        }else{
            lbl_WebSiteLink.text = ""
            website_link_View.isHidden = false
            lbl_WebSiteLink.text = data.str_website_Link
            urlString = data.str_website_Link
            lbl_WebSiteLink.isUserInteractionEnabled = true
            
        }
        
        if data.str_keywords == ""{
            lbl_Keywords.text = ""
            keywords_View.isHidden = true
        }else{
            lbl_Keywords.text = data.str_keywords
            keywords_View.isHidden = false
        }
        lbl_OnOrder.frame.size.height = 0
        if data.on_order == "" {
            lbl_OnOrder.text = ""
            onOrder_view.isHidden = true
        }
        else{
            lbl_OnOrder.text = ""
            onOrder_view.isHidden = false
            let Orderstring = data.on_order
            lbl_OnOrder.text = Orderstring.replacingOccurrences(of: "<br>", with: "\n")
        }
        if (data.on_order == "" && data.str_keywords == ""){
            onOrderAndFullfilmentStackHeight.constant = 0.0
        }else{
            onOrderAndFullfilmentStackHeight.constant = 56.0
        }
        view_wholesalePrice.isHidden = true
        if data.str_price_wholesale != "" && data.str_price_wholesale != "0"{
          let value =  Double(data.str_price_wholesale == "" ? "0" : data.str_price_wholesale)?.currencyFormat ?? "0.00"
            lbl_wholesalePrice.text = value
            view_wholesalePrice.isHidden = false
        }
        popUpScrollView.setContentOffset(.zero, animated: false)
        arrCustomFields = data.customFieldsArr
        colletionView_customField.reloadData()
        callAPIToGetProductInfoDetail(productId: data.str_product_id)
    }
}
//MARK:-  UICollectionViewDataSource, UICollectionViewDelegate
extension iPad_ProductInfoViewController : UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCustomFields.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomFieldsCell", for: indexPath)
        let lbl_Name = cell.contentView.viewWithTag(125) as? UILabel
        let lbl_Value = cell.contentView.viewWithTag(126) as? UILabel
        lbl_Name?.text = arrCustomFields[indexPath.row].label + ":"
        lbl_Value?.text = arrCustomFields[indexPath.row].value
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let arrcount = arrCustomFields.count
        var count = 3
        if arrcount.isMultiple(of: 2) {
            let arrcount1 = arrcount / 2
            count = arrcount1
            print("Number is even")
        } else {
            let arrcount1 = arrcount / 2
            count = arrcount1 + 1
            print("Number is odd")
        }
        colletionViewHieghtConst.constant = CGFloat((45 * count)) + 15
        return CGSize(width: (width/2) - 10, height: 45)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
