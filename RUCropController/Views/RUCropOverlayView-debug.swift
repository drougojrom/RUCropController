//
//  RUCropOverlayView.swift
//  RUCropController
//
//  Created by Roman Ustiantcev on 06/10/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

//import UIKit
//
//private let kRUCropOverLayerCornerWidth: CGFloat = 20.0
//
//class RUCropOverlayView: UIView {
//
//    var horizontalGridLines = NSArray()
//    var verticalGridLines = NSArray()
//    var outerLineViews = NSArray()
//    //top, right, bottom, left
//    var topLeftLineViews = NSArray()
//    //vertical, horizontal
//    var bottomLeftLineViews = NSArray()
//    var bottomRightLineViews = NSArray()
//    var topRightLineViews = NSArray()
//
//    override var frame: CGRect {
//        didSet {
//            layoutLines()
//        }
//    }
//
//    override init(frame: CGRect){
//        super.init(frame: frame)
//
//        self.clipsToBounds = true
//        setup()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func didMoveToSuperview() {
//        super.didMoveToSuperview()
//
//        layoutLines()
//    }
//
//    func setup() {
//        let newLineView: (() -> UIView)? = {(_: Void) -> UIView in
//            return self.createNewLineView()
//        }
//
//        outerLineViews = NSArray(array: [newLineView, newLineView, newLineView, newLineView])
//        topLeftLineViews = NSArray(array: [newLineView, newLineView])
//        bottomLeftLineViews = NSArray(array: [newLineView, newLineView])
//        topRightLineViews = NSArray(array: [newLineView, newLineView])
//        bottomRightLineViews = NSArray(array: [newLineView, newLineView])
//        //displayHorizontalGridLines = true
//        //displayVerticalGridLines = true
//    }
//
//    func layoutLines() {
//        let boundsSize = bounds.size
//
//        //border lines
//
//        for i in 0..<4 {
//            let lineView = self.outerLineViews[i] as! UIView
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
//        var cornerLines: NSArray = NSArray(array: [topLeftLineViews,
//                                                   topRightLineViews,
//                                                   bottomRightLineViews,
//                                                   bottomLeftLineViews])
//
//        for i in 0..<4 {
//            var cornerLine = cornerLines[i] as! NSArray
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
//
//            case 3: // bottom left
//            default:
//                break
//            }
//            (cornerLine[0] as? UIView)?.frame = verticalFrame
//            (cornerLine[1] as? UIView)?.frame = horizontalFrame
//        }
//        for (NSInteger i = 0; i < 4; i++) {
//            NSArray *cornerLine = cornerLines[i];
//
//            CGRect verticalFrame = CGRectZero, horizontalFrame = CGRectZero;
//            switch (i) {
//            case 0: //top left
//                verticalFrame = (CGRect){-3.0f,-3.0f,3.0f,kTOCropOverLayerCornerWidth+3.0f};
//                horizontalFrame = (CGRect){0,-3.0f,kTOCropOverLayerCornerWidth,3.0f};
//                break;
//            case 1: //top right
//                verticalFrame = (CGRect){boundsSize.width,-3.0f,3.0f,kTOCropOverLayerCornerWidth+3.0f};
//                horizontalFrame = (CGRect){boundsSize.width-kTOCropOverLayerCornerWidth,-3.0f,kTOCropOverLayerCornerWidth,3.0f};
//                break;
//            case 2: //bottom right
//                verticalFrame = (CGRect){boundsSize.width,boundsSize.height-kTOCropOverLayerCornerWidth,3.0f,kTOCropOverLayerCornerWidth+3.0f};
//                horizontalFrame = (CGRect){boundsSize.width-kTOCropOverLayerCornerWidth,boundsSize.height,kTOCropOverLayerCornerWidth,3.0f};
//                break;
//            case 3: //bottom left
//                verticalFrame = (CGRect){-3.0f,boundsSize.height-kTOCropOverLayerCornerWidth,3.0f,kTOCropOverLayerCornerWidth};
//                horizontalFrame = (CGRect){-3.0f,boundsSize.height,kTOCropOverLayerCornerWidth+3.0f,3.0f};
//                break;
//            }
//
//            [cornerLine[0] setFrame:verticalFrame];
//            [cornerLine[1] setFrame:horizontalFrame];
//        }
//
//        //grid lines - horizontal
//        CGFloat thickness = 1.0f / [[UIScreen mainScreen] scale];
//        NSInteger numberOfLines = self.horizontalGridLines.count;
//        CGFloat padding = (CGRectGetHeight(self.bounds) - (thickness*numberOfLines)) / (numberOfLines + 1);
//        for (NSInteger i = 0; i < numberOfLines; i++) {
//            UIView *lineView = self.horizontalGridLines[i];
//            CGRect frame = CGRectZero;
//            frame.size.height = thickness;
//            frame.size.width = CGRectGetWidth(self.bounds);
//            frame.origin.y = (padding * (i+1)) + (thickness * i);
//            lineView.frame = frame;
//        }
//
//        //grid lines - vertical
//        numberOfLines = self.verticalGridLines.count;
//        padding = (CGRectGetWidth(self.bounds) - (thickness*numberOfLines)) / (numberOfLines + 1);
//        for (NSInteger i = 0; i < numberOfLines; i++) {
//            UIView *lineView = self.verticalGridLines[i];
//            CGRect frame = CGRectZero;
//            frame.size.width = thickness;
//            frame.size.height = CGRectGetHeight(self.bounds);
//            frame.origin.x = (padding * (i+1)) + (thickness * i);
//            lineView.frame = frame;
//        }
//    }
//
//    func createNewLineView() -> UIView {
//
//
//        return UIView()
//    }
//}


