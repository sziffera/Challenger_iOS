//
//  MapViewController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 07. 17..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        mapView.isZoomEnabled = true
        mapView.showsUserLocation = true
        mapView.showsCompass = true

        NotificationCenter.default.addObserver(self, selector: #selector(challengeMapUpdated(_:)), name: .challengeDataUpdate, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func challengeMapUpdated(_ notification: NSNotification) {
        
        if let route = LocationTracking.sharedInstance.getRoute() {
            let lastLocation = route[route.count - 1]
            let polyline = MKPolyline(coordinates: route, count: route.count)
            
            DispatchQueue.main.async {
                self.mapView.addOverlay(polyline)
                self.mapView.centerCoordinate = lastLocation
                let viewRegion = MKCoordinateRegion(center: lastLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
                self.mapView.setRegion(viewRegion, animated: false)
                self.mapView.showsUserLocation = true
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let pr = MKPolylineRenderer(overlay: overlay)
        pr.strokeColor = UIColor(named: K.Color.darkRed)?.withAlphaComponent(0.8)
        pr.lineWidth = 5
        return pr
    }
}
