//
//  AppConstant.swift
//  BingImageSearch
//
//  Created by Nadeem Akram on 30/01/20.
//  Copyright © 2020 Nadeem Akram. All rights reserved.
//

import Foundation

class AppConstants {
    
}
extension AppConstants {
    struct Service {
        static let baseURL = "https://api.cognitive.microsoft.com" ///bing/v7.0/images
        static let apiKey = "ae5c59075d2b4fbcb5691d6a2b62e6dd"
        static let timeout: TimeInterval = 60.0
    }
}

enum AppText: String {
    
    case Done = "Done"
    case SomthingWentWrong = "Somthing went wrong!"
    
    // Mark- Localized Value
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
