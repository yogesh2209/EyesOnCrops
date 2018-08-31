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

class EMiscGlobeViewController: UIViewController, WhirlyGlobeViewControllerDelegate, MaplyViewControllerDelegate {

    private var theViewC: MaplyBaseViewController?
    private var globeViewC: WhirlyGlobeViewController?
    private var mapViewC: MaplyViewController?
    
    private let doGlobe = true
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
            globeViewC?.height = 0.8
            globeViewC?.animate(toPosition: MaplyCoordinateMakeWithDegrees(-5.93,54.597), time: 1.0)
        }
        else {
            mapViewC = MaplyViewController()
            theViewC = mapViewC
            //mapViewC?.delegate = self
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
            let maxZoom = Int32(18)
            
            // Stamen Terrain Tiles, courtesy of Stamen Design under the Creative Commons Attribution License.
            // Data by OpenStreetMap under the Open Data Commons Open Database License.
            
            guard let tileSource = MaplyRemoteTileSource(
                baseURL: "http://tile.stamen.com/terrain/",
                ext: "png",
                minZoom: 0,
                maxZoom: maxZoom)
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
        layer.drawPriority = 0
        layer.singleLevelLoading = false
        theViewC!.add(layer)
        
        // start up over San Francisco
        if let globeViewC = globeViewC {
            globeViewC.height = 0.8
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
        addCountries()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Create an empty globe and add it to the view
       
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func addCountries() {
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
                    let compObj = self.theViewC?.addVectors([wgVecObj], desc: self.vectorDict)
                    
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
    
    func globeViewController(_ viewC: WhirlyGlobeViewController, didTapAt coord: MaplyCoordinate) {
        let subtitle = NSString(format: "(%.2fN, %.2fE)", coord.y*57.296,coord.x*57.296) as String
        addAnnotationWithTitle(title: "Tap!", subtitle: subtitle, loc: coord)
    }
    
    func maplyViewController(_ viewC: MaplyViewController, didTapAt coord: MaplyCoordinate) {
        let subtitle = NSString(format: "(%.2fN, %.2fE)", coord.y*57.296,coord.x*57.296) as String
        addAnnotationWithTitle(title: "Tap!", subtitle: subtitle, loc: coord)
    }
    
    // Unified method to handle the selection
    private func handleSelection(selectedObject: NSObject) {
        if let selectedObject = selectedObject as? MaplyVectorObject {
            var c = selectedObject.center()
            let abc =  selectedObject.centroid(&c)
            let loc = c
            addAnnotationWithTitle(title: "selected", subtitle: selectedObject.userObject as! String, loc: loc)
        }
        else if let selectedObject = selectedObject as? MaplyScreenMarker {
            addAnnotationWithTitle(title: "selected", subtitle: "marker", loc: selectedObject.loc)
        }
        addSpheres()
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
    
    private func addSpheres() {
        let capitals = [MaplyCoordinateMakeWithDegrees(-77.036667, 38.895111),
                        MaplyCoordinateMakeWithDegrees(120.966667, 14.583333),
                        MaplyCoordinateMakeWithDegrees(55.75, 37.616667),
                        MaplyCoordinateMakeWithDegrees(-0.1275, 51.507222),
                        MaplyCoordinateMakeWithDegrees(-66.916667, 10.5),
                        MaplyCoordinateMakeWithDegrees(139.6917, 35.689506),
                        MaplyCoordinateMakeWithDegrees(166.666667, -77.85),
                        MaplyCoordinateMakeWithDegrees(-58.383333, -34.6),
                        MaplyCoordinateMakeWithDegrees(-74.075833, 4.598056),
                        MaplyCoordinateMakeWithDegrees(-79.516667, 8.983333)]
        
    
        // convert capitals into spheres. Let's do it functional!
        let spheres = capitals.map { capital -> MaplyShapeSphere in
            let sphere = MaplyShapeSphere()
            sphere.center = capital
            sphere.radius = 0.01
            return sphere
        }
        
        self.theViewC?.addShapes(spheres, desc: [
            kMaplyColor: UIColor(red: 0.75, green: 0.0, blue: 0.0, alpha: 0.75)])
    }
}
