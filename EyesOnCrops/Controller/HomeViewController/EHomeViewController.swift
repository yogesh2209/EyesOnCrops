//
//  EHomeViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/4/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit
import GoogleMobileAds

class EHomeViewController: EBaseViewController, GADBannerViewDelegate {

    @IBOutlet weak var viewBanner: GADBannerView!
    @IBOutlet weak var barButtonFilter: UIBarButtonItem!
    @IBOutlet weak var barButtonReset: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
        setupAdsBanner()
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
    //MARK: Private Methods
    func setupAdsBanner() {
        viewBanner.adUnitID = "ca-app-pub-8984057949233397/5348963984"
        viewBanner.rootViewController = self
        viewBanner.load(GADRequest())
        viewBanner.delegate = self
    }
    
    //MARK: Google Ads Banner Delegate
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner loaded successfully")
    }
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
    //MARK: UIButton Actions
    @IBAction func barButtonFilterPressed(_ sender: Any) {
        self.performSegue(withIdentifier: HOME_TO_FILTER_CATEGORY_LIST_SEGUE_VC, sender: nil)
    }
    @IBAction func barButtonResetPressed(_ sender: Any) {
    }
}
