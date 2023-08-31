//
//  NetworkConnectivity.swift
//  HieCOR
//
//  Created by HyperMacMini on 05/02/18.
//  Copyright © 2018 HyperMacMini. All rights reserved.
//

import Foundation
import Alamofire

class NetworkConnectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
