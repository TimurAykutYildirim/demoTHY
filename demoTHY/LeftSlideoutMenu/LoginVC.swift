//
//  LoginVC.swift
//  demoTHY
//
//  Created by Timur Aykut Yildirim on 15/02/2016.
//  Copyright (c) 2016 Timur Aykut Yildirim. All rights reserved.//

import UIKit
import KASlideShow


class LoginVC: UIViewController, KASlideShowDelegate, FBSDKLoginButtonDelegate  {
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
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
        //view.addSubview(slideshow)
        
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self // Remember to set the delegate of the loginButton
        
        /************************/
        
        let dummyData: [AnyObject] = [["id": 0, "lat": 40.898553, "lon": 29.309219, "title": "Sabiha Gökçen Havalimanı", "iata":"SAW", "icao":"LTFJ", "operator":"Malaysia Airports", "temperature":"13 °C" , "wind":"Orta Şiddetli (Güneybatı)"],
            ["id": 1, "lat": 40.976922, "lon": 28.814606, "title": "Atatürk Havalimanı", "iata":"IST", "icao":"LTBA", "operator":"TAV Airports", "temperature":"14.3 °C" , "wind":"Orta Şiddetli (Güneybatı)"],
            ["id": 2, "lat": 40.128082, "lon": 32.995083, "title": "Esenboğa Havalimanı", "iata":"ESB", "icao":"LTAC", "operator":"TAV Airports", "temperature":"11 °C" , "wind":"Sakin"],
            ["id": 3, "lat": 38.292392, "lon": 27.156953, "title": "Adnan Menderes Havalimanı", "iata":"ADB", "icao":"LTBJ", "operator":"TAV Airports", "temperature":"15 °C" , "wind":"Şiddetli (Güney)"],
            ["id": 4, "lat": 40.995108, "lon": 39.789728, "title": "Trabzon Havalimanı", "iata":"TZX", "icao":"LTCG", "operator":"DHMİ", "temperature":"26 °C" , "wind":"Şiddetli (Güney)"],
            ["id": 5, "lat": 37.893897, "lon": 40.201019, "title": "Diyarbakır Havalimanı", "iata":"DIY", "icao":"LTCC", "operator":"DHMİ", "temperature":"8 °C" , "wind":"Orta Şiddetli (Güney)"]]
        
        
        NSUserDefaults.standardUserDefaults().setObject(dummyData, forKey: "dummyData")
        NSUserDefaults.standardUserDefaults().synchronize()
        
    }
    
    func fetchProfile(){
        print("fetching profile..")
        let params = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: params).startWithCompletionHandler{ (connection, result, var error) -> Void in
            if error != nil {
                print (error)
                return
            }
            
            if let email = result["email"] as? String {
                print(email)
                NSUserDefaults.standardUserDefaults().setObject(email, forKey: "email")
            }
            
            if let first_name = result["first_name"] as? String {
                print(first_name)
                NSUserDefaults.standardUserDefaults().setObject(first_name, forKey: "first_name")
            }
            
            if let last_name = result["last_name"] as? String {
                print(last_name)
                NSUserDefaults.standardUserDefaults().setObject(last_name, forKey: "last_name")
            }
            
            if let picture = result["picture"] as? NSDictionary, data=picture["data"] as? NSDictionary, url=data["url"] as? String {
                print(url)
                NSUserDefaults.standardUserDefaults().setObject(url, forKey: "url")
            }
            
            NSUserDefaults.standardUserDefaults().synchronize()
            print(result) // this prints whole FBSDKGraphRequest API response
        }
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("login completed")
        fetchProfile()
        self.performSegueWithIdentifier("redirectAfterLogin", sender: self)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
