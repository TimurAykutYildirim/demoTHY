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
    
    // MARK: Flight Path Properties
    var flightpathPolyline: MKGeodesicPolyline!
    var planeAnnotation: MKPointAnnotation!
    var planeAnnotationPosition = 0
    var groundSpeed = Double(0) //plane relative speed regarding earth
    
    var flightPath: MKPolyline! // timur 2
    
    var fetchedCoordinates = [CLLocation]() // flight path
    var currentCoordinate : CLLocation? // current plane location
    
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
        apiRequest()
        
        
        // DEMO PIN ON MAP
        /*
        let location = CLLocationCoordinate2D(
            latitude: 16.40,
            longitude: -86.34
        )
        
        let myAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = location
        myAnnotation.title = "Roatan"
        myAnnotation.subtitle = "Honduras"
        mapView.addAnnotation(myAnnotation)
        */

    }
    
    func createNewPolylineWithCoorinates(coordinates : [CLLocation], currentPlaneCoordinate : CLLocation) {
        
        var coords = [CLLocationCoordinate2D]()
        for location in coordinates {
            coords.append(location.coordinate)
        }
        let geodesicPolyline = MKGeodesicPolyline(coordinates: &coords, count: coordinates.count) // BURDAKİ 2 NE İŞE YARIYOR?
        
        
        mapView.addOverlay(geodesicPolyline)
        print(geodesicPolyline.pointCount)
        
        flightpathPolyline = geodesicPolyline
        
        // displaying plane
        let annotation = MKPointAnnotation()
        annotation.title = NSLocalizedString("Plane", comment: "Plane marker")
        mapView.addAnnotation(annotation)
        
        self.planeAnnotation = annotation
        
        let closestPolylinePointIndex = self.getIndexOfMKMapPointInPolyline(flightpathPolyline, forCoordinate: currentPlaneCoordinate)
        self.planeAnnotationPosition = closestPolylinePointIndex
        let points = flightpathPolyline.points()
        let previousPolylineIndex = closestPolylinePointIndex > 0 ? closestPolylinePointIndex - 1 : 0
        self.previousMapPoint =  points[previousPolylineIndex]
        
        self.updatePlanePosition()
    }
    
    var planeDirection : CLLocationDirection?
    var previousMapPoint : MKMapPoint?
    var planeAnnotationView : MKAnnotationView?
    
    func knotsToMPS(knots : Double) -> Double {
        return knots * 0.514
    }
    
    func getIndexOfMKMapPointInPolyline(polyline : MKGeodesicPolyline, forCoordinate coordinate : CLLocation) -> Int {
        let points = polyline.points()
        
        
        var closestDistance = Double(999999999)
        var closestWaypointNumber = 0
        var i = 0
        for j in 0...polyline.pointCount {
            let point = points[j]
            let coor = MKCoordinateForMapPoint(point)
            let location = CLLocation(latitude: coor.latitude, longitude: coor.longitude)
            
            let distance = coordinate.distanceFromLocation(location)
            if distance < closestDistance {
                // Closest Waypoint
                closestDistance = distance
                closestWaypointNumber = i
            }
            i += 1
        }
        
        
        return closestWaypointNumber
    }
    
    
    func updatePlanePosition() {
        let step = 1 // esasında burası 5 idi!!! BURASI UÇAĞIN İLERLEME HIZINI BELİRLİYOR!!
        guard planeAnnotationPosition + step < flightpathPolyline.pointCount
            else { return }
        
        let points = flightpathPolyline.points()
        self.planeAnnotationPosition += step
        let nextMapPoint = points[planeAnnotationPosition]
        
        if let previousPoint = self.previousMapPoint {
            self.planeDirection = directionBetweenPoints(previousPoint, nextMapPoint)
        } else {
            self.previousMapPoint = nextMapPoint;
        }
        self.planeAnnotation.coordinate = MKCoordinateForMapPoint(nextMapPoint)
        
        if let annotationView = self.planeAnnotationView {
            if let planeDir = self.planeDirection {
                annotationView.transform = CGAffineTransformRotate(mapView.transform,
                    CGFloat(degreesToRadians(planeDir)))
            }
        }
        
        let previousCoordinate = MKCoordinateForMapPoint(self.previousMapPoint!)
        let previousLocation = CLLocation(latitude: previousCoordinate.latitude, longitude: previousCoordinate.longitude)
        let nextCoordinate = MKCoordinateForMapPoint(nextMapPoint)
        let nextLocation = CLLocation(latitude: nextCoordinate.latitude, longitude: nextCoordinate.longitude)
        
        let distanceBetweenTwoPoints = previousLocation.distanceFromLocation(nextLocation)
        let timeBetweenTwoPoints = distanceBetweenTwoPoints / self.knotsToMPS(self.groundSpeed)
        
        // Repeat method
        performSelector("updatePlanePosition", withObject: nil, afterDelay: timeBetweenTwoPoints) // buradaki 0.03 ikonun güncellenme hızı, ikonun ilerleme hızı değil!!
        
        self.previousMapPoint = nextMapPoint
    }
    
    private func directionBetweenPoints(sourcePoint: MKMapPoint, _ destinationPoint: MKMapPoint) -> CLLocationDirection {
        let x = destinationPoint.x - sourcePoint.x
        let y = destinationPoint.y - sourcePoint.y
        
        return radiansToDegrees(atan2(y, x)) % 360 + 90
    }
    
    private func radiansToDegrees(radians: Double) -> Double {
        return radians * 180 / M_PI
    }
    
    private func degreesToRadians(degrees: Double) -> Double {
        return degrees * M_PI / 180
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
        
        annotationView.image = UIImage(named: "airplane")
        self.planeAnnotationView = annotationView
        
        return annotationView
    }
    
    func apiRequest(){
        let urlString = "http://ufukturhan:6890ddc0551e06285a2173998813314407b4fae6@flightxml.flightaware.com/json/FlightXML2/InFlightInfo?ident=DAL422" // Your Normal URL String
        
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
                self.groundSpeed = result!["groundspeed"] as! Double
                let planelocation = CLLocation(latitude: Double(result!["latitude"] as! NSNumber), longitude: Double(result!["longitude"] as! NSNumber))
                self.currentCoordinate = planelocation
                
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
                
                print("\(arrayOFWaypoint)")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.fetchedCoordinates = arrayOFWaypoint
                    self.createNewPolylineWithCoorinates(arrayOFWaypoint, currentPlaneCoordinate: self.currentCoordinate!)
                })
                
            } catch {
                print (error)
            }
            
            
            }
        );
        
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

