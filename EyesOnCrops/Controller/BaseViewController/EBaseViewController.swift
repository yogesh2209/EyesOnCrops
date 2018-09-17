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
import PKHUD

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
    func setupProgressBar() {
        HUD.dimsBackground = false
        HUD.allowsInteraction = false
    }
    func showAnimatedProgressBar(title: String, subTitle: String) {
        HUD.show(.labeledProgress(title: title, subtitle: subTitle))
    }
    func hideAnimatedProgressBar() {
        HUD.hide(animated: true)
    }
    
    func showInfoAlert(title: String, message: String, animated: Bool = true) {
        // Prepare the popup
        let title = title
        let message = message
        
        // Create the dialog
        let popup = PopupDialog(title: title,
                                message: message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                gestureDismissal: true,
                                hideStatusBar: true) {
        }
        
        let buttonBack = DefaultButton(title: "Back") {
            
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonBack])
        
        // Present dialog
        self.present(popup, animated: animated, completion: nil)
    }
    
    func showExportAlert(title: String, message: String, animated: Bool = true, yesAction: @escaping (() -> Void)) {
        // Prepare the popup
        let title = title
        let message = message
        
        // Create the dialog
        let popup = PopupDialog(title: title,
                                message: message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                gestureDismissal: true,
                                hideStatusBar: true) {
        }
        
        let buttonNo = DefaultButton(title: "No") {
            
        }
        
        let buttonYes = DefaultButton(title: "Yes") {
            yesAction()
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonNo, buttonYes])
        
        // Present dialog
        self.present(popup, animated: animated, completion: nil)
    }
    
    func emptyMessageLabel(for localView: UIView, label: UILabel, hidden: Bool = true, text: String) {
        if !hidden {
            label.isHidden = false
            label.frame = CGRect(x: 0, y: localView.frame.size.height/2 - 30, width: localView.frame.size.width, height: 60)
            label.text = text
            label.textAlignment = .center
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.textColor = UIColor.black
            label.font = UIFont(name: "Palatino-Italic", size: 24.0)
            localView.isHidden = false
            localView.addSubview(label)
            localView.sendSubview(toBack: label)
        }
        else{
            label.isHidden = true
        }
    }
    
    //getting level stored from user defaults
    func getStoredLevelFromUserDefaults() -> String? {
        let defaults = UserDefaults.standard
        if let levelStored = defaults.object(forKey: "LEVEL") as? String {
            return levelStored
        }
        else{
            return nil
        }
    }
    
    //Storing data in NSUserDefaults
    func storeLevelInUserDefaults(level: String = "LEVEL-0") {
        let defaults = UserDefaults.standard
        defaults.set(level, forKey: "LEVEL")
    }
    
    //MAP OR GLOBE
    func storeMapTypeInDefaults(type: String = "GLOBE") {
        let defaults = UserDefaults.standard
        defaults.set(type, forKey: "MAP_TYPE")
    }
    
    func getStoredMapTypeFromUserDefaults() -> String? {
        let defaults = UserDefaults.standard
        if let mapTypeStored = defaults.object(forKey: "MAP_TYPE") as? String {
            return mapTypeStored
        }
        else{
            return nil
        }
    }
    
    // MARK: Notifications
    func postNotification(notification: Notification.Name) {
        NotificationCenter.default.post(name: notification, object: self, userInfo: nil)
    }
}
