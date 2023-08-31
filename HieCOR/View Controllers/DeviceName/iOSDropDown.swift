//
//  iOSDropDown.swift
//  HieCOR
//
//  Created by hiecor on 04/05/21.
//  Copyright © 2021 HyperMacMini. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

open class DropDown : UITextField{
    
    var arrow : Arrow!
    var table : UITableView!
    var shadow : UIView!
    public  var selectedIndex: Int?
    
    
    //MARK: IBInspectable
    @IBInspectable public var rowHeight: CGFloat = 30
    @IBInspectable public var rowBackgroundColor: UIColor = .white
    @IBInspectable public var selectedRowColor: UIColor = .white
    @IBInspectable public var hideOptionsWhenSelect = true
    @IBInspectable  public var isSearchEnable: Bool = true {
        didSet{
            addGesture()
        }
    }
    
    
    //Variables
    fileprivate  var tableheightX: CGFloat = 100
    fileprivate  var dataArray = [String]()
    fileprivate  var imageArray = [String]()
    fileprivate  var parentController:UIViewController?
    fileprivate  var pointToParent = CGPoint(x: 0, y: 0)
    fileprivate var backgroundView = UIView()
    fileprivate var keyboardHeight:CGFloat = 0
    var deviceName = UIDevice.current.name.condenseWhitespace() == "" ? "POS" : UIDevice.current.name
    var settingdelegate: ChangeDeviceNamePopupVCDelegate?
    
    public var rowTextColor: UIColor = .black
    public var optionArray = [String]() {
        didSet{
            self.dataArray = [String]()
        }
    }
    public var optionImageArray = [String]() {
        didSet{
            self.imageArray = self.optionImageArray
        }
    }
    public var optionIds : [Int]?
    var searchText = String() {
        didSet{
            if searchText == "" {
                self.dataArray = [String]()
            }else{
                
                // search code by Sudama -------Start------
                searchText = searchText.trimmingCharacters(in: .whitespaces).condenseWhitespace()
                dataArray.removeAll()
                var isSpaceInVal = true
                let spaceCount = searchText.filter{$0 == " "}.count
                if spaceCount > 0 {
                    isSpaceInVal = false
                }
                for i in 0..<optionArray.count {
                    let strVal = optionArray[i]
                    let strArry = strVal.split(separator: " ")
                    if strArry.count > 0 && isSpaceInVal {
                        
                        for ar in strArry {
                            if (ar.lowercased)().hasPrefix(searchText.lowercased()) {
                                dataArray.append(HomeVM.shared.sourcesList[i])
                                break
                            }
                        }
                    }else{
                        if (optionArray[i].lowercased()).hasPrefix(searchText.lowercased()) {
                            dataArray.append(optionArray[i])
                        }
                    }
                    
                }
                
                // search code by sudama -------End------
                
            }
            reSizeTable()
            selectedIndex = nil
            if self.table != nil {
                self.table.reloadData()
            }
        }
    }
    @IBInspectable public var listHeight: CGFloat = 150{
        didSet {
            
        }
    }
    
    @IBInspectable public var arrowColor: UIColor = .black {
        didSet{
            arrow.arrowColor = arrowColor
        }
    }
    @IBInspectable public var checkMarkEnabled: Bool = true {
        didSet{
            
        }
    }
    @IBInspectable public var handleKeyboard: Bool = true {
        didSet{
            
        }
    }
    
    // Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        self.delegate = self
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupUI()
        self.delegate = self
    }
    
    
    //MARK: Closures
    fileprivate var didSelectCompletion: (String, Int ,Int) -> () = {selectedText, index , id  in }
    fileprivate var TableWillAppearCompletion: () -> () = { }
    fileprivate var TableDidAppearCompletion: () -> () = { }
    fileprivate var TableWillDisappearCompletion: () -> () = { }
    fileprivate var TableDidDisappearCompletion: () -> () = { }
    
    func setupUI () {
       
        self.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
        
        self.backgroundView = UIView(frame: .zero)
        self.backgroundView.backgroundColor = .clear
        addGesture()
        self.text = DataManager.deviceNameText ?? deviceName.condenseWhitespace() == "" ? "POS" : deviceName//"POS"
        if isSearchEnable && handleKeyboard{
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: nil) { (notification) in
                if self.isFirstResponder{
                    let userInfo:NSDictionary = notification.userInfo! as NSDictionary
                    let keyboardFrame:NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    self.keyboardHeight = keyboardRectangle.height
                    if !self.isSelected{
                        self.showList()
                        //self.hideList()
                    }
                }
                
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: nil) { (notification) in
                if self.isFirstResponder{
                    self.keyboardHeight = 0
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(DropDown.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
    @objc func doneButtonClicked(_ sender: Any) {
        //your code when clicked on done
        if var name = self.text, name != "" {
            name = name.trimmingCharacters(in: .whitespaces).condenseWhitespace()
            name = name == "" ? deviceName : name
            //  DataManager.deviceNameText = name
            self.searchText = name
            //deviceNameUpdateDelegate?.deviceNameUpdate?(with: name)
            settingdelegate?.deviceNameUpdatePopup?(with: name)
            
        }else {
            // self.searchText = "POS"
            //  DataManager.deviceNameText = "POS"
            settingdelegate?.deviceNameUpdatePopup?(with: deviceName)
            
        }
        hideList()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func rotated() {
        reSizeTable()
    }
    
    
    fileprivate func addGesture (){
        let gesture =  UITapGestureRecognizer(target: self, action:  #selector(touchAction))
        if isSearchEnable{
            self.rightView?.addGestureRecognizer(gesture)
        }else{
            self.addGestureRecognizer(gesture)
        }
        let gesture2 =  UITapGestureRecognizer(target: self, action:  #selector(touchAction))
        self.backgroundView.addGestureRecognizer(gesture2)
    }
    func getConvertedPoint(_ targetView: UIView, baseView: UIView?)->CGPoint{
        var pnt = targetView.frame.origin
        if nil == targetView.superview{
            return pnt
        }
        var superView = targetView.superview
        while superView != baseView{
            pnt = superView!.convert(pnt, to: superView!.superview)
            if nil == superView!.superview{
                break
            }else{
                superView = superView!.superview
            }
        }
        return superView!.convert(pnt, to: baseView)
    }
    public func showList() {
        if parentController == nil{
            parentController = self.parentViewController
        }
        backgroundView.frame = parentController?.view.frame ?? backgroundView.frame
        pointToParent = getConvertedPoint(self, baseView: parentController?.view)
        parentController?.view.insertSubview(backgroundView, aboveSubview: self)
        TableWillAppearCompletion()
        if listHeight > rowHeight * CGFloat( dataArray.count) {
            self.tableheightX = rowHeight * CGFloat(dataArray.count)
        }else{
            self.tableheightX = listHeight
        }
        table = UITableView(frame: CGRect(x: pointToParent.x ,
                                          y: pointToParent.y + self.frame.height + 10 ,
                                          width: self.frame.width,
                                          height: self.frame.height))
        shadow = UIView(frame: table.frame)
        shadow.backgroundColor = .clear
        
        table.dataSource = self
        table.delegate = self
        table.alpha = 0
        // table.separatorStyle = .none
        table.layer.cornerRadius = 3
        table.backgroundColor = rowBackgroundColor
        table.rowHeight = rowHeight
        table.separatorStyle = .singleLine
        parentController?.view.addSubview(shadow)
        parentController?.view.addSubview(table)
        self.isSelected = true
        let height = (self.parentController?.view.frame.height ?? 0) - (self.pointToParent.y + self.frame.height + 5)
        var y = self.pointToParent.y+self.frame.height+5
        if height < (keyboardHeight+tableheightX){
            y = self.pointToParent.y - tableheightX
        }
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        
                        self.table.frame = CGRect(x: self.pointToParent.x,
                                                  y: y + 10,
                                                  width: self.frame.width,
                                                  height: self.tableheightX)
                        self.table.alpha = 1
                        self.shadow.frame = self.table.frame
                        self.shadow.dropShadow1()
                        // self.arrow.position = .up
                        
                        
        },
                       completion: { (finish) -> Void in
                        self.layoutIfNeeded()
                        
        })
        
    }
    
    
    public func hideList() {
        TableWillDisappearCompletion()
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        self.table.frame = CGRect(x: self.pointToParent.x,
                                                  y: self.pointToParent.y+self.frame.height,
                                                  width: self.frame.width,
                                                  height: 0)
                        self.shadow.alpha = 0
                        self.shadow.frame = self.table.frame
                        // self.arrow.position = .down
        },
                       completion: { (didFinish) -> Void in
                        
                        self.shadow.removeFromSuperview()
                        self.table.removeFromSuperview()
                        self.backgroundView.removeFromSuperview()
                        self.isSelected = false
                        self.TableDidDisappearCompletion()
        })
    }
    
    @objc public func touchAction() {
        
        isSelected ?  hideList() : showList()
    }
    func reSizeTable() {
        if listHeight > rowHeight * CGFloat( dataArray.count) {
            self.tableheightX = rowHeight * CGFloat(dataArray.count)
        }else{
            self.tableheightX = listHeight
        }
        let height = (self.parentController?.view.frame.height ?? 0) - (self.pointToParent.y + self.frame.height + 5)
        var y = self.pointToParent.y+self.frame.height+5
        if height < (keyboardHeight+tableheightX){
            y = self.pointToParent.y - tableheightX
        }
        UIView.animate(withDuration: 0.2,
                       delay: 0.1,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
                       animations: { () -> Void in
                        if self.table != nil {
                            self.table.frame = CGRect(x: self.pointToParent.x,
                                                      y: y + 10,
                                                      width: self.frame.width,
                                                      height: self.tableheightX)
                            self.shadow.frame = self.table.frame
                            self.shadow.dropShadow1()
                        }
                        
        },
                       completion: { (didFinish) -> Void in
                        //  self.shadow.layer.shadowPath = UIBezierPath(rect: self.table.bounds).cgPath
                        self.layoutIfNeeded()
                        
        })
    }
    
    //MARK: Actions Methods
    public func didSelect(completion: @escaping (_ selectedText: String, _ index: Int , _ id:Int ) -> ()) {
        didSelectCompletion = completion
    }
    public func listWillAppear(completion: @escaping () -> ()) {
        TableWillAppearCompletion = completion
    }
    
    public func listDidAppear(completion: @escaping () -> ()) {
        TableDidAppearCompletion = completion
    }
    
    public func listWillDisappear(completion: @escaping () -> ()) {
        TableWillDisappearCompletion = completion
    }
    
    public func listDidDisappear(completion: @escaping () -> ()) {
        TableDidDisappearCompletion = completion
    }
    
}

//MARK: UITextFieldDelegate
extension DropDown : UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        superview?.endEditing(true)
        
        if var name = textField.text, name != "" {
            name = name.trimmingCharacters(in: .whitespaces).condenseWhitespace()
            name = name == "" ? deviceName : name
            //  DataManager.deviceNameText = name
            self.searchText = name
            //deviceNameUpdateDelegate?.deviceNameUpdate?(with: name)
            settingdelegate?.deviceNameUpdatePopup?(with: name)
            
        }else {
            // self.searchText = "POS"
            //  DataManager.deviceNameText = "POS"
            settingdelegate?.deviceNameUpdatePopup?(with: deviceName)
            
        }
        hideList()
        return false
    }
    public func  textFieldDidBeginEditing(_ textField: UITextField) {
        //Device Name
        if DataManager.deviceNameText != "" && DataManager.deviceNameText != nil{
            textField.text = DataManager.deviceNameText
        }else{
            textField.text = deviceName
        }
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
     
    }
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return isSearchEnable
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != "" {
            self.searchText = self.text! + string
        }else{
            let subText = self.text?.dropLast()
            self.searchText = String(subText!)
        }
        if !isSelected {
            showList()
        }
        return true;
    }
    
}
///MARK: UITableViewDataSource
extension DropDown: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "DropDownCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        if indexPath.row != selectedIndex{
            cell!.backgroundColor = rowBackgroundColor
        }else {
            cell?.backgroundColor = selectedRowColor
        }
        
        if self.imageArray.count > indexPath.row {
            cell!.imageView!.image = UIImage(named: imageArray[indexPath.row])
        }
        cell!.textLabel!.text = dataArray[indexPath.row].condenseWhitespace()
        cell!.accessoryType = (indexPath.row == selectedIndex) && checkMarkEnabled  ? .checkmark : .none
        cell!.selectionStyle = .none
        cell?.textLabel?.font = self.font
        cell?.textLabel?.textAlignment = self.textAlignment
        cell?.textLabel?.textColor = rowTextColor
        return cell!
    }
    
}
//MARK: UITableViewDelegate
extension DropDown: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = (indexPath as NSIndexPath).row
        let selectedText = self.dataArray[self.selectedIndex!]
        tableView.cellForRow(at: indexPath)?.alpha = 0
        tableView.cellForRow(at: indexPath)?.backgroundColor = .red
        UIView.animate(withDuration: 0.5,
                       animations: { () -> Void in
                        tableView.cellForRow(at: indexPath)?.alpha = 1.0
                        tableView.cellForRow(at: indexPath)?.backgroundColor = self.selectedRowColor
        } ,
                       completion: { (didFinish) -> Void in
                        self.text = "\(selectedText)"
                        
                        tableView.reloadData()
        })
        if hideOptionsWhenSelect {
            touchAction()
            self.endEditing(true)
        }
        if let selected = optionArray.firstIndex(where: {$0 == selectedText}) {
            if let id = optionIds?[selected] {
                didSelectCompletion(selectedText, selected , id )
            }else{
                didSelectCompletion(selectedText, selected , 0)
            }
            
        }
        
    }
}






