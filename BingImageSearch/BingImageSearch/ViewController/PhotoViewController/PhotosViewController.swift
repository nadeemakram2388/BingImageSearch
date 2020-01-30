//
//  PhotosViewController.swift
//  BingImageSearch
//
//  Created by Nadeem Akram on 30/01/20.
//  Copyright © 2020 Nadeem Akram. All rights reserved.
//

import UIKit

public typealias PhotosViewControllerNavigateToPhotoHandler = (_ photo: PhotoViewable) -> ()
public typealias PhotosViewControllerLongPressHandler = (_ photo: PhotoViewable, _ gestureRecognizer: UILongPressGestureRecognizer) -> (Bool)

class PhotosViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var navigateToPhotoHandler: PhotosViewControllerNavigateToPhotoHandler?
    var longPressGestureHandler: PhotosViewControllerLongPressHandler?
    var shouldConfirmDeletion: Bool = false
    
    var currentPhotoViewController: PhotoViewController? {
        return pageViewController.viewControllers?.first as? PhotoViewController
    }
    var currentPhoto: PhotoViewable? {
        return currentPhotoViewController?.photo
    }
    
    var maximumZoomScale: CGFloat = 1.0 {
        didSet {
            self.currentPhotoViewController?.scalingImageView.maximumZoomScale = maximumZoomScale
        }
    }
    
    // MARK: - Private
    public private(set) var pageViewController: UIPageViewController!
    public private(set) var dataSource: PhotosDataSource
    private var shouldHandleLongPressGesture = true//false
    
    private func newCurrentPhotoAfterDeletion(currentPhotoIndex: Int) -> PhotoViewable? {
        let previousPhotoIndex = currentPhotoIndex - 1
        if let newCurrentPhoto = self.dataSource.photoAtIndex(currentPhotoIndex) {
            return newCurrentPhoto
        }else if let previousPhoto = self.dataSource.photoAtIndex(previousPhotoIndex) {
            return previousPhoto
        }
        return nil
    }
    
    private func orientationMaskSupportsOrientation(mask: UIInterfaceOrientationMask, orientation: UIInterfaceOrientation) -> Bool {
        return (mask.rawValue & (1 << orientation.rawValue)) != 0
    }
    
    // MARK: - Initialization
    
    deinit {
        pageViewController.delegate = nil
        pageViewController.dataSource = nil
    }
    
    required public init?(coder aDecoder: NSCoder) {
        dataSource = PhotosDataSource(photos: [])
        super.init(nibName: nil, bundle: nil)
        initialSetupWithInitialPhoto(nil)
    }
    
    public override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        dataSource = PhotosDataSource(photos: [])
        super.init(nibName: nil, bundle: nil)
        initialSetupWithInitialPhoto(nil)
    }

    public init(photos: [PhotoViewable], initialPhoto: PhotoViewable? = nil, referenceView: UIView? = nil) {
        dataSource = PhotosDataSource(photos: photos)
        super.init(nibName: nil, bundle: nil)
        initialSetupWithInitialPhoto(initialPhoto)
    }
    
    private func initialSetupWithInitialPhoto(_ initialPhoto: PhotoViewable? = nil) {
        //overlayView.photosViewController = self
        setupPageViewControllerWithInitialPhoto(initialPhoto)
        modalPresentationStyle = .custom
        modalPresentationCapturesStatusBarAppearance = true
    }

    private func setupPageViewControllerWithInitialPhoto(_ initialPhoto: PhotoViewable? = nil) {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.interPageSpacing: 16.0])
        pageViewController.view.backgroundColor = UIColor.clear
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        if let photo = initialPhoto , dataSource.contaPhoto(photo) {
            changeToPhoto(photo, animated: false)
        } else if let photo = dataSource.photos.first {
            changeToPhoto(photo, animated: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.tintColor = UIColor.white
        view.backgroundColor = UIColor.black
        pageViewController.view.backgroundColor = UIColor.clear
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pageViewController.didMove(toParent: self)
    }
    
    
    // MARK: - Public
    
    //Displays the specified photo. Can be called before the view controller is displayed. Calling with a photo not contained within the data source has no effect.
    open func changeToPhoto(_ photo: PhotoViewable, animated: Bool, direction: UIPageViewController.NavigationDirection = .forward) {
        if !dataSource.contaPhoto(photo) {
            return
        }
        let photoViewController = initializePhotoViewControllerForPhoto(photo)
        pageViewController.setViewControllers([photoViewController], direction: direction, animated: animated, completion: nil)
    }

    public func initializePhotoViewControllerForPhoto(_ photo: PhotoViewable) -> PhotoViewController {
        let photoViewController = PhotoViewController(photo: photo)
        photoViewController.longPressGestureHandler = { [weak self] gesture in
            guard let weakSelf = self else {
                return
            }
            if weakSelf.shouldHandleLongPressGesture {
                guard let view = gesture.view else {
                    return
                }
                let menuController = UIMenuController.shared
                var targetRect = CGRect.zero
                targetRect.origin = gesture.location(in: view)
                menuController.setTargetRect(targetRect, in: view)
                menuController.setMenuVisible(true, animated: true)
            }
        }
        photoViewController.scalingImageView.maximumZoomScale = self.maximumZoomScale
        return photoViewController
    }
    
    // MARK: - UIResponder
    
    open override func copy(_ sender: Any?) {
        UIPasteboard.general.image = currentPhoto?.image ?? currentPhotoViewController?.scalingImageView.image
    }
    
    open override var canBecomeFirstResponder: Bool {
        return true
    }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if let _ = currentPhoto?.image ?? currentPhotoViewController?.scalingImageView.image , shouldHandleLongPressGesture && action == "copy:" {
            return true
        }
        return false
    }
    
    //PageViewController
    @objc open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let photoViewController = viewController as? PhotoViewController,
            let photoIndex = dataSource.indexOfPhoto(photoViewController.photo),
            let newPhoto = dataSource[photoIndex-1] else {
                return nil
        }
        return initializePhotoViewControllerForPhoto(newPhoto)
    }
    
    @objc open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let photoViewController = viewController as? PhotoViewController,
            let photoIndex = dataSource.indexOfPhoto(photoViewController.photo),
            let newPhoto = dataSource[photoIndex+1] else {
                return nil
        }
        return initializePhotoViewControllerForPhoto(newPhoto)
    }
    
    @objc open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentPhotoViewController = currentPhotoViewController {
                navigateToPhotoHandler?(currentPhotoViewController.photo)
            }
        }
    }
}
