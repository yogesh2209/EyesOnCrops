//
//  NavigationControllerExtension.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 5/27/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func backToViewController(vc: Any) {
        // iterate to find the type of vc
        for element in viewControllers as Array {
            if "\(type(of: element)).Type" == "\(type(of: vc))" {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}
