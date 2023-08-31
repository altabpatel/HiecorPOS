//
//  PeripheralDelegate.swift
//  Printer
//
//  Created by GongXiang on 12/8/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

import Foundation
import CoreBluetooth

class PeripheralDelegate: NSObject, CBPeripheralDelegate {

    private var services: Set<String>!
    private var characteristics: Set<CBUUID>?

    private let writablecharacteristicUUID = "BEF8D6C9-9C21-4C9E-B632-BD58C1009F9F"

    var wellDoneCanWriteData: ((CBPeripheral) -> ())?

    private(set) var writablePeripheral: CBPeripheral?
    private(set) var writablecharacteristic: CBCharacteristic? {
        didSet {
            if let wc = writablecharacteristic, let wp = writablePeripheral {
                wp.setNotifyValue(true, for: wc)
                wellDoneCanWriteData?(wp)
            }
        }
    }

    convenience init(_ services: Set<String>, characteristics: Set<String>?) {
        self.init()
        self.services = services
        self.characteristics = (characteristics?.map { CBUUID(string: $0) }).map { Set($0) }
    }

    func disconnect(_ peripheral: CBPeripheral) {

        guard let wp = writablePeripheral else {
            return
        }

        if wp.identifier == peripheral.identifier {

            writablePeripheral = nil
            writablecharacteristic = nil
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {

            guard error == nil else { return }

            guard let prServices = peripheral.services else {
                return
            }
            
            for service in peripheral.services! {
    //
                if service.uuid.uuidString.count > 5{
                     peripheral.discoverCharacteristics(nil, for: service)
                }
                //

            }
           
    //        prServices.filter { services.contains($0.uuid.uuidString) }.forEach {
    //            peripheral.discoverCharacteristics(nil, for: $0)
    //        }
        }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {

        writablePeripheral = peripheral
        for characteristic in service.characteristics! {
            
            writablecharacteristic = characteristic
            
        }
//        writablecharacteristic = service.characteristics?.filter { $0.uuid.uuidString == writablecharacteristicUUID }.first
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateValueFor \(peripheral)")
        peripheral.setNotifyValue(true, for: characteristic)
        
    }
}
