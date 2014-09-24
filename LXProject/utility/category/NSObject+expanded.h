//
//  NSObject+expanded.h
//  AFDFramework
//
//  Created by 孙向前 on 14-4-26.
//  Copyright (c) 2014年 孙向前. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (expanded)
//perfrom for bool
- (void)performSelector:(SEL)aSelector withBool:(BOOL)aValue;
- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects;
- (id)performSelector:(SEL)aSelector withParameters:(void *)firstParameter, ...;
@end
