//
//  SCEasingFunction.h
//  SCScrollView
//
//  Created by Stefan Ceriu on 04/11/2014.
//
//

#import "SCEasingFunctionProtocol.h"

typedef NS_ENUM(NSUInteger, SCEasingFunctionType)
{
    SCEasingFunctionTypeLinear,
    
    SCEasingFunctionTypeQuadraticEaseIn,
    SCEasingFunctionTypeQuadraticEaseOut,
    SCEasingFunctionTypeQuadraticEaseInOut,
    
    SCEasingFunctionTypeCubicEaseIn,
    SCEasingFunctionTypeCubicEaseOut,
    SCEasingFunctionTypeCubicEaseInOut,
    
    SCEasingFunctionTypeQuarticEaseIn,
    SCEasingFunctionTypeQuarticEaseOut,
    SCEasingFunctionTypeQuarticEaseInOut,
    
    SCEasingFunctionTypeQuinticEaseIn,
    SCEasingFunctionTypeQuinticEaseOut,
    SCEasingFunctionTypeQuinticEaseInOut,
    
    SCEasingFunctionTypeSineEaseIn,
    SCEasingFunctionTypeSineEaseOut,
    SCEasingFunctionTypeSineEaseInOut,
    
    SCEasingFunctionTypeCircularEaseIn,
    SCEasingFunctionTypeCircularEaseOut,
    SCEasingFunctionTypeCircularEaseInOut,
    
    SCEasingFunctionTypeExponentialEaseIn,
    SCEasingFunctionTypeExponentialEaseOut,
    SCEasingFunctionTypeExponentialEaseInOut,
    
    SCEasingFunctionTypeElasticEaseIn,
    SCEasingFunctionTypeElasticEaseOut,
    SCEasingFunctionTypeElasticEaseInOut,
    
    SCEasingFunctionTypeBackEaseIn,
    SCEasingFunctionTypeBackEaseOut,
    SCEasingFunctionTypeBackEaseInOut,
    
    SCEasingFunctionTypeBounceEaseIn,
    SCEasingFunctionTypeBounceEaseOut,
    SCEasingFunctionTypeBounceEaseInOut
};

@interface SCEasingFunction : NSObject <SCEasingFunctionProtocol>

@property (nonatomic, assign) SCEasingFunctionType type;

+ (instancetype)easingFunctionWithType:(SCEasingFunctionType)type;

- (instancetype)initWithType:(SCEasingFunctionType)type;

@end
