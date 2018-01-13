//
//  EBaseViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/18/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit
import Firebase
import PopupDialog
import SideMenu

class EBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Private Methods
    func setupMenu() {
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }
    func setupFirebaseAnalytics(title : String) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id-\(title)" as NSObject,
            AnalyticsParameterItemName: title as NSObject,
            AnalyticsParameterContentType: "cont" as NSObject
            ])
    }
    func alertMessage(title : String, message : String) {
        // Create the dialog
        let popup = PopupDialog(title: title, message: message)
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
}
