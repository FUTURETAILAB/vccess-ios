//
//  MainTabBarViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/15/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController
{
    var previousSelectedIndex: Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        User.shared.userDelegates.add(self)
    }
    
    deinit
    {
        User.shared.userDelegates.remove(self)
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

        User.shared.unarchive()
        if User.shared.authenticationStatus != .authenticated
        {
            self.performSegue(withIdentifier: "sgRegister", sender: nil)
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        previousSelectedIndex = self.selectedIndex
    }
    
    func selectPreviousItem()
    {
        self.selectedIndex = previousSelectedIndex
    }
    
}

extension MainTabBarViewController: UserDelegate
{
    func userLogoutComplete()
    {
        DispatchQueue.main.async
        {
            self.selectedIndex = 0
            self.performSegue(withIdentifier: "sgRegisterAnimated", sender: nil)
        }
    }
    
    func userLoginComplete()
    {
        
    }
    
    func userProfileUpdated()
    {
        
    }
}
