//
//  EditProductContainerViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 21/02/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import Alamofire
import AssetsLibrary
import Photos
import IQKeyboardManagerSwift

class EditProductContainerViewController: BaseViewController  {
    
    //MARK: IBOutlets
    @IBOutlet var btn_CameraEditProduct: UIButton!
    @IBOutlet var view_CameraEditProduct: UIView!
    @IBOutlet var img_EditProduct: UIImageView!
    @IBOutlet var view_ImageEditProduct: UIView!
    @IBOutlet var view_ContentViewEditProduct: UIView!
    @IBOutlet var scrollView_EditProduct: UIScrollView!
    @IBOutlet var tf_EditProductQuantity: UITextField!
    @IBOutlet var lbl_EditProductQuantity: UILabel!
    @IBOutlet var tf_EditProductUPC: UITextField!
    @IBOutlet var tf_EditProductKeyWords: UITextField!
    @IBOutlet var tf_EditProductLongDescription: UITextField!
    @IBOutlet var tf_EditProductShortDescription: UITextField!
    @IBOutlet var tf_EditProductPrice: UITextField!
    @IBOutlet var tf_EditProductTitle: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var unlimitedStockButton: UIButton!
    //
    @IBOutlet weak var view_veriation_product: UIView!
    @IBOutlet weak var lbl_veriation_product_attributes_name: UILabel!
    
    @IBOutlet weak var colletionView_customField: UICollectionView!
    @IBOutlet weak var colletionViewHieghtConst: NSLayoutConstraint!
    @IBOutlet weak var lblVeriationName: UILabel!

     var arrCustomFields = [CustomFieldsModel]()
    //MARK: Private Variables
    private var imagedata = NSData()
    private var base64 = String()
    private var index = Int()
    private var isSearching = Bool()
    private var imageurl = String()
    private var productID = String()
    private var fileID = String()
    //MARK: Delegate
    var editProductDelegate: EditProductsContainerViewDelegate?
    
    
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
    
    @IBOutlet weak var lbl_Keywords: UILabel!
    @IBOutlet weak var fullfillmentTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var keyWordsHeightConstraint: NSLayoutConstraint!
    //all view inside stack
    @IBOutlet weak var lbl_title_short_Description: UILabel!
    @IBOutlet weak var product_code_view: UIView!
    @IBOutlet weak var brand_View: UIView!
    @IBOutlet weak var supplier_View: UIView!
    @IBOutlet weak var quantity_View: UIView!
    @IBOutlet weak var price_View: UIView!
    @IBOutlet weak var website_link_View: UIView!
    @IBOutlet weak var onOrder_view: UIView!
    @IBOutlet weak var inFullfillment: UIView!
    
    @IBOutlet weak var stakeHeightConstraint: NSLayoutConstraint!
    
    var image = UIImage(named: "category-bg")
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var discHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var onOrderViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var keywordStackView: UIStackView!
    @IBOutlet weak var view_wholesalePrice: UIView!
    @IBOutlet weak var lbl_wholesalePrice: UILabel!
    var tapGestureRecognizer:UITapGestureRecognizer!
    var urlString = ""
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        descriptionTextView.isEditable = false
        tapGestureRecognizer = UITapGestureRecognizer(target:self, action:      #selector(onUserClickingSendToken(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        lbl_WebSiteLink.isUserInteractionEnabled = true
        lbl_WebSiteLink.addGestureRecognizer(tapGestureRecognizer)
        super.viewDidLoad()
        self.customizeUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setBorder()
    }
    
    @objc func onUserClickingSendToken(_ sender: Any)
    {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        //        scrollView_EditProduct.contentSize = CGSize(width: CGFloat(view_ContentViewEditProduct.frame.size.width), height: CGFloat(view_ContentViewEditProduct.frame.size.height)+250)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.setBorder()
    }
    
