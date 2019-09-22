//
//  CollectionItem.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/22/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class CollectionItem
{
    public static let shared = CollectionItem()

    var id: String?
    var brand: String?
    var title: String?
    var description: String?
    var longDescription: String?
    var price: Decimal?
    var season: String?
    var color: String?
    var releaseDate: Date?
    var size: String?
    var dimensions: String?
    var ownerHistory: String?
    var latestTagCheck: Date?
    var related: [CollectionItem] = []
    var imagePath: String?
    var isFavorite: Bool = false
    
    var image: UIImage?
    {
        var img: UIImage?
        
        if let path = self.imagePath
        {
            if let i = UIImage(named: path)
            {
                img = i
            }
        }
        
        return img
    }
    
    
    func testData() -> [CollectionItem]
    {
        var items: [CollectionItem] = []
        
        let i1: CollectionItem = CollectionItem()
        i1.price = 99.50
        i1.isFavorite = true
        i1.brand = "kaws"
        i1.title = "clean slate"
        i1.description = "vinyl figure black"
        i1.id = "abc"
        i1.imagePath = "Kaws"
        i1.season = "FW18"
        i1.color = "BLACK"
        i1.releaseDate = Date(timeIntervalSinceNow: -100000)
        i1.size = "One Size"
        i1.dimensions = "14 x 7 x 7 in / 36.2 x 17.8 x 17.8"
        i1.ownerHistory = "Dead Stock"
        i1.latestTagCheck = Date(timeIntervalSinceNow: -10000)
        i1.longDescription = "To commemorate the unveiling of his new sculpture at The Modern in Forth Worth, Texas, KAWS released this Clean Slate Companion. The figure was originally released at the museum and on the museum's web shop on December 9th, followed by an online release on KAWSONE on December 12th. This figure carried a retail price of $480 and sold out quickly across both releases. Each figure comes housed in a custom box and stands at 14 inches tall. Place a bid today to secure this one-of-a-kind piece of art."
        items.append(i1)

        let i2: CollectionItem = CollectionItem()
        i2.brand = "DHL"
        i2.title = "Shoe"
        i2.description = "It's a shoe"
        i2.id = "abd"
        i2.imagePath = "shoe"
        items.append(i2)

        let i3: CollectionItem = CollectionItem()
        i3.brand = "Bearbrick"
        i3.title = "x BAPE"
        i3.description = "DSMG 5th SHARK"
        i3.id = "abe"
        i3.imagePath = "Bearbrick"
        items.append(i3)

        
        return items
    }
}
