//
//  TimerApplication.swift
//  HieCOR
//
//  Created by hiecor on 03/11/20.
//  Copyright © 2020 HyperMacMini. All rights reserved.
//

import Foundation
import UIKit

class TimerApplication: UIApplication {

    // the timeout in seconds, after which should perform custom actions
    // such as disconnecting the user
    private var timeoutInSeconds: TimeInterval {
        // 2 minutes
        return TimeInterval(DataManager.screenSaverTimeInSec)
        // return TimeInterval(10)
    }
 
    private var idleTimer: Timer?

    // resent the timer because there was user interaction
    func resetIdleTimer() {
        DataManager.isScreenSaverOnThenKeyboardHide = false
       // Indicator.sharedInstance.hideIndicatorForScreenSeverLoader()
        ScreenSaver.sharedInstance.hideScreenSaver()
       
            if let idleTimer = idleTimer {
                idleTimer.invalidate()
            }
        if DataManager.isScreenSaverOn && DataManager.isUserLogin {
            idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds,
                                             target: self,
                                             selector: #selector(TimerApplication.timeHasExceeded),
                                             userInfo: nil,
                                             repeats: true
            )
            
        }
        
    }

    // if the timer reaches the limit as defined in timeoutInSeconds, post this notification
    @objc private func timeHasExceeded() {
        if DataManager.isScreenSaverOn  && DataManager.isUserLogin && !Indicator.isLoaderScreenSaver
        {
            DataManager.isScreenSaverOnThenKeyboardHide = true
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            NotificationCenter.default.post(name: .appTimeout,
                                            object: nil
            )
        }else {
            resetIdleTimer()
        }
        
    }

    override func sendEvent(_ event: UIEvent) {

        super.sendEvent(event)

        if idleTimer != nil {
            self.resetIdleTimer()
        }

        if let touches = event.allTouches {
            for touch in touches where touch.phase == UITouch.Phase.began {
                self.resetIdleTimer()
            }
        }
    }
}
extension Notification.Name {

    static let appTimeout = Notification.Name("appTimeout")

}
