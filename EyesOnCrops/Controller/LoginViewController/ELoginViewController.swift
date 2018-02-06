//
//  ELoginViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/3/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class ELoginViewController: EBaseViewController, GIDSignInDelegate, GIDSignInUIDelegate {

    @IBOutlet weak var buttonLoginEmail: UIButton!
    @IBOutlet weak var buttonGoogleLogin: UIButton!
    @IBOutlet weak var buttonFacebookLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseUI()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        setupFirebaseAnalytics(title: "ELoginViewController")
    }
    
    //MARK: Private Methods
    func customiseUI() {
        self.navigationController?.isNavigationBarHidden = false
    }
    func facebookLoginAction() {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        //   fbLoginManager.loginBehavior = FBSDKLoginBehavior.web
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    func googleSignInAction() {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    //Storing data in NSUserDefaults
    func storeDataInUserDefaults(param : [String : Any]) {
        let defaults = UserDefaults.standard
        defaults.set(param, forKey: "LOGIN_DATA")
    }
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), gender,birthday,email"]).start(completionHandler: { (connection, result, error) -> Void in
                if ((error) != nil)
                {
                }
                else
                {
                    let data:[String : Any] = result as! [String : Any]
                    var tempData : [String : Any] = [:]
                    tempData["first_name"] = data["first_name"]
                    tempData["last_name"] = data["last_name"]
                    if let picture = data["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, case let url = data["url"] as? String {
                        tempData["image"] = url
                    }
                    else {
                        tempData["image"] = ""
                    }
                     self.storeDataInUserDefaults(param: tempData)
                }
            })
        }
    }
    
    //MARK: Google Sign In Methods
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
        
    }
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let imageUrl = user.profile.imageURL(withDimension: 200) as NSURL
            let imageUrlFinalString  = imageUrl.absoluteString!
            var data:[String : Any] = [ : ]
            let fullNameArr = user.profile.name.components(separatedBy: " ")
            data["first_name"] = fullNameArr[0]
            data["last_name"] = fullNameArr[1]
            data["image"] = imageUrlFinalString
            self.storeDataInUserDefaults(param: data)
        } else {
        }
    }
    //MARK: UIButton Actions
    @IBAction func buttonGoogleLoginPressed(_ sender: Any) {
        googleSignInAction()
    }
    @IBAction func buttonFacebookLoginPressed(_ sender: Any) {
        facebookLoginAction()
    }
    @IBAction func buttonLoginEmailPressed(_ sender: Any) {
        performSegue(withIdentifier: LOGINTOEMAIL_SEGUE_VC, sender: nil)
    }
}
