//
//  EPasswordRecoveryStepOneViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 1/11/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit
import Alamofire
import PopupDialog

class EPasswordRecoveryStepOneViewController: EBaseViewController {

    @IBOutlet weak var buttonNext: UIBarButtonItem!
    @IBOutlet weak var textFieldEmailPhone: ECustomTextField!
    @IBOutlet weak var viewEmailPhone: ECustomView!
    
    var getDOB = String()
    
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
            fetchUserDataServiceCall()
        }
        else{
            alertMessage(title: "Error", message: "Email/Phone cannot be empty!")
        }
    }
    //MARK: UIButton Actions
    @IBAction func buttonNextPressed(_ sender: Any) {
        nextButtonAction()
    }
    
    //MARK: Service Calling here
    func fetchUserDataServiceCall() {
        
        let param: Dictionary<String, Any> =
            [
                "user_email"        : getEmailOrPhone()                  as Any,
                "action_for"         : ACTION_PSWD_RECOVERY_USER_DATA     as Any
                
                ] as Dictionary<String, Any>
        
        self.showAnimatedProgressBar(title: "Wait..", subTitle: "Fetching info")
        let urL = MAIN_URL + POST_CREDENTIALS
        Alamofire.request(urL, method: .get, parameters: param).responseJSON{ response in
        
            switch response.result {
            case .success:
                self.hideAnimatedProgressBar()
                if let jsonResponse = response.result.value as? NSDictionary {
                    if let _ = jsonResponse["messageResponse"] {
                        self.alertMessage(title: ALERT_TITLE, message: INVALID_CREDENTIALS_LOGIN)
                    }
                    else{
                        if let result = jsonResponse["responseArray"]! as? NSArray {
                            if let finalResult = result[0] as? [String : String] {
                                if let dob = finalResult["dob"] {
                                    self.getDOB = dob
                                }
                              self.performSegue(withIdentifier: PSWD_RECOVERY_EMAIL_TO_DOB_SEGUE_VC, sender: nil)
                            }
                            else{
                                self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
                            }
                        }
                    }
                }
            case .failure(_ ):
                self.hideAnimatedProgressBar()
                self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
            }
        }
    }
    //MARK: UINavigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == PSWD_RECOVERY_EMAIL_TO_DOB_SEGUE_VC) {
            // pass data to next view
            let secondVC = segue.destination as! EPasswordRecoveryStepTwoViewController
            secondVC.dob = getDOB
            secondVC.getUserEmail = getEmailOrPhone()
        }
    }
}
