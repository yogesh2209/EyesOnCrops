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
import SwiftCSVExport

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
    let mean_ndvi: String?
    let mean_ndvi_count: String?
    let mean_anomaly: String?
    let mean_anomaly_count: String?
    var start_date: String?
}

class JSONExportData {
    var region_id: String? = ""
    var country: String? = ""
    var state: String? = ""
    var district: String? = ""
    var ndvi: String? = ""
    var ndvi_count: String? = ""
    var anomaly: String? = ""
    var anomaly_count: String? = ""
    var centr_lon: String? = ""
    var centr_lat: String? = ""
    var mean_ndvi: String? = ""
    var mean_ndvi_count: String? = ""
    var mean_anomaly: String? = ""
    var mean_anomaly_count: String? = ""
    var start_date: String? = ""
}

class EHomeViewController: EBaseViewController, GADBannerViewDelegate, WhirlyGlobeViewControllerDelegate, MaplyViewControllerDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var imageViewInfo: UIImageView!
    @IBOutlet weak var imageViewExport: UIImageView!
    @IBOutlet weak var viewBanner: GADBannerView!
    @IBOutlet weak var barButtonFilter: UIBarButtonItem!
    @IBOutlet weak var barButtonReset: UIBarButtonItem!
    
    
    var json : [JSONData] = []
    var dataToExport : [Any] = []
    private var theViewC: MaplyBaseViewController?
    private var globeViewC: WhirlyGlobeViewController?
    private var mapViewC: MaplyViewController?
    private var vectorDictBoundary: [String:AnyObject]?
    private var vecName: NSObject?
    
    var selectedLevel: String?
    var dateSelected: String?
    
    var statesObjectArray: [MaplyComponentObject] = []
    var countryObjectArray: [MaplyComponentObject] = []
    var districtObjectArray: [MaplyComponentObject] = []
    
    var statesObjectColorArray: [MaplyComponentObject] = []
    var districtObjectColorArray: [MaplyComponentObject] = []
    
    
    var dataParams: [Any] = []
    var colorArray: [Any] = []
    var isCurrentGlobe = Bool()
    var lastSelectedDataType: String?
    var adminLevel: String?
    
    
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
    
    func getCurrentAdminLevel() -> String {
        if let adminLevel = self.getStoredDataFromUserDefaults(for: "LEVEL") {
            return adminLevel
        }
            //admin level - 0 be default country wise
        else{
            adminLevel = "LEVEL-0"
            return adminLevel!
        }
    }
    
    func getCurrentDataType() -> String {
        if let dataType = self.getStoredDataFromUserDefaults(for: "DATA_TYPE") {
            return dataType
        }
        else{
            return "NDVI"
        }
    }
    
    func addTapGestureOnViews(){
        let tapExportView = UITapGestureRecognizer(target: self, action: #selector(self.handleTapExport(_:)))
        let tapInfoView = UITapGestureRecognizer(target: self, action: #selector(self.handleTapInfo(_:)))
        imageViewExport.addGestureRecognizer(tapExportView)
        imageViewInfo.addGestureRecognizer(tapInfoView)
    }
    
    func setupMailComposer(data: [Data]?, fileNameArr: [String]?) {
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setSubject("NDVI CSV Export")
        
        guard MFMailComposeViewController.canSendMail() else {
            let a = URL(string: "mailto:test@test.com")
            UIApplication.shared.open(a!, options: [:], completionHandler: nil)
            return
        }
        
        //setupMailFiles(mailComposer: composeVC)
        if let d = data, let fileNames = fileNameArr, d.count == fileNames.count {
            for index in 0..<d.count {
                composeVC.addAttachmentData(d[index], mimeType: "text/csv", fileName: fileNames[index] + ".csv")
            }
        }
        
        composeVC.setMessageBody("hello", isHTML: false)
        
        self.present(composeVC, animated: true, completion: nil)
    }
    
    @objc func handleTapExport(_ sender: UITapGestureRecognizer) {
        // handling code
        if self.dataParams.count != 0 {
            
            //yes action here - take him to export screen
            let yesAction = {
                if let (data, file) = self.setupMailFiles() {
                    self.setupMailComposer(data: data, fileNameArr: file)
                }
                else{
                    self.showInfoAlert(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
                }
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
            var tempString = ""
            if let dataType = self.getStoredDataFromUserDefaults(for: "DATA_TYPE") {
                if dataType == "NDVI" {
                    tempString = " NDVI (%)"
                }
                else{
                    tempString = " NDVI Anamoly (%)"
                }
            }
            self.showInfoAlert(title: "You are viewing" + tempString, message: message)
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
        //reset everything
        resetConfiguration()
        updateViewsVisibility()
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
        if let mapStored = self.getStoredDataFromUserDefaults(for: "MAP_TYPE") {
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
        
        vectorDictBoundary = [
            kMaplyColor: UIColor.black,
            kMaplySelectable: true as AnyObject,
            kMaplyVecWidth: 3.0 as AnyObject,
            kMaplyFilled: false as AnyObject,
            kMaplyDrawPriority: 1.0 as AnyObject
        ]
        
        setupZoomLevel(isGlobe: isGlobeDisplay)
    }
    
    func setupZoomLevel(isGlobe: Bool = true) {
        //setting the zoom limit
        
        if isGlobe {
            globeViewC?.setZoomLimitsMin(0.05, max: 3)
        }
        else{
            mapViewC?.setZoomLimitsMin(0.05, max: 7)
        }
    }
    
    func updateMapType() {
        //map type activate
        if !isGlobe() && isCurrentGlobe {
            resetConfiguration()
            updateViewsVisibility()
            loadGlobe(isGlobeDisplay: false)
        }
            //globe type activate
        else if isGlobe() && !isCurrentGlobe {
            resetConfiguration()
            updateViewsVisibility()
            loadGlobe(isGlobeDisplay: true)
        }
    }
    
    func resetConfiguration(){
        
        //removing all active maplycomponentobject
        removeActiveColors()
        
        //reseting shape files
        self.countryObjectArray.removeAll()
     //   self.countryObjectColorArray.removeAll()
        self.statesObjectArray.removeAll()
        self.statesObjectColorArray.removeAll()
        self.storeDataInDefaults(type: "LEVEL-0", key: "LEVEL")
        self.addCountryBoundaries()
        
        //empty json
        self.json.removeAll()
        self.json = []
        self.dataParams.removeAll()
        self.dataToExport.removeAll()
        self.updateViewsVisibility()
        dateSelected = ""
        
        self.colorArray.removeAll()
    }
    
    func removeActiveColors() {
        //remove country colors
        print(self.colorArray)
        for index in 0..<self.colorArray.count {
            if let dict = self.colorArray[index] as? [String : Any], let obj = dict["color_object"] as? [MaplyComponentObject] {
                
                for j in 0..<obj.count {
                    self.theViewC?.remove(obj[j])
                }
            }
        }
        
        //remove state colors
        for index in 0..<self.statesObjectColorArray.count {
            self.theViewC?.remove(statesObjectColorArray[index])
        }
        
        //remove district colors
        for index in 0..<self.districtObjectColorArray.count {
            self.theViewC?.remove(districtObjectColorArray[index])
        }
        
        
        
    }
    
    func checkDataTypeUpdation(){
        //get the current data type if it is updated, reset data
        if let dataType = self.getStoredDataFromUserDefaults(for: "DATA_TYPE") {
            if lastSelectedDataType == "" {
                lastSelectedDataType = dataType
            }
            else if dataType != lastSelectedDataType {
                lastSelectedDataType = dataType
                self.resetConfiguration()
            }
        }
        else{
            lastSelectedDataType = "NDVI"
        }
    }
    
    //updating globe with level and date
    func udpateGlobeLevel(){
        
        updateViewsVisibility()
        checkDataTypeUpdation()
        
        if let selectedLevel = self.getStoredDataFromUserDefaults(for: "LEVEL") {
            
            //country admin level
            if selectedLevel == "LEVEL-0" {
                
                if self.countryObjectArray.count != 0 {
                    self.theViewC?.enable(countryObjectArray, mode: MaplyThreadAny)
                }
                else{
                    self.addCountryBoundaries()
                }
                
                self.theViewC?.disableObjects(statesObjectArray, mode: MaplyThreadAny)
            }
                //state admin level
            else if selectedLevel == "LEVEL-1" {
                
                if self.countryObjectArray.count != 0 {
                    self.theViewC?.enable(countryObjectArray, mode: MaplyThreadAny)
                }
                else{
                    self.addCountryBoundaries()
                }
                
                if self.statesObjectArray.count != 0 {
                    self.theViewC?.enable(statesObjectArray, mode: MaplyThreadAny)
                }
                else{
                    self.addStatesBoundaries()
                }
            }
        }
            //No level found - in case of something wrong
        else{
            if self.countryObjectArray.count != 0 {
                self.theViewC?.enable(countryObjectArray, mode: MaplyThreadAny)
            }
            else{
                self.addCountryBoundaries()
            }
            
            self.theViewC?.disableObjects(statesObjectArray, mode: MaplyThreadAny)
        }
    }
    
    func addCountryBoundaries() {
        
        self.countryObjectArray.removeAll()
        
        // handle this in another thread
        let queue = DispatchQueue.global()
        queue.async {
            let bundle = Bundle.main
            let allOutlines = bundle.paths(forResourcesOfType: "geojson", inDirectory: "country_json")
            
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
                    let obj = self.theViewC?.addVectors([wgVecObj], desc: self.vectorDictBoundary)
                    if let maplyObj = obj {
                        self.countryObjectArray.append(maplyObj)
                    }
                    var c = wgVecObj.center()
                    wgVecObj.centroid(&c)
                }
            }
        }
    }
    
    func addStatesBoundaries() {
        
        self.statesObjectArray.removeAll()
        
        // handle this in another thread
        let queue = DispatchQueue.global()
        queue.async {
            let bundle = Bundle.main
            let allOutlines = bundle.paths(forResourcesOfType: "geojson", inDirectory: "state_json")
            
            for outline in allOutlines.reversed() {
                
                if let jsonData = NSData(contentsOfFile: outline),
                    let wgVecObj = MaplyVectorObject(fromGeoJSON: jsonData as Data) {
                    
                    wgVecObj.selectable = true
                    
                    
                    // add the outline to our view
                    let obj = self.theViewC?.addVectors([wgVecObj], desc: self.vectorDictBoundary)
                    
                    if let maplyObj = obj {
                        self.statesObjectArray.append(maplyObj)
                    }
                }
            }
        }
    }
    
    func addDistrictBoundaries() {
        let path = Bundle.main.path(forResource: "district_json/united_states", ofType: nil)
        if let path = path  {
            let url: URL = URL(fileURLWithPath: path)
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
                
                for directory in directoryContents {
                    let file = directory.appendingPathComponent("shape.geojson")
                    if let jsonData = NSData(contentsOf: file),
                        let wgVecObj = MaplyVectorObject(fromGeoJSON: jsonData as Data) {
                        
                        wgVecObj.selectable = true
                        
                        // add the outline to our view
                        let obj = self.theViewC?.addVectors([wgVecObj], desc: self.vectorDictBoundary)
                        if let maplyObj = obj {
                            self.districtObjectArray.append(maplyObj)
                        }
                    }
                }
                
                // now do whatever with the onlyFileNamesStr & subdirNamesStr
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func colorCountry(vectorDict: [String : AnyObject], country: String, date: String) {
   
        
        var dict: [String: Any] = [:]
        
        // handle this in another thread
        let queue = DispatchQueue.global()
        queue.async {
            let bundle = Bundle.main
            let allOutlines = bundle.paths(forResourcesOfType: "geojson", inDirectory: "country_json")
            
            for outline in allOutlines {
                if let jsonData = NSData(contentsOfFile: outline),
                    let wgVecObj = MaplyVectorObject(fromGeoJSON: jsonData as Data) {
                    
                    wgVecObj.selectable = true
                    
                    // the admin tag from the country outline geojson has the country name ­ save
                    if let attrs = wgVecObj.attributes,
                        let vecNameee = attrs.object(forKey: "ADMIN") as? NSObject {
                        
                        if let coun = vecNameee as? String, coun == country {
                            self.vecName = vecNameee
                            wgVecObj.userObject = self.vecName
                            
                            // add the outline to our view
                            let obj = self.theViewC?.addVectors([wgVecObj], desc: vectorDict)
                            if let maplyObj = obj {
                                
                            
                                    dict["country"] = country
                                    dict["date"] = date
                                    dict["color_object"] = [maplyObj]
                                
                                 self.colorArray.append(dict)
                                
                                
                            }
                            var c = wgVecObj.center()
                            wgVecObj.centroid(&c)
                        }
                    }
                }
            }
        }
    }
    
    func colorState(ofCountry country: String, vectorDict: [String : AnyObject], date: String, file: String, state: String) {
        
        self.statesObjectColorArray.removeAll()
        
        // handle this in another thread
        let queue = DispatchQueue.global()
        queue.async {
          
                if let jsonData = NSData(contentsOfFile: file),
                    let wgVecObj = MaplyVectorObject(fromGeoJSON: jsonData as Data) {
              
                    
                    wgVecObj.selectable = true
                    
                    print(wgVecObj.splitVectors().count)
                    
                    
                    
                    // the admin tag from the country outline geojson has the country name ­ save
                    if let attrs = wgVecObj.attributes,
                        let vecNameee = attrs.object(forKey: "name") as? NSObject {
                        
                    
          
                        //print(attrs)
                        
                        if let st = vecNameee as? String, state == st {
                            self.vecName = vecNameee
                            wgVecObj.userObject = self.vecName
                            
                            // add the outline to our view
                            let obj = self.theViewC?.addVectors([wgVecObj], desc: vectorDict)
                            if let maplyObj = obj {
                                self.statesObjectColorArray.append(maplyObj)
                            }
                            var c = wgVecObj.center()
                            wgVecObj.centroid(&c)
                        }
                    }
                }
            
            
          //  var dict: [String: Any] = [:]
            
//            if self.countryObjectColorArray.count != 0 {
//                dict["country"] = country
//                dict["date"] = date
//                dict["color_object"] = self.statesObjectColorArray
//            }
            
          //  self.colorArray.append(dict)
        }
    }
    
    func colorArea(json: [JSONData], currentAdminLevel: String, country: String, date: String) {
        
        //if current admin level = 0 -> COUNTRY SAME COLOR
        // fetch geojson file for that country and pass maplyfilled color
        
        guard json.count != 0 else { return }
        
        var vectorDictLocal: [String:AnyObject] = [:]
        
        var colorValue: Float = 0.0
        
        //COUNTRY SAME COLOR
        if currentAdminLevel == "LEVEL-0" {
            
            if  let mean_ndvi = json[0].mean_ndvi,
                let floatNDVI = Float(mean_ndvi),
                let mean_anomaly = json[0].mean_anomaly,
                let floatAnomaly = Float(mean_anomaly) {
                
                //NDVI
                if getCurrentDataType() == "NDVI" {
                    colorValue = floatNDVI * 100
                }
                    //ANOMALY
                else{
                    colorValue = floatAnomaly * 100
                }
                
                if let color = ColorMap().getColor(colorValue: colorValue) {
                    vectorDictLocal = [
                        kMaplyColor: color,
                        kMaplySelectable: true as AnyObject,
                        kMaplyFilled: true as AnyObject,
                        kMaplyDrawPriority: 3.0 as AnyObject
                    ]
                    
                    updateViewsVisibility()
                    colorCountry(vectorDict: vectorDictLocal, country: country, date: date)
                }
                else{
                    self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
                }
            }
        }
            //STATE WISE COLOR
        else if currentAdminLevel == "LEVEL-1" {
            
            
            //find the geojson file for that country from bundle
            // apply for loop with the same file and match name everytime with state name from json everytime, if it matches color it accordingly.
        
                let bundle = Bundle.main
                let allOutlines = bundle.paths(forResourcesOfType: "geojson", inDirectory: "state_json")
                
                for outline in allOutlines {
                  
                    let fileUrl = NSURL(fileURLWithPath: outline)
                
                    if  let fileName = fileUrl.lastPathComponent, fileName == country + ".geojson" {
                        
                        //we got the geojson file of the country, now apply for loop on the same file
                        
                        for index in 0..<1 {
                            
                            print(json[index])
                            
                            if  let mean_ndvi = json[index].mean_ndvi,
                                let floatNDVI = Float(mean_ndvi),
                                let state = json[index].state,
                                let mean_anomaly = json[index].mean_anomaly,
                                let floatAnomaly = Float(mean_anomaly) {
                                
                                //NDVI
                                if self.getCurrentDataType() == "NDVI" {
                                    colorValue = floatNDVI * 100
                                }
                                    //ANOMALY
                                else{
                                    colorValue = floatAnomaly * 100
                                }
                                
                                if let color = ColorMap().getColor(colorValue: colorValue) {
                                    vectorDictLocal = [
                                        kMaplyColor: color,
                                        kMaplySelectable: true as AnyObject,
                                        kMaplyFilled: true as AnyObject,
                                        kMaplyDrawPriority: 3.0 as AnyObject
                                    ]
                                    
                                    self.updateViewsVisibility()
                                    self.colorState(ofCountry: country, vectorDict: vectorDictLocal, date: date, file: outline, state: state)
                                }
                                else{
                                   //error
                                }
                            }
                        }
                    }
            }
        }
        //DISTRICT WISE COLOR
        else{
            
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
                let color_object = param["color_object"] as? [MaplyComponentObject] {
                
                for j in 0..<color_object.count {
                    //same country selected and different date - so clean old data
                    if selectedCountry == country && currentSelectedDate != date {
                        //remove old data from dataparam too
                        self.dataParams.remove(at: index)
                        self.theViewC?.remove(color_object[j])
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
        }
        return isValidDateCountry
    }
    
    // Unified method to handle the selection
    private func handleSelection(selectedObject: NSObject, date: String = "") {
        if let selectedObject = selectedObject as? MaplyVectorObject {
            var loc = selectedObject.center()
            let _ =  selectedObject.centroid(&loc)
            if let country = selectedObject.userObject as? String {
                
                if colorArray.count != 0 {
                    //validate here
                    if validateSelectedCountry(for: colorArray, selectedCountry: country, currentSelectedDate: date) {
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
        if let dateSelected = dateSelected, dateSelected != "" {
            handleSelection(selectedObject: selectedObj, date: dateSelected)
        }
        else{
            self.alertMessage(title: "ALERT", message: "Please select the date first!")
        }
    }
    
    // This is the version for a map
    func maplyViewController(_ viewC: MaplyViewController, didSelect selectedObj: NSObject) {
        if let dateSelected = dateSelected, dateSelected != ""  {
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
    
    //MARK: Service Calling
    func getJSONDataServiceCall(date: String, country: String){
        let param: Dictionary<String, Any> =
            [
                "date"               : date                     as Any,
                "country"            : country                  as Any,
                "admin_level"        : getCurrentAdminLevel()   as Any,
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
                        self.appendExportData(json: self.json, params: param)
                        self.colorArea(json: self.json, currentAdminLevel: self.getCurrentAdminLevel(), country: country, date: date)
                    }
                    else{
                        self.alertMessage(title: ALERT_TITLE, message: NO_DATA_AVAILABLE + " " + date + ", " + country)
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
    
    func appendExportData(json: [JSONData], params: [String : Any]) {
        var dict: [String : Any] = [:]
        dict["params"] = params
        dict["json_data"] = json
        
        if dict.count != 0 {
            dataToExport.append(dict)
        }
    }
    
    func setupMailFiles() -> ([Data]?, [String]?)? {
        
        if dataToExport.count != 0 {
          return self.generateCSV()
        }
        //no data to attach - show him error
        else{
            self.showInfoAlert(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
        }
        
        return nil
    }
    
    //country wise
    func generateCSV() -> ([Data]?, [String]?)?  {
        var filePathArray: [String] = []
        var fileNameArray: [String] = []
        var dataArray: [Data] = []
        var header = [String]()
        for index in 0..<dataToExport.count {
            
            let data: NSMutableArray  = NSMutableArray()
            
            if  let dataAtIndex = dataToExport[index] as? [String : Any],
                let paramsDict = dataAtIndex["params"] as? [String : Any],
                let country = paramsDict["country"] as? String,
                let date = paramsDict["date"] as? String,
                let jsonData = dataAtIndex["json_data"] as? [Any] {
                
                for j in 0..<jsonData.count {
                    
                    if  let jsonForRow = jsonData[j] as? JSONData {
                        
                        
                        if self.getCurrentAdminLevel() == "LEVEL-0" {
                            
                            header = ["country", "start_date", "mean_ndvi", "mean_ndvi_count", "mean_anomaly", "mean_anomaly_count"]
                            
                            //valid data
                            let jsonObject = JSONExportData()
                            jsonObject.country = jsonForRow.country
                            jsonObject.start_date = jsonForRow.start_date
                            jsonObject.mean_ndvi = jsonForRow.mean_ndvi
                            jsonObject.mean_ndvi_count = jsonForRow.mean_ndvi_count
                            jsonObject.mean_anomaly = jsonForRow.mean_anomaly
                            jsonObject.mean_anomaly_count = jsonForRow.mean_anomaly_count
                            
                            data.add(listPropertiesWithValues(jsonObject))
                            
                        }
                        else if self.getCurrentAdminLevel() == "LEVEL-1" {
                            
                            header = ["country", "state", "start_date", "mean_ndvi","mean_ndvi_count", "mean_anomaly", "mean_anomaly_count"]
                            
                            //valid data
                            let jsonObject = JSONExportData()
                            jsonObject.country = jsonForRow.country
                            jsonObject.country = jsonForRow.state
                            jsonObject.start_date = jsonForRow.start_date
                            jsonObject.mean_ndvi = jsonForRow.mean_ndvi
                            jsonObject.mean_ndvi_count = jsonForRow.mean_ndvi_count
                            jsonObject.mean_anomaly = jsonForRow.mean_anomaly
                            jsonObject.mean_anomaly_count = jsonForRow.mean_anomaly_count
                            
                            data.add(listPropertiesWithValues(jsonObject))
                        }
                        else if self.getCurrentAdminLevel() == "LEVEL-2" {
                            
                           header = ["country", "state", "district", "start_date", "mean_ndvi","mean_ndvi_count", "mean_anomaly", "mean_anomaly_count"]
                            
                            //valid data
                            let jsonObject = JSONExportData()
                            jsonObject.country = jsonForRow.country
                            jsonObject.state = jsonForRow.state
                            jsonObject.district = jsonForRow.district
                            jsonObject.start_date = jsonForRow.start_date
                            jsonObject.mean_ndvi = jsonForRow.mean_ndvi
                            jsonObject.mean_ndvi_count = jsonForRow.mean_ndvi_count
                            jsonObject.mean_anomaly = jsonForRow.mean_anomaly
                            jsonObject.mean_anomaly_count = jsonForRow.mean_anomaly_count
                            
                            data.add(listPropertiesWithValues(jsonObject))
                        }
                    }
                }
                
            
                // Create a object for write CSV
                let writeCSVObj = CSV()
                writeCSVObj.rows = data
                writeCSVObj.delimiter = DividerType.comma.rawValue
                writeCSVObj.fields = header as NSArray
                writeCSVObj.name = "\(country)_\(date)"
                
                let output = CSVExport.export(writeCSVObj);
                if output.result.isSuccess {
                    guard let filePath =  output.filePath else {
                        print("Export Error: \(String(describing: output.message))")
                        self.showInfoAlert(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
                        return nil
                    }
                    filePathArray.append(filePath)
                    fileNameArray.append("\(country)_\(date)")
                }
            }
        }
        
        //read csv and add it to mailcomposer
        let fileManager = FileManager.default
        for j in 0..<filePathArray.count {
            if fileManager.fileExists(atPath: filePathArray[j]){
                if let cert = NSData(contentsOfFile: filePathArray[j]) {
                    dataArray.append(cert as Data)
                }
            }
        }
        return (dataArray, fileNameArray)
    }
}
