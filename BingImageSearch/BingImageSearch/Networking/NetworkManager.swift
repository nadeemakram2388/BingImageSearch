//
//  NetworkManager.swift
//  BingImageSearch
//
//  Created by Nadeem Akram on 30/01/20.
//  Copyright © 2020 Nadeem Akram. All rights reserved.
//

import Foundation
import AFNetworking

class NetworkManager {
    
    internal static let shared: NetworkManager = {
        return NetworkManager()
    }()

    var manager: AFHTTPSessionManager = {
        return AFHTTPSessionManager()
    }()
    
    class func getUrl(apiEndPoint: ApiEndPoints) -> String? {
        return AppConstants.Service.baseURL + apiEndPoint.path
    }

    

    //MARK:- Post Request
    
    func getRequest(_ endpoint: ApiEndPoints, dataParam: NSMutableDictionary?, requestHeader: NSMutableDictionary? ,completionHandler: @escaping (NSDictionary?, NSError?) -> Void) {
        
        if Connectivity.isConnectedToInternet() {
            
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.responseSerializer = AFJSONResponseSerializer()
            manager.get(NetworkManager.getUrl(apiEndPoint: endpoint)!, parameters: nil, progress: { (progress) in
                
            }, success: { (task, responseObject) in
//                if let data = task.userInfo["data"] as? NSDictionary {
//                    print(data)
//                }

                print("Success")
                if let response = task.response as? HTTPURLResponse {
                    print(response.statusCode)
                }

            }) { (task, error) in
                print("Error")
            }
        }
    }
}

//class JSONResponseSerializer: AFJSONResponseSerializer {
//    override func responseObjectForResponse (response: URLResponse, data data: NSData, error error: AutoreleasingUnsafePointer) -> AnyObject
//    {
//        var json = super.responseObjectForResponse(response, data: data, error: error) as AnyObject
//
//        if error.memory? {
//            var errorValue = error.memory!
//            var userInfo = errorValue.userInfo as NSDictionary
//            var copy = userInfo.mutableCopy() as NSMutableDictionary
//
//            copy["data"] = json
//
//            error.memory = NSError(domain: errorValue.domain, code: errorValue.code, userInfo: copy)
//        }
//
//        return json
//    }
//}
