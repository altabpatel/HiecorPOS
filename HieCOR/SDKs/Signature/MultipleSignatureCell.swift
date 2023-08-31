//
//  MultipleSignatureCell.swift
//  HieCOR
//
//  Created by Hiecor Software on 07/11/19.
//  Copyright © 2019 HyperMacMini. All rights reserved.
//

import UIKit

protocol MultipleSignatureCellDelegate: class {
    func buttonTapped(cell: MultipleSignatureCell, btnTag: Int)
}

class MultipleSignatureCell: UITableViewCell {
    
    // for socket
    @IBOutlet weak var signatureImageForSocket: UIImageView!
    //
    @IBOutlet weak var viewBaseCell: UIStackView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet var signView: EPSignatureView!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var btnCellOpenClose: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblErrorMsg: UILabel!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet var noTripBtn: UIButton!
    @IBOutlet var fifteenBtn: UIButton!
    @IBOutlet var twentyBtn: UIButton!
    @IBOutlet var twentyFiveBtn: UIButton!
    @IBOutlet var numberField: UITextField!
    
    weak var delegate: MultipleSignatureCellDelegate?
    @IBOutlet weak var customTipViewDotBorder: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewBaseCell.layer.cornerRadius = 3
        viewBaseCell.layer.borderWidth = 1.0
        viewBaseCell.layer.borderColor = UIColor.gray.cgColor
        
        updateTipUI(type: 0)
        
        if UI_USER_INTERFACE_IDIOM() == .phone{
            noTripBtn.titleLabel?.font = noTripBtn.titleLabel?.font.withSize(12)
            fifteenBtn.titleLabel?.font = fifteenBtn.titleLabel?.font.withSize(12)
            twentyBtn.titleLabel?.font = twentyBtn.titleLabel?.font.withSize(12)
            twentyFiveBtn.titleLabel?.font = twentyFiveBtn.titleLabel?.font.withSize(12)
            numberField.font = numberField.font?.withSize(12)
            //numberField.setDollar(font: numberField.font!)
            //numberField.text?.font = numberField.text?.font.withSize(11)
            //btnSubscriptionWithOrder.titleLabel?.font =  btnSubscriptionWithOrder.titleLabel?.font.withSize(15)
            //btnSusbscriptionNoChange.titleLabel?.font =  btnSubscriptionWithOrder.titleLabel?.font.withSize(15)
        } else {
            //numberField.setDollar(font: numberField.font!)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    @IBAction func noTripTapped(_ sender: UIButton)
    {
        self.delegate?.buttonTapped(cell: self, btnTag: sender.tag)
        updateTipUI(type: 0)
    }
    
    @IBAction func fifteenTapped(_ sender: UIButton)
    {
        self.delegate?.buttonTapped(cell: self, btnTag: sender.tag)
        updateTipUI(type: 15)
    }
    
    @IBAction func twentyTapped(_ sender: UIButton)
    {
        self.delegate?.buttonTapped(cell: self, btnTag: sender.tag)
        updateTipUI(type: 20)
    }
    
    @IBAction func twentyFiveTapped(_ sender: UIButton)
    {
        self.delegate?.buttonTapped(cell: self, btnTag: sender.tag)
        updateTipUI(type: 25)
    }
    
    
    private func updateTipUI(type: Double) {
        switch type {
        case 0:
            numberField.resignFirstResponder()
            fifteenBtn.backgroundColor = UIColor.white
            fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            twentyBtn.backgroundColor = UIColor.white
            twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            twentyFiveBtn.backgroundColor = UIColor.white
            twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            noTripBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
            noTripBtn.setTitleColor(.white, for: .normal)
            
            // tipAmount = 0
            //   tipType = 0.0
            //numberField.text = ""
            //     self.delegate?.updateTotal?(with: tipAmount)
            break
        case 15:
            numberField.resignFirstResponder()
            fifteenBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
            fifteenBtn.setTitleColor(.white, for: .normal)
            twentyBtn.backgroundColor = UIColor.white
            twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            twentyFiveBtn.backgroundColor = UIColor.white
            twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            noTripBtn.backgroundColor = UIColor.white
            noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            
            //  tipAmount = (total/100)*15
            //  tipType = 15
            //  numberField.text = ""
            //   numberField.text = tipAmount.roundToTwoDecimal
            //  self.delegate?.updateTotal?(with: tipAmount)
            break
        case 20:
            numberField.resignFirstResponder()
            fifteenBtn.backgroundColor = UIColor.white
            fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            twentyBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
            twentyBtn.setTitleColor(.white, for: .normal)
            twentyFiveBtn.backgroundColor = UIColor.white
            twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            noTripBtn.backgroundColor = UIColor.white
            noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            
            //              tipAmount = (total/100)*20
            //              tipType = 20
            //numberField.text = ""
            //              numberField.text = tipAmount.roundToTwoDecimal
            //              self.delegate?.updateTotal?(with: tipAmount)
            break
        case 25:
            numberField.resignFirstResponder()
            fifteenBtn.backgroundColor = UIColor.white
            fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            twentyBtn.backgroundColor = UIColor.white
            twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            twentyFiveBtn.backgroundColor = UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0)
            twentyFiveBtn.setTitleColor(.white, for: .normal)
            noTripBtn.backgroundColor = UIColor.white
            noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            
            //  tipAmount = (total/100)*25
            //   tipType = 25
            //numberField.text = ""
            //   numberField.text = tipAmount.roundToTwoDecimal
            //  self.delegate?.updateTotal?(with: tipAmount)
            break
        case -1:    //Manual
            fifteenBtn.backgroundColor = UIColor.white
            fifteenBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            twentyBtn.backgroundColor = UIColor.white
            twentyBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            twentyFiveBtn.backgroundColor = UIColor.white
            twentyFiveBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            noTripBtn.backgroundColor = UIColor.white
            noTripBtn.setTitleColor(UIColor.init(red: 11.0/255.0, green: 118.0/255.0, blue: 201.0/255.0, alpha: 1.0), for: .normal)
            
            //              tipAmount = Double(numberField.text ?? "0") ?? 0.00
            //              tipType = -1
            //              if tipAmount > 0 {
            //                  numberField.text = tipAmount.roundToTwoDecimal
            //              } else {
            //                  numberField.text = ""
            //              }
            
            // self.delegate?.updateTotal?(with: tipAmount)
            break
        default: break
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
