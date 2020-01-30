//
//  UIViewExtension.swift
//  BingImageSearch
//
//  Created by Nadeem Akram on 30/01/20.
//  Copyright © 2020 Nadeem Akram. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIView {
    
    func showLoader(show: Bool) {
        if show {
            MBProgressHUD.showAdded(to: self, animated: true)
        } else {
            MBProgressHUD.hide(for: self, animated: true)
        }
    }
}
