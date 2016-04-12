//
//  UIViewController+RootViewController.swift
//  demoTHY
//
//  Created by timur on 12/04/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

extension UIViewController {
    func changeWindowRootToSelfAnimatedCompletion(completion : () ->Void) {
        UIView.animateWithDuration(0.3, delay: 0, options: .TransitionCrossDissolve, animations: {
            UIApplication.sharedApplication().delegate?.window!!.rootViewController = self
            }) { (finished) in
                completion()
        }
    }
}
