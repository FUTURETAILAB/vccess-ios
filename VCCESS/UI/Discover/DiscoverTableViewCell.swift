//
//  DiscoverTableViewCell.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/22/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell
{
    static var reuseIdentifier: String = "discoverReuseIdentifier"

    var collectionItem: CollectionItem?
    
    @IBOutlet weak var imgViewItem: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnShopNow: UIButton!

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        btnShopNow.layer.cornerRadius = btnShopNow.frame.size.height/2
    }
    
    func load(item: CollectionItem)
    {
        self.collectionItem = item
        self.imgViewItem.image = item.image
        self.lblTitle.text = "\(item.brand ?? ""): \(item.title ?? "")"
    }

}
