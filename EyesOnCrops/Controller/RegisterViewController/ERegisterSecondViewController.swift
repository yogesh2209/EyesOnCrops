//
//  ERegisterSecondViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/3/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

class ERegisterSecondViewController: EBaseViewController, UITextFieldDelegate {

    @IBOutlet weak var viewEmail: ECustomView!
    @IBOutlet weak var viewPhone: ECustomView!
    @IBOutlet weak var textFieldEmail: ECustomTextField!
    @IBOutlet weak var textFieldPhone: ECustomTextField!
    @IBOutlet weak var buttonNext: UIButton!
    
    //Get all the parameters from the previous screen
    var getFirstName: String!
    var getMiddleName: String!
    var getLastName: String!
    var getDOB: String!

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
        customiseUI()
        setupFirebaseAnalytics(title: "ERegisterSecondViewController")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: UITextfield Delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.textFieldEmail {
            textFieldPhone.becomeFirstResponder()
        }
        else if textField == self.textFieldPhone {
             textFieldPhone.resignFirstResponder()
        }
    }
    //MARK: Private Methods
    func customiseUI() {
        self.navigationController?.isNavigationBarHidden = false
    }
    func getEmail() -> String {
        if let tempEmail = self.textFieldEmail.text {
            return tempEmail
        }
        else {
            return ""
        }
    }
    func getPhone() -> String {
        if let tempPhone = self.textFieldPhone.text {
            return tempPhone
        }
        else {
            return ""
        }
    }
    func nextButtonAction() {
        if getEmail().count != 0 && getPhone().count != 0 && getFirstName.count != 0 && getLastName.count != 0 && getDOB.count != 0 {
            if isValidEmail(testStr: getEmail()) == true {
                if isValidPhone(value: getPhone()) == true {
                    //Take him to next screen and pass data to next screen
                    self.performSegue(withIdentifier: REGISTER_2_TO_3_SEGUE_VC, sender: nil)
                }
                else {
                    self.alertMessage(title: "ALERT", message: "Please enter a valid phone!")
                }
            }
            else {
                 self.alertMessage(title: "ALERT", message: "Please enter a valid email!")
            }
        }
        else{
            self.alertMessage(title: "ALERT", message: "Email and Phone cannot be empty!")
        }
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func isValidPhone(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    //MARK: UIButton Actions
    @IBAction func buttonNextPressed(_ sender: UIButton) {
        nextButtonAction()
    }
    //MARK: UINavigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == REGISTER_2_TO_3_SEGUE_VC) {
            // pass data to next view
            let secondVC = segue.destination as! ERegisterThreeViewController
            secondVC.getFirstName = getFirstName
            secondVC.getLastName = getLastName
            secondVC.getDOB = getDOB
            secondVC.getEmail = getEmail()
             secondVC.getPhone = getPhone()
            if getMiddleName.count == 0 {
                secondVC.getMiddleName = ""
            }
            else{
                secondVC.getMiddleName = getMiddleName
            }
        }
    }
}
