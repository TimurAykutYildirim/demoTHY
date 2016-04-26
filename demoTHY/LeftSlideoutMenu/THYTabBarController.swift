//
//  THYTabBarController.swift
//  demoTHY
//
//  Created by timur on 20/04/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit

class THYTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(THYTabBarController.changeTabBarItemWithNotification(_:)), name: "switchTabBar", object: nil)
        self.tabBar.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeTabBarItemWithNotification(notification : NSNotification) {
        if let userInfo = notification.userInfo,
            let itemIndex = userInfo["item"] as? Int {
            self.selectedIndex = itemIndex
        }
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
