//
//  AllowNotificationsViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/6/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class AllowNotificationsViewController: UIViewController
{
    @IBOutlet weak var btnAllow: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        btnAllow.layer.borderWidth = 1
        btnAllow.layer.borderColor = UIColor.white.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushRequestComplete(sender:)), name: NSNotification.Name(rawValue: Push.PushRequestComplete), object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    @IBAction func skip(sender: UIBarButtonItem)
    {
        self.performSegue(withIdentifier: "sgWallet", sender: nil)
    }
    
    @IBAction func allow(sender: UIButton)
    {
        Push.shared.register()
    }
    
    @objc func pushRequestComplete(sender: Notification?)
    {
        DispatchQueue.main.async
        {
            self.performSegue(withIdentifier: "sgWallet", sender: nil)
        }
    }
    
}
