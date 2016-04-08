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
        
        slideshow.addImagesFromResources(["1.png", "2.jpg", "3.jpg"]) // Add images from resources
        
        slideshow.addGesture(KASlideShowGestureType.All) // Gesture to go previous/next directly on the image }
        
        slideshow.start()
        
        
        /************************/
        
        let dummyData: [AnyObject] = [["id": 0, "lat": 40.898553, "lon": 29.309219, "title": "Sabiha Gökçen Havalimanı", "iata":"SAW", "icao":"LTFJ", "operator":"Malaysia Airports", "temperature":"13 °C" , "wind":"Orta Şiddetli (Güneybatı)"],
            ["id": 1, "lat": 40.976922, "lon": 28.814606, "title": "Atatürk Havalimanı", "iata":"IST", "icao":"LTBA", "operator":"TAV Airports", "temperature":"14.3 °C" , "wind":"Orta Şiddetli (Güneybatı)"],
            ["id": 2, "lat": 40.128082, "lon": 32.995083, "title": "Esenboğa Havalimanı", "iata":"ESB", "icao":"LTAC", "operator":"TAV Airports", "temperature":"11 °C" , "wind":"Sakin"],
            ["id": 3, "lat": 38.292392, "lon": 27.156953, "title": "Adnan Menderes Havalimanı", "iata":"ADB", "icao":"LTBJ", "operator":"TAV Airports", "temperature":"15 °C" , "wind":"Şiddetli (Güney)"],
            ["id": 4, "lat": 40.995108, "lon": 39.789728, "title": "Trabzon Havalimanı", "iata":"TZX", "icao":"LTCG", "operator":"DHMİ", "temperature":"26 °C" , "wind":"Şiddetli (Güney)"],
            ["id": 5, "lat": 37.893897, "lon": 40.201019, "title": "Diyarbakır Havalimanı", "iata":"DIY", "icao":"LTCC", "operator":"DHMİ", "temperature":"8 °C" , "wind":"Orta Şiddetli (Güney)"]]
        
        
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
