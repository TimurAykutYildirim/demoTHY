//
//  LoginVC.swift
//  demoTHY
//
//  Created by Timur Aykut Yildirim on 15/02/2016.
//  Copyright (c) 2016 Timur Aykut Yildirim. All rights reserved.//

import UIKit
import FBSDKLoginKit
import KASlideShow


class LoginVC: UIViewController, FBSDKLoginButtonDelegate  {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // do stuff here
        
        let slideshow = KASlideShow(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        
        slideshow.delay = 3 // Delay between transitions
        
        slideshow.transitionDuration = 1 // Transition duration
        
        slideshow.transitionType = KASlideShowTransitionType.Slide // Choose a transition type (fade or slide)
        
        slideshow.imagesContentMode = .ScaleAspectFill // Choose a content mode for images to display
        
        slideshow.addImagesFromResources(["11.jpg", "22.jpg"]) // Add images from resources
        
        slideshow.addGesture(KASlideShowGestureType.All) // Gesture to go previous/next directly on the image }
        
        slideshow.start()
        
        
        /************************/
        
        
        // Here:
        let dummyData: [AnyObject] = [["id": 0, "lat": 40.898553, "lon": 29.309219, "title": "Sabiha Gökçen Havalimanı", "iata":"SAW", "icao":"LTFJ", "operator":"Malaysia Airports", "temperature":"13 °C" , "wind":"Orta Şiddetli (Güneybatı)"],
            ["id": 1, "lat": 40.976922, "lon": 28.814606, "title": "Atatürk Havalimanı", "iata":"IST", "icao":"LTBA", "operator":"TAV Airports", "temperature":"14.3 °C" , "wind":"Orta Şiddetli (Güneybatı)"],
            ["id": 2, "lat": 40.128082, "lon": 32.995083, "title": "Esenboğa Havalimanı", "iata":"ESB", "icao":"LTAC", "operator":"TAV Airports", "temperature":"11 °C" , "wind":"Sakin"],
            ["id": 3, "lat": 38.292392, "lon": 27.156953, "title": "Adnan Menderes Havalimanı", "iata":"ADB", "icao":"LTBJ", "operator":"TAV Airports", "temperature":"15 °C" , "wind":"Şiddetli (Güney)"],
            ["id": 4, "lat": 40.995108, "lon": 39.789728, "title": "Trabzon Havalimanı", "iata":"TZX", "icao":"LTCG", "operator":"DHMİ", "temperature":"26 °C" , "wind":"Şiddetli (Güney)"],
            ["id": 5, "lat": 37.893897, "lon": 40.201019, "title": "Diyarbakır Havalimanı", "iata":"DIY", "icao":"LTCC", "operator":"DHMİ", "temperature":"8 °C" , "wind":"Orta Şiddetli (Güney)"]]
        
        /* Why don't we use the same data structure? We could but the api is really cheap also im going to use another apis of the same platform to make this more complex and take it into advanced study
        let me work on that ok:)
        
        thank you very much. take care
        
        you tooö I hope you wıll be healthy sooon thanks :)
        
        I mean we should use this:
        {
        "InFlightInfoResult": {
        "faFlightID": "TAP203-1459920567-airline-0085",
        "ident": "TAP203",
        "prefix": "",
        "type": "A332",
        "suffix": "",
        "origin": "LPPT",
        "destination": "KEWR",
        "timeout": "ok",
        "timestamp": 1460128082,
        "departureTime": 1460117183,
        "firstPositionTime": 1460117183,
        "arrivalTime": 0,
        "longitude": -34.512540000000001328,
        "latitude": 40.020589999999998554,
        "lowLongitude": -34.512540000000001328,
        "lowLatitude": 38.5393100000000004,
        "highLongitude": -9.111489999999999867,
        "highLatitude": 41.831429999999997449,
        "groundspeed": 389,
        "altitude": 410,
        "heading": 285,
        "altitudeStatus": "",
        "updateType": "TP",
        "altitudeChange": "",
        "waypoints": "38.77 -9.13 38.73 -9.32 38.7 -9.43 38.66 -9.56 38.64 -9.64 38.59 -9.84 38.54 -10 38.53 -10.16 38.51 -10.37 38.49 -10.64 38.46 -10.94 38.43 -11.27 38.42 -11.39 38.39 -11.63 38.37 -11.8 38.35 -12 38.31 -12.36 38.27 -12.73 38 -15 38 -20 39 -30 39.77 -33.32 40.84 -39 41 -40 42 -50 42.75 -55 43.07 -57.87 43 -60 41.78 -67 42.29 -70.5 42.36 -70.99 42.08 -72.14 42 -72.47 41.98 -72.52 41.98 -72.54 41.97 -72.58 41.95 -72.66 41.94 -72.68 41.94 -72.69 41.9 -72.87 41.87 -73 41.81 -73.22 41.8 -73.27 41.79 -73.31 41.76 -73.43 41.67 -73.82 41.63 -73.96 41.61 -74.05 41.6 -74.08 41.56 -74.27 41.54 -74.33 41.51 -74.35 41.42 -74.39 41.29 -74.44 41.17 -74.49 41.07 -74.54 40.83 -74.56 40.7 -74.55 40.66 -74.55 40.66 -74.55 40.66 -74.49 40.66 -74.49 40.67 -74.42 40.67 -74.39 40.68 -74.3 40.68 -74.28 40.69 -74.17"
        }
        }
        */
        
        
        NSUserDefaults.standardUserDefaults().setObject(dummyData, forKey: "dummyData")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        /************************/
        let loginButton = FBSDKLoginButton()
        loginButton.center = view.center
        loginButton.delegate = self // Remember to set the delegate of the loginButton
        view.addSubview(loginButton)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        /*
        Check for successful login and act accordingly.
        Perform your segue to another UIViewController here.
        */
        print("logged in")
        self.performSegueWithIdentifier("redirectAfterLogin", sender: self)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        // Actions for when the user logged out goes here
        print("logged out")
    }
    
}
