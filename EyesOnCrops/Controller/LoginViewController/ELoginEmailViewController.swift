//
//  ELoginEmailViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/3/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

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
        }
        else{
            alertMessage(title: ALERT_TITLE, message: EMAIL_PHONE_EMPTY_ERROR)
        }
    }
    //MARK: UIButton Actions
    @IBAction func buttonForgotPasswordPressed(_ sender: Any) {
        self.performSegue(withIdentifier: PASSEORD_RECOVERY_1_SEGUE_VC, sender: nil)
    }
    @IBAction func buttonLoginPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: LOGIN_TO_HOME_SEGUE_VC, sender: nil)
    }
}
