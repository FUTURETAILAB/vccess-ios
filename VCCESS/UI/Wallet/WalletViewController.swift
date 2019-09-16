//
//  WalletViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/15/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    @IBAction func done(sender: UIBarButtonItem)
    {
        if let nav = self.navigationController
            , let presenting = nav.presentingViewController
        {
            DispatchQueue.main.async
            {
                presenting.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
