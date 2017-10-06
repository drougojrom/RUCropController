//
//  RUCropOverlayView.h
//  RUCropController
//
//  Created by Roman Ustiantcev on 06/10/2017.
//  Copyright © 2017 Roman Ustiantcev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RUCropOverlayView : UIView
/** Hides the interior grid lines, sans animation. */
@property (nonatomic, assign) BOOL gridHidden;

/** Add/Remove the interior horizontal grid lines. */
@property (nonatomic, assign) BOOL displayHorizontalGridLines;

/** Add/Remove the interior vertical grid lines. */
@property (nonatomic, assign) BOOL displayVerticalGridLines;

/** Shows and hides the interior grid lines with an optional crossfade animation. */
- (void)setGridHidden:(BOOL)hidden animated:(BOOL)animated;
@end
