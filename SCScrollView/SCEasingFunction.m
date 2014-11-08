//
//  SCEasingFunction.m
//  SCScrollView
//
//  Created by Stefan Ceriu on 04/11/2014.
//
//

#import "SCEasingFunction.h"

#import "easing.h"

@interface SCEasingFunction ()

@property (nonatomic, assign) AHEasingFunction easingFunction;

@end

@implementation SCEasingFunction

+ (instancetype)easingFunctionWithType:(SCEasingFunctionType)type
{
    return [[self alloc] initWithType:type];
}

- (instancetype)initWithType:(SCEasingFunctionType)type
{
    if(self = [super init]) {
        self.type = type;
    }
    
    return self;
}

- (CGFloat)solveForInput:(CGFloat)input
{
    return self.easingFunction(input);
}

- (void)setType:(SCEasingFunctionType)type
{
    static const NSDictionary *typeToFunctionMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        typeToFunctionMap = @{@(SCEasingFunctionTypeLinear): [NSValue valueWithPointer:LinearInterpolation],
                              
                              @(SCEasingFunctionTypeQuadraticEaseIn): [NSValue valueWithPointer:QuadraticEaseIn],
                              @(SCEasingFunctionTypeQuadraticEaseOut): [NSValue valueWithPointer:QuadraticEaseOut],
                              @(SCEasingFunctionTypeQuadraticEaseInOut): [NSValue valueWithPointer:QuadraticEaseInOut],
                              
                              @(SCEasingFunctionTypeCubicEaseIn): [NSValue valueWithPointer:CubicEaseIn],
                              @(SCEasingFunctionTypeCubicEaseOut): [NSValue valueWithPointer:CubicEaseOut],
                              @(SCEasingFunctionTypeCubicEaseInOut): [NSValue valueWithPointer:CubicEaseInOut],
                              
                              @(SCEasingFunctionTypeQuarticEaseIn): [NSValue valueWithPointer:QuarticEaseIn],
                              @(SCEasingFunctionTypeQuarticEaseOut): [NSValue valueWithPointer:QuarticEaseOut],
                              @(SCEasingFunctionTypeQuarticEaseInOut): [NSValue valueWithPointer:QuarticEaseInOut],
                              
                              @(SCEasingFunctionTypeQuinticEaseIn): [NSValue valueWithPointer:QuinticEaseIn],
                              @(SCEasingFunctionTypeQuinticEaseOut): [NSValue valueWithPointer:QuinticEaseOut],
                              @(SCEasingFunctionTypeQuinticEaseInOut): [NSValue valueWithPointer:QuinticEaseInOut],
                              
                              @(SCEasingFunctionTypeSineEaseIn): [NSValue valueWithPointer:SineEaseIn],
                              @(SCEasingFunctionTypeSineEaseOut): [NSValue valueWithPointer:SineEaseOut],
                              @(SCEasingFunctionTypeSineEaseInOut): [NSValue valueWithPointer:SineEaseInOut],
                              
                              @(SCEasingFunctionTypeCircularEaseIn): [NSValue valueWithPointer:CircularEaseIn],
                              @(SCEasingFunctionTypeCircularEaseOut): [NSValue valueWithPointer:CircularEaseOut],
                              @(SCEasingFunctionTypeCircularEaseInOut): [NSValue valueWithPointer:CircularEaseInOut],
                              
                              @(SCEasingFunctionTypeExponentialEaseIn): [NSValue valueWithPointer:ExponentialEaseIn],
                              @(SCEasingFunctionTypeExponentialEaseOut): [NSValue valueWithPointer:ExponentialEaseOut],
                              @(SCEasingFunctionTypeExponentialEaseInOut): [NSValue valueWithPointer:ExponentialEaseInOut],
                              
                              @(SCEasingFunctionTypeElasticEaseIn): [NSValue valueWithPointer:ElasticEaseIn],
                              @(SCEasingFunctionTypeElasticEaseOut): [NSValue valueWithPointer:ElasticEaseOut],
                              @(SCEasingFunctionTypeElasticEaseInOut): [NSValue valueWithPointer:ElasticEaseInOut],
                              
                              @(SCEasingFunctionTypeBackEaseIn): [NSValue valueWithPointer:BackEaseIn],
                              @(SCEasingFunctionTypeBackEaseOut): [NSValue valueWithPointer:BackEaseOut],
                              @(SCEasingFunctionTypeBackEaseInOut): [NSValue valueWithPointer:BackEaseInOut],
                              
                              @(SCEasingFunctionTypeBounceEaseIn): [NSValue valueWithPointer:BounceEaseIn],
                              @(SCEasingFunctionTypeBounceEaseOut): [NSValue valueWithPointer:BounceEaseOut],
                              @(SCEasingFunctionTypeBounceEaseInOut): [NSValue valueWithPointer:BounceEaseInOut]};
    });
    
    self.easingFunction = [typeToFunctionMap[@(type)] pointerValue];
    
    _type = type;
}

@end
