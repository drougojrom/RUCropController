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
    
    override var frame: CGRect {
        didSet {
            layoutLines()
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.clipsToBounds = true
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        layoutLines()
    }
    
    func setup() {
        let newLineView: (() -> UIView)? = {(_: Void) -> UIView in
            return self.createNewLineView()
        }
        
        outerLineViews = NSArray(array: [newLineView, newLineView, newLineView, newLineView])
        topLeftLineViews = NSArray(array: [newLineView, newLineView])
        bottomLeftLineViews = NSArray(array: [newLineView, newLineView])
        topRightLineViews = NSArray(array: [newLineView, newLineView])
        bottomRightLineViews = NSArray(array: [newLineView, newLineView])
        //displayHorizontalGridLines = true
        //displayVerticalGridLines = true
    }
    
    func layoutLines() {
        
    }
    
    func createNewLineView() -> UIView {
        
        
        return UIView()
    }
}


