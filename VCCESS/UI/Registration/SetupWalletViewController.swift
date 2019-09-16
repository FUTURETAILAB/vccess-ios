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
    {
        ActivityManager.shared.incrementActivityCount()

        User.shared.login(email: "", password: "", completion:
        {
            error in
        
            ActivityManager.shared.decrementActivityCount()
            
            if let error = error
            {
                Utils.displayMessage(title: nil, message: error.localizedDescription, viewController: self)
                return()
            }
            
            if let nav = self.navigationController
                , let presenting = nav.presentingViewController
            {
                DispatchQueue.main.async
                {
                    presenting.dismiss(animated: true, completion: nil)
                }
            }
        })

    }
    
    @IBAction func setup(sender: UIButton)
    {
        ActivityManager.shared.incrementActivityCount()

        User.shared.login(email: "", password: "", completion:
        {
            error in
        
            ActivityManager.shared.decrementActivityCount()
            
            if let error = error
            {
                Utils.displayMessage(title: nil, message: error.localizedDescription, viewController: self)
                return()
            }
            
            if let nav = self.navigationController
                , let presenting = nav.presentingViewController as? MainTabBarViewController
            {
                DispatchQueue.main.async
                {
                    presenting.dismiss(animated: true, completion:
                    {
                        presenting.performSegue(withIdentifier: "sgWallet", sender: nil)
                    })
                }
            }
        })
    }

}
