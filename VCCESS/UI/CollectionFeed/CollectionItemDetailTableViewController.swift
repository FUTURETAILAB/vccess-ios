//
//  CollectionItemDetailTableViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/22/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class CollectionItemDetailTableViewController: UITableViewController
{
    var collectionItem: CollectionItem?
    
    @IBOutlet weak var imgViewItem: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnPrice: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        btnPrice.layer.borderColor = UIColor(displayP3Red: 138.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1.0).cgColor
        btnPrice.layer.borderWidth = 1.0

        if let item = self.collectionItem
        {
            self.title = item.brand?.uppercased()
            self.lblTitle.text = item.title
            self.lblDescription.text = item.description
            self.imgViewItem.image = item.image
            self.btnFavorite.isSelected = item.isFavorite
         
            if let image = item.image
            {
                let height = (image.size.height / image.size.width) * UIScreen.main.bounds.width
                self.tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
            }
            
            if let price = item.price
            {
                let formatter: NumberFormatter = NumberFormatter()
                formatter.numberStyle = .currency
                btnPrice.setTitle(formatter.string(from: price as NSNumber), for: .normal)
            }
        }
    }
    
    @IBAction func buy(sender: UIButton)
    {}
    
    @IBAction func share(sender: UIButton)
    {
        guard let item = self.collectionItem else { return() }
        
        var items: [Any] = []
        
        if let value = item.brand { items.append(value) }
        if let value = item.title { items.append(value) }
        if let value = item.description { items.append(value) }
        if let value = item.image { items.append(value) }

        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @IBAction func favorite(sender: UIButton)
    {
        if let item = self.collectionItem
        {
            self.collectionItem?.isFavorite = !item.isFavorite
            sender.isSelected = item.isFavorite
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        var height: CGFloat = UITableView.automaticDimension
        
        if indexPath.row > 0
        {
            height = 20
        }
        
        return height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell = UITableViewCell()
        
        guard let item = self.collectionItem else { return cell }
        
        if indexPath.row == 0
        {
            let c = tableView.dequeueReusableCell(withIdentifier: "longDescriptionReuseIdentifier", for: indexPath)
            c.textLabel?.text = item.longDescription
            cell = c
        }
        if indexPath.row == 1
        {
            let c = tableView.dequeueReusableCell(withIdentifier: "detailReuseIdentifier", for: indexPath)
            c.textLabel?.text = "SEASON"
            c.detailTextLabel?.text = item.season
            cell = c
        }
        if indexPath.row == 2
        {
            let c = tableView.dequeueReusableCell(withIdentifier: "detailReuseIdentifier", for: indexPath)
            c.textLabel?.text = "COLOR"
            c.detailTextLabel?.text = item.color
            cell = c
        }
        if indexPath.row == 3
        {
            let c = tableView.dequeueReusableCell(withIdentifier: "detailReuseIdentifier", for: indexPath)
            c.textLabel?.text = "RELEASE DATE"
            if let date = item.releaseDate
            {
                c.detailTextLabel?.text = Utils().displayDateFormatter.string(from: date)
            }
            cell = c
        }
        if indexPath.row == 4
        {
            let c = tableView.dequeueReusableCell(withIdentifier: "detailReuseIdentifier", for: indexPath)
            c.textLabel?.text = "SIZE"
            c.detailTextLabel?.text = item.size
            cell = c
        }
        if indexPath.row == 5
        {
            let c = tableView.dequeueReusableCell(withIdentifier: "detailReuseIdentifier", for: indexPath)
            c.textLabel?.text = "DIMENSIONS"
            c.detailTextLabel?.text = item.dimensions
            cell = c
        }
        if indexPath.row == 6
        {
            let c = tableView.dequeueReusableCell(withIdentifier: "detailReuseIdentifier", for: indexPath)
            c.textLabel?.text = "OWNER HISTORY"
            c.detailTextLabel?.text = item.ownerHistory
            cell = c
        }
        if indexPath.row == 7
        {
            let c = tableView.dequeueReusableCell(withIdentifier: "detailReuseIdentifier", for: indexPath)
            c.textLabel?.text = "LATEST TAG CHECK"
            if let date = item.latestTagCheck
            {
                c.detailTextLabel?.text = Utils().displayDateFormatter.string(from: date)
            }
            cell = c
        }

        
        return cell
    }

}
