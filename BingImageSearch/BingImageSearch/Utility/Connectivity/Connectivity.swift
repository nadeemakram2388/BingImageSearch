//
//  Connectivity.swift
//  BingImageSearch
//
//  Created by Nadeem Akram on 30/01/20.
//  Copyright © 2020 Nadeem Akram. All rights reserved.
//

import Foundation
import AFNetworking

class Connectivity {
    
    class func isConnectedToInternet() -> Bool {
        return AFNetworkReachabilityManager().isReachable
    }
}
