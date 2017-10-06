//
//  ViewController.swift
//  RUCropController
//
//  Created by Roman Ustiantcev on 06/10/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, RUCropViewControllerDelegate {
    
    var image: UIImage!
    var imageView: UIImageView!
    var croppingStyle: RUCropViewCroppingStyle!
    var croppedFrame: CGRect!
    var angle: NSInteger!
    var activityPopoverController: UIPopoverController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "RUCropController"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCropViewController))
        
        self.imageView = UIImageView()
        self.imageView.isUserInteractionEnabled = true
        self.imageView.contentMode = .scaleAspectFit
        self.view.addSubview(self.imageView)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        self.imageView.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layoutImageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Image picker delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let cropController = RUCropViewController(croppingStyle: self.croppingStyle, image: image)
            cropController.delegate = self
            
            self.image = image
            
            if self.croppingStyle == RUCropViewCroppingStyle.circular {
                picker.pushViewController(cropController, animated: true)
            } else {
                picker.dismiss(animated: true, completion: {
                    self.present(cropController, animated: true, completion: nil)
                })
            }
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Gesture Recognizer
    
    @objc func didTapImageView() {
        let cropController = RUCropViewController(croppingStyle: self.croppingStyle, image: self.image)
        cropController.delegate = self
        
        let viewFrame = self.view.convert(self.imageView.frame, to: self.navigationController?.view)
        cropController.presentAnimated(from: self,
                                       fromImage: self.imageView.image,
                                       fromView: nil,
                                       fromFrame: viewFrame,
                                       angle: self.angle,
                                       toFrame: self.croppedFrame,
                                       setup: {
                                        self.imageView.isHidden = true
        },
                                       completion: nil)
        
    }
    
    // MARK: cropper delegate
    
    func cropViewController(_ cropViewController: RUCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        self.croppedFrame = cropRect
        self.angle = angle
        self.updateImageView(image: image, cropViewController: cropViewController)
    }
    
    func cropViewController(_ cropViewController: RUCropViewController, didCropToCircleImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        self.croppedFrame = cropRect
        self.angle = angle
        self.updateImageView(image: image, cropViewController: cropViewController)
    }
    
    func updateImageView(image: UIImage, cropViewController: RUCropViewController) {
        self.imageView.image = image
        self.layoutImageView()
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        if cropViewController.croppingStyle != RUCropViewCroppingStyle.circular {
            self.imageView.isHidden = false
            cropViewController.dismissAnimated(from: self,
                                               croppedImage: image,
                                               toView: self.imageView,
                                               toFrame: CGRect.zero,
                                               setup: {
                                                self.layoutImageView()
            },
                                               completion: {
                                                self.imageView.isHidden = false
            })
        } else {
            self.imageView.isHidden = false
            cropViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: image layout
    
    func layoutImageView() {
        if self.imageView.image == nil {
            return
        }
        
        let padding: CGFloat = 20.0
        var viewFrame = self.view.bounds
        viewFrame.size.width -= (padding * 2.0)
        viewFrame.size.height -= (padding * 2.0)
        
        var imageFrame = CGRect.zero
        imageFrame.size = self.imageView.image!.size
        
        if imageView.image!.size.width > viewFrame.size.width || self.imageView.image!.size.height > viewFrame.size.height {
            let scale = min(viewFrame.size.width / imageFrame.size.width,
                            viewFrame.size.height / imageFrame.size.height)
            imageFrame.size.width *= scale
            imageFrame.size.height *= scale
            imageFrame.origin.x = (self.view.bounds.width - imageFrame.size.width) * 0.5
            imageFrame.origin.y = (self.view.bounds.height - imageFrame.size.height) * 0.5
            self.imageView.frame = imageFrame
        } else {
            self.imageView.frame = imageFrame
            self.imageView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        }
    }
    
    // MARK: bar button Items
    
    @objc func showCropViewController() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let defaultAction = UIAlertAction(title: "Crop image", style: .default) { (action) in
            self.croppingStyle = RUCropViewCroppingStyle.default
            let standardPicker = UIImagePickerController()
            standardPicker.sourceType = .photoLibrary
            standardPicker.allowsEditing = false
            standardPicker.delegate = self
            self.present(standardPicker, animated: true, completion: nil)
        }
        
        let profileAction = UIAlertAction(title: "Make profile picture", style: .default) { (action) in
            self.croppingStyle = RUCropViewCroppingStyle.circular
            let profilePicker = UIImagePickerController()
            profilePicker.modalPresentationStyle = .popover
            profilePicker.sourceType = .photoLibrary
            profilePicker.allowsEditing = false
            profilePicker.delegate = self
            profilePicker.preferredContentSize = CGSize(width: 512, height: 512)
            profilePicker.popoverPresentationController?.barButtonItem = self.navigationItem.leftBarButtonItem
            self.present(profilePicker, animated: true, completion: nil)
        }
        
        alertController.addAction(defaultAction)
        alertController.addAction(profileAction)
        alertController.modalPresentationStyle = .popover
        let popPresent = alertController.popoverPresentationController
        popPresent?.barButtonItem = self.navigationItem.leftBarButtonItem
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sharePhoto() {
        if self.imageView.image == nil {
            return
        }
        
        let activityController = UIActivityViewController(activityItems: [self.imageView.image],
                                                          applicationActivities: nil)
        if UI_USER_INTERFACE_IDIOM() == .phone {
            self.present(activityController, animated: true, completion: nil)
        } else {
            self.activityPopoverController.dismiss(animated: true)
            self.activityPopoverController = UIPopoverController(contentViewController: activityController)
            self.activityPopoverController.present(from: self.navigationItem.rightBarButtonItem!, permittedArrowDirections: .any, animated: true)
        }
    }
    
    
}
