//
//  SCScrollView.m
//  SCScrollView
//
//  Created by Stefan Ceriu on 31/10/2014.
//  Copyright (c) 2014 Stefan Ceriu. All rights reserved.
//

#import "SCScrollView.h"

#import "SCEasingFunctionProtocol.h"
#import "SCWeakObjectWrapper.h"

@interface UIView (SCFindFirstResponder)

- (id)scFindFirstResponder;

@end


@interface SCScrollView ()

@property (nonatomic, strong) NSMutableArray *approvalAreas;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) id<SCEasingFunctionProtocol> easingFunction;

@property (nonatomic, assign) CFTimeInterval duration;
@property (nonatomic, assign) CFTimeInterval startTime;

@property (nonatomic, assign) CGPoint startContentOffset;
@property (nonatomic, assign) CGPoint deltaContentOffset;

@property (nonatomic, copy) void(^completionBlock)();

@end

@implementation SCScrollView

- (void)dealloc
{
	[self.displayLink invalidate];
}

- (id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame]) {
		_maximumNumberOfTouches = NSUIntegerMax;
		_approvalAreas = [NSMutableArray array];
	}
	
	return self;
}

- (NSArray *)touchApprovalAreas
{
	return [self.approvalAreas copy];
}

- (void)addTouchApprovalArea:(SCScrollViewTouchApprovalArea *)touchApprovalArea
{
	if(!touchApprovalArea) {
		return;
	}
	
	[self.approvalAreas addObject:touchApprovalArea];
}

- (void)removeTouchApprovalArea:(SCScrollViewTouchApprovalArea *)touchApprovalArea
{
	[self.approvalAreas removeObject:touchApprovalArea];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
		
		if(gestureRecognizer.numberOfTouches > self.maximumNumberOfTouches) {
			return NO;
		}
		
		CGPoint touchPoint = [gestureRecognizer locationInView:self];
		CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
		
		BOOL shouldBegin = (self.touchApprovalAreas.count == 0);
		for(SCScrollViewTouchApprovalArea *touchApprovalArea in self.approvalAreas) {
			if([touchApprovalArea.path containsPoint:touchPoint]) {
				
				if((velocity.y < 0.0f && (touchApprovalArea.direction & UISwipeGestureRecognizerDirectionUp))    ||
				   (velocity.x < 0.0f && (touchApprovalArea.direction & UISwipeGestureRecognizerDirectionLeft))  ||
				   (velocity.x > 0.0f && (touchApprovalArea.direction & UISwipeGestureRecognizerDirectionRight))  ||
				   (velocity.y > 0.0f && (touchApprovalArea.direction & UISwipeGestureRecognizerDirectionDown))) {
					shouldBegin = YES;
				}
			}
		}
		
		return shouldBegin;
	}
	
	return YES;
}

#pragma mark - Public

- (BOOL)isRunningAnimation
{
	return (self.displayLink && !self.displayLink.paused);
}

- (void)setContentOffset:(CGPoint)contentOffset
		  easingFunction:(id<SCEasingFunctionProtocol>)easingFunction
				duration:(CFTimeInterval)duration
			  completion:(void(^)())completion
{
	if(!self.displayLink.paused && self.completionBlock) {
		[self stopRunningAnimation];
	}
	
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
	self.easingFunction = easingFunction;
	self.completionBlock = completion;
	self.deltaContentOffset = CGPointMake(contentOffset.x - self.contentOffset.x, contentOffset.y - self.contentOffset.y);
	self.startTime = 0.0f;
	
	[self.displayLink setPaused:NO];
}

- (void)stopRunningAnimation
{
	if(self.displayLink.isPaused) {
		return;
	}
	
	[self.displayLink setPaused:YES];
	
	if([self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
		[self.delegate scrollViewDidEndScrollingAnimation:self];
	}
	
	if(self.completionBlock) {
		self.completionBlock();
		self.completionBlock = nil;
	}
}

#pragma mark - Private

- (void)_updateContentOffset:(CADisplayLink *)displayLink
{
	if(self.startTime == 0.0f) {
		self.startTime = self.displayLink.timestamp;
		self.startContentOffset = self.contentOffset;
		return;
	}
	
	CGFloat ratio = (CGFloat) ((displayLink.timestamp - self.startTime) / self.duration);
	ratio = (1.0f - ratio < 0.01f) ? 1.0f : [self.easingFunction solveForInput:ratio];
	
	self.contentOffset = CGPointMake(self.startContentOffset.x + (self.deltaContentOffset.x * ratio),
									 self.startContentOffset.y + (self.deltaContentOffset.y * ratio));
	
	if (ratio == 1.0f) {
		[self.displayLink setPaused:YES];
		
		if([self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
			[self.delegate scrollViewDidEndScrollingAnimation:self];
		}
		
		if(self.completionBlock) {
			self.completionBlock();
			self.completionBlock = nil;
		}
	}
}

- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated
{
	id firstResponder = [self scFindFirstResponder];
	if([firstResponder isKindOfClass:[UITextField class]] ||
	   [firstResponder isKindOfClass:[UISearchBar class]] ||
	   [firstResponder isKindOfClass:[UITextView class]]) {
		return;
	}
	
	[super scrollRectToVisible:rect animated:animated];
}

@end


@implementation SCScrollViewTouchApprovalArea

- (instancetype)init
{
	if (self = [super init]) {
		
		_direction = (UISwipeGestureRecognizerDirectionUp   |
					  UISwipeGestureRecognizerDirectionLeft |
					  UISwipeGestureRecognizerDirectionDown |
					  UISwipeGestureRecognizerDirectionRight);
	}
	
	return self;
}

@end


@implementation UIView (SCFindFirstResponder)

- (id)scFindFirstResponder
{
	if (self.isFirstResponder) {
		return self;
	}
	
	for (UIView *subview in self.subviews) {
		id responder = [subview scFindFirstResponder];
		
		if (responder) {
			return responder;
		}
	}
	
	return nil;
}

@end
