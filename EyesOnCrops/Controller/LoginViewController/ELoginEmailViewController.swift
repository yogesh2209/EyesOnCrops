//
//  ELoginEmailViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/3/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

class ELoginEmailViewController: EBaseViewController {

    @IBOutlet weak var textFieldEmailPhone: ECustomTextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var viewEmailPhone: ECustomView!
    @IBOutlet weak var textFieldPassword: ECustomTextField!
    @IBOutlet weak var viewPassword: ECustomView!
    
    @IBOutlet weak var buttonForgotPassword: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func buttonForgotPasswordPressed(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFirebaseAnalytics(title: "ELoginEmailViewController")
    }
    
    @IBAction func buttonLoginPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "loginToHomeSegueVC", sender: nil)
    }
}
