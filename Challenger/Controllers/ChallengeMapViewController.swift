//
//  ChallengeMapViewController.swift
//  Challenger
//
//  Created by Andras Sziffer on 2020. 09. 24..
//  Copyright © 2020. Andras Sziffer. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ChallengeMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        /*
        guard let route = ChallengeManager.shared.getChallenge()?.route else {
            return
        }
                
        let startingPoint = CLLocation(latitude: route[0].latitude, longitude: route[0].longitude)
        
        let endPoint = CLLocation(latitude: route[route.count - 1].latitude, longitude: route[route.count - 1].longitude)
        
        let zoom = startingPoint.distance(from: endPoint)
        let location = CLLocationCoordinate2D(latitude: (endPoint.coordinate.latitude + startingPoint.coordinate.latitude)*0.5, longitude: (endPoint.coordinate.longitude + startingPoint.coordinate.longitude)*0.5)
        
    
        let region = MKCoordinateRegion(center: location, latitudinalMeters: zoom, longitudinalMeters: zoom)
        mapView.setRegion(region, animated: true)
*/
        createPolyline()
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func createPolyline() {
        // TODO: do it on other thread
        var locations = Array<CLLocationCoordinate2D>()
        guard let currentChallenge = ChallengeManager.shared.getChallenge() else {
            return
        }
        
        for myLocation in currentChallenge.route {
            locations.append(CLLocationCoordinate2D(latitude: myLocation.latitude, longitude: myLocation.longitude))
        }
        
        let polyline = MKPolyline(coordinates: locations, count: ChallengeManager.shared.getChallenge()?.route.count ?? 0)
        
        //setting up zoom to the route
        var regionRect = polyline.boundingMapRect
        let wPadding = regionRect.size.width * 0.3
        let hPadding = regionRect.size.height * 0.3

        //Add padding to the region
        regionRect.size.width += wPadding
        regionRect.size.height += hPadding

        //Center the region on the line
        regionRect.origin.x -= wPadding / 2
        regionRect.origin.y -= hPadding / 2

        mapView.setRegion(MKCoordinateRegion(regionRect), animated: true)
        mapView.addOverlay(polyline)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChallengeMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let pr = MKPolylineRenderer(overlay: overlay)
        pr.strokeColor = UIColor(named: K.Color.darkRed)?.withAlphaComponent(0.8)
        pr.lineWidth = 5
        return pr
    }
}
