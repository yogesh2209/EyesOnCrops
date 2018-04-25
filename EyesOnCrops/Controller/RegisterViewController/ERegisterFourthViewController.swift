//
//  ERegisterFourthViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/3/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit
import ActiveLabel
import Alamofire
import PopupDialog

class ERegisterFourthViewController: EBaseViewController, ActiveLabelDelegate {

    @IBOutlet weak var textViewPurpose: ECustomTextView!
    @IBOutlet weak var labelTermsCondition: ActiveLabel!
    @IBOutlet weak var buttonCheckmarkTerms: UIButton!
    @IBOutlet weak var buttonDone: UIButton!
    
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
    var loginType: String!
    var imageString: String!
    var socialLoginId: String!
    var password: String!
    var isTermsConditionChecked = Bool()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseUI()
        setupTermsPrivacyLabel()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFirebaseAnalytics(title: "ERegisterFourthViewController")
    }
    //MARK: Private Methods
    func actionFor() -> String {
        if loginType == "email" { return ACTION_FOR_REGISTER }
        return ""
    }
    
    func customiseUI() {
        textViewPurpose.layer.cornerRadius = 5.0
        textViewPurpose.layer.masksToBounds = true
        textViewPurpose.layer.borderColor = UIColor.lightGray.cgColor
        textViewPurpose.layer.borderWidth = 1.0
    }
    func setupTermsPrivacyLabel() {
        labelTermsCondition.delegate = self
        labelTermsCondition.numberOfLines = 0
        labelTermsCondition.enabledTypes = [.mention, .hashtag, .url]
        labelTermsCondition.text = "I agree to @TermsOfUse and @PrivacyPolicy"
        labelTermsCondition.textColor = .black
    }
    func getPurpose() -> String {
        if let purposeString = self.textViewPurpose.text {
            return purposeString
        }
        else {
            return ""
        }
    }
    //MARK: ActiveLabel Delegate
    func didSelect(_ text: String, type: ActiveType) {
        print(text)
        print(type)
        var variableToSend = ""
        if text == "TermsOfUse" {
            //Take him to terms of use screen
            variableToSend = "TERMS"
        }
        else if text == "PrivacyPolicy" {
            //take him to privacy policy thing
            variableToSend = "PRIVACY"
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController =
            storyBoard.instantiateViewController(withIdentifier: TERMS_PRIVACY_STORYBOARD_ID) as! ETermsPrivacyConmonViewController
        nextViewController.indicatorVariable = variableToSend
        self.present(nextViewController, animated:true, completion:nil)
    }
    //MARK: UIButton Actions
    @IBAction func buttonDonePressed(_ sender: UIButton) {
        if getPurpose().count != 0 {
            if isTermsConditionChecked == true {
                 //SERVICE CALL FINALLY
                sendDataToServer()
            }
            else{
                self.alertMessage(title: ALERT_TITLE, message: DISAGREE_CONDITIONS_TERMS_USE_ERROR)
            }
        }
        else {
            self.alertMessage(title: ALERT_TITLE, message: MISSING_PURPOSE_APP_USE_ERROR)
        }
    }
    @IBAction func buttonCheckmarkTermsPressed(_ sender: Any) {
        if isTermsConditionChecked == false {
            isTermsConditionChecked = true
            DispatchQueue.main.async {
                self.buttonCheckmarkTerms.setBackgroundImage(UIImage.init(named: "tick"), for: .normal)
            }
        }
        else{
            isTermsConditionChecked = false
            DispatchQueue.main.async {
                self.buttonCheckmarkTerms.setBackgroundImage(UIImage.init(named: "box"), for: .normal)
            }
        }
    }
   
    func showStandardDialog(animated: Bool = true, title: String, message: String) {
        
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
            //login him into app now with all his data stored into user defaults
        }
        
        // Add button to dialog
        popup.addButtons([buttonOK])
        
        // Present dialog
        self.present(popup, animated: animated, completion: nil)
    }
    
    func sendDataToServer() {

        if getLatitude.count == 0 { getLatitude = "0" }
        if getLongitude.count == 0 { getLongitude = "0" }
        if imageString.count == 0 { imageString = "0" }
        if password.count == 0 { password = "" }
        if password == "0" { password = "" }
        
        let param: Dictionary<String, Any> =
            [
                "f_name"            : getFirstName     as Any,
                "l_name"            : getLastName      as Any,
                "m_name"            : getMiddleName    as Any,
                "login_type"        : loginType        as Any,
                "image"             : imageString      as Any,
                "user_dob"          : getDOB           as Any,
                "user_email"        : getEmail         as Any,
                "user_phone"        : getPhone         as Any,
                "latitude"          : getLatitude      as Any,
                "longitude"         : getLongitude     as Any,
                "social_login_id"   : socialLoginId    as Any,
                "password"          : password         as Any,
                "user_purpose"      : getPurpose()     as Any,
                "action_for"        : actionFor()      as Any,
                "location"          : locationString   as Any
               
                ] as Dictionary<String, Any>
        
        registerServiceCall(param: param)
    }
    
    //MARK: Service Calling
    func registerServiceCall(param : Dictionary<String, Any>) {
        self.showAnimatedProgressBar(title: "Wait..", subTitle: "Registering User")
        let urL = MAIN_URL + POST_REGISTER
        Alamofire.request(urL, method: .get, parameters: param).responseJSON{ response in
           
            switch response.result {
            case .success:
                 self.hideAnimatedProgressBar()
                if let jsonResponse = response.result.value as? [String : String] {
                    print(jsonResponse)
                    if let status = jsonResponse["messageResponse"] {
                        if status == "1" {
                            //Fetch his all data - make a service call and send his email id and get all data
                            self.getUserData()
                        }
                        else if status == "2" {
                             self.alertMessage(title: ALERT_TITLE, message: USER_ALREADY_REGISTERED)
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
    
    func getUserData() {
        
        let param: Dictionary<String, Any> =
            [
                "user_email"        : getEmail                          as Any,
                "action_for"        : ACTION_FOR_GET_USER_WHOLE_DATA    as Any
            
                ] as Dictionary<String, Any>
        
        print(param)
        getUserDataFromServerServiceCall(param: param)
    }
    
    func getUserDataFromServerServiceCall(param : Dictionary<String, Any>) {
        self.showAnimatedProgressBar(title: "Almost there..", subTitle: "Fetching user info")
        let urL = MAIN_URL + POST_REGISTER
        Alamofire.request(urL, method: .get, parameters: param).responseJSON{ response in
            
            print(response)
            
            switch response.result {
            case .success:
                if let jsonResponse = response.result.value as? [String : String] {
                        print(jsonResponse)
                    if let firstName = jsonResponse["first_name"] {
                        
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
