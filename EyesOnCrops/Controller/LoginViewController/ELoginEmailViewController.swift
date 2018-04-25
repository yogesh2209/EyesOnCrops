//
//  ELoginEmailViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/3/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit
import Alamofire
import PopupDialog

class ELoginEmailViewController: EBaseViewController {

    @IBOutlet weak var textFieldEmailPhone: ECustomTextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var viewEmailPhone: ECustomView!
    @IBOutlet weak var textFieldPassword: ECustomTextField!
    @IBOutlet weak var viewPassword: ECustomView!
    @IBOutlet weak var buttonForgotPassword: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFirebaseAnalytics(title: "ELoginEmailViewController")
    }
    //MARK: Private Methods
    func getEmailOrPhone() -> String {
        if let emailOrPhone = self.textFieldEmailPhone.text {
            return emailOrPhone
        }
        else {
            return ""
        }
    }
    func getPassword() -> String {
        if let password = self.textFieldPassword.text {
            return password
        }
        else {
            return ""
        }
    }
    func loginButtonAction() {
        if getEmailOrPhone().count != 0 &&  getPassword().count != 0 {
            //Service hitting for login
            loginServiceCall()
        }
        else{
            alertMessage(title: ALERT_TITLE, message: EMAIL_PHONE_EMPTY_ERROR)
        }
    }
    //Storing data in NSUserDefaults
    func storeDataInUserDefaults(param : [String : Any]) {
        let defaults = UserDefaults.standard
        defaults.set(param, forKey: "LOGIN_DATA")
    }
  
    //MARK: UIButton Actions
    @IBAction func buttonForgotPasswordPressed(_ sender: Any) {
        self.performSegue(withIdentifier: PASSEORD_RECOVERY_1_SEGUE_VC, sender: nil)
    }
    @IBAction func buttonLoginPressed(_ sender: UIButton) {
        loginButtonAction()
    }
    
    //MARK: Service Calling here
    func loginServiceCall() {

        let param: Dictionary<String, Any> =
            [
                "email_phone"        : getEmailOrPhone()    as Any,
                "password"           : getPassword()        as Any,
                "action_for"         : ACTION_FOR_LOGIN     as Any
                
                ] as Dictionary<String, Any>
   
        self.showAnimatedProgressBar(title: "Wait..", subTitle: "Fetching info")
        let urL = MAIN_URL + POST_CREDENTIALS
        Alamofire.request(urL, method: .get, parameters: param).responseJSON{ response in
         
            switch response.result {
            case .success:
                if let jsonResponse = response.result.value as? NSDictionary {
                    
                    if let _ = jsonResponse["messageResponse"] {
                        self.alertMessage(title: ALERT_TITLE, message: INVALID_CREDENTIALS_LOGIN)
                    }
                    else{
                        if let result = jsonResponse["responseArray"]! as? NSArray {
                            
                            if  let finalResult = result[0] as? [String : String] {
                                self.storeDataInUserDefaults(param: finalResult)
                                //take him to home screen
                                self.performSegue(withIdentifier: LOGIN_TO_HOME_SEGUE_VC, sender: nil)
                            }
                            else{
                                self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
                            }
                        }
                    }
                }
                self.hideAnimatedProgressBar()
            case .failure(_ ):
                self.hideAnimatedProgressBar()
                self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
            }
        }
    }
}
