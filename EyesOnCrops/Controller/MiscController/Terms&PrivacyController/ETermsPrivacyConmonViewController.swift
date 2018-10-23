//
//  ETermsPrivacyConmonViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 1/10/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit
import WebKit

class ETermsPrivacyConmonViewController: EBaseViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
        loadWebView()
        setupFirebaseAnalytics(title: "ETermsPrivacyConmonViewController")
    }
    
    //MARK: Private Methods
    func loadWebView() {
        
        var urlString = ""
        
        if indicatorVariable == "TERMS" {
            urlString = MAIN_URL + TERMSOFUSE_URL
        }
        else if indicatorVariable == "PRIVACY" {
            urlString = MAIN_URL + PRIVACY_POLICY_URL
        }
        //setup webview here
        
        guard let url = URL(string: urlString) else { return }
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
    }
    
    //MARK: WKWebView Delegates
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
    }

    
    //MARK: UIButton Actions
    @IBAction func buttonBackPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
