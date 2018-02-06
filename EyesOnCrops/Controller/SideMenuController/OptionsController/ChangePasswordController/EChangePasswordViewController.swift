//
//  EChangePasswordViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 1/11/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit

class EChangePasswordViewController: EBaseViewController {

    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBOutlet weak var viewOldPassword: ECustomView!
    @IBOutlet weak var textFieldConfirmNewPassword: ECustomTextField!
    @IBOutlet weak var textFieldOldPassword: ECustomTextField!
    @IBOutlet weak var viewNewPassword: ECustomView!
    @IBOutlet weak var viewConfirmNewPassword: ECustomView!
    @IBOutlet weak var textFieldNewPassword: ECustomTextField!
    
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
        setupFirebaseAnalytics(title: "EChangePasswordViewController")
    }
    //MARK: UIButton Actions
    @IBAction func buttonDonePressed(_ sender: Any) {
        doneButtonAction()
    }
    //MARK: Private Methods
    func getOldPassword() -> String {
        if let password = self.textFieldOldPassword.text {
            return password
        }
        else {
            return ""
        }
    }
    func getNewPassword() -> String {
        if let password = self.textFieldNewPassword.text {
            return password
        }
        else {
            return ""
        }
    }
    func getNewConfirmPassword() -> String {
        if let confirmPassword = self.textFieldConfirmNewPassword.text {
            return confirmPassword
        }
        else {
            return ""
        }
    }
    func isPasswordSame(password: String , confirmPassword : String) -> Bool {
        if password == confirmPassword{
            return true
        }else{
            return false
        }
    }
    func isPasswordLenth(password: String , confirmPassword : String) -> Bool {
        if password.count <= 7 && confirmPassword.count <= 7{
            return true
        }else{
            return false
        }
    }
    func doneButtonAction() {
        if getOldPassword().count != 0 && getNewPassword().count != 0 && getNewConfirmPassword().count != 0 && isPasswordSame(password: getNewPassword(), confirmPassword: getNewConfirmPassword()) == true {
            if isPasswordLenth(password: getNewPassword(), confirmPassword: getNewConfirmPassword()) == true {
                //Service Calling here
            }
            else {
                alertMessage(title: "ERROR", message: "Minimum length of password must be 7!")
            }
        }
        else{
            alertMessage(title: "ERROR", message: "Password cannot be empty!")
        }
    }
}
