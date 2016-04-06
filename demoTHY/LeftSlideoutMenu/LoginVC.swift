//
//  LoginVC.swift
//  demoTHY
//
//  Created by Timur Aykut Yildirim on 15/02/2016.
//  Copyright (c) 2016 Timur Aykut Yildirim. All rights reserved.//

import UIKit
import FBSDKLoginKit

class LoginVC: UIViewController, FBSDKLoginButtonDelegate  {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // do stuff here
        
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
