//
//  CollectionFeedTableViewCell.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/22/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

protocol CollectionFeedTableViewCellDelegate
{
    func notify(item: CollectionItem)
    func share(item: CollectionItem)
}

extension CollectionFeedTableViewCellDelegate
{
    func notify(item: CollectionItem){}
    func share(item: CollectionItem){}
}

class CollectionFeedTableViewCell: UITableViewCell
{
    static var reuseIdentifier: String = "collectionFeedReuseIdentifier"

    var delegate: CollectionFeedTableViewCellDelegate?
    var collectionItem: CollectionItem?
    
    @IBOutlet weak var imgViewItem: UIImageView!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var btnNotify: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        btnNotify.layer.borderColor = UIColor(displayP3Red: 138.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1.0).cgColor
        btnNotify.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func load(item: CollectionItem)
    {
        self.collectionItem = item
        self.imgViewItem.image = item.image
        self.lblTitle.text = item.title
        self.lblDescription.text = item.description
        self.btnFavorite.isSelected = item.isFavorite
    }

    @IBAction func qfTag(sender: UIButton)
    {
    }
    
    @IBAction func notify(sender: UIButton)
    {
        if let delegate = delegate
            , let item = self.collectionItem
        {
            delegate.notify(item: item)
        }
    }
    
    @IBAction func share(sender: UIButton)
    {
        if let delegate = delegate
            , let item = self.collectionItem
        {
            delegate.share(item: item)
        }
    }
    
    @IBAction func favorite(sender: UIButton)
    {
        if let item = self.collectionItem
        {
            self.collectionItem?.isFavorite = !item.isFavorite
            sender.isSelected = item.isFavorite
        }
    }

}
