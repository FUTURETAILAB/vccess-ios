//
//  ProfileCollectionViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/15/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class ProfileHeaderReusableView: UICollectionReusableView
{
    static var reuseIdentifier: String = "profileHeaderReuseIdentifier"

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnPass: UIButton!
    @IBOutlet weak var btnEdit: UIButton!

    override func awakeFromNib()
    {
        super.awakeFromNib()

        imgView.clipsToBounds = true
        imgView.layer.borderColor = UIColor(displayP3Red: 185.0/255.0, green: 151.0/255.0, blue: 90.0/255.0, alpha: 1.0).cgColor
        imgView.layer.borderWidth = 2.0
        
        btnPass.layer.borderColor = UIColor.black.cgColor
        btnPass.layer.borderWidth = 1.0

        btnEdit.layer.borderColor = UIColor.black.cgColor
        btnEdit.layer.borderWidth = 1.0
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        imgView.layer.cornerRadius = imgView.frame.size.height/2
    }
    
    @IBAction func pass(sender: UIButton)
    {
        
    }
    
    @IBAction func editProfile(sender: UIButton)
    {
        
    }
}

class ProfileCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func logout(sender: UIBarButtonItem)
    {
        User.shared.logout()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return CollectionItem.shared.testData().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        var view = UICollectionReusableView()
        
        if kind == UICollectionView.elementKindSectionHeader
        {
            if let hv = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderReusableView.reuseIdentifier, for: indexPath) as? ProfileHeaderReusableView
            {
                if let img = UIImage(named: "petdo")
                {
                    hv.imgView.image = img
                }
                
                view = hv
            }
        }
        
        return view
    }

    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell: UICollectionViewCell = UICollectionViewCell()
        
        if let c = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.reuseIdentifier, for: indexPath) as? ItemCollectionViewCell
        {
            if let image = CollectionItem.shared.testData()[indexPath.row].image
            {
                c.imgView.image = image
            }
            cell = c
        }
    
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView
        , layout collectionViewLayout: UICollectionViewLayout
        , sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let side = (collectionView.frame.size.width - 2*5)/3 - 1

        return  CGSize(width: side, height: side)
    }
}