//MARK: Arrow
enum Position {
    case left
    case down
    case right
    case up
}

class Arrow: UIView {
    let shapeLayer = CAShapeLayer()
    var arrowColor:UIColor = .black {
        didSet{
            shapeLayer.fillColor = arrowColor.cgColor
        }
    }
    
    var position: Position = .down {
        didSet{
            switch position {
            case .left:
                self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
                break
                
            case .down:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2)
                break
                
            case .right:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                break
                
            case .up:
                self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                break
            }
        }
    }
    
    init(origin: CGPoint, size: CGFloat ) {
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: size, height: size))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        // Get size
        let size = self.layer.frame.width
        
        // Create path
        let bezierPath = UIBezierPath()
        
        // Draw points
        let qSize = size/4
        
        bezierPath.move(to: CGPoint(x: 0, y: qSize))
        bezierPath.addLine(to: CGPoint(x: size, y: qSize))
        bezierPath.addLine(to: CGPoint(x: size/2, y: qSize*3))
        bezierPath.addLine(to: CGPoint(x: 0, y: qSize))
        bezierPath.close()
        
        // Mask to path
        shapeLayer.path = bezierPath.cgPath
        //  shapeLayer.fillColor = arrowColor.cgColor
        
        if #available(iOS 12.0, *) {
            self.layer.addSublayer (shapeLayer)
        } else {
            self.layer.mask = shapeLayer
        }
    }
}

extension UIView {
    
    func dropShadow1(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
