//
//  SignInTableViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/2/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class SignInTableViewController: UITableViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    @IBAction func signIn(sender: UIButton)
    {
        self.performSegue(withIdentifier: "sgNotifications", sender: nil)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }


}
