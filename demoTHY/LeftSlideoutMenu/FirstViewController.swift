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
import CNPPopupController

class FirstViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, CNPPopupControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    // following are being used for
    var groundSpeed2 = Double()
    var altitude2 = Double()
    var departureTime2 = Double()
    var arrivalTime2 = Double()
    var destination2 = String()
    var origin2 = String()
    var type2 = String()
    var ident2 = String()
    
    
    
    var popupController:CNPPopupController = CNPPopupController()
    
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
        //let flights = ["THY1","THY1055","THY1087","THY109","THY11","THY1316","THY1325","THY1346","THY1368","THY1371","THY1383","THY1395","THY1412","THY1422","THY1486","THY15","THY1505","THY1527","THY1529","THY1534","THY1555","THY1592","THY1593","THY16","THY1635","THY1673","THY1683","THY1684","THY17","THY1705","THY1723","THY1760","THY1769","THY1776","THY1818","THY1827","THY1863","THY1869","THY1875","THY1887","THY1909","THY1919","THY1962","THY1971","THY2015","THY2163","THY2170","THY2205","THY2226","THY2329","THY2334","THY2467","THY2468","THY25","THY2649","THY2677","THY2685","THY2693","THY27","THY2751","THY2833","THY2834","THY2853","THY2912","THY2932","THY307","THY33","THY334","THY35","THY354","THY382","THY402","THY415","THY47","THY5","THY5193","THY53","THY535","THY55","THY57","THY585","THY595","THY61","THY618","THY625","THY629","THY6468","THY6526","THY657","THY667","THY675","THY7","THY71","THY73","THY77","THY787","THY788","THY79","THY81","THY85","THY9","THY91","THY93"]
        let flights = ["BAW2159","KLM735","IBE6313"]
        for flight in flights {
            apiRequest(flight)
        }
        

    }
    
    /*********** CNPPOPUP SWIFT INTEGRATION BEGINS ********/
    func showPopupWithStyle(popupStyle: CNPPopupStyle, flightModel : FlightModel) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyle.alignment = NSTextAlignment.Center
        
        let result = flightModel.popupDictionary!
        let destination2 = result["destination"] as! String
        let origin2 = result["origin"] as! String
        let type2 = result["type"] as! String
        let ident2 = result["ident"] as! String
        let altitude2 = result["altitude"] as! Double
        let departureTime2 = result["departureTime"] as! Double
        let arrivalTime2 = result["arrivalTime"] as! Double
        
        let title = NSAttributedString(string: ident2, attributes: [NSFontAttributeName: UIFont.systemFontOfSize(24), NSParagraphStyleAttributeName: paragraphStyle])
        let lineOne = NSAttributedString(string: "Origin: \(origin2)- Destination: \(destination2)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18), NSParagraphStyleAttributeName: paragraphStyle])
        let lineTwo = NSAttributedString(string: "Kalkış Saati (epoch time): \(departureTime2) - Varış Saati (epoch time): \(arrivalTime2)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18), NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 0.46, green: 0.8, blue: 1.0, alpha: 1.0), NSParagraphStyleAttributeName: paragraphStyle])
        let line3 = NSAttributedString(string: "Altitude: \(altitude2) - Speed: \(groundSpeed2) kts \nType: \(type2)", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18), NSParagraphStyleAttributeName: paragraphStyle])
        
        /*
        let button = CNPPopupButton.init(frame: CGRectMake(0, 0, 200, 60))
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(18)
        button.setTitle("Close Me", forState: UIControlState.Normal)
        
        button.backgroundColor = UIColor.init(colorLiteralRed: 0.46, green: 0.8, blue: 1.0, alpha: 1.0)
        
        button.layer.cornerRadius = 4;
        button.selectionHandler = { (CNPPopupButton button) -> Void in
            self.popupController.dismissPopupControllerAnimated(true)
            print("Block for button: \(button.titleLabel?.text)")
        }*/
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0;
        titleLabel.attributedText = title
        
        let lineOneLabel = UILabel()
        lineOneLabel.numberOfLines = 0;
        lineOneLabel.attributedText = lineOne;
        
        let imageView = UIImageView.init(image: UIImage.init(named: "icon"))
        
        let lineTwoLabel = UILabel()
        lineTwoLabel.numberOfLines = 0;
        lineTwoLabel.attributedText = lineTwo;
        
        let lineThreeLabel = UILabel()
        lineThreeLabel.numberOfLines = 0;
        lineThreeLabel.attributedText = line3;
        
        /*
        let customView = UIView.init(frame: CGRectMake(0, 0, 250, 55))
        customView.backgroundColor = UIColor.lightGrayColor()
        */
        /*
        let textField = UITextField.init(frame: CGRectMake(10, 10, 230, 35))
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.placeholder = "Custom view!"
        customView.addSubview(textField)*/
        
        self.popupController = CNPPopupController(contents:[titleLabel, lineOneLabel, imageView, lineTwoLabel, lineThreeLabel]) // bu satır popup'ın sırasını belirliyor
        self.popupController.theme = CNPPopupTheme.defaultTheme()
        self.popupController.theme.popupStyle = CNPPopupStyle.ActionSheet
        self.popupController.delegate = self
        self.popupController.presentPopupControllerAnimated(true)
    }
    
    // MARK: - CNPPopupController Delegate
    
    func popupController(controller: CNPPopupController, dismissWithButtonTitle title: NSString) {
        print("Dismissed with button title \(title)")
    }
    
    func popupControllerDidPresent(controller: CNPPopupController) {
        print("Popup controller presented")
    }
    
    // Example action - TODO: replace with yours
