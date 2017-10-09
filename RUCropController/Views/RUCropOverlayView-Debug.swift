////
////  RUCropOverlayView.swift
////  RUCropController
////
////  Created by Roman Ustiantcev on 06/10/2017.
////  Copyright © 2017 Roman Ustiantcev. All rights reserved.
////
//
//import UIKit
//
//private let kRUCropOverLayerCornerWidth: CGFloat = 20.0
//
//@objc class RUCropOverlayView: UIView {
//
//    /** Hides the interior grid lines, sans animation. */
//    @objc var isGridHidden = false
//    /** Add/Remove the interior horizontal grid lines. */
//    @objc var isDisplayHorizontalGridLines = false
//    /** Add/Remove the interior vertical grid lines. */
//    @objc var isDisplayVerticalGridLines = false
//
//    var horizontalGridLines: Array<UIView>?
//    var verticalGridLines: Array<UIView>?
//    var outerLineViews: Array<UIView>?
//    //top, right, bottom, left
//    var topLeftLineViews: Array<UIView>?
//    //vertical, horizontal
//    var bottomLeftLineViews: Array<UIView>?
//    var bottomRightLineViews: Array<UIView>?
//    var topRightLineViews: Array<UIView>?
//
//    override var frame: CGRect {
//        didSet {
//            if outerLineViews != nil {
//                layoutLines()
//            }
//        }
//    }
//
//    override func draw(_ rect: CGRect) {
//        self.clipsToBounds = true
//        setup()
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func didMoveToSuperview() {
//        super.didMoveToSuperview()
//        if outerLineViews != nil {
//            layoutLines()
//        }
//    }
//
//    func newLineView() -> UIView {
//        return createNewLineView()
//    }
//
//    func setup() {
//        outerLineViews = [newLineView(), newLineView(), newLineView(), newLineView()]
//        topLeftLineViews = [newLineView(), newLineView()]
//        bottomLeftLineViews = [newLineView(), newLineView()]
//        topRightLineViews = [newLineView(), newLineView()]
//        bottomRightLineViews = [newLineView(), newLineView()]
//        isDisplayHorizontalGridLines = true
//        isDisplayVerticalGridLines = true
//    }
//
//    func layoutLines() {
//
//        let boundsSize = bounds.size
//
//        //border lines
//
//        for i in 0..<3 {
//            let lineView = self.outerLineViews![i]
//            frame = CGRect.zero
//            switch i {
//            case 0:
//                frame = CGRect(x: 0, y: -1, width: boundsSize.width + 2, height: 1.0) // top
//            case 1:
//                frame = CGRect(x: boundsSize.width, y: 0, width: 1.0, height: boundsSize.height) // right
//            case 2:
//                frame = CGRect(x: -1.0, y: boundsSize.height, width: boundsSize.width + 2, height: 1.0) // bottom
//            case 3:
//                frame = CGRect(x: -1.0, y: 0, width: 1.0, height: boundsSize.height + 1.0) // left
//            default:
//                break
//            }
//            lineView.frame = frame
//        }
//        // corner lines
//        let cornerLines: NSArray = NSArray(array: [topLeftLineViews,
//                                                   topRightLineViews,
//                                                   bottomRightLineViews,
//                                                   bottomLeftLineViews])
//
//        for i in 0..<3 {
//            let cornerLine = cornerLines[i] as! NSArray
//            var verticalFrame = CGRect.zero
//            var horizontalFrame = CGRect.zero
//
//            switch i {
//            case 0: // top left
//                verticalFrame = CGRect(x: -3.0, y: -3.0,
//                                       width: 3.0, height: kRUCropOverLayerCornerWidth + 3.0)
//                horizontalFrame = CGRect(x: 0, y: -3.0,
//                                         width: kRUCropOverLayerCornerWidth, height: 3.0)
//            case 1: // top right
//                verticalFrame = CGRect(x: boundsSize.width, y: -3.0,
//                                       width: 3.0, height: kRUCropOverLayerCornerWidth + 3.0)
//                horizontalFrame = CGRect(x: 0, y: -3.0,
//                                         width: kRUCropOverLayerCornerWidth, height: 3.0)
//            case 2: // bottom right
//                verticalFrame = CGRect(x: boundsSize.width, y: boundsSize.height-kRUCropOverLayerCornerWidth,
//                                       width: 3.0, height: kRUCropOverLayerCornerWidth + 3.0)
//                horizontalFrame = CGRect(x: boundsSize.width - kRUCropOverLayerCornerWidth, y: boundsSize.height,
//                                         width: kRUCropOverLayerCornerWidth, height: 3.0)
//            case 3: // bottom left
//                verticalFrame = CGRect(x: -3.0, y: boundsSize.height-kRUCropOverLayerCornerWidth,
//                                       width: 3.0, height: kRUCropOverLayerCornerWidth)
//                horizontalFrame = CGRect(x: -3.0, y: boundsSize.height,
//                                         width: kRUCropOverLayerCornerWidth+3.0, height: 3.0)
//            default:
//                break
//            }
//            (cornerLine[0] as? UIView)?.frame = verticalFrame
//            (cornerLine[1] as? UIView)?.frame = horizontalFrame
//        }
//
//        //grid lines - horizontal
//        let thickness: CGFloat = 1.0 / UIScreen.main.scale
//        var numberOfLines: Int = horizontalGridLines!.count
//        var padding: CGFloat = (bounds.height - (thickness * CGFloat(numberOfLines))) / CGFloat(numberOfLines + 1)
//        for i in 0..<numberOfLines {
//            let lineView: UIView? = horizontalGridLines![i] as? UIView
//            var frame: CGRect = CGRect.zero
//            frame.size.height = thickness
//            frame.size.width = bounds.width
//            frame.origin.y = (padding * CGFloat(i + 1)) + CGFloat(thickness * CGFloat(i))
//            lineView?.frame = frame
//        }
//        //grid lines - vertical
//        numberOfLines = (verticalGridLines?.count)!
//        padding = (bounds.width - (thickness * CGFloat(numberOfLines))) / CGFloat(numberOfLines + 1)
//        for i in 0..<numberOfLines {
//            let lineView: UIView? = verticalGridLines![i] as? UIView
//            var frame: CGRect = CGRect.zero
//            frame.size.width = thickness
//            frame.size.height = bounds.height
//            frame.origin.x = (padding * CGFloat(i + 1)) + (thickness * CGFloat(i))
//            lineView?.frame = frame
//        }
//    }
//
//     @objc func setGridHidden(_ hidden: Bool, animated: Bool) {
//        isGridHidden = hidden
//        if animated == false {
//            for lineView in self.horizontalGridLines! {
//                if let lineView = lineView as? UIView {
//                    lineView.alpha = hidden ? 0.0 : 1.0
//                }
//            }
//
//            for lineView in self.verticalGridLines! {
//                if let lineView = lineView as? UIView {
//                    lineView.alpha = hidden ? 0.0 : 1.0
//                }
//            }
//            return
//        }
//
//        UIView.animate(withDuration: hidden ? 0.35 : 0.2, animations: {
//            for lineView in self.horizontalGridLines! {
//                if let lineView = lineView as? UIView {
//                    lineView.alpha = hidden ? 0.0 : 1.0
//                }
//            }
//
//            for lineView in self.verticalGridLines! {
//                if let lineView = lineView as? UIView {
//                    lineView.alpha = hidden ? 0.0 : 1.0
//                }
//            }
//        })
//    }
//
//    // MARK: - Property methods
//    func setDisplayHorizontalGridLines(_ displayHorizontalGridLines: Bool) {
//        self.isDisplayHorizontalGridLines = displayHorizontalGridLines
//        for view in horizontalGridLines! {
//            view.removeFromSuperview()
//        }
//        if self.isDisplayHorizontalGridLines {
//            horizontalGridLines = [createNewLineView(), createNewLineView()]
//        }
//        else {
//            horizontalGridLines = []
//        }
//        setNeedsDisplay()
//    }
//
//    func setDisplayVerticalGridLines(_ displayVerticalGridLines: Bool) {
//        self.isDisplayVerticalGridLines = displayVerticalGridLines
//        for view in verticalGridLines! {
//            view.removeFromSuperview()
//        }
//        if self.isDisplayVerticalGridLines {
//            verticalGridLines = [createNewLineView(), createNewLineView()]
//        } else {
//            verticalGridLines = []
//        }
//        setNeedsDisplay()
//    }
//
//
//    func setGridHidden(_ gridHidden: Bool) {
//        setGridHidden(gridHidden, animated: false)
//    }
//
//    // MARK: - Private methods
//    func createNewLineView() -> UIView {
//        let newLine = UIView(frame: CGRect.zero)
//        newLine.backgroundColor = UIColor.white
//        addSubview(newLine)
//        return newLine
//    }
//
//}
//
//
