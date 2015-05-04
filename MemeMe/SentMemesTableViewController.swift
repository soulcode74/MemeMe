//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Andrea Perazzi on 15/04/15.
//  Copyright (c) 2015 Andrea Perazzi. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var memes:[Meme]!
    @IBOutlet var tableView: UITableView!
    
    
    // MARK: ViewController LifeCycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        

        if (memes.count == 0) {
            let memeEditorViewController = self.storyboard?.instantiateViewControllerWithIdentifier("memeEditorViewController") as! MemeEditorViewController
            self.presentViewController(memeEditorViewController, animated: true, completion: nil)
            
        }
        
                                
        // Reload the data
        self.tableView.reloadData()
        
    }
    

    // MARK: TableView Delegate and DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memes.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("sentMemeCell") as! SentMemesTableViewCell
        
        var meme = self.memes[indexPath.row]
        
        cell.topText.text = meme.topText
        cell.bottomText.text = meme.bottomText
        cell.originalImage.image = meme.memedImage
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
