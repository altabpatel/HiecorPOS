//
//  PrinterManager.swift
//  Printer
//
//  Created by GongXiang on 12/8/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

import Foundation
import CoreBluetooth
import ExternalAccessory
public extension String {
    struct GBEncoding {
        public static let GB_18030_200033 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue)))
    }
}

public extension CBPeripheral {

    var printerState: PrinterStruct.State {
        switch state {
        case .disconnected:
            return .disconnected
        case .connected:
            return .connected
        case .connecting:
            return .connecting
        case .disconnecting:
            return .disconnecting
        }
    }
}

public struct PrinterStruct {

    public enum State {

        case disconnected
        case connecting
        case connected
        case disconnecting
    }

    public let name: String?
    public let identifier: UUID

    public var state: State

    public var isConnecting: Bool {
        return state == .connecting
    }

    public init(_ peripheral: CBPeripheral) {

        self.name = peripheral.name
        self.identifier = peripheral.identifier
        self.state = peripheral.printerState
    }
}

public enum NearbyPrinterChange {

    case add(PrinterStruct)
    case update(PrinterStruct)
    case remove(UUID) // identifier
}

public protocol PrinterManagerDelegate: NSObjectProtocol {

    func nearbyPrinterDidChange(_ change: NearbyPrinterChange)
}

public extension PrinterManager {

    static var specifiedServices: Set<String> = ["E7810A71-73AE-499D-8C15-FAA9AEF0C3F2"]
    static var specifiedCharacteristics: Set<String>?
}

public class PrinterManager {

    public let queue = DispatchQueue(label: "com.kevin.gong.printer")

    public let centralManager: CBCentralManager

    let centralManagerDelegate = CentralManagerDelegate(PrinterManager.specifiedServices)
    let peripheralDelegate = PeripheralDelegate(PrinterManager.specifiedServices, characteristics: PrinterManager.specifiedCharacteristics)

    public weak var delegate: PrinterManagerDelegate?

    public var errorReport: ((PError) -> ())?

    public var connectTimer: Timer?

    public var nearbyPrinters: [PrinterStruct] {
        return centralManagerDelegate.discoveredPeripherals.values.map { PrinterStruct($0) }
    }

    public init(delegate: PrinterManagerDelegate? = nil) {

        centralManager = CBCentralManager(delegate: centralManagerDelegate, queue: DispatchQueue.main)

        self.delegate = delegate

        commonInit()
    }

    private func commonInit() {

        peripheralDelegate.wellDoneCanWriteData = { [weak self] in

            self?.connectTimer?.invalidate()
            self?.connectTimer = nil

            self?.nearbyPrinterDidChange(.update(PrinterStruct($0)))
        }

        centralManagerDelegate.peripheralDelegate = peripheralDelegate

        centralManagerDelegate.addedPeripherals = { [weak self] in

            guard let printer = (self?.centralManagerDelegate[$0].map { PrinterStruct($0) }) else {
                return
            }
            self?.nearbyPrinterDidChange(.add(printer))
        }
        
        centralManagerDelegate.centralManagerDidConnectPeripheral = { [weak self]  _, peripheral in
            
            self?.nearbyPrinterDidChange(.update(PrinterStruct(peripheral)))
        }
        
        centralManagerDelegate.updatedPeripherals = { [weak self] in
            guard let printer = (self?.centralManagerDelegate[$0].map { PrinterStruct($0) }) else {
                return
            }
            self?.nearbyPrinterDidChange(.update(printer))
        }

        centralManagerDelegate.removedPeripherals = { [weak self] in
            self?.nearbyPrinterDidChange(.remove($0))
        }
        
        ///
        centralManagerDelegate.centralManagerDidUpdateState = { [weak self] in
            guard let `self` = self else {
                return
            }

            guard $0.state == .poweredOn else {
                return
            }
            if let error = self.startScan() {
                self.errorReport?(error)
            }
        }

        centralManagerDelegate.centralManagerDidDisConnectPeripheralWithError = { [weak self] _, peripheral, _ in

            guard let `self` = self else {
                return
            }

            self.nearbyPrinterDidChange(.update(PrinterStruct(peripheral)))
            self.peripheralDelegate.disconnect(peripheral)
        }

        centralManagerDelegate.centralManagerDidFailToConnectPeripheralWithError = { [weak self] _, _, err in

            guard let `self` = self else {
                return
            }

            if let error = err {
                debugPrint(error.localizedDescription)
            }

            self.errorReport?(.connectFailed)
        }
        
        centralManagerDelegate.centralManagerDidDiscoverPeripheralWithAdvertisementDataAndRSSI = { [weak self] _ ,peripheral, name, rssi in

            guard let `self` = self else {
                           return
                       }
            self.nearbyPrinterDidChange(.add(PrinterStruct(peripheral)))
            
        }
        
    }

