//
//  SCScrollView.h
//  SCScrollView
//
//  Created by Stefan Ceriu on 31/10/2014.
//  Copyright (c) 2014 Stefan Ceriu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCEasingFunctionProtocol;
@class SCScrollViewTouchApprovalArea;

@interface SCScrollView : UIScrollView

@property (nonatomic, assign) NSUInteger maximumNumberOfTouches;

@property (nonatomic, strong, readonly) NSArray *touchApprovalAreas;

- (void)setContentOffset:(CGPoint)contentOffset
		  easingFunction:(id<SCEasingFunctionProtocol>)easingFunction
				duration:(CFTimeInterval)duration
			  completion:(void(^)())completion;


- (void)addTouchApprovalArea:(SCScrollViewTouchApprovalArea *)touchApprovalArea;

- (void)removeTouchApprovalArea:(SCScrollViewTouchApprovalArea *)touchApprovalArea;


- (BOOL)isRunningAnimation;

- (void)stopRunningAnimation;

@end

@interface SCScrollViewTouchApprovalArea : NSObject

@property (nonatomic, strong) UIBezierPath *path;

@property (nonatomic, assign) UISwipeGestureRecognizerDirection direction;

@end