    //MARK: Private Functions
    private func setBorder() {
        // tf_EditProductTitle.setBorder()
        // tf_EditProductUPC.setBorder()
        // tf_EditProductPrice.setBorder()
        // tf_EditProductKeyWords.setBorder()
        //  tf_EditProductQuantity.setBorder()
        // tf_EditProductLongDescription.setBorder()
        //  tf_EditProductShortDescription.setBorder()
    }
    
    private func customizeUI() {
        //  tf_EditProductShortDescription.delegate = self
        //  tf_EditProductLongDescription.delegate = self
        // tf_EditProductQuantity.delegate = self
        // tf_EditProductKeyWords.delegate = self
        // tf_EditProductPrice.delegate = self
        // tf_EditProductUPC.delegate = self
        // tf_EditProductTitle.delegate = self
        //  tf_EditProductPrice.setDollar(color: UIColor.darkGray, font: tf_EditProductPrice.font!)
        img_EditProduct?.layer.cornerRadius = 8.0
        img_EditProduct?.layer.borderWidth = 0.0
        img_EditProduct?.layer.masksToBounds = true
        img_EditProduct?.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        
        let shadowSize : CGFloat = 5.0
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2,
                                                   y: -shadowSize / 2,
                                                   width: (view_ImageEditProduct.frame.size.width) + shadowSize,
                                                   height: (view_ImageEditProduct.frame.size.height) + shadowSize))
        view_ImageEditProduct.layer.masksToBounds = false
        view_ImageEditProduct.layer.shadowColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        view_ImageEditProduct.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        view_ImageEditProduct.layer.shadowOpacity = 0.6
        view_ImageEditProduct.layer.shadowPath = shadowPath.cgPath
        
        //        btn_CameraEditProduct.layer.cornerRadius = btn_CameraEditProduct.frame.size.width/2
        //        btn_CameraEditProduct?.layer.borderWidth = 1.0
        //        btn_CameraEditProduct?.layer.borderColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0).cgColor
        //        view_CameraEditProduct.layer.cornerRadius = btn_CameraEditProduct.frame.size.width/2
    }
    
    //MARK: IBAction Method
    @IBAction func unlimitedStockButtonAction(_ sender: Any) {
        unlimitedStockButton.isSelected = !unlimitedStockButton.isSelected
        
        if unlimitedStockButton.isSelected {
            tf_EditProductQuantity.text = "0.00"
            tf_EditProductQuantity.isUserInteractionEnabled = false
            tf_EditProductQuantity.alpha = 0.5
            lbl_EditProductQuantity.alpha = 0.5
        }else {
            tf_EditProductQuantity.isUserInteractionEnabled = true
            tf_EditProductQuantity.alpha = 1.0
            lbl_EditProductQuantity.alpha = 1.0
        }
    }
    
    //    @IBAction func btn_CameraAction(_ sender: Any)
    //    {
    //        self.view.endEditing(true)
    //        let alert = UIAlertController(title: "Alert", message: "Choose Upload", preferredStyle: .alert)
    //        let gallery = UIAlertAction(title: "Gallery", style: .default, handler: {(action: UIAlertAction) -> Void in
    //            let picker = UIImagePickerController()
    //            picker.delegate = self
    //            picker.sourceType = .photoLibrary
    //            self.present(picker, animated: true, completion: nil)
    //        })
    //        let camera = UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) -> Void in
    //            let picker = UIImagePickerController()
    //            picker.delegate = self
    //            picker.sourceType = .camera
    //            self.present(picker, animated: true, completion: nil)
    //        })
    //        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction) -> Void in
    //            //...
    //        })
    //        alert.addAction(gallery)
    //        alert.addAction(camera)
    //        alert.addAction(cancel)
    //        self.present(alert, animated: true, completion: nil)
    //    }
    
    @IBAction func btn_ProductEditCancelAction(_ sender: Any) {
        self.view.endEditing(true)
        if(UI_USER_INTERFACE_IDIOM() == .pad)
        {
            editProductDelegate?.didEditProduct?(with: "btn_ProductEditCancelActionIPAD")
            //  ipad_CancelProductInfo
        }
        else
        {
            self.editProductDelegate?.didSelectProduct?(with: "btn_ProductEditCancelAction")
        }
        
        if Keyboard._isExternalKeyboardAttached() {
            SwipeAndSearchVC.shared.enableTextField()
        }
    }
    
    //    @IBAction func btn_ProductEditDoneAction(_ sender: Any) {
    //        self.view.endEditing(true)
    //
    //        if tf_EditProductTitle.isEmpty {
    //            tf_EditProductTitle.setCustomError(text: "Please enter Title.")
    //            return
    //        }
    //
    //        if tf_EditProductPrice.isEmpty {
    //            tf_EditProductPrice.setCustomError(text: "Please enter Price.")
    //            return
    //        }
    //
    //        if tf_EditProductQuantity.isEmpty {
    //            tf_EditProductQuantity.setCustomError(text: "Please enter Quantity.")
    //            return
    //        }
    //
    //        if tf_EditProductUPC.isEmpty {
    //            tf_EditProductUPC.setCustomError(text: "Please enter Product Code.")
    //            return
    //        }
    //
    //       updateProductService()
    //    }
    
}

