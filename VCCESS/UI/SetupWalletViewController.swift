//
//  SetupWalletViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/6/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class SetupWalletViewController: UIViewController
{
    @IBOutlet weak var btnWallet: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        btnWallet.layer.borderWidth = 1
        btnWallet.layer.borderColor = UIColor.white.cgColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    @IBAction func skip(sender: UIBarButtonItem)
    {}
    
    @IBAction func setup(sender: UIButton)
    {
    }

}
