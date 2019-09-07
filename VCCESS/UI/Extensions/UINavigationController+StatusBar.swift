//
//  UINavigationController+StatusBar.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/6/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController
{
    open override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
