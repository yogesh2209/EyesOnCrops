//
//  EHomeViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/4/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit
import GoogleMobileAds
import WhirlyGlobe
import MapKit
import Alamofire
import PopupDialog
import MessageUI

struct JSONData: Decodable {
    let region_id: String?
    let country: String?
    let state: String?
    let district: String?
    let ndvi: String?
    let ndvi_count: String?
    let anomaly: String?
    let anomaly_count: String?
    let centr_lon: String?
    let centr_lat: String?
}

class EHomeViewController: EBaseViewController, GADBannerViewDelegate, WhirlyGlobeViewControllerDelegate, MaplyViewControllerDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var imageViewInfo: UIImageView!
    @IBOutlet weak var imageViewExport: UIImageView!
    @IBOutlet weak var viewBanner: GADBannerView!
    @IBOutlet weak var barButtonFilter: UIBarButtonItem!
    @IBOutlet weak var barButtonReset: UIBarButtonItem!
    
    var json : [JSONData] = []
    private var theViewC: MaplyBaseViewController?
    private var globeViewC: WhirlyGlobeViewController?
    private var mapViewC: MaplyViewController?
    private var vectorDict: [String:AnyObject]?
    private var vecName: NSObject?
    
    var selectedLevel: String?
    var dateSelected: String?
    var statesObjectArray: [MaplyComponentObject] = []
    var countryObjectArray: [MaplyComponentObject] = []
    var dataParams: [Any] = []
    var dataPointsArray: [Any] = []
    var isCurrentGlobe = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
        setupAdsBanner()
        customiseUI()
        registerNotification()
        loadGlobe(isGlobeDisplay: isGlobe())
        addTapGestureOnViews()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFirebaseAnalytics(title: "EHomeViewController")
        udpateGlobeLevel()
    }
    
    //MARK: MFMailComposerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Custom Methods
    
    func updateViewsVisibility() {
        if json.count != 0 {
            DispatchQueue.main.async {
                self.imageViewExport.isHidden = false
                self.imageViewInfo.isHidden = false
            }
        }
        else{
            DispatchQueue.main.async {
                self.imageViewExport.isHidden = true
                self.imageViewInfo.isHidden = true
            }
        }
    }
    
    func addTapGestureOnViews(){
        let tapExportView = UITapGestureRecognizer(target: self, action: #selector(self.handleTapExport(_:)))
        let tapInfoView = UITapGestureRecognizer(target: self, action: #selector(self.handleTapInfo(_:)))
        imageViewExport.addGestureRecognizer(tapExportView)
        imageViewInfo.addGestureRecognizer(tapInfoView)
    }
    
    func setupMailComposer() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        //composeVC.setToRecipients(["desiredEmail@gmail.com"])
        composeVC.setSubject("NDVI CSV Export")
        
        guard MFMailComposeViewController.canSendMail() else {
            let a = URL(string: "mailto:test@test.com")
            UIApplication.shared.open(a!, options: [:], completionHandler: nil)
            return
        }
        
        composeVC.setMessageBody("hello", isHTML: false)
        
        self.present(composeVC, animated: true, completion: nil)
    }
    
    @objc func handleTapExport(_ sender: UITapGestureRecognizer) {
        // handling code
        if self.dataParams.count != 0 {
            
            //yes action here - take him to export screen
            let yesAction = {
                self.setupMailComposer()
            }
            
            if let message = customiseCurrentInfoString() {
                self.showExportAlert(title: "Are you sure you want to export data?", message: message, animated: true, yesAction: yesAction)
            }
            else{
                self.showInfoAlert(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
            }
        }
    }
    
    func customiseCurrentInfoString() -> String? {
        // handling code
        if self.dataParams.count != 0 {
            //for loop apply and get all the countries and show it in info message
            var message = ""
            for index in 0..<self.dataParams.count {
                if let param = self.dataParams[index] as? [String : String], let country = param["country"], let date = param["date"] {
                    
                    if message != "" {
                        message = message + " | "
                    }
                    
                    message = message + country + " - " + date
                }
            }
         
            return message
        }
        else{
            return nil
        }
    }
    
    @objc func handleTapInfo(_ sender: UITapGestureRecognizer) {
        if let message = customiseCurrentInfoString() {
             self.showInfoAlert(title: "You are viewing", message: message)
        }
        else{
             self.showInfoAlert(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
        }
    }
    
    func setupAdsBanner(){
        viewBanner.adUnitID = "ca-app-pub-8984057949233397/5348963984"
        viewBanner.rootViewController = self
        viewBanner.delegate = self
        viewBanner.load(GADRequest())
    }
    
    func customiseUI(){
        self.navigationController?.isNavigationBarHidden = false
        imageViewInfo.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageViewInfo.contentMode = .scaleAspectFit // OR .scaleAspectFill
        imageViewInfo.clipsToBounds = true
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
    
    //MARK: Notifications
    func registerNotification() {
        NotificationCenter.default.addObserver(forName: .saveDateNotification, object: nil, queue: nil) { [weak self] (notification) in
            guard let strongSelf = self else { return }
            if let userDict = notification.userInfo as? [String : String], let date = userDict["selected_date"] {
                strongSelf.dateSelected = date
            }
        }
        
        NotificationCenter.default.addObserver(forName: .popToHomeScreenNotification, object: nil, queue: nil) { [weak self] (notification) in
            //pop up from back screen
            guard let strongSelf = self else { return }
            strongSelf.updateMapType()
        }
    }
}

extension EHomeViewController {
    
    func isGlobe() -> Bool {
        if let mapStored = self.getStoredMapTypeFromUserDefaults() {
            if mapStored == "GLOBE" {
                return true
            }
            else{
                return false
            }
        }
        else{
            return true
        }
    }
    
    func loadGlobe(isGlobeDisplay: Bool = true) {
        if isGlobeDisplay {
            if let map = mapViewC {
                map.removeFromParentViewController()
                theViewC?.removeFromParentViewController()
                theViewC?.view.removeFromSuperview()
            }
            
            // If you're doing a globe
            globeViewC = WhirlyGlobeViewController()
            theViewC = globeViewC
            isCurrentGlobe = true
            globeViewC?.delegate = self
            globeViewC?.animate(toPosition: MaplyCoordinateMakeWithDegrees(-5.93,54.597), time: 1.0)
        }
        else {
            
            if let globe = globeViewC {
                globe.removeFromParentViewController()
                theViewC?.removeFromParentViewController()
                theViewC?.view.removeFromSuperview()
            }
            
            mapViewC = MaplyViewController()
            theViewC = mapViewC
            mapViewC?.delegate = self
            isCurrentGlobe = false
        }
        
        self.view.addSubview(theViewC!.view)
        self.view.bringSubview(toFront: viewBanner)
        self.view.bringSubview(toFront: imageViewInfo)
        self.view.bringSubview(toFront: imageViewExport)
        //self.view.sendSubview(toBack: theViewC!.view)
        theViewC!.view.frame = self.view.bounds
        addChildViewController(theViewC!)
        
        // and thirty fps if we can get it ­ change this to 3 if you find your app is struggling
        theViewC!.frameInterval = 2
        
        // we'll need this layer in a second
        let layer: MaplyQuadImageTilesLayer
        
        // Because this is a remote tile set, we'll want a cache directory
        let baseCacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let tilesCacheDir = "\(baseCacheDir)/tiles/"
        
        // Stamen Terrain Tiles, courtesy of Stamen Design under the Creative Commons Attribution License.
        // Data by OpenStreetMap under the Open Data Commons Open Database License.
        
        guard let tileSource = MaplyRemoteTileSource(
            baseURL: "http://tile.stamen.com/terrain/",
            ext: "png",
            minZoom: 1,
            maxZoom: 7)
            else {
                print("Can't create the remote tile source")
                return
        }
        
        tileSource.cacheDir = tilesCacheDir
        layer = MaplyQuadImageTilesLayer(coordSystem: tileSource.coordSys, tileSource: tileSource)
        layer.handleEdges = (globeViewC != nil)
        layer.coverPoles = (globeViewC != nil)
        layer.requireElev = false
        layer.waitLoad = false
        layer.imageDepth = 1
        layer.drawPriority = 0
        layer.singleLevelLoading = false
        theViewC!.add(layer)
        
        // start up over San Francisco
        if let globeViewC = globeViewC {
            // we want a black background for a globe, a white background for a map.
            theViewC!.clearColor = UIColor.black
            //globeViewC.height = 0.8
            globeViewC.animate(toPosition: MaplyCoordinateMakeWithDegrees(-122.4192, 37.7793), time: 1.0)
        }
        else if let mapViewC = mapViewC {
            mapViewC.height = 1.0
            theViewC!.clearColor = UIColor.white
            mapViewC.animate(toPosition: MaplyCoordinateMakeWithDegrees(-122.4192, 37.7793), time: 1.0)
        }
        
        vectorDict = [
            kMaplyColor: UIColor.black,
            kMaplySelectable: true as AnyObject,
            kMaplyVecWidth: 4.0 as AnyObject
        ]
        
        setupZoomLevel(isGlobe: isGlobeDisplay)
    }
    
    func setupZoomLevel(isGlobe: Bool = true) {
        //setting the zoom limit
        
        if isGlobe {
            globeViewC?.setZoomLimitsMin(0.05, max: 3)
        }
        else{
            mapViewC?.setZoomLimitsMin(0.05, max: 3)
        }
    }
    
    func updateMapType() {
        //map type activate
        if !isGlobe() && isCurrentGlobe {
            resetShapePreviousConfiguration()
            updateViewsVisibility()
            loadGlobe(isGlobeDisplay: false)
        }
            //globe type activate
        else if isGlobe() && !isCurrentGlobe {
            resetShapePreviousConfiguration()
            updateViewsVisibility()
            loadGlobe(isGlobeDisplay: true)
        }
    }
    
    func resetShapePreviousConfiguration(){
        //reseting shape files
        self.countryObjectArray.removeAll()
        self.statesObjectArray.removeAll()
        self.storeLevelInUserDefaults(level: "LEVEL-0")
        self.addCountries()
        
        //removing all active maplycomponentobject
        removeActivePoints()
        
        //empty json
        json = []
    }
    
    func removeActivePoints() {
        for index in 0..<self.dataPointsArray.count {
            
            if  let param = dataPointsArray[index] as? [String : Any],
                let shape_object = param["shape_object"] as? MaplyComponentObject {
                
               self.theViewC?.remove(shape_object)
            }
        }
        
        self.dataPointsArray.removeAll()
        self.dataParams.removeAll()
    }
    
    //updating globe with level and date
    func udpateGlobeLevel(){
        
        updateViewsVisibility()
        
        if let selectedLevel = self.getStoredLevelFromUserDefaults() {
            
            //country admin level
            if selectedLevel == "LEVEL-0" {
                
                if self.countryObjectArray.count != 0 {
                    self.theViewC?.enable(countryObjectArray, mode: MaplyThreadAny)
                }
                else{
                    self.addCountries()
                }
                
                self.theViewC?.disableObjects(statesObjectArray, mode: MaplyThreadAny)
            }
                //state admin level
            else if selectedLevel == "LEVEL-1" {
                
                if self.countryObjectArray.count != 0 {
                    self.theViewC?.enable(countryObjectArray, mode: MaplyThreadAny)
                }
                else{
                    self.addCountries()
                }
                
                if self.statesObjectArray.count != 0 {
                    self.theViewC?.enable(statesObjectArray, mode: MaplyThreadAny)
                }
                else{
                    self.addStates()
                }
            }
        }
            //No level found - in case of something wrong
        else{
            if self.countryObjectArray.count != 0 {
                self.theViewC?.enable(countryObjectArray, mode: MaplyThreadAny)
            }
            else{
                self.addCountries()
            }
            
            self.theViewC?.disableObjects(statesObjectArray, mode: MaplyThreadAny)
        }
    }
    
    func addCountries() {
        
        self.countryObjectArray.removeAll()
        
        // handle this in another thread
        let queue = DispatchQueue.global()
        queue.async {
            let bundle = Bundle.main
            let allOutlines = bundle.paths(forResourcesOfType: "geojson", inDirectory: "country_json_50m")
            
            for outline in allOutlines {
                if let jsonData = NSData(contentsOfFile: outline),
                    let wgVecObj = MaplyVectorObject(fromGeoJSON: jsonData as Data) {
                    
                    wgVecObj.selectable = true
                    
                    // the admin tag from the country outline geojson has the country name ­ save
                    if let attrs = wgVecObj.attributes,
                        let vecNameee = attrs.object(forKey: "ADMIN") as? NSObject {
                        self.vecName = vecNameee
                        wgVecObj.userObject = self.vecName
                    }
                    
                    // add the outline to our view
                    let obj = self.theViewC?.addVectors([wgVecObj], desc: self.vectorDict)
                    if let maplyObj = obj {
                        self.countryObjectArray.append(maplyObj)
                    }
                    var c = wgVecObj.center()
                    wgVecObj.centroid(&c)
                }
            }
        }
    }
    
    private func addAnnotationWithTitle(title: String, subtitle: String, loc:MaplyCoordinate) {
        theViewC?.clearAnnotations()
        
        let a = MaplyAnnotation()
        a.title = title
        a.subTitle = subtitle
        
        theViewC?.addAnnotation(a, forPoint: loc, offset: .zero)
    }
    
    func globeViewController(_ viewC: WhirlyGlobeViewController, didTapAt coord: MaplyCoordinate) {
        // let subtitle = NSString(format: "(%.2fN, %.2fE)", coord.y*57.296,coord.x*57.296) as String
        // addAnnotationWithTitle(title: "Tap!", subtitle: subtitle, loc: coord)
    }
    
    func maplyViewController(_ viewC: MaplyViewController, didTapAt coord: MaplyCoordinate) {
        // let subtitle = NSString(format: "(%.2fN, %.2fE)", coord.y*57.296,coord.x*57.296) as String
        // addAnnotationWithTitle(title: "Tap!", subtitle: subtitle, loc: coord)
    }
    
    func validateSelectedCountry(for data: [Any], selectedCountry: String, currentSelectedDate: String) -> Bool {
        
        var isValidDateCountry: Bool = false
        
        for index in 0..<data.count {
            
            if  let param = data[index] as? [String : Any],
                let country = param["country"] as? String,
                let date = param["date"] as? String,
                let shape_object = param["shape_object"] as? MaplyComponentObject {
                
                //same country selected and different date - so clean old data
                if selectedCountry == country && currentSelectedDate != date {
                    //remove old data from dataparam too
                    self.dataParams.remove(at: index)
                    self.theViewC?.remove(shape_object)
                    isValidDateCountry = true
                }
                else if selectedCountry != country {
                    isValidDateCountry = true
                }
                else if selectedCountry == country && currentSelectedDate == date {
                    self.alertMessage(title: ALERT_TITLE, message: "Data already visible for the date and country")
                    return false
                }
            }
        }
        return isValidDateCountry
    }
    
    // Unified method to handle the selection
    private func handleSelection(selectedObject: NSObject, date: String = "") {
        if let selectedObject = selectedObject as? MaplyVectorObject {
            var loc = selectedObject.center()
            let _ =  selectedObject.centroid(&loc)
            if let country = selectedObject.userObject as? String {
                
                if dataPointsArray.count != 0 {
                    //validate here
                    if validateSelectedCountry(for: dataPointsArray, selectedCountry: country, currentSelectedDate: date) {
                        getJSONDataServiceCall(date: date, country: country)
                    }
                    else{
                        
                    }
                }
                else{
                    getJSONDataServiceCall(date: date, country: country)
                }
            }
        }
        else if let _ = selectedObject as? MaplyScreenMarker {
            // addAnnotationWithTitle(title: "selected", subtitle: "marker", loc: selectedObject.loc)
        }
    }
    
    // This is the version for a globe
    func globeViewController(_ viewC: WhirlyGlobeViewController, didSelect selectedObj: NSObject) {
        if let dateSelected = dateSelected {
            handleSelection(selectedObject: selectedObj, date: dateSelected)
        }
        else{
            self.alertMessage(title: "ALERT", message: "Please select the date first!")
        }
    }
    
    // This is the version for a map
    func maplyViewController(_ viewC: MaplyViewController, didSelect selectedObj: NSObject) {
        if let dateSelected = dateSelected {
            handleSelection(selectedObject: selectedObj, date: dateSelected)
        }
        else{
            self.alertMessage(title: "ALERT", message: "Please select the date first!")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    func locationManager(_ manager: CLLocationManager, didChange status: CLAuthorizationStatus) {
    }
    
    private func addCoordinates(json: [JSONData], country: String, date: String) {
        
        var coordinates: [MaplyCoordinate] = []
        var colors: [UIColor] = []
        
        for index in 0..<json.count {
            if  let latStr = json[index].centr_lat,
                let lonStr = json[index].centr_lon,
                let lat = Float(latStr),
                let lon = Float(lonStr),
                let ndvi = json[index].ndvi,
                let ndviFloat = Float(ndvi) {
                
                coordinates.append(MaplyCoordinateMakeWithDegrees(lon, lat))
                colors.append(UIColor.green)
            }
        }
        
        var circles: [MaplyShapeCircle] = []
        for index in 0..<coordinates.count {
            let circle = MaplyShapeCircle()
            circle.center = coordinates[index]
            circle.radius = 0.010
            circle.color = colors[index]
            circles.append(circle)
        }
        
        var dict: [String: Any] = [:]
        
        if circles.count != 0 {
            dict["country"] = country
            dict["date"] = date
            dict["points"] = circles
        }
        
        updateViewsVisibility()
        
        let shapes = self.theViewC?.addShapes(circles, desc: [:])
        if let s = shapes {
            dict["shape_object"] = s
        }
        dataPointsArray.append(dict)
    }
    
    func addStates() {
        
        self.statesObjectArray.removeAll()
        
        // handle this in another thread
        let queue = DispatchQueue.global()
        queue.async {
            let bundle = Bundle.main
            let allOutlines = bundle.paths(forResourcesOfType: "geojson", inDirectory: "state_json")
            
            for outline in allOutlines.reversed() {
                
                if let jsonData = NSData(contentsOfFile: outline),
                    let wgVecObj = MaplyVectorObject(fromGeoJSON: jsonData as Data) {
                    
                    // add the outline to our view
                    let obj = self.theViewC?.addVectors([wgVecObj], desc: self.vectorDict)
                    if let maplyObj = obj {
                        self.statesObjectArray.append(maplyObj)
                    }
                }
            }
        }
    }
    
    //MARK: Service Calling
    func getJSONDataServiceCall(date: String, country: String){
        let param: Dictionary<String, Any> =
            [
                "date"               : date                     as Any,
                "country"            : country                  as Any,
                "action_for"         : ACTION_FOR_JSON_DATA     as Any
                
                ] as Dictionary<String, Any>
        
        self.showAnimatedProgressBar(title: "Fetching info..", subTitle: date + ", " + country)
        let urL = MAIN_URL + POST_GET_DATA
        Alamofire.request(urL, method: .get, parameters: param).responseJSON{ response in
            
            switch response.result {
            case .success:
                
                self.hideAnimatedProgressBar()
                
                if let json = response.result.value as? NSDictionary {
                    if let _ = json["messageResponse"] {
                        self.updateViewsVisibility()
                        self.alertMessage(title: ALERT_TITLE, message: NO_DATA_AVAILABLE + " " + date + ", " + country)
                    }
                    return
                }
                
                guard let data = response.data else { return }
                
                do {
                    self.json = try JSONDecoder().decode([JSONData].self, from: data)
                    if self.json.count != 0 {
                        self.dataParams.append(param)
                        self.addCoordinates(json: self.json, country: country, date: date)
                    }
                }
                catch {
                    self.updateViewsVisibility()
                    self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
                    return
                }
                
            case .failure(_ ):
                self.hideAnimatedProgressBar()
                self.updateViewsVisibility()
                self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
            }
        }
    }
}
