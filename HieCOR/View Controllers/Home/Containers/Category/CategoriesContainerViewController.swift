//
//  CategoriesContainerViewController.swift
//  HieCOR
//
//  Created by HyperMacMini on 20/02/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import UIKit
import CoreData

class CategoriesContainerViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet var collectionView: UICollectionView?
    
    //Variables
    private var array_Categories = [CategoriesModel]()
    private var pageControl = UIPageControl()
    private var str_CategoryName = String()
    private var indexofPage:Int = 1
    var isCollectionScrolled = false
    var delegate: CategoriesContainerViewControllerDelegate?
    var productDelegate: ProductsContainerViewControllerDelegate?
    var updatePagerDelegate: CatAndProductsViewControllerDelegate?
    var editProductDelegate: EditProductsContainerViewDelegate?
    
    //MARK: Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.str_CategoryName = DataManager.selectedCategory
        self.loadCollectionView()
        self.initializeVariables()
        self.getCategoriesList()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UI_USER_INTERFACE_IDIOM() == .phone {
            SwipeAndSearchVC.delegate = self
        }
        self.collectionView?.isHidden = false
        self.collectionView?.isPagingEnabled = UI_USER_INTERFACE_IDIOM() == .pad
        if UI_USER_INTERFACE_IDIOM() == .phone {
            if !NetworkConnectivity.isConnectedToInternet() && DataManager.isOffline{
                delegate?.didTapOnManualPayment?()
            }
            OfflineDataManager.shared.delegate = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if UI_USER_INTERFACE_IDIOM() == .phone {
            SwipeAndSearchVC.delegate = nil
        }
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "ShowKeyboard"), object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView?.collectionViewLayout.invalidateLayout()
        self.updatePager()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    //MARK: Private Methods
    private func loadCollectionView() {
        self.automaticallyAdjustsScrollViewInsets = false
        if(UI_USER_INTERFACE_IDIOM() == .pad) {
            if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
            }
        } else {
            if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .vertical
            }
        }
        collectionView?.isPagingEnabled = true
    }
    
    private func initializeVariables() {
        indexofPage = 1
        self.array_Categories = [CategoriesModel]()
        self.collectionView?.reloadData()
        self.str_CategoryName = ""
    }
    
    //MARK: IBAction
    @IBAction func manualPaymentAction(_ sender: Any) {
        delegate?.didTapOnManualPayment?()
    }
    
}

//MARK:- Collectionview Delegate Methods
extension CategoriesContainerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return array_Categories.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if DataManager.isshippingRefundOnly  || DataManager.isTipRefundOnly {
            //collectionView.alpha = 0.5
            collectionView.isUserInteractionEnabled = false
            //cell.alpha = 0.5
            
        } else {
            collectionView.isUserInteractionEnabled = true
            
        }
        let CategoriesObj = array_Categories[indexPath.item]
        let lbl_CategoryName = cell.contentView.viewWithTag(2) as? UILabel
        lbl_CategoryName?.text = CategoriesObj.str_CategoryName
        let data: Character = " "
        let sensitiveCount = CategoriesObj.str_CategoryName.characters.filter { $0 == data }.count // case-sensitive
        
        print(sensitiveCount)
        
        if sensitiveCount == 0 {
            lbl_CategoryName?.numberOfLines = 1
        } else {
            lbl_CategoryName?.numberOfLines = 0
        }
        
        let view_Underline = cell.viewWithTag(3)
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if(self.str_CategoryName == self.array_Categories[indexPath.item].str_CategoryName) {
                view_Underline?.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
            } else {
                view_Underline?.backgroundColor = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 0.7)
            }
        } else {
            view_Underline?.isHidden = true
            cell.contentView.viewWithTag(100)?.cornerRadius = 5.0
            cell.contentView.viewWithTag(100)?.backgroundColor = UIColor.white
            cell.cornerRadius = 5.0
            //Add Shadow
            cell.clipsToBounds = false
            cell.layer.shadowColor = UIColor.lightGray.cgColor
            cell.layer.shadowOffset = CGSize.zero
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 3
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if DataManager.isshippingRefundOnly || DataManager.isTipRefundOnly{
            return
        }
        HomeVM.shared.isAllDataLoaded = [false, false, false]
        self.str_CategoryName = self.array_Categories[indexPath.item].str_CategoryName
        DataManager.selectedCategory = self.str_CategoryName
        delegate?.getProduct?(withCategory: self.array_Categories[indexPath.item].str_CategoryName)
        
        if(UI_USER_INTERFACE_IDIOM() == .pad)
        {
            collectionView.reloadData()
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:- CollectionviewLayout Delegate Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(UI_USER_INTERFACE_IDIOM() == .pad)
        {
            if (UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)) {
                
                if (collectionView.frame.size.width >= 1002.0){
                    
                    return CGSize(width: CGFloat((collectionView.frame.size.height/1.53)), height: CGFloat((collectionView.frame.size.height / 2)-12 ))
                    
                } else if (collectionView.frame.size.width >= 748.0 && collectionView.frame.size.width < 1002.0){
                    return CGSize(width: CGFloat((collectionView.frame.size.height/1.46)), height: CGFloat((collectionView.frame.size.height / 2)-12 ))
                    
                } else  {
                    return CGSize(width: CGFloat((collectionView.frame.size.width/5) - 11), height: CGFloat((collectionView.frame.size.height / 2)-13 ))
                }
            }else {
                if (collectionView.frame.size.width >= 660.0){
                    return CGSize(width: CGFloat((collectionView.frame.size.width/5.4)), height: CGFloat((collectionView.frame.size.height / 2)-12 ))
                    
                } else if (collectionView.frame.size.width >= 470.0 && collectionView.frame.size.width < 660.0){
                    return CGSize(width: CGFloat((collectionView.frame.size.height/1.9)), height: CGFloat((collectionView.frame.size.height / 2)-12 ))
                    
                } else  {
                    return CGSize(width: CGFloat((collectionView.frame.size.width/3)-11), height: CGFloat((collectionView.frame.size.height / 3)+21 ))
                }
            }
        } else {
            
            if (UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation)) {
                return CGSize(width: CGFloat((collectionView.frame.size.width / 5)-12 ), height: CGFloat((collectionView.frame.size.width / 5)-12 ))
            } else {
                return CGSize(width: CGFloat((collectionView.frame.size.width / 3)-12 ), height: CGFloat((collectionView.frame.size.width / 3)-12 ))
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return UI_USER_INTERFACE_IDIOM() == .pad ? 11 : 8
    }
}

