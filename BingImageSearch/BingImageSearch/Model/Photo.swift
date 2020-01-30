//
//  Photo.swift
//  BingImageSearch
//
//  Created by Nadeem Akram on 30/01/20.
//  Copyright © 2020 Nadeem Akram. All rights reserved.
//

import Foundation
import Mantle

@objc public protocol PhotoViewable: class {
    var image: UIImage? { get }    
    func loadImageWithCompletionHandler(_ completion: @escaping (_ image: UIImage?, _ error: Error?) -> ())
}

class Photo: MTLModel, MTLJSONSerializing, PhotoViewable {

    @objc open var image: UIImage?

    @objc private(set) var thumbnailUrl: String?
    @objc private(set) var contentUrl: String?
    
    static func jsonKeyPathsByPropertyKey() -> [AnyHashable : Any]! {
        return ["thumbnailUrl": "thumbnailUrl",
                "contentUrl": "contentUrl"]
    }
    
    @objc open func loadImageWithCompletionHandler(_ completion: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        if let image = image {
            completion(image, nil)
            return
        }
        loadImageWithURL(contentUrl, completion: completion)
    }
    
    open func loadImageWithURL(_ url: String?, completion: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        if let imageURL = url, let urlActual = URL(string: imageURL) {
            session.dataTask(with: urlActual, completionHandler: { (response, data, error) in
                DispatchQueue.main.async(execute: { () -> Void in
                    if error != nil {
                        completion(nil, error)
                    } else if let response = response, let image = UIImage(data: response) {
                        completion(image, nil)
                    } else {
                        completion(nil, NSError(domain: "PhotoDomain", code: -1, userInfo: [ NSLocalizedDescriptionKey: "Couldn't load image"]))
                    }
                    session.finishTasksAndInvalidate()
                })
            }).resume()
        } else {
            completion(nil, NSError(domain: "PhotoDomain", code: -2, userInfo: [ NSLocalizedDescriptionKey: "Image URL not found."]))
        }
    }

}
