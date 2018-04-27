//
//  EPasswordRecoveryStepThreeViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 1/12/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit
import Alamofire
import PopupDialog

class EPasswordRecoveryStepThreeViewController: EBaseViewController {
    
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBOutlet weak var viewPassword: ECustomView!
    @IBOutlet weak var textFieldConfirmPassword: ECustomTextField!
    @IBOutlet weak var textFieldPassword: ECustomTextField!
    @IBOutlet weak var viewConfirmPassword: ECustomView!
    
    var getUserEmail: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupFirebaseAnalytics(title: "EPasswordRecoveryStepThreeViewController")
    }
    //MARK: Private Methods
    func getPassword() -> String {
        if let password = self.textFieldPassword.text {
            return password
        }
        else {
            return ""
        }
    }
    func getConfirmPassword() -> String {
        if let confirmPassword = self.textFieldConfirmPassword.text {
            return confirmPassword
        }
        else {
            return ""
        }
    }
    func isPasswordValid() -> Bool {
        if getPassword() == getConfirmPassword() && getPassword().count != 0 && getConfirmPassword().count != 0 { return true }
        return false
    }
    func doneButtonAction() {
        if getPassword().count == 0 || getConfirmPassword().count == 0 {
            self.alertMessage(title: ALERT_TITLE, message: EMPTY_PASSWORD_ERROR)
            return
        }
        
        if isPasswordValid() {
            if getPassword().count <= 6 {
                self.alertMessage(title: ALERT_TITLE, message: INVALID_PASSWORD_ERROR)
            }
            else{
                //service calling here and update password for this user
                updatePasswordServiceCall()
            }
        }
        else{
            self.alertMessage(title: ALERT_TITLE, message: PSWD_CONFIRM_PSWD_NOT_MATCHED_ERROR)
        }
    }
    //MARK: UIButton Actions
    @IBAction func buttonDonePressed(_ sender: Any) {
        doneButtonAction()
    }
    
    //MARK: Service Calling here
    func updatePasswordServiceCall() {
        
        let param: Dictionary<String, Any> =
            [
                "user_email"        : getUserEmail                 as Any,
                "password"          : getPassword()                as Any,
                "action_for"         : ACTION_FOR_UPDATE_PASSWORD  as Any
                
                ] as Dictionary<String, Any>
        
        self.showAnimatedProgressBar(title: "Wait..", subTitle: "Fetching info")
        let urL = MAIN_URL + POST_CREDENTIALS
        Alamofire.request(urL, method: .get, parameters: param).responseJSON{ response in
            
            print(param)
            print(response)
            switch response.result {
            case .success:
                 self.hideAnimatedProgressBar()
                if let jsonResponse = response.result.value as? NSDictionary {
                    if let status = jsonResponse["messageResponse"] {
                        if status as? String == "1" {
                            self.showStandardDialog(title: "Password updated", message: "Please login with your new credentials")
                        }
                        else{
                            self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
                        }
                    }
                    else{
                       self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
                    }
                }
               
            case .failure(_ ):
                self.hideAnimatedProgressBar()
                self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
            }
        }
    }
    func showStandardDialog(title: String, message: String) {
        // Create the dialog
        let popup = PopupDialog(title: title,
                                message: message,
                                buttonAlignment: .horizontal,
                                transitionStyle: .zoomIn,
                                gestureDismissal: true,
                                hideStatusBar: true) {
        }
        
        // Create OK button
        let buttonOK = DefaultButton(title: "OK") {
           self.navigationController?.popToRootViewController(animated: true)
        }
        // Add buttons to dialog
        popup.addButtons([buttonOK])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
    }
}
