//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Andrea Perazzi on 04/04/15.
//  Copyright (c) 2015 Andrea Perazzi. All rights reserved.
//



// TODO: Dismiss the Activity View. Finally, after the Meme object has been saved the activity view should be dismissed. You can also call the dismissViewControllerAnimated method in the completion handler.

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var imageViewer: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var navigationBar: UINavigationBar!
    
    @IBOutlet var topTextfield: UITextField!
    @IBOutlet var bottomTextfield: UITextField!
    
    @IBOutlet var shareButton: UIBarButtonItem!
    
    
    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"
    
    let memeTextAttributes = [
        NSStrokeWidthAttributeName: -3.0,
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
        
    ]
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // MARK: - ViewController LifeCycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Enable the camrea button if the camera is aivalable
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Enable the share button if an image is available
        shareButton.enabled = (imageViewer.image != nil)
        
        
        // Subscribe to keyboard notifications, to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topTextfield.text = defaultTopText
        self.topTextfield.defaultTextAttributes = self.memeTextAttributes
        self.topTextfield.textAlignment = .Center
        
        self.bottomTextfield.text = defaultBottomText
        self.bottomTextfield.defaultTextAttributes = self.memeTextAttributes
        self.bottomTextfield.textAlignment = .Center
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe to keyboard notifications
        self.unsubscribeToKeyboardNotifications()
        
    }
    
    // MARK: - Actions
    
    // Pick image from Photo Album
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    // Pick image from camera (Take a picture)
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func shareAndSaveMeme(sender: AnyObject) {
        
        // Generate a memed image
        var memedImage = generateMemedImage()
        
        // Define an instance of ActivityViewController and pass memedImage
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        save()
        
        self.presentViewController(activityViewController, animated: true, completion: parentViewController?.dismissViewControllerAnimated(<#flag: Bool#>, completion: <#(() -> Void)?##() -> Void#>))
        
    }
    
    
    @IBAction func cancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    // MARK: - UIImagePickerController Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageViewer.image = image
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        // Clear text field only if it is different of default text
        if textField.text == defaultTopText || textField.text == defaultBottomText {
            textField.text = ""
        }
        
    }
    
    // When the user tap on return on the keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // register to the keyboard notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        // reasign the first responder to the parent view
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: - Keyboard settings
    
    // Move the view when the keyboard covers the text field
    func keyboardWillShow(notification: NSNotification) {
        
        // Move the view only if the bottom text field is in mode edit
        if bottomTextfield.editing {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    
    // Move the view back down when the keyboard is dismissed
    func keyboardWillHide(notification: NSNotification) {
        
        self.view.frame.origin.y = 0.0
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    
    
    // MARK: - Methods
    
    // Generated Meme Object
    func save() {
        // Create a meme
        let meme = Meme(
            topText: topTextfield.text!,
            bottomText: bottomTextfield.text!,
            image: imageViewer.image!,
            memedImage:  generateMemedImage())
        
        // Add it to meme array in the app delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    
    func generateMemedImage() -> UIImage {
        // Hide the toolbar and navbar
        self.toolbar.hidden = true
        self.navigationBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show the toolbar and navbar
        self.toolbar.hidden = false
        self.navigationBar.hidden = false
        
        return memedImage
    }
    

}
