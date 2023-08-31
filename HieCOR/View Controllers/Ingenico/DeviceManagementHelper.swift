//
//  DeviceManagementHelper.swift
//  EMVSDKSwiftTestApp
//
//  Created by Abhiram Dinesh on 5/25/18.
//  Copyright © 2018 Ingenico. All rights reserved.
//

import UIKit
import Foundation
import CoreBluetooth
import ExternalAccessory

protocol DeviceManagementDelegate {
    func connectPairedDevice(device: RUADevice, ofType deviceType: RUADeviceType)
}

class DeviceManagementHelper: NSObject, CBCentralManagerDelegate {
    var bluetoothManager : CBCentralManager?
    var accessoryManager = EAAccessoryManager.shared()
    static let shared = DeviceManagementHelper()
    var delegate : DeviceManagementDelegate?
    var lastConnectedDevice :RUADevice?
    var autoconnectionEnabled = true
    
    let DEVICE_KEY = "PairedDevices"
    let TYPE_KEY = "PairedDeviceTypes"
    
    // Step 2: Implement CBManagerDelegate.
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        //Step 3: Scan for devices
        if bluetoothManager?.state == .poweredOn {
            bluetoothManager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name  {
            // Connect only BLE devices using this delegate method. Activating MFI devices may fail when MFI devices are not connected in system's bluetooth settings. Use EAAccessoryDidConnectNotification method to connect MFI devices.
            checkScannedDeviceIsAlreadyPaired(name, isBLE: true)
        }
    }
    
    func retrievePairedDevices() -> [String:(device:RUADevice,type:RUADeviceType)] {
        var pairedDevices : [String:(device:RUADevice,type:RUADeviceType)] = [:]
        if let deviceDict = UserDefaults.standard.object(forKey: DEVICE_KEY) as? [String:Data],
            let typeDict = UserDefaults.standard.object(forKey: TYPE_KEY) as? [String:UInt32] {
            for deviceName in deviceDict.keys {
                if let encodedDevice = deviceDict[deviceName],
                    let type = typeDict[deviceName],
                    let device = NSKeyedUnarchiver.unarchiveObject(with: encodedDevice) as? RUADevice {
                    pairedDevices[deviceName] = (device,RUADeviceType(type))
                }
            }
        }
        return pairedDevices
    }
    
    func saveDevice(device:RUADevice, ofType type:RUADeviceType) {
        lastConnectedDevice = device
        var deviceDict = UserDefaults.standard.object(forKey: DEVICE_KEY) as? [String:Data]
        var typeDict = UserDefaults.standard.object(forKey: TYPE_KEY) as? [String:UInt32]
        if(deviceDict == nil || typeDict == nil) {
            deviceDict = [:]
            typeDict = [:]
        }
        let encodedDevice = NSKeyedArchiver.archivedData(withRootObject: device)
        deviceDict![device.name] = encodedDevice
        typeDict![device.name] = type.rawValue
        UserDefaults.standard.set(deviceDict, forKey: DEVICE_KEY)
        UserDefaults.standard.set(typeDict, forKey: TYPE_KEY)
        UserDefaults.standard.synchronize()
    }
    
    
    func checkScannedDeviceIsAlreadyPaired(_ deviceName: String, isBLE ble:Bool) {
        //Get paired devices list from user defaults
        let pairedDevices = retrievePairedDevices()
        if (lastConnectedDevice != nil) {
            let name = lastConnectedDevice!.name!
            if name.lowercased() == deviceName.lowercased() {
                if let type = pairedDevices[name]?.type {
                    if ((type == RUADeviceTypeRP750x && ble) ||
                        (type == RUADeviceTypeRP45BT && ble) ||
                        (type == RUADeviceTypeMOBY3000 && ble) ||
                        (type == RUADeviceTypeMOBY8500 && ble) ||
                        (type == RUADeviceTypeMOBY5500 && ble) ||
                        (type == RUADeviceTypeRP450c && !ble)) {
                        delegate?.connectPairedDevice(device: lastConnectedDevice!, ofType:type)
                    }
                }
            }
        }
    }
    
    //call stop scan once you recieve RUADeviceStatusHandler onConnected callback
    func stopScan() {
        bluetoothManager?.stopScan()
        accessoryManager.unregisterForLocalNotifications()
        NotificationCenter.default.removeObserver(NSNotification.Name.EAAccessoryDidConnect)
    }
    
    
    //call start scan once you recieve RUADeviceStatusHandler onDisconnected and onError callback
    func startScan() {
        if (autoconnectionEnabled) {
            bluetoothManager = CBCentralManager(delegate: self, queue: nil, options: nil)
            accessoryManager.registerForLocalNotifications()
            NotificationCenter.default.addObserver(self, selector: #selector(accessoryDidConnect(_:)), name: NSNotification.Name.EAAccessoryDidConnect, object: nil)
            for accessory in accessoryManager.connectedAccessories {
                if (accessory.name.count > 0) {
                    checkScannedDeviceIsAlreadyPaired(accessory.name, isBLE: false)
                }
            }
        }
        
    }
    
    @objc func accessoryDidConnect(_ note: Notification) {
        if let accessory = note.userInfo?[EAAccessoryKey] as? EAAccessory {
            if (accessory.name.count > 0) {
                checkScannedDeviceIsAlreadyPaired(accessory.name, isBLE: false)
            }
        }
    }
    
}
