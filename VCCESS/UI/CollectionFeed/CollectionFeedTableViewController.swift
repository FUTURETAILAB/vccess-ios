//
//  CollectionFeedTableViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/22/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class CollectionFeedTableViewController: UITableViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if let vc = segue.destination as? CollectionItemDetailTableViewController
            , let item = sender as? CollectionItem
        {
            vc.collectionItem = item
        }
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
        
        if let c = tableView.dequeueReusableCell(withIdentifier: CollectionFeedTableViewCell.reuseIdentifier, for: indexPath) as? CollectionFeedTableViewCell
        {
            c.load(item: item)
            c.delegate = self
            cell = c
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard CollectionItem.shared.testData().count > indexPath.row
        else
        {
            return()
        }
        
        let item = CollectionItem.shared.testData()[indexPath.row]
        
        self.performSegue(withIdentifier: "sgCollectionItemDetail", sender: item)
    }
}

extension CollectionFeedTableViewController: CollectionFeedTableViewCellDelegate
{
    func notify(item: CollectionItem)
    {
        
    }
    
    func share(item: CollectionItem)
    {
        var items: [Any] = []
        
        if let value = item.brand { items.append(value) }
        if let value = item.title { items.append(value) }
        if let value = item.description { items.append(value) }
        if let value = item.image { items.append(value) }

        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
}
