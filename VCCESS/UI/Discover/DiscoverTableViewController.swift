//
//  DiscoverTableViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/22/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class DiscoverTableViewController: UITableViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return CollectionItem.shared.testData().count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var height: CGFloat = 0
        
        guard CollectionItem.shared.testData().count > indexPath.row
            else { return height }

        let item = CollectionItem.shared.testData()[indexPath.row]
        
        guard let image = item.image
            else { return height }

        height = (image.size.height / image.size.width) * tableView.frame.size.width
        
        return height
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = UITableViewCell()
        
        guard CollectionItem.shared.testData().count > indexPath.row
        else
        {
            return cell
        }
        
        let item = CollectionItem.shared.testData()[indexPath.row]
        
        if let c = tableView.dequeueReusableCell(withIdentifier: DiscoverTableViewCell.reuseIdentifier, for: indexPath) as? DiscoverTableViewCell
        {
            c.load(item: item)
            cell = c
        }
        
        return cell
    }
}
