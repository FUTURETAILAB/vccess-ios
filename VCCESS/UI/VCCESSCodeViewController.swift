//
//  VCCESSCodeViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/6/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class VCCESSCodeViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        if let nav = self.navigationController
        {
            nav.navigationBar.shadowImage = UIImage()
        }
    }
    
    @IBAction func enter(sender: UIButton)
    {
        self.performSegue(withIdentifier: "sgRegister", sender: nil)
    }

}
