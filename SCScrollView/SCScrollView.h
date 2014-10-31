//
//  SCScrollView.h
//  SCScrollView
//
//  Created by Stefan Ceriu on 31/10/2014.
//  Copyright (c) 2014 Stefan Ceriu. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  Subclass of UIScrollView that, in contrast to UIScrollView, uses a custom
 *  timing function to animate setContentOffset.
 *
 */
@interface SCScrollView : UIScrollView

@property (nonatomic, strong) UIBezierPath *touchRefusalArea;

@property (nonatomic, assign) NSUInteger maximumNumberOfTouches;

- (void)setContentOffset:(CGPoint)contentOffset
      withTimingFunction:(CAMediaTimingFunction *)timingFunction
                duration:(CFTimeInterval)duration
              completion:(void(^)())completion;


@end
