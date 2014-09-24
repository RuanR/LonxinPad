//
//  RHMethods.h
//  ktvdr
//
//  Created by 孙向前 on 14-4-26.
//  Copyright (c) 2014年 孙向前. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Foundation.h"
@interface RHMethods : NSObject
+(UIView*)viewWithFrame:(CGRect)aframe bgcolor:(UIColor*)acolor alpha:(float)alpha;
+ (UILabel*)labelWithFrame:(CGRect)aframe font:(UIFont*)afont color:(UIColor*)acolor text:(NSString*)atext;
+(UIButton*)buttonWithFrame:(CGRect)_frame title:(NSString*)_title  image:(NSString*)_image bgimage:(NSString*)_bgimage;
+(UIImageView*)imageviewWithFrame:(CGRect)_frame defaultimage:(NSString*)_image;
+(UIImageView*)imageviewWithFrame:(CGRect)_frame defaultimage:(NSString*)_image stretchW:(NSInteger)_w stretchH:(NSInteger)_h;
+(UIButton*)buttonWithFrame:(CGRect)_frame title:(NSString*)_title image:(NSString*)_image bgColor:(UIColor*)_bgcolor;

@end
