//
//  EPasswordRecoveryStepThreeViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 1/12/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit

class EPasswordRecoveryStepThreeViewController: EBaseViewController {
    
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBOutlet weak var viewPassword: ECustomView!
    @IBOutlet weak var textFieldConfirmPassword: ECustomTextField!
    @IBOutlet weak var textFieldPassword: ECustomTextField!
    @IBOutlet weak var viewConfirmPassword: ECustomView!
    
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
        if getPassword().count != 0 && getConfirmPassword().count != 0 && isPasswordSame(password: getPassword(), confirmPassword: getConfirmPassword()) == true {
            if isPasswordLenth(password: getPassword(), confirmPassword: getConfirmPassword()) == true {
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
    //MARK: UIButton Actions
    @IBAction func buttonDonePressed(_ sender: Any) {
        doneButtonAction()
    }
}
