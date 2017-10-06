//
//  RUCropOverlayView.swift
//  RUCropController
//
//  Created by Roman Ustiantcev on 06/10/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

import UIKit

private let kRUCropOverLayerCornerWidth: CGFloat = 20.0

class RUCropOverlayView: UIView {
    
    var horizontalGridLines = NSArray()
    var verticalGridLines = NSArray()
    var outerLineViews = NSArray()
    //top, right, bottom, left
    var topLeftLineViews = NSArray()
    //vertical, horizontal
    var bottomLeftLineViews = NSArray()
    var bottomRightLineViews = NSArray()
    var topRightLineViews = NSArray()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.clipsToBounds = true
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let newLineView: ((_: Void) -> UIView)? = {(_: Void) -> UIView in
            //return self.createNewLineView()
        }
        outerLineViews = [newLineView, newLineView, newLineView, newLineView]
        topLeftLineViews = [newLineView, newLineView]
        bottomLeftLineViews = [newLineView, newLineView]
        topRightLineViews = [newLineView, newLineView]
        bottomRightLineViews = [newLineView, newLineView]
        //displayHorizontalGridLines = true
        //displayVerticalGridLines = true
    }
    
//    var frame: CGRect {
//        //layoutLines()
//    }

    
//    override func didMoveToSuperview() {
//        super.didMoveToSuperview()
//        if outerLineViews {
//            layoutLines()
//        }
//    }
    
}


