//
//  RUCropScrollView.swift
//  RUCropController
//
//  Created by Roman Ustiantcev on 09/10/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

import UIKit

@objc class RUCropScrollView: UIScrollView {
    
    @objc var touchesBegan: (() -> Void)?
    @objc var touchesCancelled: (() -> Void)?
    @objc var touchesEnded: (() -> Void)?
    
    @objc override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.touchesBegan != nil) {
            self.touchesBegan!()
        }
        super.touchesBegan(touches, with: event)
    }
    
    @objc override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.touchesEnded != nil) {
            self.touchesEnded!()
        }
        super.touchesEnded(touches, with: event)
    }
    
    @objc override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.touchesCancelled != nil) {
            self.touchesCancelled!()
        }
        super.touchesCancelled(touches, with: event)
    }
    
}
