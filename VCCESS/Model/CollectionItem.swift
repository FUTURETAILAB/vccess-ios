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
    var title: String?
    var description: String?
    var imagePath: String?
    
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
        i1.title = "Kaws clean slate"
        i1.description = "vinyl figure black"
        i1.id = "abc"
        i1.imagePath = "Kaws"
        items.append(i1)

        let i2: CollectionItem = CollectionItem()
        i2.title = "Shoe"
        i2.description = "It's a shoe"
        i2.id = "abd"
        i2.imagePath = "shoe"
        items.append(i2)

        
        return items
    }
}