//    @IBAction func showPopupCentered(sender: AnyObject) {
//        self.showPopupWithStyle(CNPPopupStyle.Centered)
//    }
//    @IBAction func showPopupFormSheet(sender: AnyObject) {
//        self.showPopupWithStyle(CNPPopupStyle.ActionSheet)
//    }
//    @IBAction func showPopupFullscreen(sender: AnyObject) {
//        self.showPopupWithStyle(CNPPopupStyle.Fullscreen)
//    }
    
    /*********** CNPPOPUP SWIFT INTEGRATION ENDS ********/
    
    // MARK: MKMapViewDelegate -> this is for delegate
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.lineWidth = 3.0
        renderer.alpha = 0.5
        renderer.strokeColor = UIColor.redColor()
        
        return renderer
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let planeIdentifier = "Plane" // it's because plane has landed
        
        let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(planeIdentifier)
            ?? MKAnnotationView(annotation: annotation, reuseIdentifier: planeIdentifier)
        
        if let plane = annotation as? FlightModel {
            annotationView.image = UIImage(named: "airplane")
            annotationView.annotation = plane
            annotationView.canShowCallout = false // uçağın mini-popup'ı
            plane.planeAnnotationView = annotationView
            plane.transform = self.mapView.transform
            plane.delegate = self
        }
        
        return annotationView
    }
    // Now we only need the data ( I mean the structure has to be correct)
    func togglePlanePath(plane : FlightModel){
        
        if plane.isPathVisible {
            self.mapView.removeOverlay(plane.flightpathPolyline)
            plane.isPathVisible = false
        } else {
            self.mapView.addOverlay(plane.flightpathPolyline)
            plane.isPathVisible = true
            //let popup = ARObject.popupControllerWithDictionary(plane.popupDictionary, style: .ActionSheet) // burada yeni popup'ı çağıracaksın
            //let popup = popupController
            //popup.presentPopupControllerAnimated(true)
            //popupController.presentPopupControllerAnimated(true)
            //popupController.presentPopupControllerAnimated(true)
            //[self showPopupWithStyle:CNPPopupStyleActionSheet];
            //self.popupControllerrhjwekjfkljdasşwek
            self.showPopupWithStyle(CNPPopupStyle.ActionSheet, flightModel: plane)
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
                let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as! [String : AnyObject]
                guard let result = jsonObject["InFlightInfoResult"] as? [String : AnyObject] else {
                    return
                }
                let waypointsString = result["waypoints"]
                let groundSpeed = result["groundspeed"] as! Double
                
                /*
                let destination = result["destination"] as! String
                let origin = result["origin"] as! String
                let type = result["type"] as! String
                let ident = result["ident"] as! String
                let altitude = result["altitude"] as! Double
                let departureTime = result["departureTime"] as! Double
                let arrivalTime = result["arrivalTime"] as! Double
                */
                
                
                
                
                
                
                print("groundSpeed = \(groundSpeed)")
                let planelocation = CLLocation(latitude: Double(result["latitude"] as! NSNumber), longitude: Double(result["longitude"] as! NSNumber))
                let currentCoordinate = planelocation
                
                print("\(waypointsString)")
                
                let parts = waypointsString!.componentsSeparatedByString(" ")
                
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
                
                let identificationOfThePLane = result["ident"] as? String
                
                //print("Number of waypoints: \(arrayOFWaypoint.count)")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let flightModel = FlightModel()
                    flightModel.setup(identificationOfThePLane!, groundSpeed: groundSpeed, fetchedCoordinates: arrayOFWaypoint, currentCoordinate: currentCoordinate)
                    self.models.append(flightModel)
                    flightModel.popupDictionary = result
                    
                    self.mapView.addAnnotation(flightModel)
                })
                
            } catch {
                print (error)
            }
            
            
            }
        );
        
    }
    
    func dateFromMilliseconds(ms: Double) -> String {
        
        var epocTime = NSTimeInterval(ms)
        
        let myDate = NSDate(timeIntervalSince1970: epocTime)
        print("Converted Time \(myDate)")
        
        var formatter = NSDateFormatter();
        formatter.dateFormat = "dd/MM/YYYY HH:mm:ss ZZZ";
        let defaultTimeZoneStr = formatter.stringFromDate(myDate);

        return (defaultTimeZoneStr)
        
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
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }

    
    @IBAction func toggleMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
    
    
    @IBAction func changeToSecondTabBarItemPressed(sender: AnyObject) {NSNotificationCenter.defaultCenter().postNotificationName("switchTabBar", object: nil, userInfo: ["item" : 1])
    }
    
}

