//
//  RUCroppedImageAttributes.swift
//  RUCropController
//
//  Created by Roman Ustiantcev on 06/10/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

import UIKit

class TOCroppedImageAttributes: NSObject {
    
    private(set) var angle: Int = 0
    private(set) var croppedFrame = CGRect.zero
    private(set) var originalImageSize = CGSize.zero
    
    init(croppedFrame: CGRect, angle: Int, originalImageSize originalSize: CGSize) {
        self.angle = angle
        self.originalImageSize = originalSize
        self.croppedFrame = croppedFrame
    }
    
    
}

