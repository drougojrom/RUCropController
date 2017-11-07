//
//  RUCropToolBar.swift
//  RUCropController
//
//  Created by Gleb Karpushkin on 06/11/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

let TOCROPTOOLBAR_DEBUG_SHOWING_BUTTONS_CONTAINER_RECT = 0

class RUCropToolBarSwift: UIView {
    
    var isStatusBarVisible = false
    /* Set an inset that will expand the background view beyond the bounds. */
    var backgroundViewOutsets = UIEdgeInsets()
    /* The 'Done' buttons to commit the crop. The text button is displayed
     in portrait mode and the icon one, in landscape. */
    private(set) var doneTextButton: UIButton?
    private(set) var doneIconButton: UIButton?
    /* The 'Cancel' buttons to cancel the crop. The text button is displayed
     in portrait mode and the icon one, in landscape. */
    private(set) var cancelTextButton: UIButton?
    private(set) var cancelIconButton: UIButton?
    /* The cropper control buttons */
    private(set) var rotateCounterclockwiseButton: UIButton?
    private(set) var resetButton: UIButton?
    private(set) var clampButton: UIButton?
    private(set) var rotateClockwiseButton: UIButton?
    // Points to `rotateCounterClockwiseButton`
    /* Button feedback handler blocks */
    var cancelButtonTapped: (() -> Void)?
    var doneButtonTapped: (() -> Void)?
    var rotateCounterclockwiseButtonTapped: (() -> Void)?
    var rotateClockwiseButtonTapped: (() -> Void)?
    var clampButtonTapped: (() -> Void)?
    var resetButtonTapped: (() -> Void)?
    /* State management for the 'clamp' button */
    var isClampButtonGlowing = false
    /* Aspect ratio button visibility settings */
    var isClampButtonHidden = false
    var isRotateCounterclockwiseButtonHidden = false
    var isRotateClockwiseButtonHidden = false
    /* Enable the reset button */
    var isResetButtonEnabled = false
    /* Done button frame for popover controllers */
    
    var backgroundView: UIView?
    
