//
//  UIImage+CropRotate.swift
//  RUCropController
//
//  Created by Roman Ustiantcev on 06/10/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

import UIKit
import CoreGraphics

@objc public extension UIImage {
    
    @objc public func hasAlpha() -> Bool {
        let alphaInfo: CGImageAlphaInfo = cgImage!.alphaInfo
        return alphaInfo == .first || alphaInfo == .last || alphaInfo == .premultipliedFirst || alphaInfo == .premultipliedLast
    }
    
    @objc public func croppedImage(withFrame frame: CGRect, angle: Int, circularClip circular: Bool) -> UIImage {
        var croppedImage: UIImage? = nil
        UIGraphicsBeginImageContextWithOptions(frame.size, !hasAlpha() && !circular, scale)
        do {
            let context: CGContext? = UIGraphicsGetCurrentContext()
            if circular {
                context?.addEllipse(in: CGRect(origin: CGPoint.zero, size: frame.size))
                context?.clip()
            }
            //To conserve memory in not needing to completely re-render the image re-rotated,
            //map the image to a view and then use Core Animation to manipulate its rotation
            if angle != 0 {
                let imageView = UIImageView(image: self)
                imageView.layer.minificationFilter = kCAFilterNearest
                imageView.layer.magnificationFilter = kCAFilterNearest
                imageView.transform = CGAffineTransform.identity.rotated(by: CGFloat(angle) * (.pi / 180.0))
                let rotatedRect: CGRect = imageView.bounds.applying(imageView.transform)
                let containerView = UIView(frame: CGRect(origin: CGPoint.zero, size: rotatedRect.size))
                containerView.addSubview(imageView)
                imageView.center = containerView.center
                context?.translateBy(x: -frame.origin.x, y: -frame.origin.y)
                containerView.layer.render(in: context!)
            }
            else {
                context?.translateBy(x: -frame.origin.x, y: -frame.origin.y)
                draw(at: CGPoint.zero)
            }
            croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return UIImage(cgImage: (croppedImage?.cgImage)!, scale: UIScreen.main.scale, orientation: .up)
    }
}