//MARK: UITextFieldDelegate
extension EditProductContainerViewController: UITextFieldDelegate {
    
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        textField.resetCustomError()
    //        if Keyboard._isExternalKeyboardAttached() {
    //            IQKeyboardManager.shared.enable = true
    //            IQKeyboardManager.shared.enableAutoToolbar = true
    //        }
    //
    //        if textField == tf_EditProductPrice || textField == tf_EditProductQuantity {
    //
    //            textField.text = textField.text?.replacingOccurrences(of: ".00", with: "")
    //            textField.selectAll(nil)
    //        }
    //    }
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        textField.resignFirstResponder()
    //        return true
    //    }
    //
    //    func textFieldDidEndEditing(_ textField: UITextField) {
    //        if textField == tf_EditProductPrice || textField == tf_EditProductQuantity {
    //            let value = textField.text ?? "0.00"
    //            textField.text = "\((Double(value) ?? 0.00).roundToTwoDecimal)"
    //        }
    //Update Unlimited Stock
    //        if textField == tf_EditProductQuantity {
    //            if textField.text == "0.00" {
    //                unlimitedStockButton.isSelected = true
    //                tf_EditProductQuantity.text = "0.00"
    //                tf_EditProductQuantity.isUserInteractionEnabled = false
    //                tf_EditProductQuantity.alpha = 0.5
    //                lbl_EditProductQuantity.alpha = 0.5
    //            }
    //        }
    
    //        if Keyboard._isExternalKeyboardAttached() {
    //            IQKeyboardManager.shared.enable = false
    //            IQKeyboardManager.shared.enableAutoToolbar = false
    //            SwipeAndSearchVC.shared.enableTextField()
    //        }
}

//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if string.contains(UIPasteboard.general.string ?? "") && string.containEmoji {
//            return false
//        }
//
//        let charactersCount = textField.text!.utf16.count + (string.utf16).count - range.length
//        if range.location == 0 && string == " " {
//            return false
//        }

//        if textField == tf_EditProductPrice || textField == tf_EditProductQuantity {
//            let currentText = textField.text ?? ""
//            let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
//            return replacementText.isValidDecimal(maximumFractionDigits: 2) && charactersCount < 15
//        }
//        return true
//    }
//}

//MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension EditProductContainerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        img_EditProduct.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
}

