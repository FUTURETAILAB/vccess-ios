//
//  PhoneNumberViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/6/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class PhoneNumberViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        if let nav = self.navigationController
        {
            nav.navigationBar.shadowImage = UIImage()
            nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
            nav.navigationBar.shadowImage = UIImage()
            nav.navigationBar.isTranslucent = true
        }
        
    }
    
    @IBAction func send(sender: UIButton)
    {
        self.performSegue(withIdentifier: "sgCode", sender: nil)
    }
    
}
