//
//  RUCropOverlayView.swift
//  RUCropController
//
//  Created by Roman Ustiantcev on 06/10/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

import UIKit

@objc class RUCropOverlayView_Debug: UIView {
    
    /** Hides the interior grid lines, sans animation. */
    @objc public var gridHidden = false
    /** Add/Remove the interior horizontal grid lines. */
    @objc public var displayHorizontalGridLines = false
    /** Add/Remove the interior vertical grid lines. */
    @objc public var displayVerticalGridLines = false
    
    private let kRUCropOverLayerCornerWidth: CGFloat = 20.0
    
    var horizontalGridLines: Array<UIView>?
    var verticalGridLines: Array<UIView>?
    var outerLineViews: Array<UIView>?
    var topLeftLineViews: Array<UIView>?
    var bottomLeftLineViews: Array<UIView>?
    var bottomRightLineViews: Array<UIView>?
    var topRightLineViews: Array<UIView>?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if outerLineViews != nil {
            layoutLines()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("coder called")
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if outerLineViews != nil {
            layoutLines()
        }
    }
    
    func setup() {
        
        let newLineView: UIView = {
            return createNewLineView()
        }()
        
        outerLineViews =       [newLineView, newLineView, newLineView, newLineView]
        
        topLeftLineViews =     [newLineView, newLineView]
        bottomLeftLineViews =  [newLineView, newLineView]
        topRightLineViews =    [newLineView, newLineView]
        bottomRightLineViews = [newLineView, newLineView]
        
        displayHorizontalGridLines = true
        displayVerticalGridLines =   true
        setDisplayHorizontalGridLines(true)
        setDisplayVerticalGridLines(true)
    }
    
    func layoutLines() {
        
        let boundsSize = bounds.size
        
        //border lines
        
        for i in 0..<4 {
            let lineView = outerLineViews![i]
            var frame = CGRect.zero
            
            if i == 0 {
                frame = CGRect(x: 0, y: -1.0, width: boundsSize.width + 2, height: 1.0)
            } else if i == 1 {
                frame = CGRect(x: boundsSize.width, y: 0.0, width: 1.0, height: boundsSize.height)
            } else if i == 2 {
                frame = CGRect(x: -1.0, y: boundsSize.height, width: boundsSize.width + 2, height: 1.0)
            } else {
                frame = CGRect(x: -1.0, y: 0, width: 1.0, height: boundsSize.height+1)
            }
            lineView.frame = frame
        }
        
        // corner lines
        let cornerLines: Array<Array<UIView>> = [topLeftLineViews!, topRightLineViews!, bottomRightLineViews!, bottomLeftLineViews!]
        
        for i in 0..<4 {
            
            let cornerLine = cornerLines[i]
            var verticalFrame = CGRect.zero
            var horizontalFrame = CGRect.zero
            
            switch i {
            case 0: // top left
                verticalFrame = CGRect(x: -3.0, y: -3.0,
                                       width: 3.0, height: kRUCropOverLayerCornerWidth + 3.0)
                horizontalFrame = CGRect(x: 0, y: -3.0,
                                         width: kRUCropOverLayerCornerWidth, height: 3.0)
                break
            case 1: // top right
                verticalFrame = CGRect(x: boundsSize.width, y: -3.0,
                                       width: 3.0, height: kRUCropOverLayerCornerWidth + 3.0)
                horizontalFrame = CGRect(x: 0, y: -3.0,
                                         width: kRUCropOverLayerCornerWidth, height: 3.0)
                break
            case 2: // bottom right
                verticalFrame = CGRect(x: boundsSize.width, y: boundsSize.height-kRUCropOverLayerCornerWidth,
                                       width: 3.0, height: kRUCropOverLayerCornerWidth + 3.0)
                horizontalFrame = CGRect(x: boundsSize.width - kRUCropOverLayerCornerWidth, y: boundsSize.height,
                                         width: kRUCropOverLayerCornerWidth, height: 3.0)
                break
            case 3: // bottom left
                verticalFrame = CGRect(x: -3.0, y: boundsSize.height-kRUCropOverLayerCornerWidth,
                                       width: 3.0, height: kRUCropOverLayerCornerWidth)
                horizontalFrame = CGRect(x: -3.0, y: boundsSize.height,
                                         width: kRUCropOverLayerCornerWidth+3.0, height: 3.0)
                break
            default:
                break
            }
            cornerLine[0].frame = verticalFrame
            cornerLine[1].frame = horizontalFrame
        }
        
        //grid lines - horizontal
        let thickness: CGFloat = 1.0 / UIScreen.main.scale
        var numberOfLines: Int = horizontalGridLines!.count
        var padding: CGFloat = (bounds.height - (thickness * CGFloat(numberOfLines))) / CGFloat(numberOfLines + 1)
        for i in 0..<numberOfLines {
            let lineView: UIView? = horizontalGridLines![i]
            var frame: CGRect = CGRect.zero
            frame.size.height = thickness
            frame.size.width = bounds.width
            frame.origin.y = (padding * CGFloat(i + 1)) + CGFloat(thickness * CGFloat(i))
            lineView?.frame = frame
        }
        //grid lines - vertical
        numberOfLines = verticalGridLines!.count
        padding = (bounds.width - (thickness * CGFloat(numberOfLines))) / CGFloat(numberOfLines + 1)
        for i in 0..<numberOfLines {
            let lineView: UIView? = verticalGridLines![i]
            var frame: CGRect = CGRect.zero
            frame.size.width = thickness
            frame.size.height = bounds.height
            frame.origin.x = (padding * CGFloat(i + 1)) + (thickness * CGFloat(i))
            lineView?.frame = frame
        }
    }
    
