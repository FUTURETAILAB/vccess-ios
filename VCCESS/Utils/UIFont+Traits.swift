//
//  UIFont+Traits.swift
//  PointClub
//
//  Created by Todd Mathison on 8/4/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

extension UIFont
{
    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont
    {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else
        {
            return self
        }
        
        return UIFont(descriptor: descriptor, size: 0)
    }
    
    func without(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont
    {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(self.fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits)))
        else
        {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
