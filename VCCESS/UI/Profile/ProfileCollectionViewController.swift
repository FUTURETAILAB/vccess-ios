//
//  ProfileCollectionViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/15/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class ProfileCollectionViewController: UICollectionViewController
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
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
    
        return cell
    }

}
