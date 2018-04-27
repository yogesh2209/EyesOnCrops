//
//  ERegisterPasswordSetupViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 4/24/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit

class ERegisterPasswordSetupViewController: EBaseViewController {
    
    @IBOutlet weak var textFieldPassword: ECustomTextField!
    @IBOutlet weak var viewConfirmPassword: ECustomView!
    @IBOutlet weak var textFieldConfirmPassword: ECustomTextField!
    @IBOutlet weak var viewPassword: ECustomView!
    @IBOutlet weak var buttonNext: UIButton!
    
    //Get all the parameters from the previous screen
    var getFirstName: String!
    var getMiddleName: String!
    var getLastName: String!
    var getDOB: String!
    var getEmail: String!
    var getPhone: String!
    var getLatitude: String!
    var getLongitude: String!
    var locationString: String!
    var imageString: String!
    var socialLoginId: String!
    var password: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UIButton Actions
    @IBAction func buttonNextPressed(_ sender: Any) {
        nextButtonAction()
    }
    
    //MARK: Private Methods
    func customiseUI() {
        self.navigationController?.isNavigationBarHidden = false
    }
    func getPassword() -> String {
        if let tempPassword = self.textFieldPassword.text {
            return tempPassword
        }
        else {
            return ""
        }
    }
    func getConfirmPassword() -> String {
        if let tempConfirmPswd = self.textFieldConfirmPassword.text {
            return tempConfirmPswd
        }
        else {
            return ""
        }
    }
    func nextButtonAction() {
        if getPassword().count == 0 || getConfirmPassword().count == 0 {
            self.alertMessage(title: ALERT_TITLE, message: EMPTY_PASSWORD_ERROR)
            return
        }
        
        if isPasswordValid() {
            if getPassword().count <= 6 {
                 self.alertMessage(title: ALERT_TITLE, message: INVALID_PASSWORD_ERROR)
            }
            else{
                //take him to next screen now
                self.performSegue(withIdentifier: REGISTER_PSWD_SETUP_TO_4_SEGUE_VC, sender: nil)
            }
        }
        else{
             self.alertMessage(title: ALERT_TITLE, message: PSWD_CONFIRM_PSWD_NOT_MATCHED_ERROR)
        }
    }
    
    func isPasswordValid() -> Bool {
        if getPassword() == getConfirmPassword() && getPassword().count != 0 && getConfirmPassword().count != 0 { return true }
        return false
    }
    
    //MARK: UINavigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == REGISTER_PSWD_SETUP_TO_4_SEGUE_VC) {
            // pass data to next view
            let secondVC = segue.destination as! ERegisterFourthViewController
            secondVC.getFirstName = getFirstName
            secondVC.getLastName = getLastName
            secondVC.getDOB = getDOB
            secondVC.getEmail = getEmail
            secondVC.getPhone = getPhone
            secondVC.getLatitude = getLatitude
            secondVC.getLongitude = getLongitude
            secondVC.locationString = locationString
            secondVC.socialLoginId = "0"
            secondVC.loginType = "email"
            secondVC.imageString = ""
            secondVC.password = getPassword()
            if getMiddleName.count == 0 {
                secondVC.getMiddleName = ""
            }
            else{
                secondVC.getMiddleName = getMiddleName
            }
        }
    }
}
