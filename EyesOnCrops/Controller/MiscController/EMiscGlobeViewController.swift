//
//  EMiscGlobeViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 1/10/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit
import WhirlyGlobe
import MapKit
import Alamofire
import PopupDialog

/*
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
 */

class EMiscGlobeViewController: EBaseViewController, WhirlyGlobeViewControllerDelegate, MaplyViewControllerDelegate {

    var json : [JSONData] = []
    private var theViewC: MaplyBaseViewController?
    private var globeViewC: WhirlyGlobeViewController?
    private var mapViewC: MaplyViewController?
    
    private let doGlobe = false
    private var vectorDict: [String:AnyObject]?
    private var vecName: NSObject?
   
    // Set this for different view options
    let DoOverlay = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if doGlobe {
            // If you're doing a globe
            globeViewC = WhirlyGlobeViewController()
            theViewC = globeViewC
            globeViewC?.delegate = self
            globeViewC?.animate(toPosition: MaplyCoordinateMakeWithDegrees(-5.93,54.597), time: 1.0)
          //  globeViewC?.setZoomLimitsMin(1, max: 5)
        }
        else {
            mapViewC = MaplyViewController()
            theViewC = mapViewC
            mapViewC?.delegate = self
        }
        
        self.view.addSubview(theViewC!.view)
        theViewC!.view.frame = self.view.bounds
        addChildViewController(theViewC!)
        
        // we want a black background for a globe, a white background for a map.
        theViewC!.clearColor = (globeViewC != nil) ? UIColor.black : UIColor.white
        
        // and thirty fps if we can get it ­ change this to 3 if you find your app is struggling
        theViewC!.frameInterval = 2
        
        // add the capability to use the local tiles or remote tiles
        let useLocalTiles = false
        
        // we'll need this layer in a second
        let layer: MaplyQuadImageTilesLayer
        
        if useLocalTiles {
            guard let tileSource = MaplyMBTileSource(mbTiles: "geography-class_medres")
                else {
                    print("Can't load 'geography-class_medres' mbtiles")
                    return
            }
             layer = MaplyQuadImageTilesLayer(coordSystem: tileSource.coordSys, tileSource: tileSource)
        }
        else {
            // Because this is a remote tile set, we'll want a cache directory
            let baseCacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
            let tilesCacheDir = "\(baseCacheDir)/tiles/"
            let maxZoom = Int32(9)
            
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
        }
        
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
            //globeViewC.height = 0.8
            globeViewC.animate(toPosition: MaplyCoordinateMakeWithDegrees(-122.4192, 37.7793), time: 1.0)
        }
        else if let mapViewC = mapViewC {
            mapViewC.height = 1.0
            mapViewC.animate(toPosition: MaplyCoordinateMakeWithDegrees(-122.4192, 37.7793), time: 1.0)
        }
        
