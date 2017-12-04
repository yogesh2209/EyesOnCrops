//
//  EMainViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/3/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

class EMainViewController: UIViewController {

    @IBOutlet weak var buttonRegister: UIButton!
    @IBOutlet weak var buttonLogin: UIButton!
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
}