    private func nearbyPrinterDidChange(_ change: NearbyPrinterChange) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.nearbyPrinterDidChange(change)
        }
    }

    private func deliverError(_ error: PError) {
        DispatchQueue.main.async { [weak self] in
            self?.errorReport?(error)
        }
    }

    public func startScan() -> PError? {

            guard !centralManager.isScanning else {
                return nil
            }

            guard centralManager.state == .poweredOn else {
                return .deviceNotReady
            }

    //        let serviceUUIDs = PrinterManager.specifiedServices.map { CBUUID(string: $0) }
            centralManager.scanForPeripherals(withServices: nil)
    //        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey:true])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.centralManager.stopScan()
            }

            return nil
        }

    public func stopScan() {

        centralManager.stopScan()
    }

    public func connect(_ printer: PrinterStruct) {

        guard let per = centralManagerDelegate[printer.identifier] else {

            return
        }

        var p = printer
        p.state = .connecting
        nearbyPrinterDidChange(.update(p))

        if let t = connectTimer {
            t.invalidate()
        }
//        connectTimer = Timer(timeInterval: 15, target: self, selector: #selector(connectTimeout(_:)), userInfo: p.identifier, repeats: false)
//        RunLoop.main.add(connectTimer!, forMode: .defaultRunLoopMode)
//
//        centralManager.connect(per, options: [CBConnectPeripheralOptionNotifyOnDisconnectionKey: true])
        self.centralManager.connect(per, options:  [CBConnectPeripheralOptionNotifyOnDisconnectionKey: true])

    }

    @objc private func connectTimeout(_ timer: Timer) {

        guard let uuid = (timer.userInfo as? UUID), let p = centralManagerDelegate[uuid] else {
            return
        }

        var printer = PrinterStruct(p)
        printer.state = .disconnected
        nearbyPrinterDidChange(.update(printer))

        centralManager.cancelPeripheralConnection(p)

        connectTimer?.invalidate()
        connectTimer = nil
    }

    public func disconnect(_ printer: PrinterStruct) {

        guard let per = centralManagerDelegate[printer.identifier] else {
            return
        }

        var p = printer
        p.state = .disconnecting
        nearbyPrinterDidChange(.update(p))

        centralManager.cancelPeripheralConnection(per)
    }

    public func disconnectAllPrinter() {

        let serviceUUIDs = PrinterManager.specifiedServices.map { CBUUID(string: $0) }
        
        centralManager.retrieveConnectedPeripherals(withServices: serviceUUIDs).forEach {
            centralManager.cancelPeripheralConnection($0)
        }
    }

    public var canPrint: Bool {
        if peripheralDelegate.writablecharacteristic == nil || peripheralDelegate.writablePeripheral == nil {
            return false
        } else {
            return true
        }
    }

    public func print(_ content: Printable, completeBlock: ((PError?) -> ())? = nil) {

        guard let p = peripheralDelegate.writablePeripheral, let c = peripheralDelegate.writablecharacteristic else {

            completeBlock?(.deviceNotReady)
            return
        }

        for data in content.datas {

            p.writeValue(data, for: c, type: .withoutResponse)
        }

        completeBlock?(nil)
    }
    public func printForImage(_ content: ESCPOSCommandsCreator, encoding: String.Encoding = String.GBEncoding.GB_18030_200033, completeBlock: ((PError?) -> ())? = nil) {

           guard let p = peripheralDelegate.writablePeripheral, let c = peripheralDelegate.writablecharacteristic else {

               completeBlock?(.deviceNotReady)
               return
           }

           for data in content.dataForImage(using: encoding) {

               p.writeValue(data, for: c, type: .withoutResponse)
           }

           completeBlock?(nil)
       }
    // Open cash drawer with normal Bluetooth printer
    public func openCashDrawer(completeBlock: ((PError?) -> ())? = nil) {
        
        guard let p = peripheralDelegate.writablePeripheral, let c = peripheralDelegate.writablecharacteristic else {
            
            completeBlock?(.deviceNotReady)
            return
        }
        
        let cashDrawerOpenCmd: [Int8] = [0x1B, 0x70, 0x0, 0x20, 0x20]
        // self.builder?.addCommand(NSData(bytes: cashDrawerOpenCmd, length: 5))
        //  receipt.append(Data(bytes: cashDrawerOpenCmd, length: 5) as Data)
        p.writeValue(Data(bytes: cashDrawerOpenCmd, count: 5), for: c, type: .withoutResponse)
        
        completeBlock?(nil)
    }

    deinit {
        connectTimer?.invalidate()
        connectTimer = nil

        disconnectAllPrinter()
    }
}

public protocol Printable {

    var datas: [Data] { get }
}
