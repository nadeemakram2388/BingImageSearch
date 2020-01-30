//
//  ViewController.swift
//  BingImageSearch
//
//  Created by Nadeem Akram on 30/01/20.
//  Copyright © 2020 Nadeem Akram. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: AllPhotoViewModel?

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action:
            #selector(ViewController.refreshData(_:)),
                                 for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()

    private func initViewModel() {
        
        viewModel = AllPhotoViewModel()
        
        viewModel?.reloadTableViewClosure = {
            self.collectionView.reloadData()
        }
        
        viewModel?.updateLoadingStatus = { [weak self] () in
            let isLoading = self?.viewModel?.isLoading ?? false
            self?.view.showLoader(show: isLoading)
            if self?.refreshControl.isRefreshing == true {
                self?.refreshControl.endRefreshing()
            }
        }
        
        viewModel?.showAlertClosure = { [weak self] in
            DispatchQueue.main.async {
                if let message = self?.viewModel?.alertMessage {
                    self?.showAlert(message)
                }
            }
        }
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initViewModel()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl

    }

    @objc func refreshData(_ sender: Any) {
        self.viewModel?.reset()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.numberOfSections ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let safeViewModel = viewModel, safeViewModel.items.count > indexPath.item {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
            cell.populateWithPhoto(safeViewModel.items[(indexPath as NSIndexPath).item])
            return cell
        }
        return PhotoCollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = collectionView.frame.size.width / 2 - 10
        return CGSize(width: dimension, height: dimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let safeViewModel = viewModel, safeViewModel.items.count > indexPath.item {
            let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
            let currentPhoto = safeViewModel.items[(indexPath as NSIndexPath).item]
            let galleryPreview = PhotosViewController(photos: safeViewModel.items, initialPhoto: currentPhoto, referenceView: cell)
            self.navigationController?.pushViewController(galleryPreview, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewModel?.loadMoreFor(indexPath)
    }
    
}

