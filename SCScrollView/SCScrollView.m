//
//  SCScrollView.m
//  SCScrollView
//
//  Created by Stefan Ceriu on 31/10/2014.
//  Copyright (c) 2014 Stefan Ceriu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SCScrollView.h"
#import "SCWeakObjectWrapper.h"

#import "CAMediaTimingFunction+HLSExtensions.h"

@interface SCScrollView ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;

@property (nonatomic, assign) CFTimeInterval duration;
@property (nonatomic, assign) CFTimeInterval startTime;

@property (nonatomic, assign) CGPoint startContentOffset;
@property (nonatomic, assign) CGPoint deltaContentOffset;

@property (nonatomic, copy) void(^animationCompletionBlock)();

@end

@implementation SCScrollView

- (void)dealloc
{
    [self.displayLink invalidate];
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        self.maximumNumberOfTouches = NSUIntegerMax;
    }
    
    return self;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        
        if(gestureRecognizer.numberOfTouches > self.maximumNumberOfTouches) {
            return NO;
        }
        
        CGPoint touchPoint = [gestureRecognizer locationInView:self];
        return ![self.touchRefusalArea containsPoint:touchPoint];
    }
    
    return YES;
}

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wundeclared-selector"
    //Ignoring calls from any textView contained by this scroll
    if([[self performSelector:@selector(firstResponder)] isKindOfClass:[UITextField class]]) {
        return;
    }
    #pragma clang diagnostic pop
    
    [super scrollRectToVisible:rect animated:animated];
}

#pragma mark - Set ContentOffset with Custom Animation

- (void)setContentOffset:(CGPoint)contentOffset
      withTimingFunction:(CAMediaTimingFunction *)timingFunction
                duration:(CFTimeInterval)duration
              completion:(void(^)())completion
{
    if(CGPointEqualToPoint(self.contentOffset, contentOffset) || duration == 0.0f) {
        
        self.contentOffset = contentOffset;
        
        if(completion) {
            completion();
        }
        return;
    }
    
    if (self.displayLink == nil) {
        SCWeakObjectWrapper *target = [[SCWeakObjectWrapper alloc] initWithObject:self];
        self.displayLink = [CADisplayLink displayLinkWithTarget:target selector:@selector(_updateContentOffset:)];
        [self.displayLink setFrameInterval:1];
        [self.displayLink setPaused:YES];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    
    self.duration = duration;
    self.timingFunction = timingFunction;
    self.animationCompletionBlock = completion;
    self.deltaContentOffset = CGPointMake(contentOffset.x - self.contentOffset.x, contentOffset.y - self.contentOffset.y);
    self.startTime = 0.0f;
    
    [self.displayLink setPaused:NO];
}

- (void)_updateContentOffset:(CADisplayLink *)displayLink
{
    if(self.startTime == 0.0f) {
        self.startTime = self.displayLink.timestamp;
        self.startContentOffset = self.contentOffset;
        return;
    }
    
    CGFloat ratio = (CGFloat) ((displayLink.timestamp - self.startTime) / self.duration);
    ratio = (1.0f - ratio < 0.01f) ? 1.0f : [self.timingFunction valueForNormalizedTime:ratio];
    
    self.contentOffset = CGPointMake(self.startContentOffset.x + (self.deltaContentOffset.x * ratio),
                                     self.startContentOffset.y + (self.deltaContentOffset.y * ratio));
    
    if (ratio == 1.0f) {
        [self.displayLink setPaused:YES];
        
        if([self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
            [self.delegate scrollViewDidEndScrollingAnimation:self];
        }
        
        if(self.animationCompletionBlock) {
            self.animationCompletionBlock();
        }
    }
}

@end

