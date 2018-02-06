//
//  ERegisterThreeViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/3/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import PKHUD

class ERegisterThreeViewController: EBaseViewController, CLLocationManagerDelegate {

    @IBOutlet weak var buttonPickupCurrentLocation: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var textViewLocation: UITextView!
    
    //Get all the parameters from the previous screen
    var getFirstName: String!
    var getMiddleName: String!
    var getLastName: String!
    var getDOB: String!
    var getEmail: String!
    var getPhone: String!
    var isLocationPicked = Bool()
    var locationManager = CLLocationManager()
    var getLatitude = ""
    var getLongitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customiseUI()
        setupProgressBar()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFirebaseAnalytics(title: "ERegisterThreeViewController")
    }
    //MARK: Private Methods
    func customiseUI() {
        textViewLocation.placeholder = "Enter your location here"
        textViewLocation.layer.cornerRadius = 5.0
        textViewLocation.layer.masksToBounds = true
        textViewLocation.layer.borderColor = UIColor.lightGray.cgColor
        textViewLocation.layer.borderWidth = 1.0
    }
    func getLocation() -> String {
        if let locationString = self.textViewLocation.text {
            return locationString
        }
        else {
            return ""
        }
    }
    func nextButtonAction() {
        if isLocationPicked == true || textViewLocation.text.count != 0 {
            if getFirstName.count != 0 && getLastName.count != 0 && getDOB.count != 0 && getEmail.count != 0 && getPhone.count != 0 && getLocation().count != 0 {
               addressToCoordinatesConverter(address: getLocation())
            }
        }
        //Error
        else{
             self.alertMessage(title: "ALERT", message: "Either pick current location or enter location manually!")
        }
    }
    func locationChecking() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        self.showAnimatedProgressBar(title: "Wait..", subTitle: "Finding location")
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                self.hideAnimatedProgressBar()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
            }
        } else {
            self.hideAnimatedProgressBar()
            self.alertMessage(title: "ALERT", message: "Location services not enabled!")
            print("Location services are not enabled")
        }
    }
    //Code to convert lat long to address string and show it to user in textview
    func getAddressStringFromCoordinates(location : CLLocationCoordinate2D) {
        let locationToPass = CLLocation(latitude: location.latitude, longitude: location.longitude)
        CLGeocoder().reverseGeocodeLocation(locationToPass, completionHandler: {(placemarks, error) -> Void in
            if let place = placemarks?[0] {
                self.setTextView(placemark: place)
            } else {
                self.alertMessage(title: "ERROR", message: "Failed to Get Your Location! Try again!")
            }
        })
    }
    //To convert address/string to latitude-longitude
    func addressToCoordinatesConverter(address: String) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address as String, completionHandler: { (placemarks, error) -> Void in
            if let placemarks = placemarks {
                if placemarks.count != 0 {
                    let annotation = MKPlacemark(placemark: placemarks.first!)
                    self.getLatitude = String(annotation.coordinate.latitude)
                    self.getLongitude = String(annotation.coordinate.longitude)
                    self.performSegue(withIdentifier: REGISTER_3_TO_4_SEGUE_VC, sender: nil)
                }
                else {
                    self.alertMessage(title: "ERROR", message: "Something went wrong, please try again later!")
                }
            }
            else {
                self.alertMessage(title: "ERROR", message: "Please enter a valid location!")
            }
        })
    }
    func setTextView(placemark : CLPlacemark?) {
        if placemark != nil {
            var name = placemark?.name
            var zip = placemark?.postalCode
            var country = placemark?.country
            var locality = placemark?.locality
            var adminArea = placemark?.administrativeArea
            var subAdminArea = placemark?.subAdministrativeArea
            var thoroughFare = placemark?.thoroughfare
            if name == nil {
                name = ""
            }
            if zip == nil {
                zip = ""
            }
            if country == nil {
                country = ""
            }
            if locality == nil {
                locality = ""
            }
            if adminArea == nil {
                adminArea = ""
            }
            if subAdminArea == nil {
                subAdminArea = ""
            }
            if thoroughFare == nil {
                thoroughFare = ""
            }
            DispatchQueue.main.async {
                self.textViewLocation.placeholder = ""
                self.textViewLocation.text = "\(name!) \(thoroughFare!) \(locality!) \(adminArea!) \(subAdminArea!) \(country!) \(zip!)"
            }
        }
        else{
            DispatchQueue.main.async {
                self.textViewLocation.placeholder = ""
                self.textViewLocation.text = "You haven't picked any location yet! Enter it!"
            }
        }
    }
    //MARK: UIButton Actions
    @IBAction func buttonPickupCurrentLocationPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.locationChecking()
        }
    }
    @IBAction func buttonNextPressed(_ sender: UIButton) {
        nextButtonAction()
    }
    //MARK: CLLocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        DispatchQueue.main.async {
            self.hideAnimatedProgressBar()
        }
        getAddressStringFromCoordinates(location: userLocation.coordinate)
    }
    //MARK: UINavigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == REGISTER_3_TO_4_SEGUE_VC) {
            // pass data to next view
            let secondVC = segue.destination as! ERegisterFourthViewController
            secondVC.getFirstName = getFirstName
            secondVC.getLastName = getLastName
            secondVC.getDOB = getDOB
            secondVC.getEmail = getEmail
            secondVC.getPhone = getPhone
            secondVC.getLatitude = getLatitude
            secondVC.getLongitude = getLongitude
            secondVC.locationString = getLocation()
            if getMiddleName.count == 0 {
                secondVC.getMiddleName = ""
            }
            else{
                secondVC.getMiddleName = getMiddleName
            }
        }
    }
}
// Extend UITextView and implemented UITextViewDelegate to listen for changes
extension UITextView: UITextViewDelegate {
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    public var placeholder: String? {
        get {
            var placeholderText: String?
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        placeholderLabel.isHidden = self.text.count > 0
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
}
