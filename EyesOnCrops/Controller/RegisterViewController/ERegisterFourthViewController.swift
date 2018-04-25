//
//  ERegisterFourthViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/3/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit
import ActiveLabel


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
}