//        if DoOverlay {
//            // For network paging layers, where we'll store temp files
//            let cacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
//            if let tileSource = MaplyRemoteTileSource(baseURL: "http://tile.stamen.com/terrain/",
//                                                      ext: "png",
//                                                      minZoom: 0,
//                                                      maxZoom: 9) {
//                tileSource.cacheDir = "\(cacheDir)/sea_temperature/"
//                tileSource.tileInfo.cachedFileLifetime = 60*60*24 // invalidate OWM data after 24 hours
//                if let temperatureLayer = MaplyQuadImageTilesLayer(coordSystem: tileSource.coordSys, tileSource: tileSource) {
//                    temperatureLayer.coverPoles = false
//                    temperatureLayer.handleEdges = false
//                    globeViewC?.add(temperatureLayer)
//                }
//            }
//        }
        
        vectorDict = [
            kMaplyColor: UIColor.black,
            kMaplySelectable: true as AnyObject,
            kMaplyVecWidth: 4.0 as AnyObject
        ]
        
        // add the countries
       // addCountries()
       // addStates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Create an empty globe and add it to the view
       
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        getJSONDataServiceCall()
    }
    
    private func addCountries() {
        
        //setting the zoom limit
        globeViewC?.setZoomLimitsMin(0.05, max: 3)
        
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
                    let compObj = self.globeViewC?.addVectors([wgVecObj], desc: self.vectorDict)
                    
                    var c = wgVecObj.center()
                    wgVecObj.centroid(&c)
                
                    // If you ever intend to remove these, keep track of the MaplyComponentObjects above.
                    
//                    if let vecName = self.vecName, vecName.description.count > 0 {
//                        let label = MaplyScreenLabel()
//                        label.text = vecName.description
//                        var c = wgVecObj.center()
//                        wgVecObj.centroid(&c)
//                        label.loc = c
//                        label.keepUpright =  true
//                        label.selectable = true
//                        label.layoutImportance = 10
//                        self.theViewC?.addScreenLabels([label],
//                                                       desc: [
//                                                        kMaplyFont: UIFont.boldSystemFont(ofSize: 14.0),
//                                                        kMaplyTextOutlineColor: UIColor.black,
//                                                        kMaplyTextOutlineSize: 2.0,
//                                                        kMaplyColor: UIColor.white
//                            ])
//
//                    }
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
    
   
    
    // Unified method to handle the selection
    private func handleSelection(selectedObject: NSObject) {
        if let selectedObject = selectedObject as? MaplyVectorObject {
            var loc = selectedObject.center()
            let _ =  selectedObject.centroid(&loc)
            if let _ = selectedObject.userObject as? String {
              //  addAnnotationWithTitle(title: "selected", subtitle: obj, loc: loc)
                getJSONDataServiceCall()
            }
        }
        else if let _ = selectedObject as? MaplyScreenMarker {
           // addAnnotationWithTitle(title: "selected", subtitle: "marker", loc: selectedObject.loc)
        }
    }
    
    // This is the version for a globe
    func globeViewController(_ viewC: WhirlyGlobeViewController, didSelect selectedObj: NSObject) {
        handleSelection(selectedObject: selectedObj)
    }
    
    // This is the version for a map
    func maplyViewController(_ viewC: MaplyViewController, didSelect selectedObj: NSObject) {
        handleSelection(selectedObject: selectedObj)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    func locationManager(_ manager: CLLocationManager, didChange status: CLAuthorizationStatus) {
    }
    
    private func addCoordinates(json: [JSONData]) {
        
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
            circle.radius = 0.05
            circle.color = colors[index]
            circles.append(circle)
        }
        
        // convert capitals into spheres. Let's do it functional!
//        let spheres = coordinates.map { coordinate -> MaplyShapeCircle in
//            let circle = MaplyShapeCircle()
//            circle.center = coordinate
//            circle.radius = 0.005
//            return circle
//        }
        
        theViewC?.addShapes(circles, desc: [:])
    }
    
    private func addStates() {
        // handle this in another thread
        let queue = DispatchQueue.global()
        queue.async {
            let bundle = Bundle.main
            let allOutlines = bundle.paths(forResourcesOfType: "geojson", inDirectory: "state_json")
            
            for outline in allOutlines.reversed() {
            
                if let jsonData = NSData(contentsOfFile: outline),
                    let wgVecObj = MaplyVectorObject(fromGeoJSON: jsonData as Data) {
 
                    // add the outline to our view
                    let compObj = self.globeViewC?.addVectors([wgVecObj], desc: self.vectorDict)
               
                }
            }
        }
    }
    
    
    //MARK: Service Calling
    func getJSONDataServiceCall(){
        let param: Dictionary<String, Any> =
            [
                "date"               : "2017-09-14"             as Any,
                "country"            : "Australia"              as Any,
                "action_for"         :  ACTION_FOR_JSON_DATA     as Any
                
                ] as Dictionary<String, Any>
        
        self.showAnimatedProgressBar(title: "Wait..", subTitle: "Fetching info")
        let urL = MAIN_URL + POST_GET_DATA
        Alamofire.request(urL, method: .get, parameters: param).responseJSON{ response in
            
            switch response.result {
            case .success:
       
                self.hideAnimatedProgressBar()
                
                if let json = response.result.value as? NSDictionary {
                    if let _ = json["messageResponse"] {
                        self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
                    }
                    return
                }
                
                guard let data = response.data else { return }
                
                do {
                    self.json = try JSONDecoder().decode([JSONData].self, from: data)
                    if self.json.count != 0 {
                        self.addCoordinates(json: self.json)
                    }
                }
                catch {
                    self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
                    return
                }
                
            case .failure(_ ):
                self.hideAnimatedProgressBar()
                self.alertMessage(title: ALERT_TITLE, message: SOMETHING_WENT_WRONG_ERROR)
            }
        }
    }
}

extension Float {
    func toRGB() -> Float {
        return self * 255.0
    }
}
