//
//  ERegisterFourthViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/3/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

class ERegisterFourthViewController: EBaseViewController {

    @IBOutlet weak var textViewPurpose: UITextView!
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
        setupFirebaseAnalytics(title: "ERegisterFourthViewController")
    }
    //MARK: Private Methods
    func customiseUI() {
        textViewPurpose.placeholder = "Enter your purpose of using this app here"
        textViewPurpose.layer.cornerRadius = 5.0
        textViewPurpose.layer.masksToBounds = true
        textViewPurpose.layer.borderColor = UIColor.lightGray.cgColor
        textViewPurpose.layer.borderWidth = 1.0
    }
    func getPurpose() -> String {
        if let purposeString = self.textViewPurpose.text {
            return purposeString
        }
        else {
            return ""
        }
    }
    //MARK: UIButton Actions
    @IBAction func buttonDonePressed(_ sender: UIButton) {
        if getPurpose().count != 0 {
            //SERVICE CALL FINALLY
        }
        else {
            self.alertMessage(title: "ERROR", message: "Something went wrong, please try again later!")
        }
    }
}
