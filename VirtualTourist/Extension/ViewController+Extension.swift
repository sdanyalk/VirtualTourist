//
//  ViewController+Extension.swift
//  VirtualTourist
//
//  Created by SDK on 5/15/19.
//  Copyright © 2019 SDK. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showError(withTitle: String = "Error", withMessage: String, action: (() -> Void)? = nil) {
        performUIUpdatesOnMain {
            let ac = UIAlertController(title: withTitle, message: withMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alertAction) in
                action?()
            }))
            self.present(ac, animated: true)
        }
    }
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
}
