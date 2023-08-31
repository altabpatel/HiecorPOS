//
//  LoadStarPrinter.swift
//  HieCOR
//
//  Created by hiecor on 18/03/21.
//  Copyright © 2021 HyperMacMini. All rights reserved.
//

import Foundation
import UIKit

class LoadStarPrinter: NSObject {
    static let settingManager = SettingManager()
    
    var portName:     String!
    var portSettings: String!
    var modelName:    String!
    var macAddress:   String!
    
    var emulation:                StarIoExtEmulation!
    var cashDrawerOpenActiveHigh: Bool!
    var allReceiptsSettings:      Int!
    var selectedIndex:            Int!
    var selectedLanguage:         LanguageIndex!
    var selectedPaperSize:        Int?
    var selectedModelIndex:       Int?
    
    fileprivate func loadParam() {
           LoadStarPrinter.settingManager.load()
       }
       
       static func getPortName() -> String {
           return settingManager.settings[0]?.portName ?? ""
       }
       
       static func setPortName(_ portName: String) {
           settingManager.settings[0]?.portName = portName
           settingManager.save()
       }
       
       static func getPortSettings() -> String {
           return settingManager.settings[0]?.portSettings ?? ""
       }
       
       static func setPortSettings(_ portSettings: String) {
           settingManager.settings[0]?.portSettings = portSettings
           settingManager.save()
       }
       
       static func getModelName() -> String {
           return settingManager.settings[0]?.modelName ?? ""
       }
       
       static func setModelName(_ modelName: String) {
           settingManager.settings[0]?.modelName = modelName
           settingManager.save()
       }
       
       static func getMacAddress() -> String {
           return settingManager.settings[0]?.macAddress ?? ""
       }
       
       static func setMacAddress(_ macAddress: String) {
           settingManager.settings[0]?.macAddress = macAddress
           settingManager.save()
       }
       
       static func getEmulation() -> StarIoExtEmulation {
           return settingManager.settings[0]?.emulation ?? .starPRNT
       }
       
       static func setEmulation(_ emulation: StarIoExtEmulation) {
           settingManager.settings[0]?.emulation = emulation
           settingManager.save()
       }
       
       static func getCashDrawerOpenActiveHigh() -> Bool {
           return settingManager.settings[0]?.cashDrawerOpenActiveHigh ?? true
       }
       
       static func setCashDrawerOpenActiveHigh(_ activeHigh: Bool) {
           settingManager.settings[0]?.cashDrawerOpenActiveHigh = activeHigh
           settingManager.save()
       }
       
       static func getAllReceiptsSettings() -> Int {
           return settingManager.settings[0]?.allReceiptsSettings ?? 0x07
       }
       
       static func setAllReceiptsSettings(_ allReceiptsSettings: Int) {
           settingManager.settings[0]?.allReceiptsSettings = allReceiptsSettings
           settingManager.save()
       }
       
//       static func getSelectedIndex() -> Int {
//           let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//
//           return delegate.selectedIndex!
//       }
//
//       static func setSelectedIndex(_ index: Int) {
//           let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//
//           delegate.selectedIndex = index
//       }
//
//       static func getSelectedLanguage() -> LanguageIndex {
//           let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//
//           return delegate.selectedLanguage!
//       }
//
//       static func setSelectedLanguage(_ index: LanguageIndex) {
//           let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//
//           delegate.selectedLanguage = index
//       }
       
       static func getSelectedPaperSize() -> PaperSizeIndex {
           return LoadStarPrinter.settingManager.settings[0]?.selectedPaperSize ?? .threeInch
       }
       
       static func setSelectedPaperSize(_ index: PaperSizeIndex) {
           LoadStarPrinter.settingManager.settings[0]?.selectedPaperSize = index
           settingManager.save()
       }
       
       static func getSelectedModelIndex() -> ModelIndex? {
           return LoadStarPrinter.settingManager.settings[0]?.selectedModelIndex
       }
       
       static func setSelectedModelIndex(_ modelIndex: ModelIndex?) {
           settingManager.settings[0]?.selectedModelIndex = modelIndex ?? .none
           settingManager.save()
       }
}
