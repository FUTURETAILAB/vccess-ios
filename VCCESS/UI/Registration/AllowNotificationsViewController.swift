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
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    @IBAction func skip(sender: UIBarButtonItem)
    {}
    
    @IBAction func allow(sender: UIButton)
    {
        self.performSegue(withIdentifier: "sgWallet", sender: nil)
    }
}