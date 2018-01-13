//
//  EMiscGlobeViewController.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 1/10/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit
import WhirlyGlobe

class EMiscGlobeViewController: UIViewController {

    private var theViewC: MaplyBaseViewController?
    private var globeViewC: WhirlyGlobeViewController?
    private var mapViewC: MaplyViewController?
    
    private let doGlobe = true
   
    // Set this for different view options
    let DoOverlay = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        if doGlobe {
            globeViewC = WhirlyGlobeViewController()
            theViewC = globeViewC
        }
        else {
            mapViewC = MaplyViewController()
            theViewC = mapViewC
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
                baseURL: "http://map1.vis.earthdata.nasa.gov/wmts-webmerc/MODIS_Terra_CorrectedReflectance_TrueColor/default/2015-06-07/GoogleMapsCompatible_Level9/{z}/{y}/{x}",
                ext: "jpg",
                minZoom: 0,
                maxZoom: 9)
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
        
        if DoOverlay {
            // For network paging layers, where we'll store temp files
            let cacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
            if let tileSource = MaplyRemoteTileSource(baseURL: "http://map1.vis.earthdata.nasa.gov/wmts-webmerc/Sea_Surface_Temp_Blended/default/2015-06-25/GoogleMapsCompatible_Level7/{z}/{y}/{x}",
                                                      ext: "png",
                                                      minZoom: 0,
                                                      maxZoom: 9) {
                tileSource.cacheDir = "\(cacheDir)/sea_temperature/"
                tileSource.tileInfo.cachedFileLifetime = 60*60*24 // invalidate OWM data after 24 hours
                if let temperatureLayer = MaplyQuadImageTilesLayer(coordSystem: tileSource.coordSys, tileSource: tileSource) {
                    temperatureLayer.coverPoles = false
                    temperatureLayer.handleEdges = false
                    globeViewC?.add(temperatureLayer)
                }
            }
        }
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
    


}
