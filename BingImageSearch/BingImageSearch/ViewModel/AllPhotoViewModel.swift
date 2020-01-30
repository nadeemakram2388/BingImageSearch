//
//  AllPhotoViewModel.swift
//  BingImageSearch
//
//  Created by Nadeem Akram on 30/01/20.
//  Copyright © 2020 Nadeem Akram. All rights reserved.
//

import UIKit
import Mantle

class AllPhotoViewModel {
    
    let httpClient: NetworkManager
    var pageNumber: Int = 0
    let loadMoreBeforeLastIndexDiff = 4
    var isMoreDataAvailable = true

    public private(set) var items: [Photo] = [Photo]()

    var numberOfSections: Int {
        return 1
    }

    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    var reloadTable: Bool = false {
        didSet {
            self.reloadTableViewClosure?()
        }
    }

    var reloadTableViewClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var showAlertClosure: (()->())?

    init(client: NetworkManager? = nil) {
        self.httpClient = client ?? NetworkManager.shared
        self.getPhotos()
    }

    private func processFetchedPhotos(photos: [Photo]) {
        items.append(contentsOf: photos)
    }

    func reset() {
        self.pageNumber = 1
        self.isLoading = false
        self.isMoreDataAvailable = true
        self.getPhotos()
    }

    func loadMoreFor(_ indexPath: IndexPath) {
        if indexPath.item == self.items.count - loadMoreBeforeLastIndexDiff, self.isMoreDataAvailable == true {
            self.getPhotos()
        }
    }
}

extension AllPhotoViewModel {
    
    func getPhotos() {

        self.isLoading = true
        httpClient.getRequest(.getImages(searchString: "iPad", pageNumber: self.pageNumber)) { [weak self] (data, error) in
            self?.isLoading = false
            
            guard let self = self, let json = data else {
                return
            }
            
            if let photoJson = json["value"] as? [[String : Any]] {
                if self.pageNumber ==  0 {
                    self.items.removeAll()
                }
                self.pageNumber = self.pageNumber + 1
                //var photos = [Photo]()
                do {
                    if let models = try? MTLJSONAdapter.models(of: Photo.self, fromJSONArray: photoJson) as? [Photo], let safeModels = models {
                        self.processFetchedPhotos(photos: safeModels)
                    }
                } catch {
                    self.alertMessage = AppText.SomthingWentWrong.localized
                }
                self.reloadTable = true
            } else {
                self.isMoreDataAvailable = false
            }
        }
    }
}
