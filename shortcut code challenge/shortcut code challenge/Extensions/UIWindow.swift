//
//  UIWindow.swift
//  shortcut code challenge
//
//  Created by Mohsen on 11/7/21.
//

import UIKit

extension UIWindow {
    static func getTopViewController() -> UIViewController? {
        if #available(iOS 13, *) {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            
            if var topController = keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                return topController
            }
        } else {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                // topController should now be your topmost view controller
                return topController
            }
        }
        return nil
    }
    
}
