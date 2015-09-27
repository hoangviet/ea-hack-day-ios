//
//  UIAlertController+Helper.swift
//  ChungKhoan
//
//  Created by Hoang Viet on 9/27/15.
//  Copyright (c) 2015 chungkhoan. All rights reserved.
//

import Foundation


extension UIAlertController {
    class func show(target: UIViewController, title: String?, message: String, actionButton: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let cancel = UIAlertAction(title: actionButton ?? "Đóng", style: .Cancel, handler: nil)
        alertController.addAction(cancel)
        target.presentViewController(alertController, animated: true, completion: nil)
    }
}