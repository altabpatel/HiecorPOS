//
//  SettingManager.swift
//  Swift SDK
//
//  Created by u3237 on 2018/06/04.
//  Copyright © 2018年 Star Micronics. All rights reserved.
//

import Foundation

class PrinterSetting: NSObject, NSCoding {
    var portName: String
    
    var portSettings: String
    
    var modelName: String
    
    var macAddress: String
    
    var emulation: StarIoExtEmulation
    
    var cashDrawerOpenActiveHigh: Bool
    
    var allReceiptsSettings: Int
    
    var selectedPaperSize: PaperSizeIndex
    
    var selectedModelIndex: ModelIndex

    
    init(portName: String, portSettings: String, macAddress: String, modelName: String,
         emulation: StarIoExtEmulation, cashDrawerOpenActiveHigh: Bool, allReceiptsSettings: Int,
         selectedPaperSize: PaperSizeIndex, selectedModelIndex: ModelIndex) {
        self.portName = portName
        self.portSettings = portSettings
        self.macAddress = macAddress
        self.modelName = modelName
        self.emulation = emulation
        self.cashDrawerOpenActiveHigh = cashDrawerOpenActiveHigh
        self.allReceiptsSettings = allReceiptsSettings
        self.selectedPaperSize = selectedPaperSize
        self.selectedModelIndex = selectedModelIndex
        
        super.init()
        
        print(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.portName = aDecoder.decodeObject(forKey: "portName") as? String ?? ""
        self.portSettings = aDecoder.decodeObject(forKey: "portSettings") as? String ?? ""
        self.macAddress = aDecoder.decodeObject(forKey: "macAddress") as? String ?? ""
        self.modelName = aDecoder.decodeObject(forKey: "modelName") as? String ?? ""
        self.emulation = StarIoExtEmulation(rawValue: aDecoder.decodeInteger(forKey: "emulation"))!
        self.cashDrawerOpenActiveHigh = aDecoder.decodeBool(forKey: "cashDrawerOpenActiveHigh")
        self.allReceiptsSettings = aDecoder.decodeInteger(forKey: "allReceiptsSettings")
        self.selectedPaperSize = PaperSizeIndex(rawValue: aDecoder.decodeInteger(forKey: "selectedPaperSize")) ?? PaperSizeIndex.twoInch
        self.selectedModelIndex = ModelIndex(rawValue: aDecoder.decodeInteger(forKey: "selectedModelIndex")) ?? ModelIndex.none
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(portName, forKey: "portName")
        aCoder.encode(portSettings, forKey: "portSettings")
        aCoder.encode(macAddress, forKey: "macAddress")
        aCoder.encode(modelName, forKey: "modelName")
        aCoder.encode(emulation.rawValue, forKey: "emulation")
        aCoder.encode(cashDrawerOpenActiveHigh, forKey: "cashDrawerOpenActiveHigh")
        aCoder.encode(allReceiptsSettings, forKey: "allReceiptsSettings")
        aCoder.encode(selectedPaperSize.rawValue, forKey: "selectedPaperSize")
        aCoder.encode(selectedModelIndex.rawValue, forKey: "selectedModelIndex")
    }
    
    override var description: String {
        return """
        PrinterSetting
        {
            portName: \(self.portName)
            portSettings: \(self.portSettings)
            macAddress: \(self.macAddress)
            modelName: \(self.modelName)
            emulation: \(self.emulation.rawValue)
            cashDrawerOpenActiveHigh: \(self.cashDrawerOpenActiveHigh)
            allReceiptsSettings: \(self.allReceiptsSettings)
            selectedPaperSize: \(self.selectedPaperSize)
            selectedModelIndex: \(self.selectedModelIndex)
        }
        """
    }
}

class SettingManager: NSObject {
    var settings: [PrinterSetting?]
    
    override init() {
        self.settings = [nil, nil]
        
        super.init()
    }
    
    func save() {

        let encodedData: Data?
        
        if #available(iOS 11.0, *) {
           encodedData = try? NSKeyedArchiver.archivedData(withRootObject: settings, requiringSecureCoding: false)
        } else {
            encodedData = NSKeyedArchiver.archivedData(withRootObject: settings)
        }
        
        UserDefaults.standard.set(encodedData, forKey: "setting")
        UserDefaults.standard.synchronize()
    }
    
    func load() {
        let optEncodedData = UserDefaults.standard.data(forKey: "setting")
        if let encodedData = optEncodedData {
            do{
                self.settings =  try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(encodedData) as? [PrinterSetting?] ?? [nil,nil]
            }catch {
                self.settings = [nil,nil]
            }
        }

    }
}

enum LanguageIndex: Int {
    case english = 0
    case japanese
    case french
    case portuguese
    case spanish
    case german
    case russian
    case simplifiedChinese
    case traditionalChinese
    case cjkUnifiedIdeograph
}

enum PaperSizeIndex: Int {
    case twoInch = 384
    case threeInch = 576
    case fourInch = 832
    case escPosThreeInch = 512
    case dotImpactThreeInch = 210
}
class GlobalQueueManager {
    static let shared = GlobalQueueManager()
    
    var serialQueue = DispatchQueue(label: "jp.star-m.swiftsdk")
}
