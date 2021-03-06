//
//  RUCropToolBar.h
//  RUCropController
//
//  Created by Roman Ustiantcev on 06/10/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUCropToolBar : UIView

/* In horizontal mode, offsets all of the buttons vertically by 20 points. */
@property (nonatomic, assign) BOOL statusBarVisible;

/* Set an inset that will expand the background view beyond the bounds. */
@property (nonatomic, assign) UIEdgeInsets backgroundViewOutsets;

/* The 'Done' buttons to commit the crop. The text button is displayed
 in portrait mode and the icon one, in landscape. */
@property (nonnull, nonatomic, strong, readonly) UIButton *doneTextButton;
@property (nonnull, nonatomic, strong, readonly) UIButton *doneIconButton;

/* The 'Cancel' buttons to cancel the crop. The text button is displayed
 in portrait mode and the icon one, in landscape. */
@property (nonnull, nonatomic, strong, readonly) UIButton *cancelTextButton;
@property (nonnull, nonatomic, strong, readonly) UIButton *cancelIconButton;

/* The cropper control buttons */
@property (nonnull, nonatomic, strong, readonly)  UIButton *rotateCounterclockwiseButton;
@property (nonnull, nonatomic, strong, readonly)  UIButton *resetButton;
@property (nonnull, nonatomic, strong, readonly)  UIButton *clampButton;
@property (nullable, nonatomic, strong, readonly) UIButton *rotateClockwiseButton;

@property (nonnull, nonatomic, readonly) UIButton *rotateButton; // Points to `rotateCounterClockwiseButton`

/* Button feedback handler blocks */
@property (nullable, nonatomic, copy) void (^cancelButtonTapped)(void);
@property (nullable, nonatomic, copy) void (^doneButtonTapped)(void);
@property (nullable, nonatomic, copy) void (^rotateCounterclockwiseButtonTapped)(void);
@property (nullable, nonatomic, copy) void (^rotateClockwiseButtonTapped)(void);
@property (nullable, nonatomic, copy) void (^clampButtonTapped)(void);
@property (nullable, nonatomic, copy) void (^resetButtonTapped)(void);

/* State management for the 'clamp' button */
@property (nonatomic, assign) BOOL clampButtonGlowing;
@property (nonatomic, readonly) CGRect clampButtonFrame;

/* Aspect ratio button visibility settings */
@property (nonatomic, assign) BOOL clampButtonHidden;
@property (nonatomic, assign) BOOL rotateCounterclockwiseButtonHidden;
@property (nonatomic, assign) BOOL rotateClockwiseButtonHidden;

/* Enable the reset button */
@property (nonatomic, assign) BOOL resetButtonEnabled;

/* Done button frame for popover controllers */
@property (nonatomic, readonly) CGRect doneButtonFrame;

@end
