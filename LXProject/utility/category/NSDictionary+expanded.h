//
//  NSDictionary+expanded.h
//  Stev_Framework
//
//  Created by 孙向前 on 14-4-26.
//  Copyright (c) 2014年 孙向前. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (expanded)

- (id)objectForJSONKey:(id)aKey;
- (id)valueForJSONKey:(NSString *)key;
- (id)valueForJSONKeys:(NSString *)key,...NS_REQUIRES_NIL_TERMINATION;
- (id)valueForJSONStrKeys:(NSString *)key,...NS_REQUIRES_NIL_TERMINATION;
- (void)setObjects:(id)objects forKey:(id)aKey;

- (NSString*)valueForJSONStrKey:(NSString *)key;
@end
