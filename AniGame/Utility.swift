//
//  Utility.swift
//  SampleFirebase
//
//  Created by takakura naohiro on 2017/05/18.
//  Copyright © 2017年 GeoMagnet. All rights reserved.
//

import UIKit

class Utility: NSObject {
    func showAlert(title: String, message: String, onViewController viewcontroller: UIViewController, buttonTitle button: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: button, style: .default, handler: nil)
        alert.addAction(defaultAction)
        viewcontroller.present(alert, animated: true, completion: nil)
    }
}
