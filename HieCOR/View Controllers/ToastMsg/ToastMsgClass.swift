//
//  ToastMsgClass.swift
//  ToastMsg
//

import UIKit

//MARK: Add Toast method function in UIView Extension so can use in whole project.
extension UIView {
    //    var inputView: UIView/
    
    
    func showToast(toastMessage:String,duration:CGFloat,isCenter:Bool) {
        //View to blur bg and stopping user interaction
        let bgView = UIView(frame: self.frame)
        // bgView.backgroundColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.4))
        bgView.tag = 555
        
        //Label For showing toast text
        let lblMessage = UILabel()
        lblMessage.numberOfLines = 0
        lblMessage.lineBreakMode = .byWordWrapping
        lblMessage.textColor = .white
        lblMessage.backgroundColor = #colorLiteral(red: 0.3057340086, green: 0.3494131267, blue: 0.3800984025, alpha: 1)
        lblMessage.textAlignment = .center
        if(UI_USER_INTERFACE_IDIOM() == .pad){
            lblMessage.font = UIFont.init(name: "OpenSans", size: 17)
        } else if UI_USER_INTERFACE_IDIOM() == .phone {
            lblMessage.font = UIFont.init(name: "OpenSans", size: 14)
        }
        lblMessage.text = toastMessage
        
        //calculating toast label frame as per message content
        let maxSizeTitle : CGSize = CGSize(width: self.bounds.size.width-16, height: self.bounds.size.height)
        var expectedSizeTitle : CGSize = lblMessage.sizeThatFits(maxSizeTitle)
        // UILabel can return a size larger than the max size when the number of lines is 1
        expectedSizeTitle = CGSize(width:maxSizeTitle.width.getminimum(value2:expectedSizeTitle.width), height: maxSizeTitle.height.getminimum(value2:expectedSizeTitle.height))
        if isCenter{
            bgView.backgroundColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.01))
            lblMessage.frame = CGRect(x:((self.bounds.size.width)/2) - ((expectedSizeTitle.width+40)/2) ,
                                      y: (self.bounds.size.height) - ((self.bounds.size.height)-(self.bounds.size.height/4)),
                                      width: expectedSizeTitle.width+40, height: expectedSizeTitle.height+20)
        } else {
            bgView.backgroundColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.4))
            //  lblMessage.frame = CGRect(x:((self.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2) , y: (self.bounds.size.height) - (self.bounds.size.height/5),width: self.bounds.size.width-10, height: expectedSizeTitle.height+20)
            lblMessage.frame = CGRect(x:((self.bounds.size.width)/2) - ((expectedSizeTitle.width+40)/2) , y: (self.bounds.size.height) - (self.bounds.size.height/5), width: expectedSizeTitle.width+40, height: expectedSizeTitle.height+20)
        }
        lblMessage.layer.cornerRadius = 20
        lblMessage.layer.masksToBounds = true
        lblMessage.padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        bgView.addSubview(lblMessage)
        self.addSubview(bgView)
        lblMessage.alpha = 0
        
        UIView.animateKeyframes(withDuration:TimeInterval(duration) , delay: 0, options: [] , animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1) {
                lblMessage.alpha = 1
                bgView.alpha = 1
            }
        }, completion: { sucess in
            UIView.animate(withDuration:TimeInterval(duration), delay: 0, options: [] , animations: {
                lblMessage.alpha = 0
                bgView.alpha = 0
            })
            //  bgView.removeFromSuperview()
        })
    }
    
    func showToastForCleanBGColor(toastMessage:String,duration:CGFloat,isCenter:Bool) {
        //View to blur bg and stopping user interaction
        let bgView = UIView(frame: self.frame)
        // bgView.backgroundColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.4))
        bgView.tag = 555
        
        //Label For showing toast text
        let lblMessage = UILabel()
        lblMessage.numberOfLines = 0
        lblMessage.lineBreakMode = .byWordWrapping
        lblMessage.textColor = .white
        lblMessage.backgroundColor = #colorLiteral(red: 0.3057340086, green: 0.3494131267, blue: 0.3800984025, alpha: 1)
        lblMessage.textAlignment = .center
        if(UI_USER_INTERFACE_IDIOM() == .pad){
            lblMessage.font = UIFont.init(name: "OpenSans", size: 17)
        } else if UI_USER_INTERFACE_IDIOM() == .phone {
            lblMessage.font = UIFont.init(name: "OpenSans", size: 14)
        }
        lblMessage.text = toastMessage
        
        //calculating toast label frame as per message content
        let maxSizeTitle : CGSize = CGSize(width: self.bounds.size.width-16, height: self.bounds.size.height)
        var expectedSizeTitle : CGSize = lblMessage.sizeThatFits(maxSizeTitle)
        // UILabel can return a size larger than the max size when the number of lines is 1
        expectedSizeTitle = CGSize(width:maxSizeTitle.width.getminimum(value2:expectedSizeTitle.width), height: maxSizeTitle.height.getminimum(value2:expectedSizeTitle.height))
        if isCenter{
            bgView.backgroundColor = .clear
            lblMessage.frame = CGRect(x:((self.bounds.size.width)/2) - ((expectedSizeTitle.width+40)/2) ,
                                      y: (self.bounds.size.height) - ((self.bounds.size.height)-(self.bounds.size.height/4)),
                                      width: expectedSizeTitle.width+40, height: expectedSizeTitle.height+20)
        } else {
            bgView.backgroundColor = .clear//UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.4))
            //  lblMessage.frame = CGRect(x:((self.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2) , y: (self.bounds.size.height) - (self.bounds.size.height/5),width: self.bounds.size.width-10, height: expectedSizeTitle.height+20)
            lblMessage.frame = CGRect(x:((self.bounds.size.width)/2) - ((expectedSizeTitle.width+40)/2) , y: (self.bounds.size.height) - (self.bounds.size.height/5), width: expectedSizeTitle.width+40, height: expectedSizeTitle.height+20)
        }
        lblMessage.layer.cornerRadius = 20
        lblMessage.layer.masksToBounds = true
        lblMessage.padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        bgView.addSubview(lblMessage)
        self.addSubview(bgView)
        lblMessage.alpha = 0
        
        UIView.animateKeyframes(withDuration:TimeInterval(duration) , delay: 0, options: [] , animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1) {
                lblMessage.alpha = 1
                bgView.alpha = 1
            }
        }, completion: { sucess in
            UIView.animate(withDuration:TimeInterval(duration), delay: 0, options: [] , animations: {
                lblMessage.alpha = 0
                bgView.alpha = 0
            })
            //  bgView.removeFromSuperview()
        })
    }
    
    func showErrorToast(toastMessage:String,duration:CGFloat,isCenter:Bool) {
        //View to blur bg and stopping user interaction
        let bgView = UIView(frame: self.frame)
        // bgView.backgroundColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.4))
        bgView.tag = 555
        
        //Label For showing toast text
        let lblMessage = UILabel()
        lblMessage.numberOfLines = 0
        lblMessage.lineBreakMode = .byWordWrapping
        lblMessage.textColor = .white
        lblMessage.backgroundColor = #colorLiteral(red: 0.3057340086, green: 0.3494131267, blue: 0.3800984025, alpha: 1)
        lblMessage.textAlignment = .center
        if(UI_USER_INTERFACE_IDIOM() == .pad){
            lblMessage.font = UIFont.init(name: "OpenSans", size: 17)
        } else if UI_USER_INTERFACE_IDIOM() == .phone {
            lblMessage.font = UIFont.init(name: "OpenSans", size: 15)
        }
        lblMessage.text = toastMessage
        
        //calculating toast label frame as per message content
        let maxSizeTitle : CGSize = CGSize(width: self.bounds.size.width-16, height: self.bounds.size.height)
        var expectedSizeTitle : CGSize = lblMessage.sizeThatFits(maxSizeTitle)
        // UILabel can return a size larger than the max size when the number of lines is 1
        expectedSizeTitle = CGSize(width:maxSizeTitle.width.getminimum(value2:expectedSizeTitle.width), height: maxSizeTitle.height.getminimum(value2:expectedSizeTitle.height))
        if isCenter{
            bgView.backgroundColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.01))
            lblMessage.frame = CGRect(x:((self.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2) , y: (self.bounds.size.height) - ((self.bounds.size.height)-(self.bounds.size.height/4)), width: expectedSizeTitle.width+40, height: expectedSizeTitle.height+20)
        } else {
            bgView.backgroundColor = UIColor(red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0.4))
            //            lblMessage.frame = CGRect(x:((self.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2) , y: (self.bounds.size.height) - (self.bounds.size.height/5), width: self.bounds.size.width-10, height: expectedSizeTitle.height+20)
            lblMessage.frame = CGRect(x:((self.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2) , y: (self.bounds.size.height) - (self.bounds.size.height/5), width: expectedSizeTitle.width+40, height: expectedSizeTitle.height+20)
        }
        lblMessage.layer.cornerRadius = 20
        lblMessage.layer.masksToBounds = true
        lblMessage.padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        bgView.addSubview(lblMessage)
        self.addSubview(bgView)
        lblMessage.alpha = 0
        
        UIView.animateKeyframes(withDuration:TimeInterval(duration) , delay: 0, options: [] , animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1) {
                lblMessage.alpha = 1
                bgView.alpha = 1
            }
        }, completion: { sucess in
            UIView.animate(withDuration:TimeInterval(duration), delay: 0, options: [] , animations: {
                lblMessage.alpha = 0
                bgView.alpha = 0
            })
        })
    }
}

extension CGFloat {
    func getminimum(value2:CGFloat)->CGFloat {
        if self < value2 {
            return self
        } else {
            return value2
        }
    }
}

//MARK: Extension on UILabel for adding insets - for adding padding in top, bottom, right, left.
extension UILabel {
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    
    //override open func draw(_ rect: CGRect) {
    //if let insets = padding {
    //      self.drawText(in: rect.UIEdgeInsetsInsetRect(by: insets))
    //} else {
    //      self.drawText(in: rect)
    //}
    //}
    
//    override open var intrinsicContentSize: CGSize {
//        get {
//            var contentSize = super.intrinsicContentSize
//            if let insets = padding {
//                contentSize.height += insets.top + insets.bottom
//                contentSize.width += insets.left + insets.right
//            }
//            return contentSize
//        }
//    }
}
