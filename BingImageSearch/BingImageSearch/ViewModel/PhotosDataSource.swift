//
//  PhotosDataSource.swift
//  BingImageSearch
//
//  Created by Nadeem Akram on 30/01/20.
//  Copyright © 2020 Nadeem Akram. All rights reserved.
//

import Foundation
public struct PhotosDataSource {
    public private(set) var photos: [PhotoViewable] = []
    
    public var numberOfPhotos: Int {
        return photos.count
    }
    
    public func photoAtIndex(_ index: Int) -> PhotoViewable? {
        if (index < photos.count && index >= 0) {
            return photos[index];
        }
        return nil
    }
    
    public func indexOfPhoto(_ photo: PhotoViewable) -> Int? {
        return photos.firstIndex(where: { $0 === photo})
    }
    
    public func contaPhoto(_ photo: PhotoViewable) -> Bool {
        return indexOfPhoto(photo) != nil
    }
    
    public mutating func deletePhoto(_ photo: PhotoViewable){
        if let index = self.indexOfPhoto(photo){
            photos.remove(at: index)
        }
    }
    
    public subscript(index: Int) -> PhotoViewable? {
        get {
            return photoAtIndex(index)
        }
    }
}
