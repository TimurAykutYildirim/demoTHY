//
//  ViewController.swift
//  demoTHY
//
//  Created by Timur Aykut YILDIRIM on 23/03/16.
//  Copyright © 2016 Timur Aykut YILDIRIM. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // do stuff here
        
        
        // MARK: Displaying user's location
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization() // get location only app is used
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // best accuracy-> kCLLocationAccuracyBest
            locationManager.startUpdatingLocation() // sürekli mevcut lokasyonu güncelliyor
        }
        
        self.mapView.showsUserLocation = true
        
        // MARK: API REQUEST AND PLANE PROJECTION RELATED STUFF
        
        // Let's add more flights!
        let flights = ["AVA11","UX97","EK204"]
        for flight in flights {
            apiRequest(flight)
        }
        

    }
    
    // MARK: MKMapViewDelegate -> this is for delegate
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 3.0
        renderer.alpha = 0.5
        renderer.strokeColor = UIColor.blueColor()
        
        return renderer
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let planeIdentifier = "Plane"
        
        let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(planeIdentifier)
            ?? MKAnnotationView(annotation: annotation, reuseIdentifier: planeIdentifier)
        
        if let plane = annotation as? FlightModel {
            annotationView.image = UIImage(named: "airplane")
            annotationView.annotation = plane
            annotationView.canShowCallout = true
            plane.planeAnnotationView = annotationView
            plane.transform = self.mapView.transform
            plane.delegate = self
        }
        
        return annotationView
    }
    
    func togglePlanePath(plane : FlightModel){
        
        if plane.isPathVisible {
            self.mapView.removeOverlay(plane.flightpathPolyline)
            plane.isPathVisible = false
        } else {
            self.mapView.addOverlay(plane.flightpathPolyline)
            plane.isPathVisible = true
        }
    }
    
    func apiRequest(flightNumber : String){
        //let flightIdents:[String] = ["KLM757","BER7446","FDX78","ISS39XW","FDX36"]
        let urlString = "http://ufukturhan:6890ddc0551e06285a2173998813314407b4fae6@flightxml.flightaware.com/json/FlightXML2/InFlightInfo?ident=\(flightNumber)" // Your Normal URL String
        
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)// Creating Http Request
        
        // Sending Asynchronous request using NSURLConnection
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{
            (response: NSURLResponse?, data: NSData?, error: NSError?)-> Void in
            
            // Get data as string
            do {
                let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                guard let result = jsonObject["InFlightInfoResult"] else {
                    return
                }
                let waypointsString = result!["waypoints"]
                let groundSpeed = result!["groundspeed"] as! Double
                print("groundSpeed = \(groundSpeed)")
                let planelocation = CLLocation(latitude: Double(result!["latitude"] as! NSNumber), longitude: Double(result!["longitude"] as! NSNumber))
                let currentCoordinate = planelocation
                
                print("\(waypointsString)")
                
                let parts = waypointsString!!.componentsSeparatedByString(" ")
                
                var arrayOFWaypoint = [CLLocation]()
                
                var x = 1
                var lastLatitude : String?
                for part in parts {
                    if (x%2 == 0) {
                        arrayOFWaypoint.append(CLLocation(latitude: Double(lastLatitude!)!, longitude: Double(part)!))
                    } else{
                        lastLatitude = part
                    }
                    
                    x+=1
                }
                
                print("Number of waypoints: \(arrayOFWaypoint.count)")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let flightModel = FlightModel()
                    flightModel.setup("Plane", groundSpeed: groundSpeed, fetchedCoordinates: arrayOFWaypoint, currentCoordinate: currentCoordinate)
                    self.models.append(flightModel)
                    
                    self.mapView.addAnnotation(flightModel)
                })
                
            } catch {
                print (error)
            }
            
            
            }
        );
        
    }
    
    var models = [FlightModel]()
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let region = MKCoordinateRegionMake(locValue, MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }

    
    @IBAction func toggleMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
    
}

