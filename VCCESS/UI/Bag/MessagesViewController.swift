//
//  MessagesTableViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/22/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController
{
    @IBOutlet weak var msgSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.titleView = msgSegmentedControl
        self.tableView.isHidden = true
    }
}

extension MessagesViewController: UITableViewDataSource, UITableViewDelegate
{
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        return cell
    }
}
