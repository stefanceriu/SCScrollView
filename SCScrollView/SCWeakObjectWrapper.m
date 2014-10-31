//
//  SCWeakObjectWrapper.m
//  SCWeakObjectWrapper
//
//  Created by Stefan Ceriu on 31/10/2014.
//  Copyright (c) 2014 Stefan Ceriu. All rights reserved.
//

#import "SCWeakObjectWrapper.h"

@interface SCWeakObjectWrapper ()

@property (nonatomic, weak) id object;

@end

@implementation SCWeakObjectWrapper

- (instancetype)initWithObject:(id)object
{
    _object = object;
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.object;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *methodSignature;
    
    id object = self.object;
    if (object) {
        methodSignature = [object methodSignatureForSelector:aSelector];
    } else {
        NSString *types = [NSString stringWithFormat:@"%s%s", @encode(id), @encode(SEL)];
        methodSignature = [NSMethodSignature signatureWithObjCTypes:[types UTF8String]];
    }
    return methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [anInvocation invokeWithTarget:self.object];
}

@end