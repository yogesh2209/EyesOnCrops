//
//  EMainViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/3/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit
import ActiveLabel

class EMainViewController: EBaseViewController, ActiveLabelDelegate {

    @IBOutlet weak var labelTermsAndPolicy: ActiveLabel!
    @IBOutlet weak var buttonRegister: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
    
    
    
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
        self.navigationController?.isNavigationBarHidden = true
        setupFirebaseAnalytics(title: "EMainViewController")
    }
    
    //MARK: UIButton Actions
    @IBAction func buttonLoginPressed(_ sender: Any) {
        performSegue(withIdentifier: LOGINSCREEN_SEGUE_VC, sender: nil)
    }
    @IBAction func buttonRegisterPressed(_ sender: Any) {
         performSegue(withIdentifier: REGISTER_1_SEGUE_VC, sender: nil)
    }
    
    //MARK: Private Methods
    func customiseUI() {
        self.navigationController?.isNavigationBarHidden = true
    }
    func setupTermsPrivacyLabel() {
        labelTermsAndPolicy.delegate = self
        labelTermsAndPolicy.numberOfLines = 0
        labelTermsAndPolicy.enabledTypes = [.mention, .hashtag, .url]
        labelTermsAndPolicy.text = "@TermsOfUse and @PrivacyPolicy"
        labelTermsAndPolicy.textColor = .black
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
}
