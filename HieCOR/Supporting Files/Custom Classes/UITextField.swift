//
//  UITextField.swift
//  HieCOR
//
//  Created by Deftsoft on 26/07/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import Foundation

extension CALayer {
    var customBorderColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}

class PaddedTextField: UITextField {
    
    @IBInspectable var padding: CGFloat = 8
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding, y: bounds.origin.y, width: bounds.width - padding * 2, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + padding, y: bounds.origin.y, width: bounds.width - padding * 2, height: bounds.height)
    }
}

extension UITextField {
    
    func addDropDownArrow() {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 22, height: 20))
        let iconView  = UIImageView(frame: CGRect(x: 5, y: 7, width: 10, height: 7))
        iconView.image = UIImage(named: "dropdown-arrow")
        outerView.isUserInteractionEnabled = true
        iconView.isUserInteractionEnabled = true
        outerView.addSubview(iconView)
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(handleTap(sender:)))
        
        iconView.addGestureRecognizer(tapGesture)
        
        self.rightView = outerView
        self.rightViewMode = .always
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.becomeFirstResponder()
    }

}

extension UIView {
    func setBorder(color: UIColor? = UIColor.init(red: 205.0/255.0, green: 206.0/255.0, blue: 210.0/255.0, alpha: 1.0)) {
        let border = CALayer()
        border.borderColor = color!.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - 1.0, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = 1.0
        border.name = "in_line"
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }

    func resetCustomError(isAddAgain: Bool? = true) {
        for view in self.subviews {
            if view.tag == 100000001 || view.tag == 100000002 {
                view.removeFromSuperview()
            }
        }
        if isAddAgain! {
            setBorder()
        }
    }
    
    func removeInLineBorder() {
        for view in self.subviews {
            if view.tag == 100000001 || view.tag == 100000002 {
                view.removeFromSuperview()
            }
        }
        
        if let layers = self.layer.sublayers {
            for lay in layers {
                if lay.name == "in_line" {
                    lay.removeFromSuperlayer()
                }
            }
        }
    }
    
    func setCustomError(text: String? = "Please swipe the card properly.",bottomSpace: CGFloat? = 2.0,rightSpace: CGFloat? = 0,isRightSide: Bool? = false) {
        removeInLineBorder()
        
        let badgeLabel = UILabel()
        badgeLabel.text = text
        badgeLabel.tag = 100000002
        badgeLabel.textColor = UIColor.red
        badgeLabel.backgroundColor = UIColor.clear
        badgeLabel.font = UIFont.systemFont(ofSize: 12.0)
        badgeLabel.sizeToFit()
        badgeLabel.textAlignment = .left
        badgeLabel.frame = CGRect(x: isRightSide! ? -50 :  rightSpace!, y: self.bounds.height + 5, width: 250, height: 15)

        badgeLabel.layer.cornerRadius = badgeLabel.frame.height/2
        badgeLabel.layer.masksToBounds = true
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        addSubview(badgeLabel)
        
        let borderLine = UIView()
        borderLine.frame = CGRect(x: 0, y: self.bounds.height + bottomSpace!, width: self.frame.size.width, height: 1)
        borderLine.backgroundColor = UIColor.red
        borderLine.tag = 100000001
        borderLine.sizeToFit()
        borderLine.layer.masksToBounds = true
        borderLine.clipsToBounds = false
        addSubview(borderLine)
    }
    
    func updateCustomBorder() {
        for view in self.subviews {
            if view.tag == 100000001 {
                view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: self.frame.size.width, height: view.frame.height)
                view.sizeToFit()
                break
            }
        }
    }
}

