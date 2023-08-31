//
//  Main.swift
//  ScreenSaver
//
//  Created by hiecor on 03/11/20.
//  Copyright © 2020 Hiecor. All rights reserved.
//

import Foundation
import UIKit


UIApplicationMain(
CommandLine.argc,
UnsafeMutableRawPointer(CommandLine.unsafeArgv)
    .bindMemory(
        to: UnsafeMutablePointer<Int8>.self,
        capacity: Int(CommandLine.argc)),
NSStringFromClass(TimerApplication.self),
NSStringFromClass(AppDelegate.self)
)
