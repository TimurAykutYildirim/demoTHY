//
//  LeftPanViewController.swift
//  demoTHY
//
//  Created by timur on 11/04/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

class LeftPanViewController: UIViewController {

    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var pointsIcon: UILabel!

    @IBOutlet var pointsLabel: UILabel!
    
    @IBOutlet var LogoutButton: UIButton!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        profilePic.layer.borderWidth = 1
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.blackColor().CGColor
        profilePic.layer.cornerRadius = profilePic.frame.height/2
        profilePic.clipsToBounds = true
        var picURL : String = NSUserDefaults.standardUserDefaults().objectForKey("url") as! String
        if let checkedUrl = NSURL(string: picURL) {
            profilePic.contentMode = .ScaleAspectFit
            downloadImage(checkedUrl)
        }
        
        LogoutButton.setFAIcon(FAType.FASignOut, forState: .Normal)
        LogoutButton.setFATitleColor(UIColor.redColor(), forState: .Normal)
        LogoutButton.setFAText(prefixText: "", icon: FAType.FASignOut, postfixText: "", size: 25, forState: .Normal, iconSize: 30)

    }
    
    // this is for getting the data from your url
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    // this is for downloading the image
    func downloadImage(url: NSURL){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                print(response?.suggestedFilename ?? "")
                print("Download Finished")
                self.profilePic.image = UIImage(data: data)
            }
        }
    }
    

    @IBAction func logoutAction(sender: AnyObject) {
        FBSDKLoginManager().logOut()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        vc?.changeWindowRootToSelfAnimatedCompletion({ () -> Void in
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