    @objc public func setGridHidden(_ hidden: Bool, animated: Bool) {
        gridHidden = hidden
        if animated == false {
            for lineView in self.horizontalGridLines! {
                lineView.alpha = hidden ? 0.0 : 1.0
            }
            
            for lineView in self.verticalGridLines! {
                lineView.alpha = hidden ? 0.0 : 1.0
            }
            return
        }
        
        UIView.animate(withDuration: hidden ? 0.35 : 0.2, animations: {
            for lineView in self.horizontalGridLines! {
                lineView.alpha = hidden ? 0.0 : 1.0
            }
            for lineView in self.verticalGridLines! {
                lineView.alpha = hidden ? 0.0 : 1.0
            }
        })
    }
    
    // MARK: - Property methods
    func setDisplayHorizontalGridLines(_ displayHorizontalGridLines: Bool) {
        self.displayHorizontalGridLines = displayHorizontalGridLines
        if let horizontalLines = horizontalGridLines {
            for view in horizontalLines {
                view.removeFromSuperview()
            }
        }
        if displayHorizontalGridLines {
            horizontalGridLines = [createNewLineView(), createNewLineView()]
        } else {
            horizontalGridLines = []
        }
        setNeedsDisplay()
    }
    
    func setDisplayVerticalGridLines(_ displayVerticalGridLines: Bool) {
        self.displayVerticalGridLines = displayVerticalGridLines
        if let verticalLines = verticalGridLines {
            for view in verticalLines {
                view.removeFromSuperview()
            }
        }
        if displayVerticalGridLines {
            verticalGridLines = [createNewLineView(), createNewLineView()]
        } else {
            verticalGridLines = []
        }
        setNeedsDisplay()
    }


    func setGridHidden(_ gridHidden: Bool) {
        setGridHidden(gridHidden, animated: false)
    }

    // MARK: - Private methods
    func createNewLineView() -> UIView {
        let newLine = UIView(frame: CGRect.zero)
        newLine.backgroundColor = UIColor.white
        addSubview(newLine)
        return newLine
    }
}
