//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Andrea Perazzi on 19/04/15.
//  Copyright (c) 2015 Andrea Perazzi. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var memes:[Meme]!
    
    @IBOutlet var collectionView: UICollectionView!
    
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        
        collectionView.reloadData()
        
    }
    
    
    // MARK: - CollectionView DataSource and Delegate
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("sentMemeCollectionCell", forIndexPath: indexPath) as! SentMemesCollectionViewCell

        let meme = memes[indexPath.item]
        
        cell.memedImage.image = meme.memedImage
    
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let detailView:MemeDetailViewController!
        
        detailView = self.storyboard?.instantiateViewControllerWithIdentifier("memeDetailViewController") as! MemeDetailViewController
        
        let meme = memes[indexPath.row]
        
        detailView.passedImage = meme.memedImage
        
        detailView.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(detailView, animated: true)

    }
    
    
    // MARK: - Actions
    
    @IBAction func addMeme(sender: AnyObject) {
        
        let memeEditorViewController:MemeEditorViewController
        
        memeEditorViewController = self.storyboard?.instantiateViewControllerWithIdentifier("memeEditorViewController") as! MemeEditorViewController
        
        self.presentViewController(memeEditorViewController, animated: true, completion: nil)
        
    }
    

}
