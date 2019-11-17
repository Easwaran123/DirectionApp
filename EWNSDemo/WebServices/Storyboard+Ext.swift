//
//  Storyboard+Ext.swift
//  PSIApp
//
//  Created by Swarup on 25/6/17.
//  Copyright © 2017 swarup. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func getViewController<T>(storyboardName: String, identifier: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}
