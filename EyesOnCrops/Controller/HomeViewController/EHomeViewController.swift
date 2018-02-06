//
//  EHomeViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/4/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

class EHomeViewController: EBaseViewController {

    @IBOutlet weak var barButtonFilter: UIBarButtonItem!
    @IBOutlet weak var barButtonReset: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
        self.navigationController?.isNavigationBarHidden = false
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFirebaseAnalytics(title: "EHomeViewController")
    }
    //MARK: UIButton Actions
    @IBAction func barButtonFilterPressed(_ sender: Any) {
        self.performSegue(withIdentifier: HOME_TO_FILTER_CATEGORY_LIST_SEGUE_VC, sender: nil)
    }
    @IBAction func barButtonResetPressed(_ sender: Any) {
    }
}
