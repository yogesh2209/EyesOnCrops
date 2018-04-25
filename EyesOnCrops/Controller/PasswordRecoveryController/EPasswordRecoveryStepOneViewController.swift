//
//  EPasswordRecoveryStepOneViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 1/11/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit

class EPasswordRecoveryStepOneViewController: EBaseViewController {

    @IBOutlet weak var buttonNext: UIBarButtonItem!
    @IBOutlet weak var textFieldEmailPhone: ECustomTextField!
    @IBOutlet weak var viewEmailPhone: ECustomView!
    
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
        setupFirebaseAnalytics(title: "EPasswordRecoveryStepOneViewController")
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
    func nextButtonAction() {
        if getEmailOrPhone().count != 0 {
            //send him to next screen
            self.performSegue(withIdentifier: PSWD_RECOVERY_EMAIL_TO_DOB_SEGUE_VC, sender: nil)
        }
        else{
            alertMessage(title: "Error", message: "Email/Phone cannot be empty!")
        }
    }
    //MARK: UIButton Actions
    @IBAction func buttonNextPressed(_ sender: Any) {
        nextButtonAction()
    }
}
