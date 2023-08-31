//
//  Printable.swift
//  Printer
//
//  Created by gix on 2019/7/29.
//  Copyright © 2019 Kevin. All rights reserved.
//

import Foundation

public protocol ESCPOSCommandsCreator {
    
    func dataForImage(using encoding: String.Encoding) -> [Data]
}

extension Ticket: ESCPOSCommandsCreator { }