//MARK:- UIScrollViewDelegate Methods
extension CategoriesContainerViewController:  UIScrollViewDelegate {
    
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
            
            self.pageControl.currentPage = newIndex - 1
            
            self.updatePagerDelegate?.updatePager?(dict: ["numberofpages": self.pageControl.numberOfPages, "pageCount":self.pageControl.currentPage], isCategory: true)
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
                    self.getCategoriesList()
                }
            }else {
                if (self.collectionView!.contentOffset.y + self.collectionView!.frame.height) + 10 >= (self.collectionView!.contentSize.height) {
                    indexofPage = indexofPage + 1
                    self.getCategoriesList()
                }
            }
        }
        updatePager()
    }
}

//MARK: API Method
extension CategoriesContainerViewController{
    func getCategoriesList() {
        
        Indicator.isEnabledIndicator = false
        Indicator.sharedInstance.showIndicator()
        
        if indexofPage != 1 {
            HomeVM.shared.isAllDataLoaded = [false, false, false]
        }
        
        HomeVM.shared.getCategory(pageNumber: indexofPage) { (success, message, error) in
            if success == 1 {
                if UI_USER_INTERFACE_IDIOM() == .pad {
                    if self.indexofPage != 1 {
                        Indicator.isEnabledIndicator = true
                        Indicator.sharedInstance.hideIndicator()
                    }
                }else {
                    Indicator.isEnabledIndicator = true
                    Indicator.sharedInstance.hideIndicator()
                }
                
                
                self.array_Categories = HomeVM.shared.categoriesArray
                self.collectionView?.reloadData()
                self.updatePager()
                
                if self.indexofPage == 1 && UI_USER_INTERFACE_IDIOM() == .pad {
                    self.delegate?.getProduct?(withCategory: DataManager.selectedCategory)
                    self.str_CategoryName = DataManager.selectedCategory
                }
                
                if !HomeVM.shared.isMoreCategoryFound {
                    self.indexofPage = self.indexofPage - 1
                }else {
                    if UI_USER_INTERFACE_IDIOM() == .pad {
                        DispatchQueue.main.async {
                            let width = self.collectionView!.frame.width - (self.collectionView!.contentInset.left*2)
                     //       let index = Int(round(self.collectionView!.contentOffset.x / width))
                            self.collectionView?.setContentOffset(CGPoint(x:  CGFloat(self.collectionView!.contentOffset.x / width) * (self.collectionView?.bounds.size.width)! , y: 0), animated: true)
                        }
                    }
                }
            }
            else
            {
                self.indexofPage = self.indexofPage - 1
                Indicator.isEnabledIndicator = true
                Indicator.sharedInstance.hideIndicator()
                DispatchQueue.main.async {
                    if message != nil {
//                        self.showAlert(message: message!)
                        appDelegate.showToast(message: message!)
                    }else {
                        if NetworkConnectivity.isConnectedToInternet() && !DataManager.isOffline{
                            self.showErrorMessage(error: error)
                        }
                    }
                }
            }
        }
    }
}

//MARK: ResetCartDelegate
extension CategoriesContainerViewController: ResetCartDelegate {
    func resetHomeCart() {
        self.resetCart()
    }
    
    func resetCart() {
        self.view.endEditing(true)
        DataManager.selectedCategory = "Home"
        initializeVariables()
        self.updatePager()
        self.getCategoriesList()
    }
}

//MARK: SwipeAndSearchDelegate
extension CategoriesContainerViewController: SwipeAndSearchDelegate {
    func didSearchingProduct() {
        print("Searching")
    }
    
    func didSearchedProduct(product: ProductsModel) {
        self.collectionView?.isHidden = false
        self.editProductDelegate?.didSelectProduct?(with: "productDetails")
        self.editProductDelegate?.didReceiveProductDetail?(data: product)
    }
    
    func noProductFound() {
        print("no product found")
        self.collectionView?.isHidden = true
        self.editProductDelegate?.hideDetailView?()
    }
    
    func didEndSearching() {
        self.collectionView?.isHidden = false
    }
    
    func didGetCardDetail(number: String, month: String, year: String) {
        productDelegate?.didGetCardDetail?()
    }
    
    func noCardDetailFound() {
        productDelegate?.noCardDetailFound?()
    }
}

//MARK: OfflineDataManagerDelegate
extension CategoriesContainerViewController: OfflineDataManagerDelegate {
    func didUpdateInternetConnection(isOn: Bool) {
        if isOn {
            self.resetCart()
        }else {
            if DataManager.isOffline {
                delegate?.didTapOnManualPayment?()
            }
        }
    }
}
