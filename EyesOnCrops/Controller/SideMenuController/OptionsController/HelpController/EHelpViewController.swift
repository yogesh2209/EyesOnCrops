//
//  EHelpViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/20/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit
import WebKit

class EHelpViewController: EBaseViewController, WKNavigationDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    
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
        setupFirebaseAnalytics(title: "EHelpViewController")
        loadWebView()
    }
    
    //MARK: PrivateMethods
    func loadWebView() {
        let urlString = MAIN_URL + HELP_URL
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
}
