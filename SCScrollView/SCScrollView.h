//
//  SCScrollView.h
//  SCScrollView
//
//  Created by Stefan Ceriu on 31/10/2014.
//  Copyright (c) 2014 Stefan Ceriu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCEasingFunctionProtocol;

@interface SCScrollView : UIScrollView

@property (nonatomic, strong) UIBezierPath *touchRefusalArea;

@property (nonatomic, assign) NSUInteger maximumNumberOfTouches;

- (void)setContentOffset:(CGPoint)contentOffset
          easingFunction:(id<SCEasingFunctionProtocol>)easingFunction
                duration:(CFTimeInterval)duration
              completion:(void(^)())completion;

- (BOOL)isRunningAnimation;

- (void)stopRunningAnimation;

@end
