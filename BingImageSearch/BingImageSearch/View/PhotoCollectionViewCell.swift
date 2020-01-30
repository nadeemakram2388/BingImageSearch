//
//  PhotoCollectionViewCell.swift
//  BingImageSearch
//
//  Created by Nadeem Akram on 30/01/20.
//  Copyright © 2020 Nadeem Akram. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        imageView.cancelImageDownloadTask()
        imageView.image = nil
    }
    
    func populateWithPhoto(_ photo: PhotoViewable) {
        photo.loadImageWithCompletionHandler { [weak photo] (image, error) in
            if let image = image {
                if let photo = photo as? Photo {
                    photo.image = image
                }
                self.imageView.image = image
            }
        }
    }
}
