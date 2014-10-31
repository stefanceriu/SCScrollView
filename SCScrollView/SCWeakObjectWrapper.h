//
//  SCWeakObjectWrapper.h
//  SCWeakObjectWrapper
//
//  Created by Stefan Ceriu on 31/10/2014.
//  Copyright (c) 2014 Stefan Ceriu. All rights reserved.
//

@interface SCWeakObjectWrapper : NSProxy

- (instancetype)initWithObject:(id)object;

@end