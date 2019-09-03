//
//  IntroViewController.swift
//  VCCESS
//
//  Created by Todd Mathison on 9/2/19.
//  Copyright © 2019 Todd Mathison. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController
{
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var introCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        btnSignUp.layer.borderColor = UIColor.black.cgColor
        btnSignUp.layer.borderWidth = 1.0
        
        introCollectionView.reloadData()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

extension IntroViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell: UICollectionViewCell = UICollectionViewCell()
        
        if indexPath.row == 0
        {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "intro1ReuseIdentifier", for: indexPath)
        }
        else if indexPath.row == 1
        {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "intro2ReuseIdentifier", for: indexPath)
        }
        else if indexPath.row == 2
        {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "intro3ReuseIdentifier", for: indexPath)
        }
        else if indexPath.row == 3
        {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "intro4ReuseIdentifier", for: indexPath)
        }
        else if indexPath.row == 4
        {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "intro5ReuseIdentifier", for: indexPath)
        }

        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return collectionView.frame.size
    }
    
}