//MARK: API Methods
extension EditProductContainerViewController {
    //
    //    func updateProductService() {
    //        //Update
    //        let parameters: Parameters = ["product_id": productID, "title": tf_EditProductTitle.text!, "price":tf_EditProductPrice.text!, "stock": tf_EditProductQuantity.text!, "short_description": tf_EditProductShortDescription.text!, "long_description": tf_EditProductLongDescription.text!, "fileID": fileID, "keywords": tf_EditProductKeyWords.text!, "product_code": tf_EditProductUPC.text!, "unlimited_stock" : (self.unlimitedStockButton.isSelected ? "1" : "0")]
    //
    //        var imageDict = [String: Data]()
    //
    //        if self.img_EditProduct.image != nil {
    //            let image = self.img_EditProduct.image!
    //            //imageDict["image"] = UIImageJPEGRepresentation(image, 1.0)
    //            imageDict["image"] = UIImagePNGRepresentation(image)
    //        }
    //        //Call API
    //        HomeVM.shared.updateProductService(parameters: parameters,imageDict: imageDict) { (success, message, error) in
    //            if success == 1 {
    //                //Update Array
    //                if self.isSearching {
    //                    HomeVM.shared.searchProductsArray[self.index] = HomeVM.shared.updatedProduct
    //                }else {
    //                    HomeVM.shared.productsArray[self.index] = HomeVM.shared.updatedProduct
    //                }
    //                if(UI_USER_INTERFACE_IDIOM() == .pad)
    //                {
    //                    self.editProductDelegate?.didEditProduct?(with: "updateproductIPAD")
    //                }
    //                else
    //                {
    //                    self.editProductDelegate?.didSelectProduct?(with: "btn_ProductEditCancelAction")
    //                    self.editProductDelegate?.refreshCart?()
    //                }
    //            }
    //            else {
    //                if  message != nil {
    ////                    self.showAlert(message: message!)
    //                    appDelegate.showToast(message: message!)
    //                }else {
    //                    self.showErrorMessage(error: error)
    //                }
    //            }
    //        }
    //    }
    
    //***
    func updateCartData() {
        
        if let cartProductsArray = DataManager.cartProductsArray {
            for i in  0..<cartProductsArray.count {
                if let dict = cartProductsArray[i] as? JSONDictionary {
                    if let id = dict["productid"] as? String , (Int(id) ?? -1) == (Int(productID) ?? -2) {
                        DataManager.cartProductsArray?.remove(at: i)
                    }
                }
            }
            self.editProductDelegate?.refreshCart?()
        }
        
    }
}

