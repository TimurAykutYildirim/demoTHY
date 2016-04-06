//
//  ModalWindow.swift
//  LeftSlideoutMenu
//
//  Created by Timur Aykut Yildirim on 15/02/2016.
//  Copyright (c) 2016 Timur Aykut Yildirim. All rights reserved.
//

import UIKit

class ModalWindow : UIViewController {
    
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
