//
//  EPasswordRecoveryStepTwoViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 1/11/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit

class EPasswordRecoveryStepTwoViewController: EBaseViewController {

    @IBOutlet weak var buttonNext: UIBarButtonItem!
    @IBOutlet weak var viewDOB: ECustomView!
    @IBOutlet weak var textFieldDOB: ECustomTextField!
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
        setupFirebaseAnalytics(title: "EPasswordRecoveryStepTwoViewController")
    }
    //MARK: Private Methods
    func getDOB() -> String {
        if let dob = self.textFieldDOB.text {
            return dob
        }
        else {
            return ""
        }
    }
    func nextButtonAction() {
        if getDOB().count != 0 {
            //Service Calling here
        }
        else{
            alertMessage(title: "Error", message: "Date of birth cannot be empty!")
        }
    }
    //MARK: UIButton Actions
    @IBAction func buttonNextPressed(_ sender: Any) {
        nextButtonAction()
    }
}
