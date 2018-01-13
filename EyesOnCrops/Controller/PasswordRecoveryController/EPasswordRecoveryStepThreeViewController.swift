//
//  EPasswordRecoveryStepThreeViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 1/12/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit

class EPasswordRecoveryStepThreeViewController: UIViewController {
    
    @IBOutlet weak var buttonDone: UIBarButtonItem!
    @IBOutlet weak var viewPassword: ECustomView!
    @IBOutlet weak var textFieldConfirmPassword: ECustomTextField!
    
    @IBOutlet weak var textFieldPassword: ECustomTextField!
    
    @IBOutlet weak var viewConfirmPassword: ECustomView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonDonePressed(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
