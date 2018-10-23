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
import Alamofire
import PopupDialog

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
    func storeDataInUserDefaults(param : [String : String]) {
        let defaults = UserDefaults.standard
        defaults.set(param, forKey: "LOGIN_DATA")
    }
    //Getting data from NSUserDefaults
    func getStoredData() -> [String : Any]? {
        let defaults = UserDefaults.standard
        if let filterDataStored = defaults.object(forKey: "LOGIN_DATA") {
            return filterDataStored as? [String : Any]
        }
        else{
            return nil
        }
    }
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), gender,birthday,email"]).start(completionHandler: { (connection, result, error) -> Void in
                if ((error) != nil)
                {
                    self.alertMessage(title: ALERT_ERROR_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
                }
                else
                {
                    let data:[String : Any] = result as! [String : Any]
                    print(data)
                    var tempData : [String : String] = [:]
                    tempData["f_name"] = data["first_name"] as? String
                    tempData["l_name"] = data["last_name"] as? String
                    tempData["social_login_id"] = data["id"] as? String
                    tempData["user_email"] = data["email"] as? String
                    if let picture = data["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, case let url = data["url"] as? String {
                        tempData["image"] = url
                    }
                    else {
                        tempData["image"] = ""
                    }
                
                    tempData["login_type"] = "facebook"
                    tempData["phone"] = "0"
                    
                    tempData["action_for"] = ACTION_FOR_LOGIN_SOCIAL
                    
                    print(tempData)
                    
                    self.storeDataInUserDefaults(param: tempData)
                    //service call for login
                    self.loginSocialServiceCall(param: tempData)
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
            var data:[String : String] = [ : ]
            let fullNameArr = user.profile.name.components(separatedBy: " ")
            data["f_name"] = fullNameArr[0]
            data["l_name"] = fullNameArr[1]
            data["image"] = imageUrlFinalString
            data["user_email"] = user.profile.email
            data["login_type"] = "google"
            data["phone"] = "0"
            data["action_for"] = ACTION_FOR_LOGIN_SOCIAL
            
            print(data)
            print(user)
            
            self.storeDataInUserDefaults(param: data)
            //service call for login
            self.loginSocialServiceCall(param: data)
        }
        else{
            self.alertMessage(title: ALERT_ERROR_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
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
    func loginSocialServiceCall(param : Dictionary<String, Any>) {
        self.showAnimatedProgressBar(title: "Wait..", subTitle: "Fetching info")
        let urL = MAIN_URL + POST_CREDENTIALS
        Alamofire.request(urL, method: .get, parameters: param).responseJSON{ response in
        
            switch response.result {
            case .success:
                self.hideAnimatedProgressBar()
                if let jsonResponse = response.result.value as? NSDictionary {
                    
                    if let _ = jsonResponse["messageResponse"] {
                        self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
                    }
                    else{
                        print(jsonResponse)
                        if let result = jsonResponse["responseArray"]! as? NSArray {
                            
                            print(result[0])
                            
                            if let finalResult = result[0] as? [String : String] {
                                
                                //check if status = 1 or 2
                                //if status = 1 => take user to purpose screen else home screen
                                self.storeDataInUserDefaults(param: finalResult)
                                if let status = finalResult["status"] {
                                    
                                    if status == "1" {
                                        //take him to home screen with proper registration done
                                        self.performSegue(withIdentifier: SOCIAL_LOGIN_TO_REG_SEGUE_VC, sender: nil)
                                    }
                                    else if status == "2" {
                                        //take him to home screen with proper registration done
                                        self.performSegue(withIdentifier: SOCIAL_LOGIN_TO_HOME_SEGUE_VC, sender: nil)
                                    }
                                    else{
                                         self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
                                    }
                                }
                            }
                            else{
                                self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
                            }
                        }
                    }
                }
            case .failure(_ ):
                self.hideAnimatedProgressBar()
                self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
            }
        }
    }
    //MARK: UINavigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == SOCIAL_LOGIN_TO_REG_SEGUE_VC) {
            // pass data to next view
            let secondVC = segue.destination as! ERegisterFourthViewController
            
            if getStoredData() != nil {
                if let user_email = self.getStoredData()!["email"] {
                    secondVC.getEmail = user_email as? String
                }
                else{
                    secondVC.getEmail = ""
                }
            }
        }
    }
}
