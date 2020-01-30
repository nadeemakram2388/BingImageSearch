//
//  NetworkEndPoint.swift
//  BingImageSearch
//
//  Created by Nadeem Akram on 30/01/20.
//  Copyright © 2020 Nadeem Akram. All rights reserved.
//

import Foundation

enum ApiEndPoints {
    
    case getImages(searchString: String, pageNumber: Int)
    
    var baseURL: URL {
        guard let url = URL(string: AppConstants.Service.baseURL) else {
            fatalError("BaseURL could not be configured.")
        }
        return url
    }
    
    //Returns EndPoint for Contact APIs
    var path: String {
        switch self {
        case .getImages(let searchString, let pageNumber):
            return "/bing/v7.0/images/search?q=\(searchString)&count=50&offset=\(pageNumber)&mkt=en-us&safeSearch=Moderate"
        }
    }

}
