//
//  CustomTextField.swift
//  HieCOR
//
//  Created by Deftsoft on 12/12/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

class CustomSearchBar: UISearchBar {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
