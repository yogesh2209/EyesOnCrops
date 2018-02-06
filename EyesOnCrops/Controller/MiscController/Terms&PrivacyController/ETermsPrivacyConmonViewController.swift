//
//  ETermsPrivacyConmonViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 1/10/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit
import WebKit

class ETermsPrivacyConmonViewController: EBaseViewController {
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var buttonBack: UIButton!
    var indicatorVariable : String!

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
        setup()
        setupFirebaseAnalytics(title: "ETermsPrivacyConmonViewController")
    }
    
    //MARK: Private Methods
    func setup() {
        if indicatorVariable == "TERMS" {
            
        }
        else if indicatorVariable == "PRIVACY" {
            
        }
        //setup webview here
    }
    //MARK: UIButton Actions
    @IBAction func buttonBackPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