    // defaults to counterclockwise button for legacy compatibility
    var isReverseContentLayout = false
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame)
        setup()
    }
    
    func setup() {
        backgroundView = UIView(frame: bounds)
        backgroundView?.backgroundColor = UIColor(white: 0.12, alpha: 1.0)
        addSubview(backgroundView!)
        isRotateClockwiseButtonHidden = true
        // On iOS 9, we can use the new layout features to determine whether we're in an 'Arabic' style language mode
        if UIView.resolveClassMethod(#selector(getter: self.semanticContentAttribute)) {
            isReverseContentLayout = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
        }
        else {
            isReverseContentLayout = NSLocale.preferredLanguages[0].hasPrefix("ar")
        }
        // In CocoaPods, strings are stored in a separate bundle from the main one
        var resourceBundle: Bundle? = nil
        let classBundle = Bundle(for: type(of: self))
        let resourceBundleURL: URL? = classBundle.url(forResource: "TOCropViewControllerBundle", withExtension: "bundle")
        if resourceBundleURL != nil {
            resourceBundle = Bundle(url: resourceBundleURL!)
        }
        else {
            resourceBundle = classBundle
        }
        
        doneTextButton = UIButton(type: .system)
        doneTextButton?.setTitle(NSLocalizedString("Done", tableName: "TOCropViewControllerLocalizable", value: "Done", comment: ""), for: .normal)
        doneTextButton?.setTitleColor(UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0), for: .normal)
        doneTextButton?.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        doneTextButton?.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        addSubview(doneTextButton!)
        doneIconButton = UIButton(type: .system)
        doneIconButton?.setImage(RUCropToolBar.doneImage(), for: .normal)
        doneIconButton?.tintColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
        doneIconButton?.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        addSubview(doneIconButton!)
        cancelTextButton = UIButton(type: .system)
        let lstring = NSLocalizedString("Done", tableName: "TOCropViewControllerLocalizable", bundle: resourceBundle!, value: "Done", comment: "")
        cancelTextButton?.setTitle(lstring, for: .normal)
        cancelTextButton?.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        cancelTextButton?.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        addSubview(cancelTextButton!)
        cancelIconButton = UIButton(type: .system)
        cancelIconButton?.setImage(RUCropToolBar.cancelImage(), for: .normal)
        cancelIconButton?.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        addSubview(cancelIconButton!)
        clampButton = UIButton(type: .system)
        clampButton?.contentMode = .center
        clampButton?.tintColor = UIColor.white
        clampButton?.setImage(RUCropToolBar.clampImage(), for: .normal)
        clampButton?.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        addSubview(clampButton!)
        rotateCounterclockwiseButton = UIButton(type: .system)
        rotateCounterclockwiseButton?.contentMode = .center
        rotateCounterclockwiseButton?.tintColor = UIColor.white
        rotateCounterclockwiseButton?.setImage(RUCropToolBar.rotateCCWImage(), for: .normal)
        rotateCounterclockwiseButton?.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        addSubview(rotateCounterclockwiseButton!)
        resetButton = UIButton(type: .system)
        resetButton?.contentMode = .center
        resetButton?.tintColor = UIColor.white
        resetButton?.isEnabled = false
        resetButton?.setImage(RUCropToolBar.resetImage(), for: .normal)
        resetButton?.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        addSubview(resetButton!)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let verticalLayout: Bool = bounds.width < bounds.height
        let boundsSize: CGSize = bounds.size
        cancelIconButton?.isHidden = !verticalLayout
        cancelTextButton?.isHidden = verticalLayout
        doneIconButton?.isHidden = !verticalLayout
        doneTextButton?.isHidden = verticalLayout
        let frame: CGRect = bounds
        //    frame.origin.x -= self.backgroundViewOutsets.left;
        //    frame.size.width += self.backgroundViewOutsets.left;
        //    frame.size.width += self.backgroundViewOutsets.right;
        //    frame.origin.y -= self.backgroundViewOutsets.top;
        //    frame.size.height += self.backgroundViewOutsets.top;
        //    frame.size.height += self.backgroundViewOutsets.bottom;
        backgroundView?.frame = frame
        #if TOCROPTOOLBAR_DEBUG_SHOWING_BUTTONS_CONTAINER_RECT
            var containerView: UIView? = nil
            if containerView == nil {
                containerView = UIView(frame: CGRect.zero)
                containerView?.backgroundColor = UIColor.red
                containerView?.alpha = 0.1
                addSubview(containerView ?? UIView())
            }
        #endif
        
        if verticalLayout == false {
            let insetPadding: CGFloat = 10.0
            // Work out the cancel button frame
            var frame: CGRect = CGRect.zero
            frame.origin.y = isStatusBarVisible ? 20.0 : 0.0
            frame.size.height = 44.0
            frame.size.width = (cancelTextButton?.titleLabel?.text?.size(withAttributes: [NSAttributedStringKey.font: cancelTextButton?.titleLabel?.font as Any]).width)! + 10
            //If normal layout, place on the left side, else place on the right
            if isReverseContentLayout == false {
                frame.origin.x = insetPadding
            }
            else {
                frame.origin.x = boundsSize.width - (frame.size.width + insetPadding)
            }
            cancelTextButton?.frame = frame
            // Work out the Done button frame
            frame.size.width = (doneTextButton?.titleLabel?.text?.size(withAttributes: [NSAttributedStringKey.font: doneTextButton?.titleLabel?.font as Any]).width)! + 10
            if isReverseContentLayout == false {
                frame.origin.x = boundsSize.width - (frame.size.width + insetPadding)
            }
            else {
                frame.origin.x = insetPadding
            }
            doneTextButton?.frame = frame
            // Work out the frame between the two buttons where we can layout our action buttons
            let x: CGFloat = isReverseContentLayout ? doneTextButton!.frame.maxX : cancelTextButton!.frame.maxX
            var width: CGFloat = 0.0
            if isReverseContentLayout == false {
                width = (doneTextButton?.frame.minX)! - (cancelTextButton?.frame.maxX)!
            }
            else {
                width = (cancelTextButton?.frame.minX)! - (doneTextButton?.frame.maxX)!
            }
            var containerRect: CGRect? = CGRect(x: x, y: frame.origin.y, width: width, height: 44.0)
            #if TOCROPTOOLBAR_DEBUG_SHOWING_BUTTONS_CONTAINER_RECT
                containerView.frame = containerRect
            #endif
            
            
            let buttonSize: CGSize? = CGSize(width: 44, height: 44)
            var buttonsInOrderHorizontally = [AnyHashable]()
            if !isRotateCounterclockwiseButtonHidden {
                buttonsInOrderHorizontally.append(rotateCounterclockwiseButton!)
            }
            buttonsInOrderHorizontally.append(resetButton!)
            if !isClampButtonHidden {
                buttonsInOrderHorizontally.append(clampButton!)
            }
            if !isRotateClockwiseButtonHidden {
                buttonsInOrderHorizontally.append(rotateClockwiseButton!)
            }
            layoutToolbarButtons(buttonsInOrderHorizontally, withSameButtonSize: buttonSize!, inContainerRect: containerRect!, horizontally: true)
        }else {
            var frame: CGRect = CGRect.zero
            frame.size.height = 44.0
            frame.size.width = 44.0
            frame.origin.y = bounds.height - 44.0
            cancelIconButton?.frame = frame
            frame.origin.y = 0.0
            frame.size.width = 44.0
            frame.size.height = 44.0
            doneIconButton?.frame = frame
            var containerRect: CGRect? = CGRect(x: 0, y: (doneIconButton?.frame.maxY)!, width: 44, height: (cancelIconButton?.frame.minY)! - (doneIconButton?.frame.maxY)!)
            #if TOCROPTOOLBAR_DEBUG_SHOWING_BUTTONS_CONTAINER_RECT
                containerView.frame = containerRect
            #endif
            let buttonSize: CGSize? = CGSize(width: 44, height: 44)
            var buttonsInOrderVertically = [AnyHashable]()
            if !isRotateCounterclockwiseButtonHidden {
                buttonsInOrderVertically.append(rotateCounterclockwiseButton!)
            }
            buttonsInOrderVertically.append(resetButton!)
            if !isClampButtonHidden {
                buttonsInOrderVertically.append(clampButton!)
            }
            if !isRotateClockwiseButtonHidden {
                buttonsInOrderVertically.append(rotateClockwiseButton!)
            }
            layoutToolbarButtons(buttonsInOrderVertically, withSameButtonSize: buttonSize!, inContainerRect: containerRect!, horizontally: false)
        }
    }
    
    // The convenience method for calculating button's frame inside of the container rect
    func layoutToolbarButtons(_ buttons: [Any], withSameButtonSize size: CGSize, inContainerRect containerRect: CGRect, horizontally: Bool) {
        let count: Int = buttons.count
        let fixedSize: CGFloat = horizontally ? size.width : size.height
        let maxLength: CGFloat = horizontally ? containerRect.width : containerRect.height
        let padding: CGFloat = (maxLength - (fixedSize * CGFloat(count)) / CGFloat((count + 1)))
        for i in 0..<count {
            let button = buttons[i] as? UIView
            let sameOffset: CGFloat = horizontally ? fabs(containerRect.height - button!.bounds.height) : fabs(containerRect.width - button!.bounds.width)
            let diffOffset: CGFloat = padding + CGFloat(i) * (fixedSize + padding)
            var origin = horizontally ? CGPoint(x: diffOffset, y: sameOffset) : CGPoint(x: sameOffset, y: diffOffset)
            if horizontally {
                origin.x += containerRect.minX
                origin.y += isStatusBarVisible ? 20.0 : 0.0
            }
            else {
                origin.y += containerRect.minY
            }
            button?.frame = CGRect(origin: origin, size: size)
        }
    }
    
    @objc func buttonTapped(_ button: UIButton) {
        if button == cancelTextButton || button == cancelIconButton {
            if (cancelButtonTapped != nil) {
                cancelButtonTapped!()
            }
        }
        else if button == doneTextButton || button == doneIconButton {
            if (doneButtonTapped != nil) {
                doneButtonTapped!()
            }
        }
        else if button == resetButton && (resetButtonTapped != nil) {
            resetButtonTapped!()
        }
        else if button == rotateCounterclockwiseButton && (rotateCounterclockwiseButtonTapped != nil) {
            rotateCounterclockwiseButtonTapped!()
        }
        else if button == rotateClockwiseButton && (rotateClockwiseButtonTapped != nil) {
            rotateClockwiseButtonTapped!()
        }
        else if button == clampButton && (clampButtonTapped != nil) {
            clampButtonTapped!()
            return
        }
        
    }
    
    func clampButtonFrame() -> CGRect {
        return clampButton!.frame
    }
    
    func setClampButtonHidden(_ clampButtonHidden: Bool) {
        if self.isClampButtonHidden == clampButtonHidden {
            return
        }
        self.isClampButtonHidden = clampButtonHidden
        setNeedsLayout()
    }
    
    func setClampButtonGlowing(_ clampButtonGlowing: Bool) {
        if self.isClampButtonGlowing == clampButtonGlowing {
            return
        }
        self.isClampButtonGlowing = clampButtonGlowing
        if self.isClampButtonGlowing {
            clampButton?.tintColor = nil
        }
        else {
            clampButton?.tintColor = UIColor.white
        }
    }
    
    func setRotateCounterClockwiseButtonHidden(_ rotateButtonHidden: Bool) {
        if isRotateCounterclockwiseButtonHidden == rotateButtonHidden {
            return
        }
        isRotateCounterclockwiseButtonHidden = rotateButtonHidden
        setNeedsLayout()
    }
    
    func resetButtonEnabled() -> Bool {
        return resetButton!.isEnabled
    }
    
    func setResetButtonEnabled(_ resetButtonEnabled: Bool) {
        resetButton?.isEnabled = resetButtonEnabled
    }
    
    func doneButtonFrame() -> CGRect {
        if doneIconButton?.isHidden == false {
            return doneIconButton!.frame
        }
        return doneTextButton!.frame
    }
    
    // MARK: - Image Generation
    class func doneImage() -> UIImage {
        var doneImage: UIImage? = nil
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 17, height: 14), false, 0)
        do {
            //// Rectangle Drawing
            let rectanglePath = UIBezierPath()
            rectanglePath.move(to: CGPoint(x: 1, y: 7))
            rectanglePath.addLine(to: CGPoint(x: 6, y: 12))
            rectanglePath.addLine(to: CGPoint(x: 16, y: 1))
            UIColor.white.setStroke()
            rectanglePath.lineWidth = 2
            rectanglePath.stroke()
            doneImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return doneImage ?? UIImage()
    }
    
    class func cancelImage() -> UIImage {
        var cancelImage: UIImage? = nil
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 16, height: 16), false, 0.0)
        do {
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: 15, y: 15))
            bezierPath.addLine(to: CGPoint(x: 1, y: 1))
            UIColor.white.setStroke()
            bezierPath.lineWidth = 2
            bezierPath.stroke()
            //// Bezier 2 Drawing
            let bezier2Path = UIBezierPath()
            bezier2Path.move(to: CGPoint(x: 1, y: 15))
            bezier2Path.addLine(to: CGPoint(x: 15, y: 1))
            UIColor.white.setStroke()
            bezier2Path.lineWidth = 2
            bezier2Path.stroke()
            cancelImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return cancelImage ?? UIImage()
    }
    
    class func rotateCCWImage() -> UIImage {
        var rotateImage: UIImage? = nil
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 18, height: 21), false, 0.0)
        do {
            //// Rectangle 2 Drawing
            let rectangle2Path = UIBezierPath(rect: CGRect(x: 0, y: 9, width: 12, height: 12))
            UIColor.white.setFill()
            rectangle2Path.fill()
            //// Rectangle 3 Drawing
            let rectangle3Path = UIBezierPath()
            rectangle3Path.move(to: CGPoint(x: 5, y: 3))
            rectangle3Path.addLine(to: CGPoint(x: 10, y: 6))
            rectangle3Path.addLine(to: CGPoint(x: 10, y: 0))
            rectangle3Path.addLine(to: CGPoint(x: 5, y: 3))
            rectangle3Path.close()
            UIColor.white.setFill()
            rectangle3Path.fill()
            //// Bezier Drawing
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: 10, y: 3))
            bezierPath.addCurve(to: CGPoint(x: 17.5, y: 11), controlPoint1: CGPoint(x: 15, y: 3), controlPoint2: CGPoint(x: 17.5, y: 5.91))
            UIColor.white.setStroke()
            bezierPath.lineWidth = 1
            bezierPath.stroke()
            rotateImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return rotateImage ?? UIImage()
    }
    
    class func rotateCWImage() -> UIImage {
        let rotateCWImage: UIImage? = RUCropToolBar.rotateCWImage()
        UIGraphicsBeginImageContextWithOptions((rotateCWImage?.size)!, false, (rotateCWImage?.scale)!)
        let context: CGContext? = UIGraphicsGetCurrentContext()
        context?.translateBy(x: (rotateCWImage?.size.width)!, y: (rotateCWImage?.size.height)!)
        context?.rotate(by: .pi)
        context?.draw((rotateCWImage?.cgImage)!, in: CGRect(x: 0, y: 0, width: rotateCWImage?.size.width ?? 0.0, height: rotateCCWImage().size.height ))
        let rotateCWImage1 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rotateCWImage1 ?? UIImage()
    }
    
    class func resetImage() -> UIImage {
        var resetImage: UIImage? = nil
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 22, height: 18), false, 0.0)
        do {
            //// Bezier 2 Drawing
            let bezier2Path = UIBezierPath()
            bezier2Path.move(to: CGPoint(x: 22, y: 9))
            bezier2Path.addCurve(to: CGPoint(x: 13, y: 18), controlPoint1: CGPoint(x: 22, y: 13.97), controlPoint2: CGPoint(x: 17.97, y: 18))
            bezier2Path.addCurve(to: CGPoint(x: 13, y: 16), controlPoint1: CGPoint(x: 13, y: 17.35), controlPoint2: CGPoint(x: 13, y: 16.68))
            bezier2Path.addCurve(to: CGPoint(x: 20, y: 9), controlPoint1: CGPoint(x: 16.87, y: 16), controlPoint2: CGPoint(x: 20, y: 12.87))
            bezier2Path.addCurve(to: CGPoint(x: 13, y: 2), controlPoint1: CGPoint(x: 20, y: 5.13), controlPoint2: CGPoint(x: 16.87, y: 2))
            bezier2Path.addCurve(to: CGPoint(x: 6.55, y: 6.27), controlPoint1: CGPoint(x: 10.1, y: 2), controlPoint2: CGPoint(x: 7.62, y: 3.76))
            bezier2Path.addCurve(to: CGPoint(x: 6, y: 9), controlPoint1: CGPoint(x: 6.2, y: 7.11), controlPoint2: CGPoint(x: 6, y: 8.03))
            bezier2Path.addLine(to: CGPoint(x: 4, y: 9))
            bezier2Path.addCurve(to: CGPoint(x: 4.65, y: 5.63), controlPoint1: CGPoint(x: 4, y: 7.81), controlPoint2: CGPoint(x: 4.23, y: 6.67))
            bezier2Path.addCurve(to: CGPoint(x: 7.65, y: 1.76), controlPoint1: CGPoint(x: 5.28, y: 4.08), controlPoint2: CGPoint(x: 6.32, y: 2.74))
            bezier2Path.addCurve(to: CGPoint(x: 13, y: 0), controlPoint1: CGPoint(x: 9.15, y: 0.65), controlPoint2: CGPoint(x: 11, y: 0))
            bezier2Path.addCurve(to: CGPoint(x: 22, y: 9), controlPoint1: CGPoint(x: 17.97, y: 0), controlPoint2: CGPoint(x: 22, y: 4.03))
            bezier2Path.close()
            UIColor.white.setFill()
            bezier2Path.fill()
            
            //// Polygon Drawing
            let polygonPath = UIBezierPath()
            polygonPath.move(to: CGPoint(x: 5, y: 15))
            polygonPath.addLine(to: CGPoint(x: 10, y: 9))
            polygonPath.addLine(to: CGPoint(x: 0, y: 9))
            polygonPath.addLine(to: CGPoint(x: 5, y: 15))
            polygonPath.close()
            UIColor.white.setFill()
            polygonPath.fill()
            resetImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return resetImage!
    }
    
    class func clampImage() -> UIImage {
        var clampImage: UIImage? = nil
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 22, height: 16), false, 0.0)
        do {
            //// Color Declarations
            let outerBox: UIColor? = UIColor(red: 1, green: 1, blue: 1, alpha: 0.553)
            let innerBox: UIColor? = UIColor(red: 1, green: 1, blue: 1, alpha: 0.773)
            //// Rectangle Drawing
            let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 3, width: 13, height: 13))
            UIColor.white.setFill()
            rectanglePath.fill()
            //// Outer
            do {
                //// Top Drawing
                let topPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 22, height: 2))
                outerBox?.setFill()
                topPath.fill()
                //// Side Drawing
                let sidePath = UIBezierPath(rect: CGRect(x: 19, y: 2, width: 3, height: 14))
                outerBox?.setFill()
                sidePath.fill()
            }
            //// Rectangle 2 Drawing
            let rectangle2Path = UIBezierPath(rect: CGRect(x: 14, y: 3, width: 4, height: 13))
            innerBox?.setFill()
            rectangle2Path.fill()
            clampImage = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return clampImage ?? UIImage()
    }
    
    // MARK: - Accessors
    func setRotateClockwiseButtonHidden(_ rotateClockwiseButtonHidden: Bool) {
        if isRotateClockwiseButtonHidden == rotateClockwiseButtonHidden {
            return
        }
        isRotateClockwiseButtonHidden = rotateClockwiseButtonHidden
        if rotateClockwiseButtonHidden == false {
            rotateClockwiseButton = UIButton(type: .system)
            rotateClockwiseButton?.contentMode = .center
            rotateClockwiseButton?.tintColor = UIColor.white
            rotateClockwiseButton?.setImage(RUCropToolBar.rotateCWImage(), for: .normal)
            rotateClockwiseButton?.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
            addSubview(rotateClockwiseButton!)
        }
        else {
            rotateClockwiseButton?.removeFromSuperview()
            rotateClockwiseButton = nil
        }
        setNeedsLayout()
    }
    
    func rotateButton() -> UIButton {
        return rotateCounterclockwiseButton!
    }
    
}

