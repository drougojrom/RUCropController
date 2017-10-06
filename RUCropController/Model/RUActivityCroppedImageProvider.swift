//
//  RUActivityCroppedImageProvider.swift
//  RUCropController
//
//  Created by Roman Ustiantcev on 06/10/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

import UIKit

@objc class RUActivityCroppedImageProvider: UIActivityItemProvider {
    
    private(set) var image: UIImage?
    private(set) var cropFrame = CGRect.zero
    private(set) var angle: Int = 0
    private(set) var isCircular = false

    var croppedImage: UIImage?
        
    @objc init(image: UIImage, cropFrame: CGRect, angle: Int, circular: Bool) {
        super.init(placeholderItem: UIImage())
        self.image = image
        self.cropFrame = cropFrame
        self.angle = angle
        isCircular = circular
    }
// MARK: - UIActivity Protocols -
    override func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return UIImage()
    }
    override func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType?) -> Any? {
        return croppedImage
    }
// MARK: - Image Generation -
    override var item: Any {
        //If the user didn't touch the image, just forward along the original
        
        if angle == 0 && cropFrame.equalTo(CGRect(origin: CGPoint.zero, size: self.image!.size)) {
            croppedImage = self.image
            return croppedImage
        }
        let image: UIImage? = self.image?.croppedImage(withFrame: cropFrame, angle: angle, circularClip: isCircular)
        croppedImage = image
        return croppedImage
    }
}

