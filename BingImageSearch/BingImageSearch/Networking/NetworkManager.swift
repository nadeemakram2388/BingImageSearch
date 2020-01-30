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
        return AFHTTPSessionManager(baseURL: URL(string: AppConstants.Service.baseURL))
    }()
    
    class func getUrl(apiEndPoint: ApiEndPoints) -> String {
       // return AppConstants.Service.baseURL + apiEndPoint.path
        return apiEndPoint.path
    }

    //MARK:- Post Request
    
    func getRequest(_ endpoint: ApiEndPoints ,completionHandler: @escaping ([String: Any]?, Error?) -> Void) {
        
            manager.requestSerializer = AFJSONRequestSerializer()
            manager.requestSerializer.setValue(AppConstants.Service.apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")

            manager.responseSerializer = AFJSONResponseSerializer()
            manager.responseSerializer.acceptableContentTypes = NSSet(array: ["application/json"]) as? Set<String>

            manager.get(NetworkManager.getUrl(apiEndPoint: endpoint), parameters: nil, progress: { (progress) in
                
            }, success: { (task, responseObject) in

                print("Success")
                if let response = task.response as? HTTPURLResponse {
                    print(response.statusCode)
                    
                }
                
                if let data = responseObject as? [String: Any] {
                    completionHandler(data, nil)
                }

            }) { (task, error) in
                print("Error")
                completionHandler(nil, error)
            }
    }
}
