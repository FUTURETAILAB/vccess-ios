//
//  ScannerViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/16/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

//  https://developer.apple.com/videos/play/wwdc2019/715/

class ScannerViewController: UIViewController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if let nav = self.navigationController
            , let tab = nav.tabBarController
        {
            tab.tabBar.isHidden = true
        }

        NFCReader.shared.start()
    }
    

    @IBAction func close(sender: UIBarButtonItem)
    {
        if let nav = self.navigationController
            , let tab = nav.tabBarController as? MainTabBarViewController
        {
            tab.selectPreviousItem()
            tab.tabBar.isHidden = false
        }
    }

}