extension EditProductContainerViewController: ProductsContainerViewControllerDelegate {
    func didSelectEditButton(data: ProductsModel, index: Int, isSearching: Bool) {
        self.isSearching = isSearching
        self.index = index
        print(data)
        if let url = URL(string: data.str_product_image) {
            img_EditProduct.kf.setImage(with: url, placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
        }else {
            if let data = data.productImageData {
                img_EditProduct.image = UIImage(data: data)
            }
        }
        colletionViewHieghtConst.constant = 0
        lbl_Title.text = data.str_title
        lbl_ProductCode.text = data.str_product_code
        lbl_Price.text = Double(data.str_price == "" ? "0" : data.str_price)?.currencyFormat ?? "0.00"
        lbl_Quantity.text = data.v_product_stock
       // lbl_InFulfillment.text = data.str_fulfillment_action
        
        lbl_veriation_product_attributes_name.frame.size.height = 0
        if data.v_product_attributes_name == "" {
            lbl_veriation_product_attributes_name.frame.size.height = 0
            view_veriation_product.isHidden = true
            lbl_veriation_product_attributes_name.text = ""
        }else{
            view_veriation_product.isHidden = false
            lblVeriationName.text = data.v_product_attributes_name
            if data.v_product_attributes_values.count > 0 {
                let value = data.v_product_attributes_values.joined(separator: ",")
                lbl_veriation_product_attributes_name.text = value.replacingOccurrences(of: ",", with: "\n")
            }
            lbl_veriation_product_attributes_name.frame.size.height = CGFloat(25 * data.v_product_attributes_values.count)
        }
        // mark: check brand
        if data.str_brand == ""{
            brand_View.isHidden = true
        }else{
            brand_View.isHidden = false
            lbl_Brand.text = data.str_brand
        }
        
        // mark: check supplier
        if data.str_supplier == ""{
            supplier_View.isHidden = true
        }else{
            lbl_Supplier.text = data.str_supplier
            supplier_View.isHidden = false
        }
        
        if data.str_keywords == ""{
            keyWordsHeightConstraint.constant = 0
            keywordStackView.isHidden = true
            lbl_Keywords.text = ""
        }else{
            lbl_Keywords.text = ""
            lbl_Keywords.text = data.str_keywords
            keyWordsHeightConstraint.constant = 40
            keywordStackView.isHidden = false
        }
        
        // mark: check short description
        if data.str_short_description != "" {
            descriptionTextView.text = ""
            descriptionTextView.isHidden = false
            let attrStr = try! NSAttributedString(
                data: data.str_short_description.data(using: .unicode, allowLossyConversion: true)!,
                options:[.documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
            descriptionTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.init(red: 11.0/255.0, green: 118/255.0, blue: 201.0/255.0, alpha: 1.0)]
            descriptionTextView.attributedText = attrStr
            descriptionTextView.font =  UIFont(name: "OpenSans", size: 14.0)
            discHeightConstraint.constant = 18
        }else{
            descriptionTextView.text = ""
            descriptionTextView.isHidden = true
            discHeightConstraint.constant = 0
            }
        
        //mark: check website link
        if data.str_website_Link == "" {
            website_link_View.isHidden = true
            stakeHeightConstraint.constant = 105
        }else{
            lbl_WebSiteLink.text = data.str_website_Link
            urlString = data.str_website_Link
            website_link_View.isHidden = false
            stakeHeightConstraint.constant = 140
        }
        
        //mark: check onOrder List
        if data.on_order == "" {
            lbl_OnOrder.text = ""
            fullfillmentTopConstraint.constant = -35
            onOrder_view.isHidden = true
            
        }else{
            fullfillmentTopConstraint.constant = 0
            onOrder_view.isHidden = false
            let Orderstring = data.on_order
            lbl_OnOrder.text = Orderstring.replacingOccurrences(of: "<br>", with: "\n")
            
        }
        view_wholesalePrice.isHidden = true
        if data.str_price_wholesale != "" && data.str_price_wholesale != "0"{
            view_wholesalePrice.isHidden = false
            let value =  Double(data.str_price_wholesale == "" ? "0" : data.str_price_wholesale)?.currencyFormat ?? "0.00"
            lbl_wholesalePrice.text = value
        }
        productID = data.str_product_id
        fileID = data.str_fileID
        
        if data.unlimited_stock == "Yes" {
            //            self.unlimitedStockButton.isSelected = true
            //            tf_EditProductQuantity.isUserInteractionEnabled = false
            //            tf_EditProductQuantity.alpha = 0.5
            //            lbl_EditProductQuantity.alpha = 0.5
        }else {
            // self.unlimitedStockButton.isSelected = false
            //  tf_EditProductQuantity.isUserInteractionEnabled = true
            //  tf_EditProductQuantity.alpha = 1.0
            //lbl_EditProductQuantity.alpha = 1.0
        }
        arrCustomFields = data.customFieldsArr
        colletionView_customField.reloadData()
        self.scrollView.scrollToTop()
        callAPIToGetProductInfoDetail(productId: data.str_product_id)
    }
}
//MARK:-  UICollectionViewDataSource, UICollectionViewDelegate
extension EditProductContainerViewController : UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
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
 
extension EditProductContainerViewController {
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
        print(data)
        if let url = URL(string: data.str_product_image) {
            img_EditProduct.kf.setImage(with: url, placeholder: image, options: nil, progressBlock: nil, completionHandler: nil)
        }else {
            if let data = data.productImageData {
                img_EditProduct.image = UIImage(data: data)
            }
        }
        colletionViewHieghtConst.constant = 0
        lbl_Title.text = data.str_title
        lbl_ProductCode.text = data.str_product_code
        lbl_Price.text = Double(data.str_price == "" ? "0" : data.str_price)?.currencyFormat ?? "0.00"
        lbl_Quantity.text = data.v_product_stock
       // lbl_InFulfillment.text = data.str_fulfillment_action
        
        lbl_veriation_product_attributes_name.frame.size.height = 0
        if data.v_product_attributes_name == "" {
            lbl_veriation_product_attributes_name.frame.size.height = 0
            view_veriation_product.isHidden = true
            lbl_veriation_product_attributes_name.text = ""
        }else{
            view_veriation_product.isHidden = false
            lblVeriationName.text = data.v_product_attributes_name
            if data.v_product_attributes_values.count > 0 {
                let value = data.v_product_attributes_values.joined(separator: ",")
                lbl_veriation_product_attributes_name.text = value.replacingOccurrences(of: ",", with: "\n")
            }
            lbl_veriation_product_attributes_name.frame.size.height = CGFloat(25 * data.v_product_attributes_values.count)
        }
        // mark: check brand
        if data.str_brand == ""{
            brand_View.isHidden = true
        }else{
            brand_View.isHidden = false
            lbl_Brand.text = data.str_brand
        }
        
        // mark: check supplier
        if data.str_supplier == ""{
            supplier_View.isHidden = true
        }else{
            lbl_Supplier.text = data.str_supplier
            supplier_View.isHidden = false
        }
        
        if data.str_keywords == ""{
            keyWordsHeightConstraint.constant = 0
            keywordStackView.isHidden = true
            lbl_Keywords.text = ""
        }else{
            lbl_Keywords.text = ""
            lbl_Keywords.text = data.str_keywords
            keyWordsHeightConstraint.constant = 40
            keywordStackView.isHidden = false
        }
        
        // mark: check short description
        if data.str_short_description != "" {
            descriptionTextView.text = ""
            descriptionTextView.isHidden = false
            let attrStr = try! NSAttributedString(
                data: data.str_short_description.data(using: .unicode, allowLossyConversion: true)!,
                options:[.documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
            descriptionTextView.linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.init(red: 11.0/255.0, green: 118/255.0, blue: 201.0/255.0, alpha: 1.0)]
            descriptionTextView.attributedText = attrStr
            descriptionTextView.font =  UIFont(name: "OpenSans", size: 14.0)
            discHeightConstraint.constant = 18
        }else{
            descriptionTextView.text = ""
            descriptionTextView.isHidden = true
            discHeightConstraint.constant = 0
            }
        
        //mark: check website link
        if data.str_website_Link == "" {
            website_link_View.isHidden = true
            stakeHeightConstraint.constant = 105
        }else{
            lbl_WebSiteLink.text = data.str_website_Link
            urlString = data.str_website_Link
            website_link_View.isHidden = false
            stakeHeightConstraint.constant = 140
        }
        
        //mark: check onOrder List
        if data.on_order == "" {
            lbl_OnOrder.text = ""
            fullfillmentTopConstraint.constant = -35
            onOrder_view.isHidden = true
            
        }else{
            fullfillmentTopConstraint.constant = 0
            onOrder_view.isHidden = false
            let Orderstring = data.on_order
            lbl_OnOrder.text = Orderstring.replacingOccurrences(of: "<br>", with: "\n")
            
        }
        view_wholesalePrice.isHidden = true
        if data.str_price_wholesale != "" && data.str_price_wholesale != "0"{
            view_wholesalePrice.isHidden = false
            let value =  Double(data.str_price_wholesale == "" ? "0" : data.str_price_wholesale)?.currencyFormat ?? "0.00"
            lbl_wholesalePrice.text = value
        }
        productID = data.str_product_id
        fileID = data.str_fileID
        
        if data.unlimited_stock == "Yes" {
            //            self.unlimitedStockButton.isSelected = true
            //            tf_EditProductQuantity.isUserInteractionEnabled = false
            //            tf_EditProductQuantity.alpha = 0.5
            //            lbl_EditProductQuantity.alpha = 0.5
        }else {
            // self.unlimitedStockButton.isSelected = false
            //  tf_EditProductQuantity.isUserInteractionEnabled = true
            //  tf_EditProductQuantity.alpha = 1.0
            //lbl_EditProductQuantity.alpha = 1.0
        }
        arrCustomFields = data.customFieldsArr
        colletionView_customField.reloadData()
        self.scrollView.scrollToTop()
    }
}
